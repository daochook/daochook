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

addon.name    = 'example';
addon.author  = 'atom0s';
addon.desc    = 'Example addon that demonstrates the various available addon events.';
addon.link    = 'https://atom0s.com';
addon.version = '1.0';

require 'common';

--[[
* event: load
* desc : Called when the addon is being loaded.
--]]
hook.events.register('load', 'load_cb', function ()
    --[[
    Event has no arguments.
    --]]
end);

--[[
* event: unload
* desc : Called when the addon is being unloaded.
--]]
hook.events.register('unload', 'unload_cb', function ()
    --[[
    Event has no arguments.
    --]]
end);

--[[
* event: command
* desc : Called when the game is handling a command.
--]]
hook.events.register('command', 'command_cb', function (e)
    --[[

    Event Arguments

        e.mode              - number    - [Read Only] The command mode.
        e.imode             - number    - [Read Only] The command input mode.
        e.command           - string    - [Read Only] The command string.
        e.modified_mode     - number    - The modified command mode.
        e.modified_imode    - number    - The modified command input mode.
        e.modified_command  - string    - The modified command string.
        e.injected          - boolean   - [Read Only] Flag that states if the event was injected by daochook or another addon.
        e.blocked           - boolean   - Flag that states if the event has been blocked by daochook or another addon.

    --]]
end);

--[[
* event: message
* desc : Called when the game is handling a message.
--]]
hook.events.register('message', 'message_cb', function (e)
    --[[

    Event Arguments

        e.mode              - number    - [Read Only] The message mode.
        e.message           - string    - [Read Only] The message string.
        e.modified_mode     - number    - The modified message mode.
        e.modified_message  - string    - The modified message string.
        e.injected          - boolean   - [Read Only] Flag that states if the event was injected by daochook or another addon.
        e.blocked           - boolean   - Flag that states if the event has been blocked by daochook or another addon.

    --]]
end);

--[[
* event: packet_recv
* desc : Called when the game is handling a received packet.
--]]
hook.events.register('packet_recv', 'packet_recv_cb', function (e)
    --[[

    Event Arguments

        e.opcode            - number    - [Read Only] The packet opcode.
        e.unknown           - number    - [Read Only] Unknown. (Generally zero.)
        e.session_id        - number    - [Read Only] The client session id.
        e.data              - string    - [Read Only] The packet data. (As a string literal.)
        e.data_raw          - void*     - [Read Only] The packet data. (As a raw pointer, for use with FFI.)
        e.data_modified     - string    - The modified packet data. (As a string literal.)
        e.data_modified_raw - void*     - The modified packet data. (As a raw pointer, for use with FFI.)
        e.size              - number    - [Read Only] The packet size.
        e.state             - number    - [Read Only] The game state pointer.
        e.injected          - boolean   - [Read Only] Flag that states if the event was injected by daochook or another addon.
        e.blocked           - boolean   - Flag that states if the event has been blocked by daochook or another addon.

    --]]
end);

--[[
* event: packet_send
* desc : Called when the game is sending a packet.
--]]
hook.events.register('packet_send', 'packet_send_cb', function (e)
    --[[

    Event Arguments

        e.opcode            - number    - [Read Only] The packet opcode.
        e.data              - string    - [Read Only] The packet data. (As a string literal.)
        e.data_raw          - void*     - [Read Only] The packet data. (As a raw pointer, for use with FFI.)
        e.data_modified     - string    - The modified packet data. (As a string literal.)
        e.data_modified_raw - void*     - The modified packet data. (As a raw pointer, for use with FFI.)
        e.size              - number    - [Read Only] The packet size.
        e.parameter         - number    - [Read Only] The packet parameter.
        e.injected          - boolean   - [Read Only] Flag that states if the event was injected by daochook or another addon.
        e.blocked           - boolean   - Flag that states if the event has been blocked by daochook or another addon.

    --]]
end);

--[[
* event: d3d_prereset
* desc : Called when the Direct3D device is being reset. (pre-reset)
--]]
hook.events.register('d3d_prereset', 'd3d_prereset_cb', function (e)
    --[[

    Event Arguments

        e.back_buffer_width             - number    - [Read Only] The back buffer width.
        e.back_buffer_height            - number    - [Read Only] The back buffer height.
        e.back_buffer_format            - number    - [Read Only] The back buffer format.
        e.back_buffer_count             - number    - [Read Only] The back buffer count.
        e.multisample_type              - number    - [Read Only] The multisample type.
        e.multisample_quality           - number    - [Read Only] The multisample quality.
        e.swap_effect                   - number    - [Read Only] The swap effect.
        e.device_window                 - number    - [Read Only] The device window handle.
        e.windowed                      - boolean   - [Read Only] The windowed mode flag.
        e.enable_auto_depth_stencil     - boolean   - [Read Only] The enable auto depth stencil flag.
        e.auto_depth_stencil_format     - number    - [Read Only] The auto depth stencil format.
        e.flags                         - number    - [Read Only] The flags.
        e.fullscreen_refresh_rate_in_hz - number    - [Read Only] The fullscreen refresh rate in hz.
        e.presentation_interval         - number    - [Read Only] The presentation interval.

    Note:

        Addons generally should not need to register to this event. You should only need to use this
        event if you are creating your own Direct3D objects and need to recreate them when the device
        is being reset.
    --]]
end);

