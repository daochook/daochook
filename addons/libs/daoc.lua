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

-- Define the main daoc table..
daoc = daoc or T{ };

--[[
* Supported DAoC Client Versions
--]]
local submodules = T{
    T{ version = T{ 1, 1, 27, 101, 1409, }, folder = '1127101_1409', }, -- 1.127e [1409]
};

-- Obtain the current client version..
local version = T{
    game.get_version_major(),
    game.get_version_minor1(),
    game.get_version_minor2(),
    game.get_version_revision(),
    game.get_version_build(),
};

-- Find a matching client submodule to include..
local _, m = submodules:find_if(function (v)
    return v.version:eq(version);
end);
if (not m) then
    error(('\n\nError while requireing library \'daoc\'; no suitable submodule was found.\nPlease report this client version: %d.%d%d_%d [%d]\n'):fmt(unpack(version)));
end

-- Include the found submodules main library..
return require('daoc.' .. m.folder .. '.main');
