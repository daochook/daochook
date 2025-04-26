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

addon.name    = 'antiafk';
addon.author  = 'atom0s';
addon.desc    = 'Prevents the client from disconnecting due to being afk for an hour.';
addon.link    = 'https://atom0s.com';
addon.version = '1.0';

require 'common';

-- antiafk variables..
local antiafk = T{ pointer = 0, };

--[[
* Resets the AFK kick timer.
--]]
local function reset_afktimer()
    if (antiafk.pointer ~= 0) then
        hook.memory.write_uint32(antiafk.pointer, 0);
    end
end

--[[
* event: load
* desc : Called when the addon is being loaded.
--]]
hook.events.register('load', 'load_cb', function ()
    -- Locate the afk timer memory pointer..
    local ptr = hook.pointers.add('antiafk.afktimer', 'game.dll', 'FF05????????83C0056BC03C39', 2, 0);
    if (ptr == 0) then
        error('Failed to locate required memory pointer; cannot load.');
    end

    -- Read the pointer from the opcode..
    ptr = hook.memory.read_uint32(ptr);
    if (ptr == 0) then
        error('Failed to locate required memory pointer; cannot load.');
    end

    -- Store the pointer..
    antiafk.pointer = ptr;

    -- Create a task to keep resetting the AFK timer..
    reset_afktimer:loop(5, function () return addon.instance.state == 1; end);
end);
