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
daoc.entity = daoc.entity or T{ };

--[[
* Entity Related Enumerations
--]]

daoc.entity.status              = T{ };
daoc.entity.status.normal       = 0x00; -- The entity is standing normally.
daoc.entity.status.swimming     = 0x01; -- The entity is swimming.
daoc.entity.status.floating     = 0x02; -- The entity is floating. (Floating, falling or flying.)
daoc.entity.status.debug        = 0x03; -- The entity is floating. (Debug mode flying.)
daoc.entity.status.sitting      = 0x04; -- The entity is sitting.
daoc.entity.status.unknown05    = 0x05; -- Unknown.
daoc.entity.status.unknown06    = 0x06; -- Unknown.
daoc.entity.status.climbing     = 0x07; -- The entity is climbing.
daoc.entity.status.strafing     = 0x08; -- The entity is strafing.

daoc.entity.type                = T{ };
daoc.entity.type.object         = 0x00; -- The entity is an object.
daoc.entity.type.unknown01      = 0x01; -- Unknown. (01)
daoc.entity.type.npc            = 0x02; -- The entity is an npc.
daoc.entity.type.unknown03      = 0x03; -- Unknown. (03)
daoc.entity.type.player         = 0x04; -- The entity is a player.
daoc.entity.type.unknown05      = 0x05; -- Unknown. (05)
daoc.entity.type.unknown06      = 0x06; -- Unknown. (06)
daoc.entity.type.unknown07      = 0x07; -- Unknown. (07)

daoc.entity.strings             = T{ };
daoc.entity.strings.titles      = 0x00; -- The string table containing entity titles.
daoc.entity.strings.unknown01   = 0x01; -- Unknown.
daoc.entity.strings.unknown02   = 0x02; -- Unknown.
daoc.entity.strings.names       = 0x03; -- The string table containing entity names.
daoc.entity.strings.unknown04   = 0x04; -- Unknown.

