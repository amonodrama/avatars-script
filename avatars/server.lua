local avatarAPI = "http://ctrl.gg/mta_getavatar.php?getAvatar&username="
local downloading = {}

addEvent("downloadDetails",true)
function downloadDetails(player,user)
if getAccount(tostring(user)) then
  downloadAvatar(player, user)
  end
end
addEventHandler ( "downloadDetails", resourceRoot, downloadDetails)

function downloadAvatar(player, username)
  if not username then
  return
  end
  local path = "avatar_"..username
  if downloading[path] then
    return
  end
  local avatarPath = "avatars/"..path
  if fileExists(avatarPath) then
  fileDelete(avatarPath)
  end
  fetchRemote(avatarAPI..username, path, 1, 10000, saveDownloadedFile, "", false, path, player, username)
  downloading[path] = true
  end

  function saveDownloadedFile(responseData, errorNo, path, player, username)
  if errorNo == 0 then
  local file = fileCreate("avatars/"..path)
  if file then
  fileWrite(file, responseData)
  fileClose(file)
  setElementData(player, "avatarHash", path)
  print("[SERVER] Saved avatar for "..path)
  triggerClientEvent(player, "avatars:onAvatarDataReceive", resourceRoot, username, responseData)
  end
  end
    if downloading[path] then
    downloading[path] = nil
  end
end 