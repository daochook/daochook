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
daoc.items.slot_invalid                 = 0;
daoc.items.slot_ground                  = 1;
daoc.items.slot_unknown_002             = 2;
daoc.items.slot_unknown_003             = 3;
daoc.items.slot_unknown_004             = 4;
daoc.items.slot_unknown_005             = 5;
daoc.items.slot_unknown_006             = 6;
daoc.items.slot_horse_armor             = 7;
daoc.items.slot_horse_barding           = 8;
daoc.items.slot_horse                   = 9;
daoc.items.slot_equip_rhand             = 10;
daoc.items.slot_equip_lhand             = 11;
daoc.items.slot_equip_2hand             = 12;
daoc.items.slot_equip_ranged            = 13;
daoc.items.slot_equip_quiver1           = 14;
daoc.items.slot_equip_quiver2           = 15;
daoc.items.slot_equip_quiver3           = 16;
daoc.items.slot_equip_quiver4           = 17;
daoc.items.slot_unknown_018             = 18;
daoc.items.slot_unknown_019             = 19;
daoc.items.slot_unknown_020             = 20;
daoc.items.slot_equip_head              = 21;
daoc.items.slot_equip_hands             = 22;
daoc.items.slot_equip_feet              = 23;
daoc.items.slot_equip_jewel             = 24;
daoc.items.slot_equip_body              = 25;
daoc.items.slot_equip_cloak             = 26;
daoc.items.slot_equip_legs              = 27;
daoc.items.slot_equip_arms              = 28;
daoc.items.slot_equip_neck              = 29;
daoc.items.slot_unknown_030             = 30;
daoc.items.slot_unknown_031             = 31;
daoc.items.slot_equip_waist             = 32;
daoc.items.slot_equip_lbracer           = 33;
daoc.items.slot_equip_rbracer           = 34;
daoc.items.slot_equip_lring             = 35;
daoc.items.slot_equip_rring             = 36;
daoc.items.slot_equip_mythical          = 37;
daoc.items.slot_unknown_038             = 38;
daoc.items.slot_unknown_039             = 39;
daoc.items.slot_inv_bag1_slot1          = 40;
daoc.items.slot_inv_bag1_slot2          = 41;
daoc.items.slot_inv_bag1_slot3          = 42;
daoc.items.slot_inv_bag1_slot4          = 43;
daoc.items.slot_inv_bag1_slot5          = 44;
daoc.items.slot_inv_bag1_slot6          = 45;
daoc.items.slot_inv_bag1_slot7          = 46;
daoc.items.slot_inv_bag1_slot8          = 47;
daoc.items.slot_inv_bag2_slot1          = 48;
daoc.items.slot_inv_bag2_slot2          = 49;
daoc.items.slot_inv_bag2_slot3          = 50;
daoc.items.slot_inv_bag2_slot4          = 51;
daoc.items.slot_inv_bag2_slot5          = 52;
daoc.items.slot_inv_bag2_slot6          = 53;
daoc.items.slot_inv_bag2_slot7          = 54;
daoc.items.slot_inv_bag2_slot8          = 55;
daoc.items.slot_inv_bag3_slot1          = 56;
daoc.items.slot_inv_bag3_slot2          = 57;
daoc.items.slot_inv_bag3_slot3          = 58;
daoc.items.slot_inv_bag3_slot4          = 59;
daoc.items.slot_inv_bag3_slot5          = 60;
daoc.items.slot_inv_bag3_slot6          = 61;
daoc.items.slot_inv_bag3_slot7          = 62;
daoc.items.slot_inv_bag3_slot8          = 63;
daoc.items.slot_inv_bag4_slot1          = 64;
daoc.items.slot_inv_bag4_slot2          = 65;
daoc.items.slot_inv_bag4_slot3          = 66;
daoc.items.slot_inv_bag4_slot4          = 67;
daoc.items.slot_inv_bag4_slot5          = 68;
daoc.items.slot_inv_bag4_slot6          = 69;
daoc.items.slot_inv_bag4_slot7          = 70;
daoc.items.slot_inv_bag4_slot8          = 71;
daoc.items.slot_inv_bag5_slot1          = 72;
daoc.items.slot_inv_bag5_slot2          = 73;
daoc.items.slot_inv_bag5_slot3          = 74;
daoc.items.slot_inv_bag5_slot4          = 75;
daoc.items.slot_inv_bag5_slot5          = 76;
daoc.items.slot_inv_bag5_slot6          = 77;
daoc.items.slot_inv_bag5_slot7          = 78;
daoc.items.slot_inv_bag5_slot8          = 79;
daoc.items.slot_horsebag1_slot1         = 80;
daoc.items.slot_horsebag1_slot2         = 81;
daoc.items.slot_horsebag1_slot3         = 82;
daoc.items.slot_horsebag1_slot4         = 83;
daoc.items.slot_horsebag2_slot1         = 84;
daoc.items.slot_horsebag2_slot2         = 85;
daoc.items.slot_horsebag2_slot3         = 86;
daoc.items.slot_horsebag2_slot4         = 87;
daoc.items.slot_horsebag3_slot1         = 88;
daoc.items.slot_horsebag3_slot2         = 89;
daoc.items.slot_horsebag3_slot3         = 90;
daoc.items.slot_horsebag3_slot4         = 91;
daoc.items.slot_horsebag4_slot1         = 92;
daoc.items.slot_horsebag4_slot2         = 93;
daoc.items.slot_horsebag4_slot3         = 94;
daoc.items.slot_horsebag4_slot4         = 95;
daoc.items.slot_saddlebag_lfront        = 96;
daoc.items.slot_saddlebag_rfront        = 97;
daoc.items.slot_saddlebag_lrear         = 98;
daoc.items.slot_saddlebag_rrear         = 99;
daoc.items.slot_player_paperdoll        = 100;
daoc.items.slot_money_mithril           = 101; -- Old money slots. (Unused on this client version.)
daoc.items.slot_money_platinum          = 102; -- Old money slots. (Unused on this client version.)
daoc.items.slot_money_gold              = 103; -- Old money slots. (Unused on this client version.)
daoc.items.slot_money_silver            = 104; -- Old money slots. (Unused on this client version.)
daoc.items.slot_money_copper            = 105; -- Old money slots. (Unused on this client version.)
daoc.items.slot_unknown_106             = 106;
daoc.items.slot_unknown_107             = 107;
daoc.items.slot_unknown_108             = 108;
daoc.items.slot_unknown_109             = 109;

-- Slot Range Helpers
daoc.items.slot_equip_min               = 10;
daoc.items.slot_equip_max               = 37;
daoc.items.slot_inv_min                 = 40;
daoc.items.slot_inv_max                 = 79;
daoc.items.slot_horsebag_min            = 80;
daoc.items.slot_horsebag_max            = 95;
daoc.items.slot_vault_min               = 110;
daoc.items.slot_vault_max               = 149;
daoc.items.slot_houseinv_min            = 150;
daoc.items.slot_houseinv_max            = 249;

-- Newer Client Slots
daoc.items.slot_money_mithril_new       = 500;
daoc.items.slot_money_platinum_new      = 501;
daoc.items.slot_money_gold_new          = 502;
daoc.items.slot_money_silver_new        = 503;
daoc.items.slot_money_copper_new        = 504;
daoc.items.slot_player_paperdoll_new    = 600;

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
        uint32_t    factor;             // The item factor.
        uint32_t    absorb;             // The item absorb.
        uint32_t    hand;               // The item hand. [Also used as sub information.]
        uint32_t    object_type;        // The item object type.
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
