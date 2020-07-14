@echo off
set __LUA_PATH=%LUA_PATH%
set LUA_PATH=%~dp0\..\?.lua;%LUA_PATH%
call lua %~dp0\..\%~n0.lua %*
set LUA_PATH=%__LUA_PATH%
set __LUA_PATH=
