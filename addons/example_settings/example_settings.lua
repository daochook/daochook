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

addon.name    = 'example_settings';
addon.author  = 'atom0s';
addon.desc    = 'Example addon that demonstrates using the settings library.';
addon.link    = 'https://atom0s.com';
addon.version = '1.0';

require 'common';
require 'daoc';

local imgui     = require 'imgui';
local settings  = require 'settings';

--[[

This addon is used to demonstrate the usage of the Lua settings library. This library can be used to handle
Lua based settings on a per-character basis. (Along with having a set of defaults used when no character is
currently logged in.) Settings blocks are stored per-alias, meaning you can have multiple settings files
for your addon that are maintained by the settings library.

For more information please check the documentation website at: https://daochook.github.io/developers/libraries/

--]]

--[[
* Default Settings Blocks
--]]

-- Used with the default alias, 'settings'..
local default_settings = T{
    num_val1 = T{ 123, },
    num_val2 = T{ 12.3, },
    num_val3 = T{ -12.3, },

    str_val1 = T{ 'Hello world.', },
    str_val2 = T{ [[String literal 1.]], },
    str_val3 = T{ [==[String literal 2.
Line 2 of this string.
Line 3 of this string.]==], },

    tbl_val1 = T{ },
    tbl_val2 = T{
        val1 = T{ 123, },
        val2 = T{ 12.3, },
    },
};

-- Used with the alias, 'derp' to demonstrate multiple configuration files..
local default_settings2 = T{
    val1 = T{ 123, },
    val2 = T{ 12.3, },
    val3 = T{ 'Hello world.', },
};

-- Load both settings blocks..
local cfg1 = settings.load(default_settings); -- Uses 'settings' alias by default..
local cfg2 = settings.load(default_settings2, 'derp');

--[[
* Event invoked when a settings table has been changed within the settings library.
*
* Note: This callback only affects the default 'settings' table.
--]]
settings.register('settings', 'settings_update', function (e)
    -- Update the local copy of the 'settings' settings table..
    cfg1 = e;

    -- Ensure settings are saved to disk when changed..
    settings.save();
end);

--[[
* Event invoked when a settings table has been changed within the settings library.
*
* Note: This callback only affects the 'derp' settings table.
--]]
settings.register('derp', 'derp_update', function (e)
    -- Update the local copy of the 'derp' settings table..
    cfg2 = e;

    -- Ensure settings are saved to disk when changed..
    settings.save('derp');
end);

--[[
* event: d3d_present
* desc : Called when the Direct3D device is presenting a scene.
--]]
hook.events.register('d3d_present', 'd3d_present_cb', function ()
    imgui.SetNextWindowSize({ 500, 500, });
    if (imgui.Begin('Settings Example')) then
        -- Show the current settings library information..
        imgui.Text(('     Name: %s'):fmt(settings.name));
        imgui.Text(('Logged In: %s'):fmt(tostring(settings.logged_in)));
        imgui.NewLine();
        imgui.Separator();
        imgui.TextColored({ 1.0, 1.0, 0.0, 1.0 }, 'Select a tab to modify the settings related to that file.');
        imgui.NewLine();

        if (imgui.BeginTabBar('##settings_tabbar', ImGuiTabBarFlags_NoCloseWithMiddleMouseButton)) then
            --[[
            * Tab: 'settings'
            *
            * Demostrates the usage of the default configuration alias 'settings'.
            --]]
            if (imgui.BeginTabItem('settings', nil)) then
                imgui.TextColored({ 0.0, 0.8, 1.0, 1.0 }, 'Modify the \'settings\' configurations.');

                if (imgui.Button('Load', { 55, 20 })) then
                    cfg1 = settings.load(default_settings);
                end
                imgui.SameLine();
                if (imgui.Button('Save', { 55, 20 })) then
                    settings.save();
                end
                imgui.SameLine();
                if (imgui.Button('Reload', { 55, 20 })) then
                    settings.reload();
                end
                imgui.SameLine();
                if (imgui.Button('Reset', { 55, 20 })) then
                    settings.reset();
                end

                imgui.SliderInt('num_val1', cfg1.num_val1, 0, 100);
                imgui.SliderFloat('num_val2', cfg1.num_val2, 0, 100);
                imgui.SliderFloat('num_val3', cfg1.num_val3, -200, 200);
                imgui.InputTextMultiline('##str_val1', cfg1.str_val1, 255, { -1, imgui.GetTextLineHeight() * 4, }, ImGuiInputTextFlags_AllowTabInput);
                imgui.InputTextMultiline('##str_val2', cfg1.str_val2, 255, { -1, imgui.GetTextLineHeight() * 4, }, ImGuiInputTextFlags_AllowTabInput);
                imgui.InputTextMultiline('##str_val3', cfg1.str_val3, 255, { -1, imgui.GetTextLineHeight() * 4, }, ImGuiInputTextFlags_AllowTabInput);
                imgui.SliderInt('val1', cfg1.tbl_val2.val1, 0, 100);
                imgui.SliderFloat('val2', cfg1.tbl_val2.val2, 0, 100);

                imgui.EndTabItem();
            end

            --[[
            * Tab: 'derp'
            *
            * Demonstrates the usage of a second configuration file using a non-default alias.
            --]]
            if (imgui.BeginTabItem('derp', nil)) then
                imgui.TextColored({ 0.0, 0.8, 1.0, 1.0 }, 'Modify the \'derp\' configurations.');

                if (imgui.Button('Load', { 55, 20 })) then
                    cfg2 = settings.load(default_settings2, 'derp');
                end
                imgui.SameLine();
                if (imgui.Button('Save', { 55, 20 })) then
                    settings.save('derp');
                end
                imgui.SameLine();
                if (imgui.Button('Reload', { 55, 20 })) then
                    settings.reload('derp');
                end
                imgui.SameLine();
                if (imgui.Button('Reset', { 55, 20 })) then
                    settings.reset('derp');
                end

                imgui.SliderInt('val1', cfg2.val1, 0, 200);
                imgui.SliderFloat('val2', cfg2.val2, 0, 100);
                imgui.InputTextMultiline('##val3', cfg2.val3, 255, { -1, imgui.GetTextLineHeight() * 4, }, ImGuiInputTextFlags_AllowTabInput);

                imgui.EndTabItem();
            end

            imgui.EndTabBar();
        end
    end
    imgui.End();
end);
