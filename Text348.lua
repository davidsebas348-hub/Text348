--// TOGGLE GLOBAL
getgenv().TrapCleaner = getgenv().TrapCleaner or {
    Enabled = false
}

-- invertir estado
getgenv().TrapCleaner.Enabled = not getgenv().TrapCleaner.Enabled


--// SERVICIOS
local Workspace = game:GetService("Workspace")

-- evitar duplicar conexión
if not getgenv().TrapCleaner.Connection then

    local function clearTrap(model)
        if not getgenv().TrapCleaner.Enabled then return end
        if not (model:IsA("Model") and model.Name == "TrapModel") then return end

        for _, obj in ipairs(model:GetDescendants()) do
            if obj:IsA("Part") then
                obj:Destroy()
            end
        end

    end

    -- existentes
    for _, obj in ipairs(Workspace:GetDescendants()) do
        clearTrap(obj)
    end

    -- nuevos
    getgenv().TrapCleaner.Connection = Workspace.DescendantAdded:Connect(function(obj)
        if not getgenv().TrapCleaner.Enabled then return end

        if obj:IsA("Model") and obj.Name == "TrapModel" then
            task.wait(0.05)
            clearTrap(obj)
            return
        end

        if obj:IsA("Part") then
            local model = obj:FindFirstAncestor("TrapModel")
            if model then
                obj:Destroy()
            end
        end
    end)
end
