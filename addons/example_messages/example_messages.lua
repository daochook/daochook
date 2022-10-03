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

addon.name    = 'example_messages';
addon.author  = 'atom0s';
addon.desc    = 'Example addon that demonstrates working with messages.';
addon.link    = 'https://atom0s.com';
addon.version = '1.0';

require 'common';
require 'daoc';

--[[
* event: message
* desc : Called when the game is handling a message.
--]]
hook.events.register('message', 'message_cb', function (e)
    -- Look for chat messages that contain 'derp'..
    if (e.modified_message:contains('derp')) then
        -- Replace 'derp' with 'xxxx'..
        e.modified_message = e.modified_message:replace('derp', 'xxxx');
    end

    -- Add a timestamp to each message..
    local time = hook.time.get_local_time();
    e.modified_message = ('%02i:%02i | %s'):fmt(time['hh'], time['mm'], e.modified_message);
end);
