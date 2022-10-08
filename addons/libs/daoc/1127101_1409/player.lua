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

-- Ensure the daoc tables exists..
daoc = daoc or T{ };
daoc.player = daoc.player or T{ };

--[[
* Player Related Enumerations
--]]

daoc.player.attributes_index                    = T{ };
daoc.player.attributes_index.level              = 0x00;
daoc.player.attributes_index.hit_points_hi      = 0x01;
daoc.player.attributes_index.hit_points_lo      = 0x02;
daoc.player.attributes_index.unknown3           = 0x03; -- Unknown, does not appear to be used other than set.
daoc.player.attributes_index.realm_rank         = 0x04;
daoc.player.attributes_index.realm_skill_points = 0x05;
daoc.player.attributes_index.unknown6           = 0x06; -- Used for housing number.
daoc.player.attributes_index.unknown7           = 0x07; -- Used for housing number.
daoc.player.attributes_index.master_level       = 0x08;
daoc.player.attributes_index.unknown9           = 0x09; -- Unknown, does not appear to be used other than set.
daoc.player.attributes_index.unknown10          = 0x0A; -- Unknown, does not appear to be used other than set.
daoc.player.attributes_index.unknown11          = 0x0B; -- Unknown, does not appear to be used other than set.
daoc.player.attributes_index.unknown12          = 0x0C; -- Unknown, does not appear to be used other than set.
daoc.player.attributes_index.unknown13          = 0x0D; -- Unknown, does not appear to be used other than set.
daoc.player.attributes_index.champion_level     = 0x0E;

--[[
* Returns the index within the character attributes window.
--]]
local function calc_attributes_index(idx1, idx2)
    return (42 * (idx2 + (150 * idx1))) * 4;
end

----------------------------------------------------------------------------------------------------
--
-- Player Attributes Window Information
--
----------------------------------------------------------------------------------------------------

--[[
* Returns the local players level.
--]]
daoc.player.get_level = function ()
    local ptr = hook.pointers.get('game.ptr.player_attributes_window');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return 0; end
    return hook.memory.read_uint32(ptr + calc_attributes_index(3, daoc.player.attributes_index.level));
end

--[[
* Returns the local players maximum hit points.
--]]
daoc.player.get_max_hit_points = function ()
    local ptr = hook.pointers.get('game.ptr.player_attributes_window');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return 0; end

    local hi = hook.memory.read_uint32(ptr + calc_attributes_index(3, daoc.player.attributes_index.hit_points_hi));
    local lo = hook.memory.read_uint32(ptr + calc_attributes_index(3, daoc.player.attributes_index.hit_points_lo));

    return bit.lshift(hi, 8) + lo;
end

--[[
* Returns the local players realm rank.
--]]
daoc.player.get_realm_rank = function ()
    local ptr = hook.pointers.get('game.ptr.player_attributes_window');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return 0; end
    return hook.memory.read_uint32(ptr + calc_attributes_index(3, daoc.player.attributes_index.realm_rank));
end

--[[
* Returns the local players realm skill points.
--]]
daoc.player.get_realm_skill_points = function ()
    local ptr = hook.pointers.get('game.ptr.player_attributes_window');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return 0; end
    return hook.memory.read_uint32(ptr + calc_attributes_index(3, daoc.player.attributes_index.realm_skill_points));
end

--[[
* Returns the local players master level.
--]]
daoc.player.get_master_level = function ()
    local ptr = hook.pointers.get('game.ptr.player_attributes_window');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return 0; end

    local lvl = hook.memory.read_uint32(ptr + calc_attributes_index(3, daoc.player.attributes_index.master_level));
    if (lvl == 0) then
        return 0;
    end
    return lvl - 1;
end

--[[
* Returns the local players champion level.
--]]
daoc.player.get_champion_level = function ()
    local ptr = hook.pointers.get('game.ptr.player_attributes_window');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return 0; end
    return hook.memory.read_uint32(ptr + calc_attributes_index(3, daoc.player.attributes_index.champion_level));
end

----------------------------------------------------------------------------------------------------
--
-- Player Entity Forwards
--
----------------------------------------------------------------------------------------------------

--[[
* Returns the local players entity index.
--]]
daoc.player.get_index = function ()
    return daoc.entity.get_player_index();
end

--[[
* Returns the local players entity.
--]]
daoc.player.get_entity = function ()
    return daoc.entity.get(daoc.entity.get_player_index());
end

--[[
* Returns the local players realm id.
--]]
daoc.player.get_realm_id = function ()
    local ptr = hook.pointers.get('game.ptr.player_realm_id');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return 0; end
    return hook.memory.read_uint32(ptr);
end

--[[
* Returns the local players pet index.
--]]
daoc.player.get_pet_index = function ()
    return daoc.entity.get_pet_index();
end

--[[
* Returns the local players pet entity.
--]]
daoc.player.get_pet_entity = function ()
    return daoc.entity.get(daoc.entity.get_pet_index());
end

--[[
* Returns the local players pet object id.
--]]
daoc.player.get_pet_objectid = function ()
    return daoc.entity.get_pet_objectid();
end
