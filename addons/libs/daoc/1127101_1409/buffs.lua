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
daoc.buffs = daoc.buffs or T{ };

--[[
* Buff Related Structure Definitions
--]]
ffi.cdef[[
    typedef struct {
        char        name_[64];          // The buff name.
        int32_t     type;               // The buff type. (1 = immunity, 2 = protection)
        int32_t     time_remaining;     // The buff time remaining before it wears off. (in milliseconds, snapshot of the time when the buff was received.)
        int32_t     slot;               // The buff slot index. (Some buffs use slot -1.)
        int32_t     tooltip_id;         // The buff tooltip id.
        int32_t     stale_flag;         // The buff stale flag. (Set to 1 when the buff is marked as stale and needs to be refreshed/updated visually.)
        uint8_t     unknown00[8];       // Unknown.
        int32_t     effect_flag;        // The buff effect flag. (Set to 1 if the buff has a special negative or positive effect.)
        int32_t     unknown01;          // Unknown.
        int32_t     id;                 // The buff id.
        uint8_t     unknown02[64];      // Unknown.
    } buff_t;

    typedef struct {
        buff_t      buffs[75];          // The array of buffs.
    } playerbuffs_t;

    typedef struct {
        uint32_t    vtable_pointer;     // The buff timer vtable pointer.
        uint32_t    icon_id;            // The buff timer icon id.
        float       color_r;            // The buff icon color. (red)
        float       color_g;            // The buff icon color. (green)
        float       color_b;            // The buff icon color. (blue)
        uint32_t    disable_alpha;      // The buff icon disable alpha amount. (0 to 100)
        float       unknown00;          // Unknown.
        uint32_t    unknown01;          // Unknown.
        uint32_t    icon_x;             // The buff icon x position.
        uint32_t    icon_y;             // The buff icon y position.
        uint32_t    icon_width;         // The buff icon width.
        uint32_t    icon_height;        // The buff icon height.
        uint32_t    unknown02;          // Unknown.
        uint8_t     unknown03;          // Unknown.
        uint8_t     is_dirty;           // Flag that marks the timers timer string as dirty to be redrawn.
        uint8_t     unknown04;          // Unknown.
        uint8_t     unknown05;          // Unknown.
        uint32_t    unknown06;          // Unknown. (Flag set to 1 or 2 when the icon is first loaded.)
        uint32_t    tick_count;         // The buff icon current tick count.
        uint32_t    time_remaining;     // The buff icon time remaining. (In milliseconds.)
        char        icon_text[32];      // The buff icon overlay text.
        char        icon_timestamp[16]; // The buff icon time remaining timestamp.
        uint32_t    unknown07[3];       // Unknown. (Pointers used when rendering the icons.)
        uint32_t    unknown08;          // Unknown.
        uint32_t    index;              // The buff icon index.
        uint32_t    unknown09;          // Unknown.
    } bufftimer_t;

    typedef struct {
        bufftimer_t timers[75];         // The array of buff timers.
    } playerbufftimers_t;
]];

--[[
* Buff Related Helper Metatype Definitions
--]]

ffi.metatype('buff_t', T{
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
* Returns the local players buffs table.
--]]
daoc.buffs.get_buffs = function ()
    local ptr = hook.pointers.get('game.ptr.player_buffs');
    if (ptr == 0) then return nil; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return nil; end
    return ffi.cast('playerbuffs_t*', ptr).buffs;
end

--[[
* Returns the local players buff timers table.
--]]
daoc.buffs.get_timers = function ()
    local ptr = hook.pointers.get('game.ptr.player_buff_timers');
    if (ptr == 0) then return nil; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return nil; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return nil; end
    ptr = hook.memory.read_uint32(ptr + 0x160);
    if (ptr == 0) then return nil; end
    ptr = ptr + 0x280;
    return ffi.cast('playerbufftimers_t*', ptr).timers;
end
