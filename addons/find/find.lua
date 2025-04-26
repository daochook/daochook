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

addon.name    = 'find';
addon.author  = 'atom0s';
addon.desc    = 'Locate items within your various containers.';
addon.link    = 'https://atom0s.com';
addon.version = '1.0';

require 'common';
require 'daoc';

local imgui = require 'imgui';

--[[
* Returns the proper information values for the given item based on its type.
--]]
local function get_item_values(item)
    local ret = T{ [1] = '', [2] = '', [3] = '', };

    if (item == nil) then return ret; end

    local item_type = bit.band(item.type, 0x3F);

    switch(item_type, T{
        -- Generic Item
        [0] = function ()
            ret[1] = ('Count: %d'):fmt(bit.band(item.value1, 0xFF) + bit.lshift(bit.band(item.value2, 0xFF), 0x08));
        end,

        -- Weapons
        [table.range(daoc.items.types.weapon_first, daoc.items.types.weapon_last)] = function ()
            if (item_type == 16) then
                ret[1] = ('DPS: %d.%d Num: %d'):fmt(
                    item.value1 / 10, item.value1 % 10,
                    bit.band(item.value2, 0x7F));
            else
                ret[1] = ('DPS: %d.%d Spd: %d.%d'):fmt(
                    item.value1 / 10, item.value1 % 10,
                    bit.band(item.value2, 0x7F) / 10, bit.band(item.value2, 0x7F) % 10);
            end

            ret[2] = ('Weight: %.1f lbs'):fmt(item.weight * 0.10);
            ret[3] = ('Con: %3d%%%% Dur: %3d%%%%'):fmt(item.condition, item.durability);
            ret[4] = ('Qua: %3d%%%% Bon: %3d%%%% (Lv. %d)'):fmt(item.quality, item.bonus, item.bonus_level);

            if (bit.band(item.value3, 0x80) == 0x80) then
                ret[5] = 'Usable in Left Hand';
            end
            if (bit.band(item.value3, 0x40) == 0x40) then
                ret[5] = 'Two-Handed';
            end
        end,

        -- Armor
        [table.range(daoc.items.types.armor_first, daoc.items.types.armor_last)] = function ()
            ret[1] = ('Factor: %d'):fmt(item.value1);
            ret[2] = ('Absorb: %d%%%%'):fmt(item.value2);
            ret[3] = ('Weight: %.1f lbs'):fmt(item.weight * 0.10);
            ret[4] = ('Con: %3d%%%% Dur: %3d%%%%'):fmt(item.condition, item.durability);
            ret[5] = ('Qua: %3d%%%% Bon: %3d%%%% (Lv. %d)'):fmt(item.quality, item.bonus, item.bonus_level);
        end,

        -- Magical Items
        [41] = function ()
            ret[1] = ('Weight: %.1f lbs'):fmt(item.weight * 0.10);
            ret[2] = ('Con: %3d%%%% Dur: %3d%%%%'):fmt(item.condition, item.durability);
            ret[3] = ('Qua: %3d%%%% Bon: %3d%%%% (Lv. %d)'):fmt(item.quality, item.bonus, item.bonus_level);
        end,

        -- Shield
        [42] = function ()
            ret[1] = ('Con: %3d%%%% Dur: %3d%%%%'):fmt(item.condition, item.durability);
            ret[2] = ('Qua: %3d%%%% Bon: %3d%%%% (Lv. %d)'):fmt(item.quality, item.bonus, item.bonus_level);
        end,

        [switch.default] = function ()
            ret[1] = ('No additional info for this item type currently. (%d)'):fmt(item_type);
        end,
    });

    return ret;
end

-- Window Variables
local window = T{
    show            = T{ true, },
    filter          = T{ '', },
    filter_size     = 255,
    selected_item   = T{ 0, },
};

