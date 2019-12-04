

function math.clamp(value, minClamp, maxClamp)
	return math.min(maxClamp, math.max(value, minClamp))
end

blipTextures = {}

for i=0,63 do
	blipTextures[i] = dxCreateTexture("blips/"..i..".png")
end


-- addEventHandler("onClientResourceStart", resourceRoot, function() -- DEBUG
	-- local density = 500
	-- for i=0,63 do
		-- createBlip((i%8)*density, (i/8)*density, 0, i, 1, math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255))
	-- end
-- end)

addEventHandler("onClientRender", root, function()
	blip3DHeight = 250.0
	blip3DSize = 15

	for i,v in ipairs(getElementsByType("blip")) do
		local x, y, z = getElementPosition(v)
		local id = getBlipIcon(v)
		local r, g, b, a = getBlipColor(v)
		
		-- if id ~= 0 then r, g, b = 255, 255, 255 end
		
		local cx, cy, cz = getCameraMatrix()
		
		local distance = getDistanceBetweenPoints2D(x, y, cx, cy) - 100
		
		if distance <= 0 then distance = 0 end
		
		if distance < getFarClipDistance() then
		-- if false then -- always render fake 3d
		-- if true then -- always render 3d with line
			local alpha = (1-(15/distance))*255
			local alpha = math.clamp(alpha, 0, 255)
			
			
			-- blip3DSize = blip3DSize / distance
			
			dxDrawLine3D(x, y, z, x, y, blip3DHeight-10, tocolor(r, g, b, alpha/4), 250, false)
			if id > 1 then r, g, b = 255, 255, 255 end
			dxDrawMaterialLine3D(x, y, blip3DHeight+blip3DSize, x, y, blip3DHeight-blip3DSize, blipTextures[id], blip3DSize*2, tocolor(r, g, b, alpha))
		else
			local sx, sy = getScreenFromWorldPosition(x, y, z)
			if sx and sy then
				if id > 1 then r, g, b = 255, 255, 255 end
				dxDrawImage(sx-20, sy-20, 40, 40, blipTextures[id], 0, 0, 0, tocolor(r, g, b, 150))
				-- if getElementType(getElementAttachedTo(v)) == "player" then
					-- local player = getElementAttachedTo(v)
					-- dxDrawText(getPlayerName(player), sx, sy-35, 0, 0, tocolor(r, g, b, a))
				-- end
			end
		end
	end
end)