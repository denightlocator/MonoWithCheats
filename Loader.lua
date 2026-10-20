-- Loader.lua
local baseUrl = "https://raw.githubusercontent.com/denightlocator/MonoWithCheats/main/"

-- 1. Fetch the UI library
local uiCode = game:HttpGet(baseUrl .. "MonoUI.lua")
loadstring(uiCode)()

-- 2. Fetch the Survive 100 Days cheat module
local gameCode = game:HttpGet(baseUrl .. "Survive100Days.lua")
loadstring(gameCode)()

print("[Mono] Successfully loaded and executed all modules.")
