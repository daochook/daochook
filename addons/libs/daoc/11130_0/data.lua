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

local ffi = require 'ffi';

-- Ensure the daoc tables exists..
daoc = daoc or T{ };
daoc.data = daoc.data or T{ };

--[[
* Data Related Structure Definitions
--]]
ffi.cdef[[
    // File: spells.csv
    typedef struct {
        char name_[64];
        uint32_t icon;
        uint32_t anim1;
        uint32_t anim2;
        uint32_t anim3;
        uint32_t effect1a;
        uint32_t effect1b;
        uint32_t effect2;
        uint32_t effect3;
        uint32_t effect4[4];
        uint32_t set;
        uint32_t effect5[2];
        uint32_t lag;
        uint32_t anims;
        uint32_t caster_fx;
        uint32_t effect_on_cast;
    } spell_t;
]];

--[[
* Spell Related Helper Metatype Definitions
--]]

ffi.metatype('spell_t', T{
    __index = function (self, k)
        return switch(k, {
            ['name']            = function () return ffi.string(self.name_); end,
            [switch.default]    = function () return nil; end
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
* Returns the count of loaded spells.
--]]
daoc.data.get_spell_count = function ()
    local ptr = hook.pointers.get('game.ptr.spells');
    if (ptr == 0) then return 0; end
    return hook.memory.read_uint32(ptr - 0x16);
end

--[[
* Returns the loaded spells.csv data.
--]]
daoc.data.get_spells = function ()
    local ptr = hook.pointers.get('game.ptr.spells');
    if (ptr == 0) then return nil; end
    local cnt = hook.memory.read_uint32(ptr - 0x16);
    if (cnt <= 0) then return nil; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return nil; end
    return ffi.cast('spell_t*', ptr);
end

--[[
* Returns the loaded spells.csv data.
--]]
daoc.data.get_spell = function (index)
    local ptr = hook.pointers.get('game.ptr.spells');
    if (ptr == 0) then return nil; end
    local cnt = hook.memory.read_uint32(ptr - 0x16);
    if (cnt <= 0) then return nil; end

    if (index <= 0 or index > cnt) then return nil; end

    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return nil; end
    return ffi.cast('spell_t*', ptr)[index];
end