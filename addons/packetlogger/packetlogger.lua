--[[
* daochook - Copyright (c) 2022 atom0s [atom0s@live.com]
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

addon.name    = 'packetlogger';
addon.author  = 'atom0s';
addon.desc    = 'Logs packets to a file on disk.';
addon.link    = 'https://atom0s.com';
addon.version = '1.0';

require 'common';
require 'daoc';

-- Prepare the logs output folder..
local path = ('%s\\logs\\'):fmt(hook.get_hook_path());
hook.fs.create_dir(path);

-- Prepare the output file name based on the current date information..
local time = hook.time.get_local_time();
local file = ('%s\\packetlog_%02d.%02d.%02d.log'):fmt(path, time['day'], time['month'], time['year']);
daoc.chat.msg(daoc.chat.message_mode.help, ('[Packet Log] Packets will save to:\n%s'):fmt(file));

--[[
* Writes the given string to the current packet log file.
--]]
local function log(str)
    local f = io.open(file, 'a');
    if (f == nil) then
        return;
    end

    f:write(str);
    f:flush();
    f:close();
end

--[[
* event: packet_recv
* desc : Called when the game is handling a received packet.
--]]
hook.events.register('packet_recv', 'packet_recv_cb', function (e)
    log(('[S -> C] OpCode: %02X | Size: %d\n'):fmt(e.opcode, e.size));
    log(e.data:hexdump() .. '\n');
end);

--[[
* event: packet_send
* desc : Called when the game is sending a packet.
--]]
hook.events.register('packet_send', 'packet_send_cb', function (e)
    log(('[C -> S] OpCode: %02X | Size: %d | Param: %08X\n'):fmt(e.opcode, e.size, e.parameter));
    log(e.data:hexdump() .. '\n');
end);

--[[
* event: packet_send
* desc : Called when the game is sending a packet.
--]]
hook.events.register('packet_send_udp', 'packet_send_cb', function (e)
    log(('[C -> S UDP] OpCode: %02X | Size: %d | Param: %08X\n'):fmt(e.opcode, e.size, e.parameter));
    log(e.data:hexdump() .. '\n');
end);
