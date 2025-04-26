--[[
* daochook - Copyright (c) 2025 atom0s [atom0s@live.com]
* Contact: https://www.atom0s.com/
* Contact: https://discord.gg/UmXNvjq
* Contact: https://github.com/atom0s
*
* This file is part of daochook.
*
* daochook is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* daochook is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with daochook.  If not, see <https://www.gnu.org/licenses/>.
--]]

--[[
* Settings Library
*
* Implements a library that will manage and automatically handle loading/saving character-specific settings.
* Once a settings block is loaded; the library will monitor for character changes and automatically update
* accordingly. Addons can register to a callback event to monitor for when these switches happen.
*
* Addon settings loaded/saved through this library are located within:
*       <daochook_path>/config/addons/<addon_name>/
*
* Addons can maintain multiple settings files at once via passing an alias to the settings functions accordingly.
* If no settings alias is provided, it is always defaulted to 'settings'.
*
* Addon settings are saved under the following paths:
*       Defaults : <daochook_path>/config/addons/<addon_name>/_defaults_/<alias>.lua
*       Character: <daochook_path>/config/addons/<addon_name>/<charname>/<alias>.lua
*
* For example, here are two paths for the FPS addon:
*       Defaults : <daochook_path>/config/addons/fps/_defaults_/settings.lua
*       Character: <daochook_path>/config/addons/fps/Atomos/settings.lua
--]]

require 'common';
require 'daoc';

local ffi = require 'ffi';

-- Settings library table..
local settingslib       = T{ };
settingslib.cache       = T{ };
settingslib.logged_in   = false;
settingslib.name        = '';

-- Function forwards..
local process_settings;
local load_settings;
local save_settings;
local raise_events;
local switch_character;

-- Lua Reserved Keywords
local keywords = T{
    ['and']     = true, ['break']   = true, ["do"]      = true,
    ['else']    = true, ['elseif']  = true, ["end"]     = true,
    ['false']   = true, ['for']     = true, ["function"]= true,
    ['if']      = true, ['in']      = true, ["local"]   = true,
    ["nil"]     = true, ['not']     = true, ['or']      = true,
    ["repeat"]  = true, ['return']  = true, ['then']    = true,
    ["true"]    = true, ['until']   = true, ['while']   = true,
};

