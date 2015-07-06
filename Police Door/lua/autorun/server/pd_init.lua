PD_Door = {}

PD_Door.AddDoor = function(map,pos,ang)
	if string.lower(game.GetMap())==string.lower(map) then
		local Door = ents.Create("pd_door")
		Door:SetPos(pos)
		Door:SetPos(Door:LocalToWorld(Vector(0,0,-20)))
		Door:SetAngles(Angle(0,0,0))
		Door:Spawn()
		Door:Activate()
		
				Door:SetAngles(Door:LocalToWorldAngles(ang))
		
		print("Door added")
	end
end

PD_Door.RemoveDoor = function(map,pos)
	if string.lower(game.GetMap())==string.lower(map) then
		local Ents = ents.FindInSphere(pos,20)
		
		for k,v in pairs(Ents) do
			if v:GetClass()=="prop_door_rotating" then
				v:Remove()
			end
		end
	end
end

PD_Door.SpawnDoors = function()
	for k,v in pairs(ents.GetAll()) do
		if v:GetClass()=="pd_door" then
			v:Remove()
		end
	end

	PD_Door.AddDoor("gm_flatgrass",Vector(506.866211,-50.352909,-12223.968750),Angle(0,0,0))
	PD_Door.AddDoor("gm_flatgrass",Vector(529.653381,-78.400650,-12223.968750),Angle(32,0,0))
	
	PD_Door.AddDoor("rp_downtown_v2",Vector(-1572.088867,117,-131.968750),Angle(0,0,0))
	PD_Door.AddDoor("rp_downtown_v2",Vector(-1455.483032,117,-131.968750),Angle(0,0,0))
	
	PD_Door.RemoveDoor("rp_downtown_v2",Vector(-1572.088867,116.597923,-131.968750))
	PD_Door.RemoveDoor("rp_downtown_v2",Vector(-1455.483032,113.012917,-131.968750))
end

hook.Add("InitPostEntity","PD_Door_Spawn",PD_Door.SpawnDoors)