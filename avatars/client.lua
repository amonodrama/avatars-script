local downloading = {}
local avatarCache = {}

addEvent("avatars:onAvatarDataReceive", true)
addEventHandler("avatars:onAvatarDataReceive", resourceRoot,
function(username, data)
saveDownloadedFile(data, 0, "avatar_"..username, localPlayer, true)
end)

function saveDownloadedFile(responseData, errorNo, path, player, noAssign)
	if errorNo == 0 then
		if fileExists("avatars/"..path) then
			fileDelete("avatars/"..path)
		end
		local file = fileCreate("avatars/"..path)
		if file then
			fileWrite(file, responseData)
			fileClose(file)
				assignPlayerAvatar(player, path)
			print("[CLIENT] created avatar cache for "..path)
		end
	end
	if downloading[path] then
		downloading[path] = nil
	end
end

function assignPlayerAvatar(player, path)
	if isElement(player) and type(path) == "string" and fileExists("avatars/"..path) then
		if not avatarCache[player] then
			avatarCache[player] = dxCreateTexture("avatars/"..path)
		end
		if avatarCache[player] then
			setElementData(player, "avatarTexture", avatarCache[player], false)
		end
	end
end

addEventHandler("onClientPlayerQuit", root,
function()
	if isElement(avatarCache[source]) then
		destroyElement(avatarCache[source])
	end
	avatarCache[source] = nil
end)