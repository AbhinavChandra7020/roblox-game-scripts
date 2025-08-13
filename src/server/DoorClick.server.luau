-- Universal Door Script - Place in ServerScriptService

local function setupDoor(door)
    local clickDetector = door:FindFirstChild("ClickDetector")
    if not clickDetector then
        return -- Skip if no ClickDetector
    end
    
    clickDetector.MouseClick:Connect(function(player)
        local character = player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local playerPos = humanoidRootPart.Position
                local doorPos = door.Position
                local doorToPlayer = playerPos - doorPos
                
                local dotProduct = doorToPlayer:Dot(door.CFrame.UpVector)
                
                local doorBottom = door.CFrame.Position - Vector3.new(0, door.Size.Y/2, 0)
                
                local behindPos
                if dotProduct > 0 then
                    behindPos = doorBottom - door.CFrame.UpVector * 4
                else
                    behindPos = doorBottom + door.CFrame.UpVector * 4
                end
                
                behindPos = behindPos + Vector3.new(0, 4, 0)
                
                humanoidRootPart.CFrame = CFrame.new(behindPos)
                
            end
        end
    end)
end

-- Setup existing doors
for _, door in pairs(workspace:GetDescendants()) do
    if door:IsA("BasePart") and door.Name:find("Door") and door:FindFirstChild("ClickDetector") then
        setupDoor(door)
    end
end

-- Setup new doors that get added
workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("BasePart") and descendant.Name:find("Door") and descendant:FindFirstChild("ClickDetector") then
        setupDoor(descendant)
    end
end)