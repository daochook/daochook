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

addon.name    = 'move';
addon.author  = 'atom0s';
addon.desc    = 'Window helper to adjust position, size, border, etc.';
addon.link    = 'https://atom0s.com';
addon.version = '1.0';

require 'common';
require 'win32types';
require 'daoc';

local ffi   = require 'ffi';
local C     = ffi.C;

--[[
* FFI Definitions
--]]
ffi.cdef[[
    BOOL        AttachThreadInput(DWORD idAttach, DWORD idAttachTo, BOOL fAttach);
    BOOL        GetClientRect(HWND hWnd, LPRECT lpRect);
    DWORD       GetCurrentThreadId();
    BOOL        GetWindowRect(HWND hWnd, LPRECT lpRect);
    LONG_PTR    GetWindowLongA(HWND hWnd, int nIndex);
    DWORD       GetWindowThreadProcessId(HWND hWnd, LPDWORD lpdwProcessId);
    BOOL        SetForegroundWindow(HWND hWnd);
    LONG_PTR    SetWindowLongA(HWND hWnd, int nIndex, LONG_PTR dwNewLong);
    BOOL        SetWindowPos(HWND hWnd, HWND hWndInsertAfter, int X, int Y, int cx, int cy, UINT uFlags);
    BOOL        ShowWindow(HWND hWnd, int nCmdShow);

    enum {
        SWP_NOSIZE          = 0x0001,
        SWP_NOMOVE          = 0x0002,
        SWP_NOZORDER        = 0x0004,
        SWP_FRAMECHANGED    = 0x0020,
        SWP_SHOWWINDOW      = 0x0040,
    };

    enum {
        SW_MAXIMIZE = 3,
        SW_SHOW     = 5,
        SW_MINIMIZE = 6,
    };

    enum {
        GWL_STYLE   = -16,
        GWL_EXSTYLE = -20,
    };

    enum {
        WS_SYSMENU          = 0x00080000,
        WS_BORDER           = 0x00800000,
        WS_OVERLAPPEDWINDOW = 0x00CF0000,
        WS_VISIBLE          = 0x10000000,
        WS_POPUP            = 0x80000000,

        WS_EX_TOPMOST       = 0x00000008,
    };

    enum {
        HWND_TOP        = 0,
        HWND_TOPMOST    = -1,
        HWND_NOTOPMOST  = -2,
    };
]];

--[[
* Prints the addon specific help information.
*
* @param {err} err - Flag that states if this function was called due to an error.
--]]
local function print_help(err)
    err = err or false;

    local mode = daoc.chat.message_mode.help;
    if (err) then
        daoc.chat.msg(mode, 'Invalid command syntax for command: /move');
    else
        daoc.chat.msg(mode, 'Available commands for the move addon are:');
    end

    local help = daoc.chat.msg:compose(function (cmd, desc)
        return mode, ('  %s - %s'):fmt(cmd, desc);
    end);

    help('/maximize', 'Maximizes the game window.');
    help('/minimize', 'Minimizes the game window.');
    help('/move <x> <y>', 'Moves the game window to the given position.');
    help('/move (pos|position) <x> <y>', 'Moves the game window to the given position.');
    help('/move size <w> <h>', 'Resizes the game window to the given dimensions.');
    help('/topmost', 'Toggles the game window being the top-most window.');
    help('/border', 'Toggles the game window border.');
    help('/windowframe', 'Toggles the game window border.');
end

