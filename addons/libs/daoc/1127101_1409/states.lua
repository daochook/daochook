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

require 'common';

local ffi = require 'ffi';

-- Ensure the daoc tables exists..
daoc = daoc or T{ };
daoc.states = daoc.states or T{ };

--[[
* State Related Structure Definitions
--]]
ffi.cdef[[
    // Game State [Size: 0x0EE0]
    typedef struct {
        uint8_t     unknown00[0x30];            // Unknown.
        uint32_t    player_status;              // The local players entity status.
        uint8_t     unknown01[0x30];            // Unknown.
        uint32_t    player_entity_index;        // The local players entity index.
    } gamestate_t;

    // Player State [Size: 0x0070]
    typedef struct {
        float       x;                          // The local players X coord.
        uint32_t    heading;                    // The local players heading direction. [0 to 4095]
        uint32_t    velocity_max_heading;       // The maximum heading velocity. (Set to 1500 every frame.)
        uint8_t     force_redraw;               // Flag that is used to redraw the area outward from the player. (Used when the player is leaving a collision area.)
        uint8_t     padding00[3];               // Padding. (Unused.)
        uint32_t    velocity_rampup_heading;    // The local players heading velocity. (Set to 10000 every frame.)
        float       camera_z;                   // The player camera Z coord.
        uint32_t    collision_id;               // The id (or type) of collision object/switch the player is either close to, or intersecting with.
        uint32_t    max_speed;                  // The local players maximum speed.
        float       camera_x;                   // The player camera X coord.
        uint32_t    unknown00;                  // Unknown. (Unused?)
        float       fog_resample;               // The current distance from the player the game has re-drawn when flagged to do so.
        uint32_t    velocity_max_x;             // The local players maximum X velocity.
        float       velocity_x2;                // The local players X velocity. (Momentum - North/South)   (Copy)
        float       velocity_y;                 // The local players Y velocity. (Momentum - East/West)     (Editable)
        uint32_t    current_max_speed_x;        // The local players calculated maximum speed. (X Axis)
        float       unknown01;                  // Unknown. (Used with how shadows are being casted.)
        uint8_t     unknown02;                  // Unknown. (Used as a flag during certain conditions. When the player is near a building, on a slope, climbing, etc.)
        uint8_t     padding01[3];               // Padding. (Unused.)
        float       velocity_x;                 // The local players X velocity. (Momentum - North/South)   (Editable)
        uint32_t    velocity_rampdown_heading;  // The ramping down value used to slow the player down when turning and jumping. (Set to 30000 every frame.)
        float       y;                          // The local players Y coord.
        float       velocity_z;                 // The local players Z velocity. (Momentum - Up/Down)   (Editable)
        uint32_t    is_turning_disabled;        // Flag that prevents the player from turning when enabled.
        float       z;                          // The local players Z coord.
        uint32_t    swim_speed;                 // The local players swimming speed. (Added to the actual speed of swimming.)
        float       camera_y;                   // The player camera Z coord.
        uint8_t     is_underwater;              // Flag that states if the local player is under water. (If true, shows breathing bar info.)
        uint8_t     padding02[3];               // Padding. (Unused.)
        uint32_t    velocity_ramp_speed;        // The speed at which a player ramps up to their maximum velocity. (250 for movement, 62 when jumping.)
        uint32_t    velocity_heading;           // The local players heading velocity.
    } playerstate_t;

    // Player Name State [Size: 0x0198]
    typedef struct {
        char        character_name_[0x20];      // The local players character name.     (Encoded.)
        char        account_name_[0x28];        // The local players account login name. (Encoded.)
        char        zone_name_[0x20];           // The local players current zone name.  (Encoded.)
        char        guild_name_[0x20];          // The local players current guild name. (Not encoded.)
        char        prefix_[0x20];              // The local players name prefix.        (Not encoded.)
        char        title_[0x20];               // The local players current title.      (Not encoded.)
        char        last_name_[0x20];           // The local players last name.          (Not encoded.)
    } playernamesstate_t;

]];

--[[
* State Related Helper Metatype Definitions
--]]

ffi.metatype('playernamesstate_t', T{
    __index = function (self, k)
        return switch(k, {
            ['character_name']  = function () return daoc.game.decode_string(self.character_name_); end,
            ['account_name']    = function () return daoc.game.decode_string(self.account_name_); end,
            ['zone_name']       = function () return daoc.game.decode_string(self.zone_name_); end,
            ['guild_name']      = function () return ffi.string(self.guild_name_); end,
            ['prefix']          = function () return ffi.string(self.prefix_); end,
            ['title']           = function () return ffi.string(self.title_); end,
            ['last_name']       = function () return ffi.string(self.last_name_); end,
            [switch.default]    = function () return nil; end
        });
    end,
    __newindex = function (self, k, v)
        error('read-only type');
    end
});

--[[
* Returns the current game state.
--]]
daoc.states.get_game_state = function ()
    local state = game.get_game_state();
    if (state == 0 or state == nil) then return nil; end
    return ffi.cast('gamestate_t**', state)[0];
end

--[[
* Returns the current local player state.
--]]
daoc.states.get_player_state = function ()
    local ptr = hook.pointers.get('game.ptr.player_state');
    if (ptr == 0) then return nil; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return nil; end
    return ffi.cast('playerstate_t**', ptr)[0];
end

--[[
* Returns the current local player names state.
--]]
daoc.states.get_names_state = function ()
    local ptr = hook.pointers.get('game.ptr.player_names_state');
    if (ptr == 0) then return nil; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return nil; end
    return ffi.cast('playernamesstate_t**', ptr)[0];
end
