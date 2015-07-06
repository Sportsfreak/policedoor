local maps = {}
maps["gm_flatgrass"] = {
	{Vector(506.866211,-50.352909,-12223.968750), Angle(0,0,0)}
}
maps["gm_flatgrass"] = {
	{Vector(529.653381,-78.400650,-12223.968750), Angle(32,0,0)}
}
	 
maps["rp_downtown_v2"] = { 
	{Vector(-1572.088867,117,-131.968750), Angle(0,0,0)}, 
	{Vector(-1455.483032,117,-131.968750), Angle(0,0,0)} 
}	

hook.Add("InitPostEntity", "PD_Door_Spawn", function()
	local map = string.lower(game.GetMap())
	local pos = maps[map] 
	if (!pos) then return end
	
	for key, tbl in pairs(pos) do
		local Ents = ents.FindInSphere(tbl[1],20)
		
		if (#Ents > 0) then
			for k,v in pairs(Ents) do
				if v:GetClass() == "prop_door_rotating" then
					v:Remove()
				end
			end
		end

		local Door = ents.Create("pd_door")
		Door:SetPos(tbl[1])
		Door:SetPos(Door:LocalToWorld(Vector(0,0,-20)))
		Door:SetAngles(tbl[2])
		Door:Spawn()
		Door:Activate()
		
		Door:SetAngles(Door:LocalToWorldAngles(tbl[2]))
		
		print("Door added")
	end
end)
