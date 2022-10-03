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

local ffi = require 'ffi';

-- Ensure the daoc tables exists..
daoc = daoc or T{ };
daoc.party = daoc.party or T{ };

--[[
* Party Related Structure Definitions
--]]
ffi.cdef[[
    typedef struct {
        uint8_t     unknown00[66];  // Unknown.
        int16_t     id;             // The buff id.
        uint8_t     unknown01[24];  // Unknown.
    } partybuff_t;

    typedef struct {
        int32_t     health;         // The party members health percent.
        int32_t     endurance;      // The party members endurance percent.
        int32_t     unknown00;      // Unknown.
        int32_t     power;          // The party members power percent.
        char        name_[40];      // The party members name.
        uint32_t    level;          // The party members level.
        char        class_[20];     // The party members class.
        uint32_t    flags;          // The party members name flags. (Alters the name style and color.)
        uint32_t    zoneid;         // The party members zone id.
        uint32_t    x;              // The party members x position. (Used for updating the minimap icon.)
        uint32_t    y;              // The party members y position. (Used for updating the minimap icon.)
        uint32_t    z;              // The party members z position. (Seems to always be -1.)
        partybuff_t buffs[50];      // The party members buff information.
    } partymember_t;

    typedef struct {
        partymember_t members[8];   // The array of party members.
    } party_t;

    typedef struct {
        int32_t id[8];
    } partymemberids_t;
]];

--[[
* Party Related Helper Metatype Definitions
--]]

ffi.metatype('partymember_t', T{
    __index = function (self, k)
        return switch(k, {
            ['name'] = function () return ffi.string(self.name_); end,
            ['class'] = function () return ffi.string(self.class_); end,
            [switch.default] = function() return nil; end
        });
    end,
    __newindex = function (self, k, v)
        error('read-only type');
    end,
    __tostring = function (self)
        return ffi.string(self.name_);
    end,
});

--[[
* Returns the party members object id.
--]]
daoc.party.get_member_object_id = function (index)
    if (index > 7 or index < 0) then return 0; end
    local ptr = hook.pointers.get('game.ptr.party_members_ids');
    if (ptr == 0) then return nil; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return nil; end
    return ffi.cast('partymemberids_t*', ptr).id[index];
end

--[[
* Returns the current party members.
--]]
daoc.party.get_members = function ()
    local ptr = hook.pointers.get('game.ptr.party_members');
    if (ptr == 0) then return nil; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return nil; end
    return ffi.cast('party_t*', ptr).members;
end
