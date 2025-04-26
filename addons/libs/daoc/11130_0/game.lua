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

require 'common';

local ffi = require 'ffi';

-- Ensure the daoc tables exists..
daoc = daoc or T{ };
daoc.game = daoc.game or T{ };

--[[
* Game Related Pointer Definitions
--]]
local pointers = T{
    -- Packet Functions (Send)
    T{ n = 'game.func.packet_send_0x71', m = nil, p = '558BEC51833D????????020F85????????56', o = 0, c = 0, },
    T{ n = 'game.func.packet_send_0x7D', m = nil, p = '558BEC83EC??833D????????020F??????????568B35????????D946??57', o = 0, c = 0, },
    T{ n = 'game.func.packet_send_0xBB', m = nil, p = '558BEC51833D????????020F85????????66', o = 0, c = 0, },

    -- Map Information Functions
    T{ n = 'game.func.get_map_index_from_pos',  m = nil, p = 'A1????????83F80474??83F80274??D9', o = 0, c = 0, },
    T{ n = 'game.func.get_map_x_from_pos',      m = nil, p = 'A1????????83F80474??83F80274??D9', o = 0, c = 1, },
    T{ n = 'game.func.get_map_y_from_pos',      m = nil, p = 'A1????????83F80474??83F80274??D9', o = 0, c = 2, },
    T{ n = 'game.func.get_map_name_from_pos',   m = nil, p = 'D94424045657E8????????D944241099BF002000008BCFF7F98BF0E8????????8B', o = 0, c = 1, },
};

-- Ensure all pointers are valid..
pointers:each(function (p)
    if (hook.pointers.get(p.n) == 0) then
        local v = hook.pointers.add(p.n, p.m, p.p, p.o, p.c);
        if (v == 0) then
            error(('Failed to locate version specific pointer: %s'):fmt(p.n));
        end
    end
end);

--[[
* Game Related Function Definitions
--]]
ffi.cdef[[
    typedef const char* (__cdecl *decode_string_f)(char* str);
    typedef void        (__cdecl *packet_send_0x71_f)(const uint8_t id1, const uint8_t id2);
    typedef void        (__cdecl *packet_send_0x7D_f)(const uint8_t id1, const uint8_t id2);
    typedef void        (__cdecl *packet_send_0xBB_f)(const uint8_t id1, const uint8_t id2);
    typedef int32_t     (__cdecl *get_map_index_from_pos_f)(const float x, const float y);
    typedef int32_t     (__cdecl *get_map_x_from_pos_f)(const float x, const float y);
    typedef int32_t     (__cdecl *get_map_y_from_pos_f)(const float x, const float y);
    typedef const char* (__cdecl *get_map_name_from_pos_f)(const float x, const float y);
]];

--[[
* Returns the given string, decoded.
--]]
daoc.game.decode_string = function (s)
    local ptr = hook.pointers.get('game.func.decode_string');
    return ffi.string(ffi.cast('decode_string_f', ptr)(ffi.cast('char*', s)));
end

--[[
* Returns a global integer value by its index.
--]]
daoc.game.get_global_value = function (index)
    if (index < 0 or index > 159) then return 0; end
    return game.get_global_value(index);
end

--[[
* Uses the given skill.
--]]
daoc.game.use_skill = function (id1, id2)
    local ptr = hook.pointers.get('game.func.packet_send_0xBB');
    if (ptr == 0) then return; end
    ffi.cast('packet_send_0xBB_f', ptr)(id1, id2);
end

--[[
* Uses the given slot.
--]]
daoc.game.use_slot = function (id1, id2)
    local ptr = hook.pointers.get('game.func.packet_send_0x71');
    if (ptr == 0) then return; end
    ffi.cast('packet_send_0x71_f', ptr)(id1, id2);
end

--[[
* Uses the given spell.
--]]
daoc.game.use_spell = function (id1, id2)
    local ptr = hook.pointers.get('game.func.packet_send_0x7D');
    if (ptr == 0) then return; end
    ffi.cast('packet_send_0x7D_f', ptr)(id1, id2);
end

--[[
* Sends a packet to the client as if the server sent it.
--]]
daoc.game.recv_packet = function (opcode, packet)
    game.recv_packet(opcode, packet);
end

--[[
* Sends a packet to the server as if the client sent it.
--]]
daoc.game.send_packet = function (opcode, packet, parameter)
    game.send_packet(opcode, packet, parameter);
end

----------------------------------------------------------------------------------------------------
--
-- Map Related Functions
--
----------------------------------------------------------------------------------------------------

--[[
* Returns the map index for the given position.
--]]
daoc.game.get_map_index_from_pos_f = function (x, y)
    local ptr = hook.pointers.get('game.func.get_map_index_from_pos');
    if (ptr == 0) then return 0; end
    return ffi.cast('get_map_x_from_pos_f', ptr)(x, y);
end

--[[
* Returns the map x location for the given position.
--]]
daoc.game.get_map_x_from_pos = function (x, y)
    local ptr = hook.pointers.get('game.func.get_map_x_from_pos');
    if (ptr == 0) then return 0; end
    return ffi.cast('get_map_x_from_pos_f', ptr)(x, y);
end

--[[
* Returns the map y location for the given position.
--]]
daoc.game.get_map_y_from_pos = function (x, y)
    local ptr = hook.pointers.get('game.func.get_map_y_from_pos');
    if (ptr == 0) then return 0; end
    return ffi.cast('get_map_y_from_pos_f', ptr)(x, y);
end

--[[
* Returns the map name for the given position.
--]]
daoc.game.get_map_name_from_pos = function (x, y)
    local ptr = hook.pointers.get('game.func.get_map_name_from_pos');
    if (ptr == 0) then return 0; end

    local name = ffi.cast('get_map_name_from_pos_f', ptr)(x, y);
    if (name == nil) then
        return nil;
    end
    return ffi.string(name);
end