do
    --[[
    * Returns the amount of equals symbols to properly escape the string if its a literal, nil otherwise.
    *
    * @param {string} s - The string to test.
    * @return {number|nil} The number of equals (minus 1) needed if literal, nil otherwise.
    --]]
    local function find_literal(s)
        local eq, eqn, f, _ = nil, nil, 1, nil;
        repeat
            _, f, _, eqn = s:find('([%[%]])(=*)%1', f);
            if (eqn) then
                eq = math.max(eq or 0, #eqn);
            end
        until not eqn;
        return eq;
    end

    --[[
    * Returns the string quoted to properly escape special characters or if its a string literal.
    *
    * @param {string} s - The string to quote.
    * @return {string} The quoted string.
    --]]
    local function quote_string(s)
        local eq = find_literal(s .. ']');
        if (s:find('\n') or eq and not s:find('\r')) then
            eq = ('='):rep((eq or -1) + 1);
            if (s:find('^\n')) then
                s = '\n' .. s;
            end
            s = '[' .. eq .. '[' .. s .. ']' .. eq .. ']';
        else
            s = ('%q'):fmt(s):gsub('\r', '\\r');
        end
        return s;
    end

    --[[
    * tostring override to handle numerical values specifically.
    *
    * @param {any} val - The value to convert to a string.
    * @return {string} The converted string value.
    --]]
    local otostring = tostring;
    local function tostring(val)
        if (type(val) ~= 'number') then
            return otostring(val);
        elseif (val ~= val) then
            return '0/0';
        elseif (val == math.huge) then
            return '1/0';
        elseif (val == -math.huge) then
            return '-1/0';
        elseif (math.floor(val) == val) then
            return ('%d'):fmt(val);
        else
            return ('%.14g'):fmt(val);
        end
    end

    --[[
    * Returns the string, quoted, if required.
    *
    * @param {string} s - The string to quote.
    * @return {string} The string.
    --]]
    local function quote_if_req(s)
        if (not s) then return ''; end
        if (s:find(' ')) then
            s = quote_string(s);
        end
        return s;
    end

    --[[
    * Returns if the given value is an identifier or Lua keyword.
    *
    * @param {any} val - The value to check.
    * @return {boolean} True if identifier or Lua keyword, false otherwise.
    --]]
    local function is_keyword(val)
        return type(val) == 'string' and val:find('^[%a_][%w_]*$') and not keywords[val];
    end

    --[[
    * Processes the incoming object, either reprocessing it if its a table, or attempting to quote it otherwise.
    *
    * @param {any} o - The object to process.
    * @return {string} The processed string if o was a table, the quoted string otherwise.
    --]]
    local function quote(o)
        if (type(o) == 'table') then
            return process_settings(o, '');
        end
        return quote_string(o);
    end

    --[[
    * Returns the generated index.
    *
    * @param {any} nk - The numerical key.
    * @param {string} key - The string key.
    * @return {string} The formatted key.
    --]]
    local function index(nk, key)
        if (not nk) then
            key = quote(key);
            key = key:find('^%[') and (' ' .. key .. ' ') or key;
        end
        return '[' .. key .. ']';
    end

    --[[
    * Processes a settings table, converting it to a string that can be reloaded into Lua later.
    *
    * @param {any} o - The object to process. (Generally a table to begin.)
    * @param {string} space - The indent spacing to use. (Default is 4 spaces.)
    * @return {string} The formatted settings string.
    --]]
    process_settings = function (o, space)
        -- Process non-table values first..
        if (type(o) ~= 'table') then
            local res = tostring(o);
            if (type(o) == 'string') then
                return quote(o);
            end
            return res, 'invalid table';
        end

        -- Prepare the element spacing..
        local set = ' = ';
        if (space == '') then
            set = '=';
        end
        space = space or '    ';

        local line      = '';
        local lines     = T{ };
        local tables    = T{ };

        -- Appends the given string to the current line.
        local function put(s)
            if (s ~= nil and s:len() > 0) then
                line = line .. s;
            end
        end

        -- Appends the current line to the table of lines.
        local function putln(s)
            lines:append(line .. s);
            line = '';
        end

        -- Processes the remaining table information.
        local write;
        write = function (t, old_indent, indent)
            local tp = type(t);
            if (tp ~= 'string' and tp ~= 'table') then
                putln(quote_if_req(tostring(t)) .. ',');
            elseif (tp == 'string') then
                putln(quote_string(t) .. ',');
            elseif (tp == 'table') then
                -- Check for table self-references..
                if (tables[t]) then
                    error('Tables cannot reference themselves while using the settings library!');
                    return;
                end

                -- Mark this table as seen..
                tables[t] = true;

                -- Begin the table entry..
                local new_indent = indent .. space;
                putln('T{');

                local used = T{ };
                for i, val in ipairs(t) do
                    put(indent);
                    write(val, indent, new_indent);
                    used[i] = true;
                end

                -- Prepare the ordered keys..
                local okeys = T{ };
                for k, _ in pairs(t) do
                    if (type(k) ~= 'number') then
                        okeys[okeys:len() + 1] = k;
                    end
                end

                -- Sort the ordered keys..
                okeys:sort(function (a, b)
                    local ta = type(a);
                    local tb = type(b);
                    if (ta == tb) then
                        return tostring(a) < tostring(b);
                    else
                        return ta < tb;
                    end
                end);

                -- Writes the given key value pair.
                local function write_entry(key, val)
                    local tkey = type(key);
                    local nkey = tkey == 'number';

                    if (not nkey or not used[key]) then
                        if (tkey ~= 'string') then
                            key = tostring(key);
                        end
                        if (nkey or not is_keyword(key)) then
                            key = index(nkey, key);
                        end
                        put(indent .. key .. set);
                        write(val, indent, new_indent);
                    end
                end

                -- Write the entries..
                for n = 1, #okeys do
                    local key = okeys[n];
                    write_entry(key, t[key]);
                end
                for key, val in pairs(t) do
                    if (type(key) == 'number') then
                        write_entry(key, val);
                    end
                end

                -- Reset the seen tables..
                tables[t] = nil;

                putln(old_indent .. '},');
            else
                putln(tostring(t) .. ',');
            end
        end

        -- Process the main table..
        write(o, '', space);

        -- Remove trailing commas..
        lines[lines:len()] = lines[lines:len()]:trimend(',') .. ';';

        -- Return the lines converted to a single string..
        return lines:concat(space:len() > 0 and '\n' or '');
    end

    --[[
    * Loads a settings file from disk.
    *
    * @param {table} defaults - The default settings to use if none are read from disk.
    * @param {string} alias - The settings file alias to use for the file name.
    * @return {table} The loaded settings on success, defaults copy otherwise.
    --]]
    load_settings = function (defaults, alias)
        local file = ('%s\\%s.lua'):fmt(settingslib.settings_path(), alias);

        if (not hook.fs.exists(file)) then
            save_settings(defaults, alias);
            return defaults:copy(true);
        end

        local settings = nil;
        local status, err = pcall(function() settings = loadfile(file)(); end);

        if (status == false or type(settings) ~= 'table') then
            daoc.chat.msg(daoc.chat.message_mode.help, ('Failed to load settings file: %s'):fmt(alias));
            if(status == false) then
                daoc.chat.msg(daoc.chat.message_mode.help, ('Error: %s'):fmt(err));
            elseif (type(settings) ~= 'table') then
                daoc.chat.msg(daoc.chat.message_mode.help, 'Error: Settings file did not return a valid table.');
            end
            daoc.chat.msg(daoc.chat.message_mode.help, 'Settings have been reveted to default values.');

            save_settings(defaults, alias);
            return defaults:copy(true);
        end

        return T(settings);
    end

    --[[
    * Saves the settings table to disk.
    *
    * @param {table} settings - The settings table to save.
    * @param {string} alias - The settings file alias.
    * @return {boolean} True on success, false otherwise.
    --]]
    save_settings = function (settings, alias)
        hook.fs.create_dir(settingslib.settings_path());

        local file  = ('%s\\%s.lua'):fmt(settingslib.settings_path(), alias);
        local s     = process_settings(settings);

        local f = io.open(file, 'w+');
        if (f == nil) then
            daoc.chat.msg(daoc.chat.message_mode.help, ('Failed to save settings file: %s'):fmt(alias));
            return false;
        end

        f:write('require \'common\';\n\n');
        f:write('local settings = ' .. s);
        f:write('\n\nreturn settings;\n');
        f:close();

        return true;
    end
end

do
    --[[
    * Invokes the registered settings callbacks to inform addons of settings table changes.
    *
    * @param {string} alias - The alias of the settings raising the event.
    * @param {table} settings - The table of new settings.
    *--]]
    raise_events = function (alias, settings)
        if (settingslib.cache[alias] ~= nil and settingslib.cache[alias].events ~= nil) then
            settingslib.cache[alias].events:each(function (v) v(settings); end);
        end
    end

    --[[
    * Triggers a character switch, saving the current settings then loading the character specific settings.
    *
    * @param {string} name - The name of the character being logged into, or blank string if logged out.
    --]]
    switch_character = function (name)
        -- Check if the switch attempt should happen..
        if (settingslib.name == name) then
            return;
        end

        -- Save all current settings to disk first..
        for _, v in settingslib.cache:it() do
            save_settings(v.settings, v.alias);
        end

        -- Update the current login information..
        settingslib.logged_in   = name:len() > 0;
        settingslib.name        = name;

        -- Reload all settings that are currently loaded..
        for _, v in settingslib.cache:it() do
            -- Load and merge the settings..
            local settings = load_settings(v.defaults, v.alias);
            settings = settings:merge(v.defaults);

            -- Save the updated settings to ensure all data matches..
            save_settings(settings, v.alias);

            -- Update the cache..
            settingslib.cache[v.alias].settings = settings;

            -- Raise events..
            raise_events(v.alias, settings);
        end
    end
end

--[[
* Returns the current settings path. (Specific to the given addons namespace.)
*
* @return {string} The settings path for this addon.
--]]
settingslib.settings_path = function ()
    local name = '_defaults_';
    if (settingslib.logged_in and settingslib.name:len() > 0) then
        name = ('%s'):fmt(settingslib.name);
    end
    return ('%s\\config\\addons\\%s\\%s\\'):fmt(hook.get_hook_path(), addon.name, name);
end

--[[
* Loads and returns a settings table.
*
* @param {table} defaults - The default settings table to be used if no settings are loaded from disk.
* @param {string} alias - The alias to store the settings within. (Optional.)
* @return {table} The settings table.
*
* @note
*   The settings alias is optional for the main settings block being loaded. If it is not given, then the alias is
*   defaulted to 'settings'. If the requested file does not exist, then the defaults passed are saved to disk for
*   that file and then returned as the settings to be used.
*
*   It is important to make use of the table returned here and to not overwrite the returned object afterward. This
*   class keeps track of the same table to be used for saving settings back to disk.
*
*   Register to the settings block events if you need to monitor for character switches and reloads of the settings.
--]]
settingslib.load = function (defaults, alias)
    -- Prepare the arguments..
    defaults = defaults or T{ };
    alias = alias or 'settings';

    -- Load and merge the settings..
    local settings = load_settings(defaults, alias);

    try(function ()
        -- Attempt to merge in defaults..
        settings = settings:merge(defaults);
    end).catch(function (e)
        -- Default merge failed, reset to defaults..
        settings = defaults:copy(true);

        daoc.chat.msg(daoc.chat.message_mode.help, 'Failed to merge settings defaults; reverting to defaults.');
    end);

    -- Save the updated settings to ensure all data matches..
    save_settings(settings, alias);

    -- Cache the settings information..
    settingslib.cache[alias]            = settingslib.cache[alias] or T{ };
    settingslib.cache[alias].alias      = alias;
    settingslib.cache[alias].defaults   = defaults;
    settingslib.cache[alias].events     = settingslib.cache[alias].events or T{ };
    settingslib.cache[alias].settings   = settings;

    -- Raise events..
    raise_events(alias, settings);

    return settings;
end

--[[
* Saves a settings table to disk.
*
* @param {string} alias - The alias of the settings to save. (Optional.)
* @return {boolean} True on success, false otherwise.
*
* @note
*   The settings alias is optional. If it is not given, then the alias is defaulted to 'settings'.
--]]
settingslib.save = function (alias)
    alias = alias or 'settings';

    -- Ensure the cached settings exists..
    local settings = settingslib.cache[alias];
    if (settings == nil) then
        return false;
    end

    -- Save the updated settings to ensure all data matches..
    save_settings(settings.settings, alias);
    return true;
end

--[[
* Reloads a settings table from disk.
*
* @param {string} alias - The alias of the settings to reload. (Optional.)
* @return {boolean} True on success, false otherwise.
*
* @note
*   The settings alias is optional. If it is not given, then the alias is defaulted to 'settings'.
--]]
settingslib.reload = function (alias)
    alias = alias or 'settings';

    -- Ensure the settings alias exists..
    if (settingslib.cache[alias] == nil) then
        return false;
    end

    -- Load and merge the settings..
    local settings = load_settings(settingslib.cache[alias].defaults, alias);
    settings = settings:merge(settingslib.cache[alias].defaults);

    -- Save the updated settings to ensure all data matches..
    save_settings(settings, alias);

    -- Cache the settings information..
    settingslib.cache[alias].settings = settings;

    -- Raise events..
    raise_events(alias, settings);

    return true;
end

--[[
* Resets a settings table to its defaults.
*
* @param {string} alias - The alias of the settings to reset. (Optional.)
* @return {boolean} True on success, false otherwise.
*
* @note
*   The settings alias is optional. If it is not given, then the alias is defaulted to 'settings'.
--]]
settingslib.reset = function (alias)
    alias = alias or 'settings';

    -- Ensure the settings alias exists..
    if (settingslib.cache[alias] == nil) then
        return false;
    end

    -- Default the settings..
    local settings = T{ };
    settings = settings:merge(settingslib.cache[alias].defaults:copy(true));

    -- Save the updated settings to ensure all data matches..
    save_settings(settings, alias);

    -- Cache the settings information..
    settingslib.cache[alias].settings = settings;

    -- Raise events..
    raise_events(alias, settings);

    return true;
end

--[[
* Returns the settings table for the given alias.
*
* @param {string} alias - The alias of the settings to obtain. (Optional.)
* @return {table} The settings table on success, nil otherwise.
*
* @note
*   The settings alias is optional. If it is not given, then the alias is defaulted to 'settings'.
--]]
settingslib.get = function (alias)
    alias = alias or 'settings';

    -- Ensure the settings alias exists..
    if (settingslib.cache[alias] == nil) then
        return nil;
    end

    -- Return the cached settings table..
    return settingslib.cache[alias].settings;
end

--[[
* Registers an event callback to a settings block.
*
* @param {string} alias - The alias of the settings block to register the event for.
* @param {string} event_alias - The alias of the event callback.
* @param {function} callback - The callback function to invoke when an event is raised.
--]]
settingslib.register = function (alias, event_alias, callback)
    assert(type(alias) == 'string', 'Invalid event settings alias; expected a string.');
    assert(type(event_alias) == 'string', 'Invalid event callback alias; expected a string.');
    assert(type(callback) == 'function', 'Invalid event callback function; expected a function.');

    local s = alias:lower();
    local a = event_alias:lower();

    settingslib.cache[s]            = settingslib.cache[s] or T{ };
    settingslib.cache[s].events     = settingslib.cache[s].events or T{ } ;
    settingslib.cache[s].events[a]  = callback;
end

--[[
* Unregisters an event callback from a settings block.
*
* @param {string} alias - The alias of the settings block to register the event for.
* @param {string} event_alias - The alias of the event callback.
--]]
settingslib.unregister = function (alias, event_alias)
    assert(type(alias) == 'string', 'Invalid event settings alias; expected a string.');
    assert(type(event_alias) == 'string', 'Invalid event callback alias; expected a string.');

    local s = alias:lower();
    local a = event_alias:lower();

    settingslib.cache[s]            = settingslib.cache[s] or T{ };
    settingslib.cache[s].events     = settingslib.cache[s].events or T{ } ;
    settingslib.cache[s].events[a]  = nil;
end

--[[
* event: packet_recv
* desc : Called when the game is handling a received packet.
--]]
hook.events.register('packet_recv', '__settingslib_packet_recv', function (e)
    -- Packet: MiscUpdate
    if (e.opcode == 0x16) then
        local packet = ffi.cast('uint8_t*', e.data_modified_raw);
        if (packet[0] == 0x03) then
            local name = '';
            local size = packet[5];

            if (size > 0) then
                name = struct.unpack(('c%d'):fmt(size), e.data_modified, 0x06 + 0x01);
                switch_character(name:trim('\0'));
            end
        end
        return;
    end

    -- Packet: Quit
    if (e.opcode == 0xA4) then
        switch_character('');
        return;
    end
end);

--[[
* Settings Library Preparations
*
*   - Ensure the settings folder exists.
*   - Check if the player is already logged in to initialize per-character settings.
--]]

do
    -- Create the addons configuration folder..
    local path = ('%s\\config\\addons\\'):fmt(hook.get_hook_path());
    if (not hook.fs.exists(path)) then
        hook.fs.create_dir(path);
    end

    -- Check if the player is already logged in..
    if (daoc.game.get_global_value(154) > 0) then
        local name = daoc.states.get_names_state().character_name;
        if (name ~= nil) then
            switch_character(name);
        end
    end
end

-- Library helper forwards..
settingslib.process = process_settings;

-- Return the settingslib table..
return settingslib;

--[[
*
* The 'process_settings' function (and additional sub-functions called within it) are based on the 'pretty'
* library from Penlight. You can find their project here: https://github.com/lunarmodules/Penlight
*
* Copyright (C) 2009-2016 Steve Donovan, David Manura.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of
* this software and associated documentation files (the "Software"), to deal in the
* Software without restriction, including without limitation the rights to use, copy,
* modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so, subject to the
* following conditions:
*
* The above copyright notice and this permission notice shall be included in all copies
* or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
* INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
* PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
* FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*
--]]
