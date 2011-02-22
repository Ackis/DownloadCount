--[[
************************************************************************
DownloadCount.lua
Script which will add your total downloads from the three release sites.
************************************************************************
File date: @file-date-iso@
File hash: @file-abbreviated-hash@
Project hash: @project-abbreviated-hash@
Project version: @project-version@
************************************************************************
Please see http://wow.curseforge.com/addons/dlcount/ for more information.
************************************************************************
This source code is released under Public Domain
************************************************************************
Require socket.  You can get it from: http://luaforge.net/projects/luasocket/

This is not to be run in WoW or any other game.  It will query all of the release sites and obtain
download information for the mod specified in the parameters.
************************************************************************
]]--

http = require("socket.http")

function GetNumberDownloads(addonurl,patternmatch1,patternmatch2)

	local _,_,temp = string.find(http.request(addonurl), patternmatch1)
	local _,_,temp1 = string.find(http.request(addonurl), patternmatch2)

	if (temp) then
		local numberdownloads = string.gsub(temp,",","")
		return numberdownloads
	else
		return temp1
	end

end

do

	-- URL of where the add-ons are hosted
	local curseurl = "http://wow.curse.com/downloads/wow-addons/details/"
	local wowuiurl = "http://wowui.worldofwar.net/?p=mod&m="
	local wowiurl = "http://www.wowinterface.com/downloads/info"

	-- Patterns which we match to find download information
	--local cursepatternmatch1 = "<th>Downloads Total:</th>\n                                            <td>(%d+,%d+)</td>"
	--local cursepatternmatch2 = "<th>Downloads Total:</th>\n                                            <td>(%d+)</td>"
	local cursepatternmatch1 = "Downloads Total:</dt><dd class=\"alt\">(%d+)</dd>"
	local cursepatternmatch2 = "Downloads Total:</dt><dd class=\"alt\">(%d+)</dd>"
	local wowuipatternmatch1 = "<b>(%d+,%d+)</b> total downloads</b>"
	local wowuipatternmatch2 = "<b>(%d+)</b> total downloads</b>"
	local wowipatternmatch1 = "<td class=\"alt1\"><div class=\"smallfont\">(%d+,%d+)</div></td>"
	local wowipatternmatch2 = "<td class=\"alt1\"><div class=\"smallfont\">(%d+)</div></td>"

	print("Curse ID: " .. arg[1])
	print("WoWUI ID: " .. arg[2])
	print("WoWI  ID: " .. arg[3])
	print("")
	print("Downloads by site:")

	local curse
	local WoWUI
	local WoWI

	if (arg[1]) then

		local tempurl = curseurl .. arg[1] .. ".aspx"
		curse = GetNumberDownloads(tempurl,cursepatternmatch1,cursepatternmatch2)
		print("Curse Gaming:   " .. curse)

	end

	if (arg[2]) then

		local tempurl = wowuiurl .. arg[2]
		WoWUI = GetNumberDownloads(tempurl,wowuipatternmatch1,wowuipatternmatch2)
		print("WoW UI:         " .. WoWUI)

	end

	if (arg[3]) then

		local tempurl = wowiurl .. arg[3] .. ".html"
		WoWI = GetNumberDownloads(tempurl,wowipatternmatch1,wowipatternmatch2)
		print("WoW Interface:  " .. WoWI)

	end

	print("--------------------")
	print("Total: " .. curse + WoWUI + WoWI)

end

