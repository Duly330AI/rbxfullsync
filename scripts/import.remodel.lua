-- scripts/import.remodel.lua
-- Usage: remodel run scripts/import.remodel.lua [inputPlace]
-- Priority: tries place.rbxlx (XML) first, then gardenclash.rbxlx, then gardenclash.rbxl, then place.rbxl

local input = ...
if not input or input == "" then
    local picks = {"place.rbxlx","gardenclash.rbxlx","gardenclash.rbxl","place.rbxl"}
    for _, f in ipairs(picks) do
        local ok = pcall(function() local h=io.open(f,"rb"); if h then h:close() end end)
        if ok then input = f; break end
    end
end
assert(input and input ~= "", "No .rbxlx/.rbxl found in repo root. Prefer exporting .rbxlx (XML).")

local ok, place = pcall(function() return remodel.readPlaceFile(input) end)
if not ok then
    error("Remodel could not read '"..tostring(input).."'. Prefer exporting as .rbxlx (XML) from Roblox Studio.")
end

-- Workspace -> src/workspace/*.rbxmx
remodel.createDirAll("src/workspace")
for _, child in ipairs(place.Workspace:GetChildren()) do
    local safe = child.Name:gsub("[^%w_%-% ]","_")
    remodel.writeModelFile(("src/workspace/%s.rbxmx"):format(safe), child)
end

-- ReplicatedStorage/Models -> src/models/*.rbxmx (optional)
local rs = place:FindFirstChild("ReplicatedStorage")
if rs then
    local models = rs:FindFirstChild("Models")
    if models then
        remodel.createDirAll("src/models")
        for _, child in ipairs(models:GetChildren()) do
            local safe = child.Name:gsub("[^%w_%-% ]","_")
            remodel.writeModelFile(("src/models/%s.rbxmx"):format(safe), child)
        end
    end
end

print(("\226\156\147 Import from %s -> src/workspace + src/models"):format(input))
-- scripts/import.remodel.lua
-- Usage:
--   remodel run scripts/import.remodel.lua [inputPlace]
-- If no inputPlace is provided, it tries gardenclash.rbxl, then place.rbxlx, then place.rbxl

local input = ...
if not input or input == "" then
    local candidates = {"gardenclash.rbxl", "place.rbxlx", "place.rbxl"}
    for _, f in ipairs(candidates) do
        local ok = pcall(function()
            local h = io.open(f, "rb"); if h then h:close() end
        end)
        if ok then input = f; break end
    end
end
assert(input and input ~= "", "No .rbxl/.rbxlx provided or found in repo root.")

local place = remodel.readPlaceFile(input)

-- Workspace -> src/workspace/*.rbxmx (one file per top-level child)
remodel.createDirAll("src/workspace")
for _, child in ipairs(place.Workspace:GetChildren()) do
    local name = child.Name:gsub("[^%w_%-% ]","_")
    remodel.writeModelFile(("src/workspace/%s.rbxmx"):format(name), child)
end

-- ReplicatedStorage/Models -> src/models/*.rbxmx
local rs = place:FindFirstChild("ReplicatedStorage")
if rs then
    local models = rs:FindFirstChild("Models")
    if models then
        remodel.createDirAll("src/models")
        for _, child in ipairs(models:GetChildren()) do
            local name = child.Name:gsub("[^%w_%-% ]","_")
            remodel.writeModelFile(("src/models/%s.rbxmx"):format(name), child)
        end
    end
end

print(("\226\156\147 Import from %s -> src/workspace + src/models"):format(input))
