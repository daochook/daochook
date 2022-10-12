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
daoc.items = daoc.items or T{ };

--[[
* Item Slots Enumerations
--]]
daoc.items.slots                            = T{ };
daoc.items.slots.invalid                    = 0;
daoc.items.slots.ground                     = 1;
daoc.items.slots.unknown_002                = 2;
daoc.items.slots.unknown_003                = 3;
daoc.items.slots.unknown_004                = 4;
daoc.items.slots.unknown_005                = 5;
daoc.items.slots.unknown_006                = 6;
daoc.items.slots.horse_armor                = 7;
daoc.items.slots.horse_barding              = 8;
daoc.items.slots.horse                      = 9;
daoc.items.slots.equip_rhand                = 10;
daoc.items.slots.equip_lhand                = 11;
daoc.items.slots.equip_2hand                = 12;
daoc.items.slots.equip_ranged               = 13;
daoc.items.slots.equip_quiver1              = 14;
daoc.items.slots.equip_quiver2              = 15;
daoc.items.slots.equip_quiver3              = 16;
daoc.items.slots.equip_quiver4              = 17;
daoc.items.slots.unknown_018                = 18;
daoc.items.slots.unknown_019                = 19;
daoc.items.slots.unknown_020                = 20;
daoc.items.slots.equip_head                 = 21;
daoc.items.slots.equip_hands                = 22;
daoc.items.slots.equip_feet                 = 23;
daoc.items.slots.equip_jewel                = 24;
daoc.items.slots.equip_body                 = 25;
daoc.items.slots.equip_cloak                = 26;
daoc.items.slots.equip_legs                 = 27;
daoc.items.slots.equip_arms                 = 28;
daoc.items.slots.equip_neck                 = 29;
daoc.items.slots.unknown_030                = 30;
daoc.items.slots.unknown_031                = 31;
daoc.items.slots.equip_waist                = 32;
daoc.items.slots.equip_lbracer              = 33;
daoc.items.slots.equip_rbracer              = 34;
daoc.items.slots.equip_lring                = 35;
daoc.items.slots.equip_rring                = 36;
daoc.items.slots.equip_mythical             = 37;
daoc.items.slots.unknown_038                = 38;
daoc.items.slots.unknown_039                = 39;
daoc.items.slots.inv_bag1_slot1             = 40;
daoc.items.slots.inv_bag1_slot2             = 41;
daoc.items.slots.inv_bag1_slot3             = 42;
daoc.items.slots.inv_bag1_slot4             = 43;
daoc.items.slots.inv_bag1_slot5             = 44;
daoc.items.slots.inv_bag1_slot6             = 45;
daoc.items.slots.inv_bag1_slot7             = 46;
daoc.items.slots.inv_bag1_slot8             = 47;
daoc.items.slots.inv_bag2_slot1             = 48;
daoc.items.slots.inv_bag2_slot2             = 49;
daoc.items.slots.inv_bag2_slot3             = 50;
daoc.items.slots.inv_bag2_slot4             = 51;
daoc.items.slots.inv_bag2_slot5             = 52;
daoc.items.slots.inv_bag2_slot6             = 53;
daoc.items.slots.inv_bag2_slot7             = 54;
daoc.items.slots.inv_bag2_slot8             = 55;
daoc.items.slots.inv_bag3_slot1             = 56;
daoc.items.slots.inv_bag3_slot2             = 57;
daoc.items.slots.inv_bag3_slot3             = 58;
daoc.items.slots.inv_bag3_slot4             = 59;
daoc.items.slots.inv_bag3_slot5             = 60;
daoc.items.slots.inv_bag3_slot6             = 61;
daoc.items.slots.inv_bag3_slot7             = 62;
daoc.items.slots.inv_bag3_slot8             = 63;
daoc.items.slots.inv_bag4_slot1             = 64;
daoc.items.slots.inv_bag4_slot2             = 65;
daoc.items.slots.inv_bag4_slot3             = 66;
daoc.items.slots.inv_bag4_slot4             = 67;
daoc.items.slots.inv_bag4_slot5             = 68;
daoc.items.slots.inv_bag4_slot6             = 69;
daoc.items.slots.inv_bag4_slot7             = 70;
daoc.items.slots.inv_bag4_slot8             = 71;
daoc.items.slots.inv_bag5_slot1             = 72;
daoc.items.slots.inv_bag5_slot2             = 73;
daoc.items.slots.inv_bag5_slot3             = 74;
daoc.items.slots.inv_bag5_slot4             = 75;
daoc.items.slots.inv_bag5_slot5             = 76;
daoc.items.slots.inv_bag5_slot6             = 77;
daoc.items.slots.inv_bag5_slot7             = 78;
daoc.items.slots.inv_bag5_slot8             = 79;
daoc.items.slots.horsebag1_slot1            = 80;
daoc.items.slots.horsebag1_slot2            = 81;
daoc.items.slots.horsebag1_slot3            = 82;
daoc.items.slots.horsebag1_slot4            = 83;
daoc.items.slots.horsebag2_slot1            = 84;
daoc.items.slots.horsebag2_slot2            = 85;
daoc.items.slots.horsebag2_slot3            = 86;
daoc.items.slots.horsebag2_slot4            = 87;
daoc.items.slots.horsebag3_slot1            = 88;
daoc.items.slots.horsebag3_slot2            = 89;
daoc.items.slots.horsebag3_slot3            = 90;
daoc.items.slots.horsebag3_slot4            = 91;
daoc.items.slots.horsebag4_slot1            = 92;
daoc.items.slots.horsebag4_slot2            = 93;
daoc.items.slots.horsebag4_slot3            = 94;
daoc.items.slots.horsebag4_slot4            = 95;
daoc.items.slots.saddlebag_lfront           = 96;
daoc.items.slots.saddlebag_rfront           = 97;
daoc.items.slots.saddlebag_lrear            = 98;
daoc.items.slots.saddlebag_rrear            = 99;
daoc.items.slots.player_paperdoll           = 100;
daoc.items.slots.money_mithril              = 101; -- Old money slots. (Unused on this client version.)
daoc.items.slots.money_platinum             = 102; -- Old money slots. (Unused on this client version.)
daoc.items.slots.money_gold                 = 103; -- Old money slots. (Unused on this client version.)
daoc.items.slots.money_silver               = 104; -- Old money slots. (Unused on this client version.)
daoc.items.slots.money_copper               = 105; -- Old money slots. (Unused on this client version.)
daoc.items.slots.unknown_106                = 106;
daoc.items.slots.unknown_107                = 107;
daoc.items.slots.unknown_108                = 108;
daoc.items.slots.unknown_109                = 109;
daoc.items.slots.vault1_slot1               = 110; -- Vault Page 1
daoc.items.slots.vault1_slot2               = 111;
daoc.items.slots.vault1_slot3               = 112;
daoc.items.slots.vault1_slot4               = 113;
daoc.items.slots.vault1_slot5               = 114;
daoc.items.slots.vault1_slot6               = 115;
daoc.items.slots.vault1_slot7               = 116;
daoc.items.slots.vault1_slot8               = 117;
daoc.items.slots.vault1_slot9               = 118;
daoc.items.slots.vault1_slot10              = 119;
daoc.items.slots.vault1_slot11              = 120;
daoc.items.slots.vault1_slot12              = 121;
daoc.items.slots.vault1_slot13              = 122;
daoc.items.slots.vault1_slot14              = 123;
daoc.items.slots.vault1_slot15              = 124;
daoc.items.slots.vault1_slot16              = 125;
daoc.items.slots.vault1_slot17              = 126;
daoc.items.slots.vault1_slot18              = 127;
daoc.items.slots.vault1_slot19              = 128;
daoc.items.slots.vault1_slot20              = 129;
daoc.items.slots.vault2_slot1               = 130; -- Vault Page 2
daoc.items.slots.vault2_slot2               = 131;
daoc.items.slots.vault2_slot3               = 132;
daoc.items.slots.vault2_slot4               = 133;
daoc.items.slots.vault2_slot5               = 134;
daoc.items.slots.vault2_slot6               = 135;
daoc.items.slots.vault2_slot7               = 136;
daoc.items.slots.vault2_slot8               = 137;
daoc.items.slots.vault2_slot9               = 138;
daoc.items.slots.vault2_slot10              = 139;
daoc.items.slots.vault2_slot11              = 140;
daoc.items.slots.vault2_slot12              = 141;
daoc.items.slots.vault2_slot13              = 142;
daoc.items.slots.vault2_slot14              = 143;
daoc.items.slots.vault2_slot15              = 144;
daoc.items.slots.vault2_slot16              = 145;
daoc.items.slots.vault2_slot17              = 146;
daoc.items.slots.vault2_slot18              = 147;
daoc.items.slots.vault2_slot19              = 148;
daoc.items.slots.vault2_slot20              = 149;
daoc.items.slots.player_merchant1_slot1     = 150; -- Player Merchant Page 1
daoc.items.slots.player_merchant1_slot2     = 151;
daoc.items.slots.player_merchant1_slot3     = 152;
daoc.items.slots.player_merchant1_slot4     = 153;
daoc.items.slots.player_merchant1_slot5     = 154;
daoc.items.slots.player_merchant1_slot6     = 155;
daoc.items.slots.player_merchant1_slot7     = 156;
daoc.items.slots.player_merchant1_slot8     = 157;
daoc.items.slots.player_merchant1_slot9     = 158;
daoc.items.slots.player_merchant1_slot10    = 159;
daoc.items.slots.player_merchant1_slot11    = 160;
daoc.items.slots.player_merchant1_slot12    = 161;
daoc.items.slots.player_merchant1_slot13    = 162;
daoc.items.slots.player_merchant1_slot14    = 163;
daoc.items.slots.player_merchant1_slot15    = 164;
daoc.items.slots.player_merchant1_slot16    = 165;
daoc.items.slots.player_merchant1_slot17    = 166;
daoc.items.slots.player_merchant1_slot18    = 167;
daoc.items.slots.player_merchant1_slot19    = 168;
daoc.items.slots.player_merchant1_slot20    = 169;
daoc.items.slots.player_merchant2_slot1     = 170; -- Player Merchant Page 2
daoc.items.slots.player_merchant2_slot2     = 171;
daoc.items.slots.player_merchant2_slot3     = 172;
daoc.items.slots.player_merchant2_slot4     = 173;
daoc.items.slots.player_merchant2_slot5     = 174;
daoc.items.slots.player_merchant2_slot6     = 175;
daoc.items.slots.player_merchant2_slot7     = 176;
daoc.items.slots.player_merchant2_slot8     = 177;
daoc.items.slots.player_merchant2_slot9     = 178;
daoc.items.slots.player_merchant2_slot10    = 179;
daoc.items.slots.player_merchant2_slot11    = 180;
daoc.items.slots.player_merchant2_slot12    = 181;
daoc.items.slots.player_merchant2_slot13    = 182;
daoc.items.slots.player_merchant2_slot14    = 183;
daoc.items.slots.player_merchant2_slot15    = 184;
daoc.items.slots.player_merchant2_slot16    = 185;
daoc.items.slots.player_merchant2_slot17    = 186;
daoc.items.slots.player_merchant2_slot18    = 187;
daoc.items.slots.player_merchant2_slot19    = 188;
daoc.items.slots.player_merchant2_slot20    = 189;
daoc.items.slots.player_merchant3_slot1     = 190; -- Player Merchant Page 3
daoc.items.slots.player_merchant3_slot2     = 191;
daoc.items.slots.player_merchant3_slot3     = 192;
daoc.items.slots.player_merchant3_slot4     = 193;
daoc.items.slots.player_merchant3_slot5     = 194;
daoc.items.slots.player_merchant3_slot6     = 195;
daoc.items.slots.player_merchant3_slot7     = 196;
daoc.items.slots.player_merchant3_slot8     = 197;
daoc.items.slots.player_merchant3_slot9     = 198;
daoc.items.slots.player_merchant3_slot10    = 199;
daoc.items.slots.player_merchant3_slot11    = 200;
daoc.items.slots.player_merchant3_slot12    = 201;
daoc.items.slots.player_merchant3_slot13    = 202;
daoc.items.slots.player_merchant3_slot14    = 203;
daoc.items.slots.player_merchant3_slot15    = 204;
daoc.items.slots.player_merchant3_slot16    = 205;
daoc.items.slots.player_merchant3_slot17    = 206;
daoc.items.slots.player_merchant3_slot18    = 207;
daoc.items.slots.player_merchant3_slot19    = 208;
daoc.items.slots.player_merchant3_slot20    = 209;
daoc.items.slots.player_merchant4_slot1     = 210; -- Player Merchant Page 4
daoc.items.slots.player_merchant4_slot2     = 211;
daoc.items.slots.player_merchant4_slot3     = 212;
daoc.items.slots.player_merchant4_slot4     = 213;
daoc.items.slots.player_merchant4_slot5     = 214;
daoc.items.slots.player_merchant4_slot6     = 215;
daoc.items.slots.player_merchant4_slot7     = 216;
daoc.items.slots.player_merchant4_slot8     = 217;
daoc.items.slots.player_merchant4_slot9     = 218;
daoc.items.slots.player_merchant4_slot10    = 219;
daoc.items.slots.player_merchant4_slot11    = 220;
daoc.items.slots.player_merchant4_slot12    = 221;
daoc.items.slots.player_merchant4_slot13    = 222;
daoc.items.slots.player_merchant4_slot14    = 223;
daoc.items.slots.player_merchant4_slot15    = 224;
daoc.items.slots.player_merchant4_slot16    = 225;
daoc.items.slots.player_merchant4_slot17    = 226;
daoc.items.slots.player_merchant4_slot18    = 227;
daoc.items.slots.player_merchant4_slot19    = 228;
daoc.items.slots.player_merchant4_slot20    = 229;
daoc.items.slots.player_merchant5_slot1     = 230; -- Player Merchant Page 5
daoc.items.slots.player_merchant5_slot2     = 231;
daoc.items.slots.player_merchant5_slot3     = 232;
daoc.items.slots.player_merchant5_slot4     = 233;
daoc.items.slots.player_merchant5_slot5     = 234;
daoc.items.slots.player_merchant5_slot6     = 235;
daoc.items.slots.player_merchant5_slot7     = 236;
daoc.items.slots.player_merchant5_slot8     = 237;
daoc.items.slots.player_merchant5_slot9     = 238;
daoc.items.slots.player_merchant5_slot10    = 239;
daoc.items.slots.player_merchant5_slot11    = 240;
daoc.items.slots.player_merchant5_slot12    = 241;
daoc.items.slots.player_merchant5_slot13    = 242;
daoc.items.slots.player_merchant5_slot14    = 243;
daoc.items.slots.player_merchant5_slot15    = 244;
daoc.items.slots.player_merchant5_slot16    = 245;
daoc.items.slots.player_merchant5_slot17    = 246;
daoc.items.slots.player_merchant5_slot18    = 247;
daoc.items.slots.player_merchant5_slot19    = 248;
daoc.items.slots.player_merchant5_slot20    = 249;

