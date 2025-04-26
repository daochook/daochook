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

addon.name    = 'example_commands';
addon.author  = 'atom0s';
addon.desc    = 'Example addon that demonstrates implementing custom commands.';
addon.link    = 'https://atom0s.com';
addon.version = '1.0';

require 'common';
require 'daoc';

--[[
* event: command
* desc : Called when the game is handling a command.
--]]
hook.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.modified_command:args();
    if (#args == 0) then
        return;
    end

    -- Command: /example1
    if ((args[1]:ieq('example1') and e.imode == daoc.chat.input_mode.slash) or args[1]:ieq('/example1')) then
        -- Mark the command as handled, preventing the game from ever seeing it..
        e.blocked = true;

        -- Display a message to the chat window..
        daoc.chat.msg(daoc.chat.message_mode.help, 'Example command was executed!');
        return;
    end

    -- Command: /example2
    if ((args[1]:ieq('example2') and e.imode == daoc.chat.input_mode.slash) or args[1]:ieq('/example2')) then
        -- Mark the command as handled, preventing the game from ever seeing it..
        e.blocked = true;

        -- Execute a command..
        daoc.chat.exec(daoc.chat.command_mode.typed, daoc.chat.input_mode.normal, '/wave');
        return;
    end
end);