--[[
* event: d3d_postreset
* desc : Called when the Direct3D device is being reset. (post-reset)
--]]
hook.events.register('d3d_postreset', 'd3d_postreset_cb', function (e)
    --[[

    Event Arguments

        e.back_buffer_width             - number    - [Read Only] The back buffer width.
        e.back_buffer_height            - number    - [Read Only] The back buffer height.
        e.back_buffer_format            - number    - [Read Only] The back buffer format.
        e.back_buffer_count             - number    - [Read Only] The back buffer count.
        e.multisample_type              - number    - [Read Only] The multisample type.
        e.multisample_quality           - number    - [Read Only] The multisample quality.
        e.swap_effect                   - number    - [Read Only] The swap effect.
        e.device_window                 - number    - [Read Only] The device window handle.
        e.windowed                      - boolean   - [Read Only] The windowed mode flag.
        e.enable_auto_depth_stencil     - boolean   - [Read Only] The enable auto depth stencil flag.
        e.auto_depth_stencil_format     - number    - [Read Only] The auto depth stencil format.
        e.flags                         - number    - [Read Only] The flags.
        e.fullscreen_refresh_rate_in_hz - number    - [Read Only] The fullscreen refresh rate in hz.
        e.presentation_interval         - number    - [Read Only] The presentation interval.

    Note:

        Addons generally should not need to register to this event. You should only need to use this
        event if you are creating your own Direct3D objects and need to recreate them when the device
        is being reset.
    --]]
end);


--[[
* event: d3d_beginscene
* desc : Called when the Direct3D device is beginning a scene.
--]]
hook.events.register('d3d_beginscene', 'd3d_beginscene_cb', function ()
    --[[
    Event has no arguments.
    --]]
end);

--[[
* event: d3d_endscene
* desc : Called when the Direct3D device is ending a scene.
--]]
hook.events.register('d3d_endscene', 'd3d_endscene_cb', function ()
    --[[
    Event has no arguments.
    --]]
end);

--[[
* event: d3d_present
* desc : Called when the Direct3D device is presenting a scene.
--]]
hook.events.register('d3d_present', 'd3d_present_cb', function ()
    --[[
    Event has no arguments.
    --]]
end);

--[[
* event: d3d_renderstate
* desc : Called when the Direct3D device is setting a render state.
--]]
hook.events.register('d3d_renderstate', 'd3d_renderstate_cb', function (e)
    --[[

    Event Arguments

        - e.state   - number    - [Read Only] The render state id.
        - e.value   - number    - The render state value.
        - e.blocked - boolean   - Flag that states if the event has been blocked by daochook or another addon.

    Note:

        Addons should avoid registering to this event unless absolutely needed. This event is
        extremely CPU intensive and can cause large FPS drops just by having it enabled.
    --]]
end);

--[[
* event: d3d_dip
* desc : Called when the Direct3D device is rendering a primitive. (DrawIndexedPrimitive)
--]]
hook.events.register('d3d_dip', 'd3d_dip_cb', function (e)
    --[[

    Event Arguments

        e.primitive_type    - number    - [Read Only] The primitive type.
        e.base_vertex_index - number    - [Read Only] The primitive base vertex index.
        e.min_index         - number    - [Read Only] The primitive min index.
        e.num_vertices      - number    - [Read Only] The primitive num vertices.
        e.start_index       - number    - [Read Only] The primitive start index.
        e.prim_count        - number    - [Read Only] The primitive primitive count.
        e.blocked           - boolean   - Flag that states if the event has been blocked by daochook or another addon.

    --]]
end);

--[[
* event: d3d_dipup
* desc : Called when the Direct3D device is rendering a primitive. (DrawIndexedPrimitiveUP)
--]]
hook.events.register('d3d_dipup', 'd3d_dipup_cb', function (e)
    --[[

    Event Arguments

        e.primitive_type            - number    - [Read Only] The primitive type.
        e.min_vertex_index          - number    - [Read Only] The primitive min vertex index.
        e.num_vertex_indices        - number    - [Read Only] The primitive num vertex indices.
        e.primitive_count           - number    - [Read Only] The primitive primitive count.
        e.index_data                - number    - [Read Only] The primitive index data.
        e.index_data_format         - number    - [Read Only] The primitive index data format.
        e.vertex_stream_zero_data   - number    - [Read Only] The primitive vertex stream zero data.
        e.vertex_stream_zero_stride - number    - [Read Only] The primitive vertex stream zero stride.
        e.blocked                   - boolean   - Flag that states if the event has been blocked by daochook or another addon.

    --]]
end);

--[[
* event: d3d_dp
* desc : Called when the Direct3D device is rendering a primitive. (DrawPrimitive)
--]]
hook.events.register('d3d_dp', 'd3d_dp_cb', function (e)
    --[[

    Event Arguments

        e.primitive_type    - number    - [Read Only] The primitive type.
        e.start_vertex      - number    - [Read Only] The primitive start vertex.
        e.primitive_count   - number    - [Read Only] The primitive count.
        e.blocked           - boolean   - Flag that states if the event has been blocked by daochook or another addon.

    --]]
end);

--[[
* event: d3d_dpup
* desc : Called when the Direct3D device is rendering a primitive. (DrawPrimitiveUP)
--]]
hook.events.register('d3d_dpup', 'd3d_dpup_cb', function (e)
    --[[

    Event Arguments

        e.primitive_type            - number    - [Read Only] The primitive type.
        e.primitive_count           - number    - [Read Only] The primitive count.
        e.vertex_stream_zero_data   - number    - [Read Only] The primitive vertex stream zero data.
        e.vertex_stream_zero_stride - number    - [Read Only] The primitive vertex stream zero stride.
        e.blocked                   - boolean   - Flag that states if the event has been blocked by daochook or another addon.

    --]]
end);