-- Slot Range Helpers
daoc.items.slots.equip_min                  = 10;
daoc.items.slots.equip_max                  = 37;
daoc.items.slots.inv_min                    = 40;
daoc.items.slots.inv_max                    = 79;
daoc.items.slots.horsebag_min               = 80;
daoc.items.slots.horsebag_max               = 95;
daoc.items.slots.vault_min                  = 110;
daoc.items.slots.vault_max                  = 149;
daoc.items.slots.player_merchant_min        = 150;
daoc.items.slots.player_merchant_max        = 249;

-- Newer Client Slots
daoc.items.slots.money_mithril_new          = 500;
daoc.items.slots.money_platinum_new         = 501;
daoc.items.slots.money_gold_new             = 502;
daoc.items.slots.money_silver_new           = 503;
daoc.items.slots.money_copper_new           = 504;
daoc.items.slots.player_paperdoll_new       = 600;

--[[
* Item Types Enumerations
--]]
daoc.items.types                        = T{ };
daoc.items.types.generic                = 0;
daoc.items.types.weapon_generic         = 1;
daoc.items.types.weapon_crushing        = 2;
daoc.items.types.weapon_slashing        = 3;
daoc.items.types.weapon_thrusting       = 4;
daoc.items.types.weapon_fired           = 5;
daoc.items.types.weapon_two_handed      = 6;
daoc.items.types.weapon_polearm         = 7;
daoc.items.types.weapon_staff           = 8;
daoc.items.types.weapon_longbow         = 9;
daoc.items.types.weapon_crossbow        = 10;
daoc.items.types.weapon_sword           = 11;
daoc.items.types.weapon_hammer          = 12;
daoc.items.types.weapon_axe             = 13;
daoc.items.types.weapon_spear           = 14;
daoc.items.types.weapon_composite_bow   = 15;
daoc.items.types.weapon_thrown          = 16;
daoc.items.types.weapon_left_axe        = 17;
daoc.items.types.weapon_recurved_bow    = 18;
daoc.items.types.weapon_blades          = 19;
daoc.items.types.weapon_blunt           = 20;
daoc.items.types.weapon_piercing        = 21;
daoc.items.types.weapon_large_weapons   = 22;
daoc.items.types.weapon_celtic_spear    = 23;
daoc.items.types.weapon_flexible        = 24;
daoc.items.types.weapon_hand_to_hand    = 25;
daoc.items.types.weapon_scythe          = 26;
daoc.items.types.weapon_fist_wraps      = 27;
daoc.items.types.weapon_mauler_staff    = 28;
daoc.items.types.unknown_29             = 29;
daoc.items.types.unknown_30             = 30;
daoc.items.types.armor_generic          = 31;
daoc.items.types.armor_cloth            = 32;
daoc.items.types.armor_leather          = 33;
daoc.items.types.armor_studded          = 34;
daoc.items.types.armor_chain            = 35;
daoc.items.types.armor_plate            = 36;
daoc.items.types.armor_reinforced       = 37;
daoc.items.types.armor_scale            = 38;
daoc.items.types.unknown_39             = 39;
daoc.items.types.unknown_40             = 40;
daoc.items.types.magical                = 41;
daoc.items.types.shield                 = 42;
daoc.items.types.arrow                  = 43;
daoc.items.types.bolt                   = 44;
daoc.items.types.instrument             = 45;
daoc.items.types.poison                 = 46;
daoc.items.types.tincture               = 47;
daoc.items.types.spellcraft_gem         = 48;
daoc.items.types.garden_object          = 49;
daoc.items.types.house_wall_object      = 50;
daoc.items.types.house_floor_object     = 51;
daoc.items.types.house_carpet1          = 52;
daoc.items.types.house_npc              = 53;
daoc.items.types.house_vault            = 54;
daoc.items.types.house_interior         = 55;
daoc.items.types.house_tent_color       = 56;
daoc.items.types.house_exterior_banner  = 57;
daoc.items.types.house_exterior_shield  = 58;
daoc.items.types.house_roof_material    = 59;
daoc.items.types.house_wall_material    = 60;
daoc.items.types.house_door_material    = 61;
daoc.items.types.house_porch_material   = 62;
daoc.items.types.house_wood_material    = 63;
daoc.items.types.house_shutter_material = 64;
daoc.items.types.unknown_64             = 64;
daoc.items.types.house_interior_banner  = 66;
daoc.items.types.house_interior_shield  = 67;
daoc.items.types.house_bindstone        = 68;
daoc.items.types.house_carpet2          = 69;
daoc.items.types.house_carpet3          = 70;
daoc.items.types.house_carpet4          = 71;
daoc.items.types.unknown_72             = 72;
daoc.items.types.unknown_73             = 73;
daoc.items.types.unknown_74             = 74;
daoc.items.types.unknown_75             = 75;
daoc.items.types.unknown_76             = 76;
daoc.items.types.unknown_77             = 77;
daoc.items.types.unknown_78             = 78;
daoc.items.types.unknown_79             = 79;
daoc.items.types.siege_balista          = 80;
daoc.items.types.siege_catapult         = 81;
daoc.items.types.siege_cauldron         = 82;
daoc.items.types.siege_ram              = 83;
daoc.items.types.siege_trebuchet        = 84;

