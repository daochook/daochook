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

-- Ensure the daoc tables exists..
daoc = daoc or T{ };
daoc.chat = daoc.chat or T{ };

--[[
* The mode of an executed command.
--]]
daoc.chat.command_mode                   = T{ };
daoc.chat.command_mode.typed             = 0x00; -- The command was executed via player input.
daoc.chat.command_mode.macro             = 0x01; -- The command was executed via a macro.
daoc.chat.command_mode.system            = 0x02; -- The command was executed via the client/system.

--[[
* The input mode the client is in during an executed command.
--]]
daoc.chat.input_mode                     = T{ };
daoc.chat.input_mode.normal              = 0x00; -- The input mode was started by pressing 'Enter'.
daoc.chat.input_mode.slash               = 0x01; -- The input mode was started by pressing '/'.
daoc.chat.input_mode.debug               = 0x02; -- The input mode was started by pressing ']'.

--[[
* The message mode (channel) of a chat/combat message. (As per default client settings.)
--]]
daoc.chat.message_mode                   = T{ };
daoc.chat.message_mode.system            = 0x00; -- Combat       - White             -
daoc.chat.message_mode.say               = 0x01; -- Main         - White             -
daoc.chat.message_mode.send              = 0x02; -- Main         - Cyan              -
daoc.chat.message_mode.group             = 0x03; -- Main         - Orange            -
daoc.chat.message_mode.guild             = 0x04; -- Main         - Light Green       -
daoc.chat.message_mode.broadcast         = 0x05; -- Main         - Deep Purple       -
daoc.chat.message_mode.emote             = 0x06; -- Combat       - Grey              -
daoc.chat.message_mode.help              = 0x07; -- Main         - Yellow            -
daoc.chat.message_mode.chat              = 0x08; -- Main         - Green             -
daoc.chat.message_mode.advise            = 0x09; -- Main         - Cyan              -
daoc.chat.message_mode.officer           = 0x0A; -- Main         - White             -
daoc.chat.message_mode.alliance          = 0x0B; -- Main         - Pink              -
daoc.chat.message_mode.bg                = 0x0C; -- Main         - Red               -
daoc.chat.message_mode.bg_leader         = 0x0D; -- Main         - Light Yellow      -
daoc.chat.message_mode.unused_0e         = 0x0E; -- None         - None              - Unknown.
daoc.chat.message_mode.staff             = 0x0F; -- Both         - Yellow            -
daoc.chat.message_mode.spell             = 0x10; -- Combat       - Deep Purple       -
daoc.chat.message_mode.you_hit           = 0x11; -- Combat       - Orange            -
daoc.chat.message_mode.you_were_hit      = 0x12; -- Combat       - White             -
daoc.chat.message_mode.skill             = 0x13; -- Combat       - Yellow            -
daoc.chat.message_mode.merchant          = 0x14; -- Combat       - Light Orange      -
daoc.chat.message_mode.you_died          = 0x15; -- Command      - Red               -
daoc.chat.message_mode.player_died       = 0x16; -- Combat       - Light Orange      -
daoc.chat.message_mode.others_combat     = 0x17; -- None         - None              - Unknown.
daoc.chat.message_mode.damage_add        = 0x18; -- Combat       - Yellow            -
daoc.chat.message_mode.spell_expires     = 0x19; -- Combat       - Green             -
daoc.chat.message_mode.loot              = 0x1A; -- Combat       - Light Green       -
daoc.chat.message_mode.spell_resisted    = 0x1B; -- Combat       - Pink              -
daoc.chat.message_mode.important         = 0x1C; -- Combat       - Orange            -
daoc.chat.message_mode.damaged           = 0x1D; -- Combat       - Red               -
daoc.chat.message_mode.missed            = 0x1E; -- Combat       - Cyan              -
daoc.chat.message_mode.spell_pulse       = 0x1F; -- None         - None              - Unknown.
daoc.chat.message_mode.killed_by_alb     = 0x20; -- Combat       - Deep Red          -
daoc.chat.message_mode.killed_by_mid     = 0x21; -- Combat       - Deep Blue         -
daoc.chat.message_mode.killed_by_hib     = 0x22; -- Combat       - Deep Green        -
daoc.chat.message_mode.lfg               = 0x23; -- Main         - Light Red         -
daoc.chat.message_mode.trade             = 0x24; -- Main         - Grey              -
-- Modes 0x25 to 0x63 are unused.
daoc.chat.message_mode.social            = 0x64; -- Unknown      - Unknown           - Unknown.
-- Modes 0x65 to 0xC7 are unused.
daoc.chat.message_mode.notice1           = 0xC8; -- Notice       - Light Yellow      - Normal font, center screen notice.
daoc.chat.message_mode.notice2           = 0xC9; -- Notice       - White             - Small font, center screen notice.
daoc.chat.message_mode.notice3           = 0xCA; -- Notice, Chat - Light Yellow      - Normal font, center screen notice + main chat message. (White)
daoc.chat.message_mode.notice4           = 0xCB; -- Notice, Chat - White             - Small font, center screen notice + main chat message. (White)
-- Modes 0xCC to 0xFF are unused.

--[[
* Executes a command.
--]]
daoc.chat.exec = function (cmd_mode, input_mode, cmd)
    game.exec_command(cmd_mode, input_mode, cmd);
end

--[[
* Prints a message to the game chat.
--]]
daoc.chat.msg = function (message_mode, msg)
    game.add_message(message_mode, msg);
end
