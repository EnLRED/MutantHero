AddCSLuaFile()
include("shared.lua")

local old_time_standart = 6

local ROUND_SETTIME = old_time_standart
local ROUND_STARTED = false
local ROUND_TIME_SECS = 0
local ROUND_ENT = false

resource.AddWorkshop("107347296") //sunnyisles

util.PrecacheSound("npc/stalker/stalker_scream1.wav")
util.PrecacheSound("npc/crow/idle3.wav")
util.PrecacheSound("music/hl2_song3.mp3")
util.PrecacheSound("music/radio1.mp3")
util.PrecacheSound("music/ravenholm_1.mp3")

SetGlobalString("timetoend", tostring(ROUND_SETTIME))
SetGlobalString("timetoendsec", tostring(SECONDS_ROUND_SETTIME))
SetGlobalBool("round_started", ROUND_STARTED)

local Models = {
	"models/player/zombie_fast.mdl",
	"models/player/charple.mdl"
}
















--[[----------------------------------------------------------------------------------------------
	 ______    __    __    _____           _____    ___      __    __
	|      |  |  |  |  |  |  ___|         |  ___|  |   \    |  |  |   \\
	|__  __|  |  |__|  |  | |___          | |___   |  |\ \  |  |  |  _ \\
	  |  |    |   __   |  |  ___|         |  ___|  |  | \ \ |  |  | |_|||
	  |  |    |  |  |  |  | |___          | |___   |  |  \ \|  |  |    //
	  |__|    |__|  |__|  |_____|         |_____|  |__|   \____|  |___//
--]]----------------------------------------------------------------------------------------------