-- Item Type Helpers
daoc.items.types.weapon_first           = 1;
daoc.items.types.weapon_last            = 28;
daoc.items.types.armor_first            = 31;
daoc.items.types.armor_last             = 38;
daoc.items.types.house_first            = 49;
daoc.items.types.house_last             = 71;

--[[
* Item Related Structure Definitions
--]]
ffi.cdef[[
    typedef struct {
        uint32_t    id;                 // The item id. [ie. Unique id if used.]
        uint32_t    model;              // The item model.
        uint32_t    color;              // The item color. [Also used as emblem depending on the item type.]
        uint32_t    effect;             // The item effect.
        uint32_t    level;              // The item level.
        uint32_t    value1;             // The item value1. (Value depends on item type. Count, Damage, DPS, Factor)
        uint32_t    value2;             // The item value2. (Value depends on item type. Absorb, Count, Speed)
        uint32_t    value3;             // The item value3. (Value depends on item type. DPS, Factor, Hand)
        uint32_t    type;               // The item type.
        uint32_t    unknown00;          // Unknown.
        uint32_t    weight;             // The item weight.
        uint32_t    condition;          // The item condition percent.
        uint32_t    durability;         // The item durability percent.
        uint32_t    quality;            // The item quality percent.
        uint32_t    bonus;              // The item bonus.
        uint32_t    bonus_level;        // The item bonus level.
        uint32_t    unknown01;          // Unknown.
        uint32_t    extension;          // The item extension.
        uint32_t    flags;              // The item flags.
        char        name_[128];         // The item name.
        char        spell1_name_[128];  // The item spell name. (1) [Set when (flags & 0x08) == 0x08]
        uint32_t    spell1_icon;        // The item spell icon. (1) [Set when (flags & 0x08) == 0x08]
        char        spell2_name_[128];  // The item spell name. (2) [Set when (flags & 0x10) == 0x10]
        uint32_t    spell2_icon;        // The item spell icon. (2) [Set when (flags & 0x10) == 0x10]
    } item_t;

    typedef struct {
        item_t      items[250];         // The array of item slots.
    } slots_t;
]];