--[[
* event: command
* desc : Called when the game is handling a command.
--]]
hook.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.modified_command:args();
    if (#args == 0) then return; end

    -- Obtain the game window handle..
    local hwnd = ffi.cast('HWND', hook.get_game_hwnd());

    -- Command: /maximize, /minimize
    if ((args[1]:any('maximize', 'minimize') and e.imode == daoc.chat.input_mode.slash) or args[1]:any('/maximize', '/minimize')) then
        e.blocked = true;

        hook.tasks.oncef(1, function ()
            local flag = args[1]:any('maximize', '/maximize') and C.SW_MAXIMIZE or C.SW_MINIMIZE;
            C.ShowWindow(hwnd, flag);
        end);

        return;
    end

    -- Command: /move
    if ((args[1]:any('move') and e.imode == daoc.chat.input_mode.slash) or args[1]:any('/move')) then
        e.blocked = true;

        -- Command: /move help
        if (#args == 2 and args[2]:any('help')) then
            print_help(false);
            return;
        end

        -- Command: /move <x> <y>
        -- Command: /move (position|pos) <x> <y>
        if (#args == 3 or (#args == 4 and (args[2]:any('pos', 'position')))) then
            hook.tasks.oncef(1, function ()
                local x = args[#args == 3 and 2 or 3]:num_or(0);
                local y = args[#args == 3 and 3 or 4]:num_or(0);
                C.SetWindowPos(hwnd, nil, x, y, 0, 0, bit.bor(C.SWP_NOZORDER, C.SWP_NOSIZE));
            end);
            return;
        end

        -- Command: /move size <x> <y>
        if (#args == 4 and args[2]:any('size')) then
            hook.tasks.oncef(1, function ()
                local w = args[3]:num_or(800);
                local h = args[4]:num_or(600);
                C.SetWindowPos(hwnd, nil, 0, 0, w, h, bit.bor(C.SWP_NOMOVE, C.SWP_NOZORDER));
            end);
            return;
        end

        -- Unknown sub-command..
        print_help(true);
        return;
    end

    -- Command: /topmost
    if ((args[1]:any('topmost') and e.imode == daoc.chat.input_mode.slash) or args[1]:any('/topmost')) then
        e.blocked = true;
        hook.tasks.oncef(1, function ()
            local style = C.GetWindowLongA(hwnd, C.GWL_EXSTYLE);
            local top   = (bit.band(style, C.WS_EX_TOPMOST) == C.WS_EX_TOPMOST) and C.HWND_NOTOPMOST or C.HWND_TOPMOST;
            local hwndi = ffi.cast('HWND', top);
            C.SetWindowPos(hwnd, hwndi, 0, 0, 0, 0, bit.bor(C.SWP_NOMOVE, C.SWP_NOSIZE));
        end);
        return;
    end

    -- Command: /border, /windowframe
    if ((args[1]:any('border', 'windowframe') and e.imode == daoc.chat.input_mode.slash) or args[1]:any('/border', '/windowframe')) then
        e.blocked = true;
        hook.tasks.oncef(1, function ()
            local style = C.GetWindowLongA(hwnd, C.GWL_STYLE);
            if (bit.band(style, C.WS_BORDER) == C.WS_BORDER) then
                style = bit.bor(C.WS_POPUP, C.WS_VISIBLE, C.WS_SYSMENU);

                local rclient = ffi.new('RECT');
                C.GetClientRect(hwnd, rclient);

                local w = rclient.right - rclient.left;
                local h = rclient.bottom - rclient.top;

                C.SetWindowLongA(hwnd, C.GWL_STYLE, style);
                C.SetWindowLongA(hwnd, C.GWL_EXSTYLE, 0);
                C.SetWindowPos(hwnd, nil, 0, 0, 0, 0, bit.bor(C.SWP_NOMOVE, C.SWP_NOSIZE, C.SWP_NOZORDER, C.SWP_FRAMECHANGED));
                C.SetWindowPos(hwnd, nil, 0, 0, w, h, bit.bor(C.SWP_NOMOVE, C.SWP_NOZORDER));
            else
                style = bit.bor(C.WS_OVERLAPPEDWINDOW, C.WS_VISIBLE, C.WS_BORDER);

                local rclient = ffi.new('RECT');
                local rwindow = ffi.new('RECT');
                C.GetClientRect(hwnd, rclient);

                local bw = rclient.right - rclient.left;
                local bh = rclient.bottom - rclient.top;

                C.SetWindowLongA(hwnd, C.GWL_STYLE, style);
                C.SetWindowLongA(hwnd, C.GWL_EXSTYLE, 0);
                C.SetWindowPos(hwnd, nil, 0, 0, 0, 0, bit.bor(C.SWP_NOMOVE, C.SWP_NOSIZE, C.SWP_NOZORDER, C.SWP_FRAMECHANGED));
                C.GetClientRect(hwnd, rclient);
                C.GetWindowRect(hwnd, rwindow);

                local w = bw + ((rwindow.right - rwindow.left) - rclient.right)
                local h = bh + ((rwindow.bottom - rwindow.top) - rclient.bottom);
                C.SetWindowPos(hwnd, nil, 0, 0, w, h, bit.bor(C.SWP_NOMOVE, C.SWP_NOZORDER));
            end
        end);
        return;
    end
end);
