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

addon.name    = 'fps';
addon.author  = 'atom0s';
addon.desc    = 'Displays the current framerate as an ImGui overlay.';
addon.link    = 'https://atom0s.com';
addon.version = '1.0';

require 'common';

local imgui = require 'imgui';

-- Window Variables
local window = T{
    location = 0,
    show = T{ true, },
};

--[[
* event: d3d_present
* desc : Called when the Direct3D device is presenting a scene.
--]]
hook.events.register('d3d_present', 'd3d_present_cb', function ()
    local flags = bit.bor(ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_AlwaysAutoResize, ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoFocusOnAppearing, ImGuiWindowFlags_NoNav);

    if (window.location ~= -1) then
        local padding       = 4.0;
        local viewport      = imgui.GetMainViewport();
        local work_pos      = viewport.WorkPos;
        local work_size     = viewport.WorkSize;
        local win_pos       = T{ };
        local win_pos_pivot = T{ };

        if (bit.band(window.location, 0x01) == 1) then
            win_pos.x       = work_pos.x + work_size.x - padding;
            win_pos_pivot.x = 1.0;
        else
            win_pos.x       = work_pos.x + padding;
            win_pos_pivot.x = 0.0;
        end
        if (bit.band(window.location, 0x02) == 2) then
            win_pos.y       = work_pos.y + work_size.y - padding;
            win_pos_pivot.y = 1.0;
        else
            win_pos.y       = work_pos.y + padding;
            win_pos_pivot.y = 0.0;
        end

        imgui.SetNextWindowPos(T{ win_pos.x, win_pos.y, }, ImGuiCond_Always, T{ win_pos_pivot.x, win_pos_pivot.y, });
        flags = bit.bor(flags, ImGuiWindowFlags_NoMove);
    end

    imgui.SetNextWindowBgAlpha(0.8);
    if (imgui.Begin('fps_overlay', window.show, flags)) then
        imgui.Text(('FPS: %0.f'):fmt(imgui.GetIO().Framerate));
        if (imgui.BeginPopupContextWindow()) then
            if (imgui.MenuItem('Custom', nil, window.location == -1)) then
                window.location = -1;
            end
            if (imgui.MenuItem('Top-Left', nil, window.location == 0)) then
                window.location = 0;
            end
            if (imgui.MenuItem('Top-right', nil, window.location == 1)) then
                window.location = 1;
            end
            if (imgui.MenuItem('Bottom-left', nil, window.location == 2)) then
                window.location = 2;
            end
            if (imgui.MenuItem('Bottom-right', nil, window.location == 3)) then
                window.location = 3;
            end
            imgui.EndPopup();
        end
    end
    imgui.End();
end);