--[[
* event: command
* desc : Called when the game is handling a command.
--]]
hook.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.modified_command:args();
    if (#args == 0) then
        return;
    end

    -- Command: /find
    if ((args[1]:ieq('find') and e.imode == daoc.chat.input_mode.slash) or args[1]:ieq('/find')) then
        e.blocked = true;
        window.show[1] = not window.show[1];
        return;
    end
end);

--[[
* event: d3d_present
* desc : Called when the Direct3D device is presenting a scene.
--]]
hook.events.register('d3d_present', 'd3d_present_cb', function ()
    if (not window.show[1]) then return; end

    imgui.SetNextWindowSize({ 650, 500, });
    if (imgui.Begin('Find', window.show, ImGuiWindowFlags_NoResize)) then
        imgui.InputText('Name Filter', window.filter, window.filter_size);
        if (imgui.BeginTable('##find_items_list2', 4, bit.bor(ImGuiTableFlags_RowBg, ImGuiTableFlags_BordersH, ImGuiTableFlags_BordersV, ImGuiTableFlags_ContextMenuInBody, ImGuiTableFlags_ScrollX, ImGuiTableFlags_ScrollY, ImGuiTableFlags_SizingFixedFit))) then
            imgui.TableSetupColumn('Slot', ImGuiTableColumnFlags_WidthFixed, 35.0, 0);
            imgui.TableSetupColumn('Quality', ImGuiTableColumnFlags_WidthFixed, 70.0, 0);
            imgui.TableSetupColumn('Bonus', ImGuiTableColumnFlags_WidthFixed, 70.0, 0);
            imgui.TableSetupColumn('Name', ImGuiTableColumnFlags_WidthStretch, 0, 0);
            imgui.TableSetupScrollFreeze(0, 1);
            imgui.TableHeadersRow();

            for x = 0, 250 do
                local item = daoc.items.get_item(x);
                if (item ~= nil and item.name:len() > 0 and (item.name:lower():contains(window.filter[1]:lower()))) then
                    imgui.PushID(x);
                    imgui.TableNextRow();
                    imgui.TableSetColumnIndex(0);

                    -- Set the row as selectable..
                    if (imgui.Selectable(('%d##%d'):fmt(x, x), x == window.selected_item[1], bit.bor(ImGuiSelectableFlags_SpanAllColumns, ImGuiSelectableFlags_AllowItemOverlap), { 0, 0, })) then
                        window.selected_item[1] = x;
                    end

                    -- Handle the item hover tooltip..
                    if (imgui.IsItemHovered()) then
                        imgui.BeginTooltip();
                        imgui.Text(('Slot: %d - %s'):fmt(x, daoc.items.get_slot_name(x)));
                        imgui.NewLine();
                        imgui.Separator();
                        imgui.NewLine();
                        imgui.Text(tostring(item.name):gsub('%%', '%%%%'));
                        imgui.NewLine();
                        imgui.Text(('Lv. %d'):fmt(item.level));

                        local vals = get_item_values(item);
                        for y = 1, 5 do
                            if (vals[y] ~= nil and vals[y]:len() > 0) then
                                imgui.Text(vals[y]);
                            end
                        end

                        local has_spell1 = bit.band(item.flags, 0x08) == 0x08;
                        local has_spell2 = bit.band(item.flags, 0x10) == 0x10;
                        if (has_spell1 or has_spell2) then
                            imgui.Separator();
                            if (bit.band(item.flags, 0x08) == 0x08) then
                                imgui.Text(('Spell 1: %s'):fmt(item.spell1_name));
                            end
                            if (bit.band(item.flags, 0x10) == 0x10) then
                                imgui.Text(('Spell 2: %s'):fmt(item.spell2_name));
                            end
                        end

                        imgui.EndTooltip();
                    end

                    imgui.TableNextColumn();
                    imgui.Text(tostring(item.quality));
                    imgui.TableNextColumn();
                    imgui.Text(tostring(item.bonus));
                    imgui.TableNextColumn();
                    imgui.Text(tostring(item.name):gsub('%%', '%%%%'));
                    imgui.PopID();
                end
            end
            imgui.EndTable();
        end
    end
    imgui.End();
end);
