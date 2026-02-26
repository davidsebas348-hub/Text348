repeat task.wait() until game:IsLoaded()

local Workspace = game:GetService("Workspace")

-- =========================
-- TOGGLE REAL
-- =========================
if _G.TrapCleanerSystem then
	
	-- Apagar sistema
	_G.TrapCleanerSystem.Enabled = false
	
	-- Desconectar eventos
	for _, conn in pairs(_G.TrapCleanerSystem.Connections) do
		conn:Disconnect()
	end
	
	_G.TrapCleanerSystem = nil
	
	return
end

-- =========================
-- CREAR SISTEMA
-- =========================
_G.TrapCleanerSystem = {
	Enabled = true,
	Connections = {}
}

-- Función para eliminar TouchInterest dentro de un HitBox
local function cleanHitbox(hitbox)
	for _, obj in ipairs(hitbox:GetChildren()) do
		if obj:IsA("TouchTransmitter") or obj.Name == "TouchInterest" then
			obj:Destroy()
		end
	end

	local conn = hitbox.ChildAdded:Connect(function(obj)
		if not _G.TrapCleanerSystem or not _G.TrapCleanerSystem.Enabled then return end
		
		if obj:IsA("TouchTransmitter") or obj.Name == "TouchInterest" then
			obj:Destroy()
		end
	end)
	
	table.insert(_G.TrapCleanerSystem.Connections, conn)
end

-- Función para vigilar cada TrapModel
local function monitorTrap(trap)
	if not trap:IsA("Model") then return end
	
	local hitbox = trap:FindFirstChild("HitBox")
	if hitbox and hitbox:IsA("Part") then
		cleanHitbox(hitbox)
	end
	
	local conn = trap.ChildAdded:Connect(function(child)
		if not _G.TrapCleanerSystem or not _G.TrapCleanerSystem.Enabled then return end
		
		if child.Name == "HitBox" and child:IsA("Part") then
			cleanHitbox(child)
		end
	end)
	
	table.insert(_G.TrapCleanerSystem.Connections, conn)
end

-- Detectar cuando aparezca TrapModel
local workspaceConn = Workspace.ChildAdded:Connect(function(obj)
	if not _G.TrapCleanerSystem or not _G.TrapCleanerSystem.Enabled then return end
	
	if obj.Name == "TrapModel" and obj:IsA("Model") then
		monitorTrap(obj)
	end
end)

table.insert(_G.TrapCleanerSystem.Connections, workspaceConn)

-- Revisar si ya existen
for _, obj in ipairs(Workspace:GetChildren()) do
	if obj.Name == "TrapModel" and obj:IsA("Model") then
		monitorTrap(obj)
	end
end
