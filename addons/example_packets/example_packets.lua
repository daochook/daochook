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

addon.name    = 'example_packets';
addon.author  = 'atom0s';
addon.desc    = 'Example addon that demonstrates working with packets.';
addon.link    = 'https://atom0s.com';
addon.version = '1.0';

local ffi = require 'ffi';

require 'common';
require 'daoc';

--[[
* event: packet_recv
* desc : Called when the game is handling a received packet.
--]]
hook.events.register('packet_recv', 'packet_recv_cb', function (e)
    -- OpCode: Message
    if (e.opcode == 0xAF) then
        -- Cast the raw packet pointer to a byte array via FFI..
        local packet = ffi.cast('uint8_t*', e.data_modified_raw);

        -- Look for 'say' chat mode packets..
        if (packet[0] == daoc.chat.message_mode.say) then
            -- Set the chat mode to 'help' instead..
            packet[0] = daoc.chat.message_mode.help;
        end
    end
end);

--[[
* event: packet_send
* desc : Called when the game is sending a packet.
--]]
hook.events.register('packet_send', 'packet_send_cb', function (e)
    -- OpCode: Command
    if (e.opcode == 0xAF) then
        -- Cast the raw packet pointer to a byte array via FFI..
        local packet = ffi.cast('uint8_t*', e.data_modified_raw);

        -- Look for 'yell' packets (cmd: &yell)..
        if (e.size > 6 and
            packet[0] == 0x00 and packet[1] == 0x26 and
            packet[2] == 0x79 and packet[3] == 0x65 and packet[4] == 0x6C and packet[5] == 0x6C) then
            -- Block the packet from being sent to the server..
            e.blocked = true;
        end
    end
end);