--[[
* Entity Related Structure Definitions
--]]
ffi.cdef[[

    typedef struct {
        uint8_t     unknown00;
        uint8_t     unknown01;
        uint16_t    nif_id;
        uint32_t    unknown02;
        float       unknown03;
        float       unknown04;
        float       unknown05;
        float       unknown06;
        float       unknown07;
        uint8_t     unknown08[8];
        uint8_t     unknown09;
        uint8_t     unknown10;
        uint16_t    unknown12; // Possibly scale
        uint8_t     unknown13;
        uint8_t     unknown14;
        uint16_t    unknown15;
        uint8_t     unknown16;
        char        node[64];
        uint8_t     unknown17[3];
    } speffect_t;

    typedef struct {
        uint16_t    model_id_skin_tone;
        uint8_t     unknown00[10];
        uint16_t    tattoo;
        uint8_t     unknown01[6];
        uint16_t    render_shadow_flag;
        uint8_t     unknown02[6];
        uint32_t    unknown03;
        uint32_t    unknown04;
        uint32_t    unknown05;
        uint8_t     unknown06;
        uint8_t     unknown07;
        uint16_t    unknown08;
        uint32_t    model_id_rhand;
        uint32_t    model_id_lhand;
        uint32_t    model_id_2hand;
        uint32_t    model_id_ranged;
        uint32_t    unknown09;
        uint16_t    unknown10;
        uint16_t    unknown11;
        float       z_offset;
        float       x;
        uint16_t    state;
        uint16_t    unknown12;
        uint32_t    unknown13;
        uint8_t     unknown14[4];
        uint32_t    unknown15;
        uint32_t    unknown16;
        uint32_t    level;
        uint8_t     unknown17[276];
        uint8_t     unknown18;
        uint8_t     unknown19[9];
        uint16_t    model_id_face;
        uint8_t     unknown20[16];
        uint32_t    unknown21;
        uint8_t     unknown22[4];
        uint32_t    model_id;
        uint8_t     unknown23[8];
        uint16_t    unknown24;
        uint8_t     unknown25[6];
        uint16_t    wireframe_flag;
        uint8_t     unknown26[16];
        uint8_t     mounted_flag;
        uint8_t     unknown27[14];
        uint8_t     plane_align_flag;
        uint8_t     unknown28[72];
        uint8_t     unknown29;
        uint8_t     unknown30;
        float       unknown31;
        uint8_t     unknown32[4];
        uint16_t    model_id_hair_color;
        uint8_t     unknown33[2];
        uint32_t    health;
        uint8_t     unknown34[8];
        uint32_t    nameplate_index;
        uint8_t     unknown35[4];
        uint32_t    object_id;
        uint8_t     unknown36[4];
        uint32_t    unknown37;
        uint16_t    initialized_flag;
        uint8_t     unknown38[6];
        uint16_t    unknown39;          // Flag that sets the entity to 'stick' to the gronud when moving/jumping.
        uint8_t     unknown40[4];
        uint16_t    unknown41;          // Flag that stops the player from strafing and causes the camera to control differently.
        uint16_t    model_id_eye_color;
        uint8_t     unknown42[2];
        uint32_t    unknown43[4]; // Unknown, related to spell casting.
        uint32_t    realm_id;
        uint8_t     unknown44[16];
        float       unknown45;
        uint8_t     unknown46[2];
        uint16_t    animation_subid[4]; // Related to spell casting.
        uint16_t    object_type;
        uint8_t     unknown46_[4];
        uint16_t    model_id_hair_style;
        uint8_t     unknown47[202];
        uint16_t    unknown48;          // If set to 1, prevents the entity from being targeted.
        uint16_t    unknown49;
        uint8_t     vampir_flag;
        uint8_t     unknown50[3];
        uint32_t    unknown51;          // Used as a countdown timer.
        uint16_t    unknown52;
        uint8_t     unknown53[2];
        float       y;
        uint8_t     unknown54[4];
        float       unknown55;
        uint8_t     underwater_flag;
        uint8_t     unknown56[23];
        uint16_t    unknown57;          // Possibly guild id.
        uint8_t     unknown58;
        uint8_t     unknown59;
        uint8_t     unknown60[48];
        speffect_t  effects[20];        // The spell effects playing on the entity.
        uint32_t    unknown61;
        uint8_t     unknown62[4];
        uint16_t    unknown63;
        uint8_t     unknown64[2];
        float       unknown65;
        uint8_t     unknown66[30];
        uint16_t    heading;
        uint8_t     unknown67[4];
        uint16_t    unknown68;
        uint8_t     unknown69[2];
        uint32_t    unknown70;
        uint8_t     unknown71[2];
        uint16_t    unknown72;
        uint16_t    unknown73;
        uint8_t     unknown74;
        uint8_t     unknown75;
        uint16_t    unknown76;
        uint8_t     unknown77[6];
        uint16_t    unknown78;
        uint16_t    unknown79;
        uint8_t     unknown80[14];
        uint16_t    unknown81;
        uint8_t     unknown82[12];
        uint16_t    is_dead_flag;
        uint16_t    unknown83;          // Used as a model reference index.
        uint8_t     unknown84[8];
        uint16_t    unknown85;
        uint8_t     unknown86[2];
        uint16_t    unknown87;
        uint8_t     unknown88[6];
        uint32_t    unknown88_[4]; // Unknown, related to spell casting.
        uint8_t     unknown88__[8];
        uint32_t    animation_model_index; // Index of the animation model type being used for the entity.
        uint8_t     unknown89[18];
        uint16_t    unknown90;
        uint32_t    unknown91;
        uint8_t     unknown92;
        uint8_t     unknown93[79];
        int16_t     unknown94;
        uint8_t     unknown95[6];
        uint32_t    unknown96;
        uint16_t    unknown97;
        uint16_t    animation_speed;
        uint8_t     unknown98[12];
        uint32_t    unknown99;
        uint8_t     unknown100[16];
        uint32_t    last_update_tick;
        uint8_t     unknown101[8];
        uint32_t    unknown102;
        uint16_t    is_stealthed_flag;
        uint8_t     unknown103[26];
        uint8_t     unknown103_[4]; // Unknown, related to spell casting.
        uint32_t    attached_entity_index;
        uint16_t    unknown104;
        uint8_t     unknown105[2];
        uint32_t    model_id_equip_head;
        uint32_t    model_id_equip_hands;
        uint32_t    model_id_equip_feet;
        uint32_t    model_id_equip_jewel;
        uint32_t    model_id_equip_body;
        uint32_t    model_id_equip_cloak;
        uint32_t    model_id_equip_legs;
        uint32_t    model_id_equip_arms;
        uint32_t    model_id_equip_neck;
        uint32_t    model_id_equip_unk0;
        uint32_t    model_id_equip_unk1;
        uint32_t    model_id_equip_waist;
        uint32_t    model_id_equip_lbracer;
        uint32_t    model_id_equip_rbracer;
        uint32_t    model_id_equip_lring;
        uint32_t    model_id_equip_rring;
        uint32_t    model_id_equip_mythical;
        float       unknown106;
        uint8_t     unknown107[60];
        float       z;
        uint8_t     unknown108;
        uint8_t     unknown109[2723];
        float       unknown110;
        uint16_t    unknown111;
        uint8_t     unknown112[6];
        uint32_t    model_id_hornsize_noselength;
        uint32_t    model_id_eyes;
        uint32_t    model_id_lips_jaw_nosewidth_tusks_sharpness_tines;
        uint32_t    model_id_nosewidth_ears_jaw_spines;
        uint32_t    model_id_mood1;
        uint32_t    model_id_mood2;
        float       unknown113;
        uint8_t     unknown114[12];
        uint32_t    unknown115;
        uint32_t    unknown116;
        uint8_t     unknown117[20];
        uint16_t    unknown118;
        uint16_t    unknown119;
        uint8_t     unknown120;
        uint8_t     unknown121[3];
        float       unknown122;
        uint8_t     unknown123[8];
        float       unknown124;
        float       unknown125;
        uint32_t    unknown126;
        uint16_t    unknown127[4]; // Unknown, related to spell casting.
        uint16_t    unknown128;
        uint8_t     unknown129[6];
        float       unknown130;
        int32_t     unknown131;
        uint32_t    unknown132;
    } entity_t;

]];

