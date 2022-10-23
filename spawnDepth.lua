loadstring(game:HttpGet"https://raw.githubusercontent.com/sponguss/storage/main/entitySpawner.lua")().createEntity("Ambush")

local tb=entityTable["Ambush"]
tb.Speed=120
tb.Sounds={"PlaySound", "Footsteps"}
tb.Model="https://github.com/Volta07/stuff/raw/main/Depth.rbxm"
tb.Ambush.Enabled=true
tb.WaitTime=2.5

loadstring(game:HttpGet"https://raw.githubusercontent.com/sponguss/storage/main/entitySpawner.lua")().runEntity("Ambush")