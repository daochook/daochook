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

addon.name    = 'distance';
addon.author  = 'atom0s';
addon.desc    = 'Displays the distance between the local player and their target in an ImGui overlay.';
addon.link    = 'https://atom0s.com';
addon.version = '1.0';

require 'common';
require 'daoc';

local imgui = require 'imgui';

-- Window Variables
local window = T{
    hide_border = T{ false, },
    opacity     = T{ 1.0, },
    scale       = T{ 1.0, },
    show        = T{ true, },
};

--[[
* event: d3d_present
* desc : Called when the Direct3D device is presenting a scene.
--]]
hook.events.register('d3d_present', 'd3d_present_cb', function ()
    -- Clamp the window properties..
    window.opacity[1]   = window.opacity[1]:clamp(0.01, 1);
    window.scale[1]     = window.scale[1]:clamp(0.1, 10);

    -- Obtain the players current target entity..
    local target = daoc.entity.get(daoc.entity.get_target_index());
    if (target == nil or target.initialized_flag == 0) then
        return;
    end

    -- Obtain the current player state..
    local pstate = daoc.states.get_player_state();
    if (pstate == nil) then
        return;
    end

    -- Calculate the 3D distance between the player and target..
    local dist = math.distance3d(pstate.x, pstate.y, pstate.z, target.x, target.y, target.z);

    -- Prepare the window flags..
    local flags = bit.bor(ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_AlwaysAutoResize, ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoFocusOnAppearing, ImGuiWindowFlags_NoNav);
    if (window.hide_border[1] == true) then
        flags = bit.bor(flags, ImGuiWindowFlags_NoBackground);
    end

    -- Render the distance overlay..
    imgui.SetNextWindowBgAlpha(window.opacity[1]);
    if (imgui.Begin('distance_overlay', window.show, flags)) then
        imgui.SetWindowFontScale(window.scale[1]);
        imgui.Text(('%.f'):fmt(dist));
        imgui.SetWindowFontScale(1.0);

        if (imgui.BeginPopupContextWindow()) then
            imgui.Checkbox('Hide Border?', window.hide_border);
            imgui.DragFloat('Opacity', window.opacity, 0.25, 0, 1.0);
            imgui.DragFloat('Scale', window.scale, 0.25, 0.25, 10.0);
            imgui.EndPopup();
        end
    end
    imgui.End();
end);