--[[
* Item Related Helper Metatype Definitions
--]]

ffi.metatype('item_t', T{
    __index = function (self, k)
        return switch(k, {
            ['name'] = function () return ffi.string(self.name_); end,
            ['spell1_name'] = function () return ffi.string(self.spell1_name_); end,
            ['spell2_name'] = function () return ffi.string(self.spell2_name_); end,
            [switch.default] = function () return nil; end
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
* Returns the name of a given slot index.
--]]
daoc.items.get_slot_name = function (index)
    return switch(index, T{
        [daoc.items.slots.invalid]           = function () return 'invalid'; end,
        [daoc.items.slots.ground]            = function () return 'ground'; end,
        [daoc.items.slots.unknown_002]       = function () return 'unknown (002)'; end,
        [daoc.items.slots.unknown_003]       = function () return 'unknown (003)'; end,
        [daoc.items.slots.unknown_004]       = function () return 'unknown (004)'; end,
        [daoc.items.slots.unknown_005]       = function () return 'unknown (005)'; end,
        [daoc.items.slots.unknown_006]       = function () return 'unknown (006)'; end,
        [daoc.items.slots.horse_armor]       = function () return 'horse armor'; end,
        [daoc.items.slots.horse_barding]     = function () return 'horse barding'; end,
        [daoc.items.slots.horse]             = function () return 'horse'; end,
        [daoc.items.slots.equip_rhand]       = function () return 'equipped (right hand)'; end,
        [daoc.items.slots.equip_lhand]       = function () return 'equipped (left hand)'; end,
        [daoc.items.slots.equip_2hand]       = function () return 'equipped (2-hand)'; end,
        [daoc.items.slots.equip_ranged]      = function () return 'equipped (ranged)'; end,
        [daoc.items.slots.equip_quiver1]     = function () return 'equipped (quiver 1)'; end,
        [daoc.items.slots.equip_quiver2]     = function () return 'equipped (quiver 2)'; end,
        [daoc.items.slots.equip_quiver3]     = function () return 'equipped (quiver 3)'; end,
        [daoc.items.slots.equip_quiver4]     = function () return 'equipped (quiver 4)'; end,
        [daoc.items.slots.unknown_018]       = function () return 'unknown (018)'; end,
        [daoc.items.slots.unknown_019]       = function () return 'unknown (019)'; end,
        [daoc.items.slots.unknown_020]       = function () return 'unknown (020)'; end,
        [daoc.items.slots.equip_head]        = function () return 'equipped (head)'; end,
        [daoc.items.slots.equip_hands]       = function () return 'equipped (hands)'; end,
        [daoc.items.slots.equip_feet]        = function () return 'equipped (feet)'; end,
        [daoc.items.slots.equip_jewel]       = function () return 'equipped (jewel)'; end,
        [daoc.items.slots.equip_body]        = function () return 'equipped (body)'; end,
        [daoc.items.slots.equip_cloak]       = function () return 'equipped (cloak)'; end,
        [daoc.items.slots.equip_legs]        = function () return 'equipped (legs)'; end,
        [daoc.items.slots.equip_arms]        = function () return 'equipped (arms)'; end,
        [daoc.items.slots.equip_neck]        = function () return 'equipped (neck)'; end,
        [daoc.items.slots.unknown_030]       = function () return 'unknown (030)'; end,
        [daoc.items.slots.unknown_031]       = function () return 'unknown (031)'; end,
        [daoc.items.slots.equip_waist]       = function () return 'equipped (waist)'; end,
        [daoc.items.slots.equip_lbracer]     = function () return 'equipped (left bracer)'; end,
        [daoc.items.slots.equip_rbracer]     = function () return 'equipped (right bracer)'; end,
        [daoc.items.slots.equip_lring]       = function () return 'equipped (left ring)'; end,
        [daoc.items.slots.equip_rring]       = function () return 'equipped (right ring)'; end,
        [daoc.items.slots.equip_mythical]    = function () return 'equipped (mythical)'; end,
        [daoc.items.slots.unknown_038]       = function () return 'unknown (038)'; end,
        [daoc.items.slots.unknown_039]       = function () return 'unknown (039)'; end,
        [daoc.items.slots.inv_bag1_slot1]    = function () return 'inventory bag 1, slot 1'; end,
        [daoc.items.slots.inv_bag1_slot2]    = function () return 'inventory bag 1, slot 2'; end,
        [daoc.items.slots.inv_bag1_slot3]    = function () return 'inventory bag 1, slot 3'; end,
        [daoc.items.slots.inv_bag1_slot4]    = function () return 'inventory bag 1, slot 4'; end,
        [daoc.items.slots.inv_bag1_slot5]    = function () return 'inventory bag 1, slot 5'; end,
        [daoc.items.slots.inv_bag1_slot6]    = function () return 'inventory bag 1, slot 6'; end,
        [daoc.items.slots.inv_bag1_slot7]    = function () return 'inventory bag 1, slot 7'; end,
        [daoc.items.slots.inv_bag1_slot8]    = function () return 'inventory bag 1, slot 8'; end,
        [daoc.items.slots.inv_bag2_slot1]    = function () return 'inventory bag 2, slot 1'; end,
        [daoc.items.slots.inv_bag2_slot2]    = function () return 'inventory bag 2, slot 2'; end,
        [daoc.items.slots.inv_bag2_slot3]    = function () return 'inventory bag 2, slot 3'; end,
        [daoc.items.slots.inv_bag2_slot4]    = function () return 'inventory bag 2, slot 4'; end,
        [daoc.items.slots.inv_bag2_slot5]    = function () return 'inventory bag 2, slot 5'; end,
        [daoc.items.slots.inv_bag2_slot6]    = function () return 'inventory bag 2, slot 6'; end,
        [daoc.items.slots.inv_bag2_slot7]    = function () return 'inventory bag 2, slot 7'; end,
        [daoc.items.slots.inv_bag2_slot8]    = function () return 'inventory bag 2, slot 8'; end,
        [daoc.items.slots.inv_bag3_slot1]    = function () return 'inventory bag 3, slot 1'; end,
        [daoc.items.slots.inv_bag3_slot2]    = function () return 'inventory bag 3, slot 2'; end,
        [daoc.items.slots.inv_bag3_slot3]    = function () return 'inventory bag 3, slot 3'; end,
        [daoc.items.slots.inv_bag3_slot4]    = function () return 'inventory bag 3, slot 4'; end,
        [daoc.items.slots.inv_bag3_slot5]    = function () return 'inventory bag 3, slot 5'; end,
        [daoc.items.slots.inv_bag3_slot6]    = function () return 'inventory bag 3, slot 6'; end,
        [daoc.items.slots.inv_bag3_slot7]    = function () return 'inventory bag 3, slot 7'; end,
        [daoc.items.slots.inv_bag3_slot8]    = function () return 'inventory bag 3, slot 8'; end,
        [daoc.items.slots.inv_bag4_slot1]    = function () return 'inventory bag 4, slot 1'; end,
        [daoc.items.slots.inv_bag4_slot2]    = function () return 'inventory bag 4, slot 2'; end,
        [daoc.items.slots.inv_bag4_slot3]    = function () return 'inventory bag 4, slot 3'; end,
        [daoc.items.slots.inv_bag4_slot4]    = function () return 'inventory bag 4, slot 4'; end,
        [daoc.items.slots.inv_bag4_slot5]    = function () return 'inventory bag 4, slot 5'; end,
        [daoc.items.slots.inv_bag4_slot6]    = function () return 'inventory bag 4, slot 6'; end,
        [daoc.items.slots.inv_bag4_slot7]    = function () return 'inventory bag 4, slot 7'; end,
        [daoc.items.slots.inv_bag4_slot8]    = function () return 'inventory bag 4, slot 8'; end,
        [daoc.items.slots.inv_bag5_slot1]    = function () return 'inventory bag 5, slot 1'; end,
        [daoc.items.slots.inv_bag5_slot2]    = function () return 'inventory bag 5, slot 2'; end,
        [daoc.items.slots.inv_bag5_slot3]    = function () return 'inventory bag 5, slot 3'; end,
        [daoc.items.slots.inv_bag5_slot4]    = function () return 'inventory bag 5, slot 4'; end,
        [daoc.items.slots.inv_bag5_slot5]    = function () return 'inventory bag 5, slot 5'; end,
        [daoc.items.slots.inv_bag5_slot6]    = function () return 'inventory bag 5, slot 6'; end,
        [daoc.items.slots.inv_bag5_slot7]    = function () return 'inventory bag 5, slot 7'; end,
        [daoc.items.slots.inv_bag5_slot8]    = function () return 'inventory bag 5, slot 8'; end,
        [daoc.items.slots.horsebag1_slot1]   = function () return 'horse bag 1, slot 1'; end,
        [daoc.items.slots.horsebag1_slot2]   = function () return 'horse bag 1, slot 2'; end,
        [daoc.items.slots.horsebag1_slot3]   = function () return 'horse bag 1, slot 3'; end,
        [daoc.items.slots.horsebag1_slot4]   = function () return 'horse bag 1, slot 4'; end,
        [daoc.items.slots.horsebag2_slot1]   = function () return 'horse bag 2, slot 1'; end,
        [daoc.items.slots.horsebag2_slot2]   = function () return 'horse bag 2, slot 2'; end,
        [daoc.items.slots.horsebag2_slot3]   = function () return 'horse bag 2, slot 3'; end,
        [daoc.items.slots.horsebag2_slot4]   = function () return 'horse bag 2, slot 4'; end,
        [daoc.items.slots.horsebag3_slot1]   = function () return 'horse bag 3, slot 1'; end,
        [daoc.items.slots.horsebag3_slot2]   = function () return 'horse bag 3, slot 2'; end,
        [daoc.items.slots.horsebag3_slot3]   = function () return 'horse bag 3, slot 3'; end,
        [daoc.items.slots.horsebag3_slot4]   = function () return 'horse bag 3, slot 4'; end,
        [daoc.items.slots.horsebag4_slot1]   = function () return 'horse bag 4, slot 1'; end,
        [daoc.items.slots.horsebag4_slot2]   = function () return 'horse bag 4, slot 2'; end,
        [daoc.items.slots.horsebag4_slot3]   = function () return 'horse bag 4, slot 3'; end,
        [daoc.items.slots.horsebag4_slot4]   = function () return 'horse bag 4, slot 4'; end,
        [daoc.items.slots.saddlebag_lfront]  = function () return 'saddlebag left front'; end,
        [daoc.items.slots.saddlebag_rfront]  = function () return 'saddlebag right front'; end,
        [daoc.items.slots.saddlebag_lrear]   = function () return 'saddlebag left rear'; end,
        [daoc.items.slots.saddlebag_rrear]   = function () return 'saddlebag right rear'; end,
        [daoc.items.slots.player_paperdoll]  = function () return 'player paperdoll'; end,
        [daoc.items.slots.money_mithril]     = function () return 'money (mithril)'; end,
        [daoc.items.slots.money_platinum]    = function () return 'money (platinum)'; end,
        [daoc.items.slots.money_gold]        = function () return 'money (gold)'; end,
        [daoc.items.slots.money_silver]      = function () return 'money (silver)'; end,
        [daoc.items.slots.money_copper]      = function () return 'money (copper)'; end,
        [daoc.items.slots.unknown_106]       = function () return 'unknown (106)'; end,
        [daoc.items.slots.unknown_107]       = function () return 'unknown (107)'; end,
        [daoc.items.slots.unknown_108]       = function () return 'unknown (108)'; end,
        [daoc.items.slots.unknown_109]       = function () return 'unknown (109)'; end,
        [daoc.items.slots.vault1_slot1]      = function () return 'vault page 1, slot 1'; end,
        [daoc.items.slots.vault1_slot2]      = function () return 'vault page 1, slot 2'; end,
        [daoc.items.slots.vault1_slot3]      = function () return 'vault page 1, slot 3'; end,
        [daoc.items.slots.vault1_slot4]      = function () return 'vault page 1, slot 4'; end,
        [daoc.items.slots.vault1_slot5]      = function () return 'vault page 1, slot 5'; end,
        [daoc.items.slots.vault1_slot6]      = function () return 'vault page 1, slot 6'; end,
        [daoc.items.slots.vault1_slot7]      = function () return 'vault page 1, slot 7'; end,
        [daoc.items.slots.vault1_slot8]      = function () return 'vault page 1, slot 8'; end,
        [daoc.items.slots.vault1_slot9]      = function () return 'vault page 1, slot 9'; end,
        [daoc.items.slots.vault1_slot10]     = function () return 'vault page 1, slot 10'; end,
        [daoc.items.slots.vault1_slot11]     = function () return 'vault page 1, slot 11'; end,
        [daoc.items.slots.vault1_slot12]     = function () return 'vault page 1, slot 12'; end,
        [daoc.items.slots.vault1_slot13]     = function () return 'vault page 1, slot 13'; end,
        [daoc.items.slots.vault1_slot14]     = function () return 'vault page 1, slot 14'; end,
        [daoc.items.slots.vault1_slot15]     = function () return 'vault page 1, slot 15'; end,
        [daoc.items.slots.vault1_slot16]     = function () return 'vault page 1, slot 16'; end,
        [daoc.items.slots.vault1_slot17]     = function () return 'vault page 1, slot 17'; end,
        [daoc.items.slots.vault1_slot18]     = function () return 'vault page 1, slot 18'; end,
        [daoc.items.slots.vault1_slot19]     = function () return 'vault page 1, slot 19'; end,
        [daoc.items.slots.vault1_slot20]     = function () return 'vault page 1, slot 20'; end,
        [daoc.items.slots.vault2_slot1]      = function () return 'vault page 2, slot 1'; end,
        [daoc.items.slots.vault2_slot2]      = function () return 'vault page 2, slot 2'; end,
        [daoc.items.slots.vault2_slot3]      = function () return 'vault page 2, slot 3'; end,
        [daoc.items.slots.vault2_slot4]      = function () return 'vault page 2, slot 4'; end,
        [daoc.items.slots.vault2_slot5]      = function () return 'vault page 2, slot 5'; end,
        [daoc.items.slots.vault2_slot6]      = function () return 'vault page 2, slot 6'; end,
        [daoc.items.slots.vault2_slot7]      = function () return 'vault page 2, slot 7'; end,
        [daoc.items.slots.vault2_slot8]      = function () return 'vault page 2, slot 8'; end,
        [daoc.items.slots.vault2_slot9]      = function () return 'vault page 2, slot 9'; end,
        [daoc.items.slots.vault2_slot10]     = function () return 'vault page 2, slot 10'; end,
        [daoc.items.slots.vault2_slot11]     = function () return 'vault page 2, slot 11'; end,
        [daoc.items.slots.vault2_slot12]     = function () return 'vault page 2, slot 12'; end,
        [daoc.items.slots.vault2_slot13]     = function () return 'vault page 2, slot 13'; end,
        [daoc.items.slots.vault2_slot14]     = function () return 'vault page 2, slot 14'; end,
        [daoc.items.slots.vault2_slot15]     = function () return 'vault page 2, slot 15'; end,
        [daoc.items.slots.vault2_slot16]     = function () return 'vault page 2, slot 16'; end,
        [daoc.items.slots.vault2_slot17]     = function () return 'vault page 2, slot 17'; end,
        [daoc.items.slots.vault2_slot18]     = function () return 'vault page 2, slot 18'; end,
        [daoc.items.slots.vault2_slot19]     = function () return 'vault page 2, slot 19'; end,
        [daoc.items.slots.vault2_slot20]     = function () return 'vault page 2, slot 20'; end,
        -- TODO: Add house slots..
        [switch.default]                    = function () return 'unknown'; end,
    });
end

--[[
* Returns an item by its slot id.
--]]
daoc.items.get_item = function (slotid)
    if (slotid < 0 or slotid > 250) then
        return nil;
    end

    local ptr = hook.pointers.get('game.ptr.inventory_slots');
    if (ptr == 0) then return nil; end
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then return nil; end

    return ffi.cast('item_t*', ptr + (slotid * ffi.sizeof('item_t')));
end

--[[
* Returns a table of the local players current money information.
--]]
daoc.items.get_money = function ()
    local ptr = hook.pointers.get('game.ptr.money');
    if (ptr == 0) then return nil; end

    local money = T{ };

    local mptr = hook.memory.read_uint32(ptr + 0x06);
    if (mptr == 0) then return nil; end
    money['mithril'] = hook.memory.read_int32(mptr);

    mptr = hook.memory.read_uint32(ptr + 0x10);
    if (mptr == 0) then return nil; end
    money['platinum'] = hook.memory.read_int32(mptr);

    mptr = hook.memory.read_uint32(ptr + 0x1A);
    if (mptr == 0) then return nil; end
    money['gold'] = hook.memory.read_int32(mptr);

    mptr = hook.memory.read_uint32(ptr + 0x24);
    if (mptr == 0) then return nil; end
    money['silver'] = hook.memory.read_int32(mptr);

    mptr = hook.memory.read_uint32(ptr + 0x31);
    if (mptr == 0) then return nil; end
    money['copper'] = hook.memory.read_int32(mptr);

    return money;
end

--[[
* Returns the local players current mithril count.
--]]
daoc.items.get_money_mithril = function ()
    local ptr = hook.pointers.get('game.ptr.money');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr + 0x06);
    if (ptr == 0) then return 0; end
    return hook.memory.read_int32(ptr);
end

--[[
* Returns the local players current platinum count.
--]]
daoc.items.get_money_platinum = function ()
    local ptr = hook.pointers.get('game.ptr.money');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr + 0x10);
    if (ptr == 0) then return 0; end
    return hook.memory.read_int32(ptr);
end

--[[
* Returns the local players current gold count.
--]]
daoc.items.get_money_gold = function ()
    local ptr = hook.pointers.get('game.ptr.money');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr + 0x1A);
    if (ptr == 0) then return 0; end
    return hook.memory.read_int32(ptr);
end

--[[
* Returns the local players current silver count.
--]]
daoc.items.get_money_silver = function ()
    local ptr = hook.pointers.get('game.ptr.money');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr + 0x24);
    if (ptr == 0) then return 0; end
    return hook.memory.read_int32(ptr);
end

--[[
* Returns the local players current copper count.
--]]
daoc.items.get_money_copper = function ()
    local ptr = hook.pointers.get('game.ptr.money');
    if (ptr == 0) then return 0; end
    ptr = hook.memory.read_uint32(ptr + 0x31);
    if (ptr == 0) then return 0; end
    return hook.memory.read_int32(ptr);
end
