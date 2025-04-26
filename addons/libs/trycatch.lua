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

--[[
* Implements a try, catch, finally handler similar to C/C++ or C#.
*
* @param {function} func - The function to attempt to call safely.
* @return {table} A table containing the preperation of catch/finally usage.
--]]
local function try(func)
    local status = true;
    local err;

    -- Invoke the try function if valid..
    if (type(func) == 'function') then
        status, err = xpcall(func, debug.traceback);
    end

    -- Implements the 'finally' callback handling.
    local finally = function (finally_func, has_catch)
        -- Invoke the finally function if valid..
        if (type(finally_func) == 'function') then
            finally_func();
        end

        -- Throw error if nothing can catch..
        if (not has_catch and not status) then
            error(err);
        end
    end

    -- Implements the 'catch' callback handling.
    local catch = function (catch_func)
        local has_catch = type(catch_func) == 'function';
        -- Invoke the catch function if valid..
        if (not status and has_catch) then
            local e = err or '(unknown error)';
            catch_func(e);
        end

        -- Return table containing the finally handler..
        return {
            finally = function (finally_func)
                finally(finally_func, has_catch);
            end
        };
    end

    -- Return table containing the catch and finally handlers..
    return {
        catch = catch,
        finally = function (finally_func)
            finally(finally_func, false);
        end
    };
end

-- Return the try function..
return try;

--[[
* This file is based on the following library:
* https://github.com/djfdyuruiry/lua-try-catch-finally
*
* MIT License
*
* Copyright (c) 2017 djfdyuruiry
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
--]]
