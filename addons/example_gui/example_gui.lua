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

addon.name    = 'example_gui';
addon.author  = 'atom0s';
addon.desc    = 'Example addon that demonstrates working with ImGui.';
addon.link    = 'https://atom0s.com';
addon.version = '1.0';

require 'common';
require 'daoc';

local imgui = require 'imgui';

-- Window Variables
local window = T{
    is_checked = T{ false, },
};

--[[
* event: d3d_present
* desc : Called when the Direct3D device is presenting a scene.
--]]
hook.events.register('d3d_present', 'd3d_present_cb', function ()
    -- Render a custom example window via ImGui..
    imgui.SetNextWindowSize(T{ 350, 200, }, ImGuiCond_Always);
    if (imgui.Begin('Example Window')) then
        imgui.Text('This is a custom window via ImGui.');
        imgui.Checkbox('Check Me', window.is_checked);

        if (window.is_checked[1]) then
            imgui.TextColored(T{ 0.0, 1.0, 0.0, 1.0, }, 'Checkbox is checked!');
        else
            imgui.TextColored(T{ 1.0, 0.0, 0.0, 1.0, }, 'Checkbox is not checked!');
        end

        if (imgui.Button('Click Me')) then
            daoc.chat.msg(daoc.chat.message_mode.help, 'Button was clicked!');
        end
    end
    imgui.End();
end);