--[[
* Entity Related Function Definitions
--]]
ffi.cdef[[
    typedef bool        (__fastcall *is_entity_valid_f)(const int32_t index);
    typedef entity_t*   (__fastcall *get_entity_f)(const int32_t index);
    typedef void        (__cdecl *set_target_f)(const uint32_t index, const uint8_t flag);
    typedef void        (__cdecl *repaint_target_window_f)(void);
]];

--[[
* Returns the current number of allocated and in-use entities.
--]]
daoc.entity.get_count = function ()
    local ptr = hook.pointers.get('entity.ptr.entity_count');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return 0; end
    return hook.memory.read_uint32(ptr);
end

--[[
* Returns if the entity at the given index is valid.
--]]
daoc.entity.is_valid = function (index)
    local ptr = hook.pointers.get('entity.func.is_valid');
    if (ptr == 0) then return nil; end
    return ffi.cast('is_entity_valid_f', ptr)(index);
end

--[[
* Returns the index of an entity by its object id.
--]]
daoc.entity.get_index_by_id = function (id)
    return game.get_entity_index_by_objectid(id);
end

--[[
* Returns the entity at the given index.
--]]
daoc.entity.get = function (index)
    local ptr = hook.pointers.get('entity.func.get');
    if (ptr == 0) then return nil; end
    return ffi.cast('get_entity_f', ptr)(index);
end

--[[
* Returns the entity string for the given index.
--]]
daoc.entity.get_string = function (table_index, entity_index)
    return game.get_entity_string(table_index, entity_index);
end

--[[
* Returns the local players entity index.
--]]
daoc.entity.get_player_index = function ()
    local state = daoc.states.get_game_state();
    if (state == nil) then return 0; end
    return state.player_entity_index;
end

----------------------------------------------------------------------------------------------------
--
-- Player Pet Related Functions
--
----------------------------------------------------------------------------------------------------

--[[
* Returns the local players pet entity index.
--]]
daoc.entity.get_pet_index = function ()
    local ptr = hook.pointers.get('entity.ptr.player_pet_info');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return 0; end
    return hook.memory.read_int32(ptr);
end

--[[
* Returns the local players pet entity object id.
--]]
daoc.entity.get_pet_objectid = function ()
    local ptr = hook.pointers.get('entity.ptr.player_pet_info');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return 0; end
    return hook.memory.read_int32(ptr + 0x04);
end

----------------------------------------------------------------------------------------------------
--
-- Target Related Functions
--
----------------------------------------------------------------------------------------------------

--[[
* Returns the local players target entity index.
--]]
daoc.entity.get_target_index = function ()
    local ptr = hook.pointers.get('entity.ptr.target_index');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return 0; end
    return hook.memory.read_uint32(ptr);
end

--[[
* Returns the local players target entity index.
--]]
daoc.entity.get_target_objectid = function ()
    local ptr = hook.pointers.get('entity.ptr.target_index');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return 0; end
    return hook.memory.read_uint32(ptr + 0x04);
end

--[[
* Sets the local players current target.
--]]
daoc.entity.set_target = function (index, examine_flag)
    if (not daoc.entity.is_valid(index)) then return false; end

    local ptr1 = hook.pointers.get('game.func.set_target');
    if (ptr1 == 0) then return false; end
    local ptr2 = hook.pointers.get('game.func.repaint_target_window');
    if (ptr1 == 0) then return false; end

    examine_flag = examine_flag or 0;

    ffi.cast('set_target_f', ptr1)(index, examine_flag);
    ffi.cast('repaint_target_window_f', ptr2)();

    return true;
end

--[[
* Returns the current targets health percent.
--]]
daoc.entity.get_target_health = function ()
    local ptr = hook.pointers.get('entity.ptr.target_info1');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr + 0x08);
    if (ptr == 0) then return 0; end
    return hook.memory.read_int32(ptr);
end

--[[
* Returns the current targets name color id.
--]]
daoc.entity.get_target_name_color_id = function ()
    local ptr = hook.pointers.get('entity.ptr.target_info1');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr + 0x01);
    if (ptr == 0) then return 0; end
    return hook.memory.read_int32(ptr);
end

--[[
* Returns the current targets difficulty.
* (-2 to 2, adds the --- or +++ characters to the name.)
--]]
daoc.entity.get_target_difficulty = function ()
    local ptr = hook.pointers.get('entity.ptr.target_info2');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr + 0x0A);
    if (ptr == 0) then return 0; end
    return hook.memory.read_int32(ptr);
end

--[[
* Returns the current targets name.
--]]
daoc.entity.get_target_name = function ()
    local ptr = hook.pointers.get('entity.ptr.target_info2');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr + 0x0A);
    if (ptr == 0) then return 0; end
    return hook.memory.read_string(ptr + 0x04, 64);
end