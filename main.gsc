#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\animscripts\zm_utility;

/$
	i_text_color
	i_title_color
	i_bg_color
	i_highlight_color
	i_freezecontrols
	i_blur_menu
	i_bg_enabled
	i_controls
	doorsdisabledfortime
	current_buildable_piece
	buildablename
	unitrigger_stubs
	piece
	pose
	meleerange
	stance
	sessionteam
	_encounters_team
	infinite_mana
	zombie_weapons_upgraded
	sq_bg_macguffins
	souls_received
	n_souls_absorbed
	zombie_weapons_upgraded
	damage_own_team
	addon_attachments
	default_attachment
	_poi_override
	_zombie_human_array
	_zombie_using_humangun
	ignore_enemyoverride
	script_noteworthy
	script_origin
	i_bg_alpha
	i_pref_vertical
	i_pref_bg_shader
	i_pref_horizontal
	i_customOptionsEnabled
	i_customoptions
	i_addoption
	i_endsubmenu
	i_addsubmenu
	i_addsliderbool
	i_addsliderint
	i_addsliderlist
	i_getcbool
	i_getcvar
	i_setscvar
	i_customoptionsmenuaccess
	i_bg_h
	i_bg_v
	i_bg_height
	i_bg_width
$/

/! 
	forever
	VerificationChanged
	settext
	EvanescenceClose
	loops
	HitTarget_hma
	_option_
	ControlMonitor
	Deselected
	hubbajubba
	MenuUpateInbound
	EnsureMaxhealth
	EvanescenceVerification
	toggleall
	spooky
	rspook
	noemergency
	emergencyfix
!/

init()
{
	maps/mp/gametypes_zm/_shellshock::init();
	level.i_bg_shader = "white";
	if(isdefined(level.i_pref_bg_shader))
		level.i_bg_shader = level.i_pref_bg_shader;
	level.i_addoption = ::addoption;
	level.i_endsubmenu = ::endsubmenu;
	level.i_addsubmenu = ::addsubmenu;
	level.i_addsliderbool = ::addsliderbool;
	level.i_addsliderint = ::addsliderint;
	level.i_addsliderlist = ::addsliderlist;
	level.i_getcbool = ::getcbool;
	level.i_getcvar ::getcvar;
	level.i_setscvar = ::setcvar;
	precacheshader("white");
	precacheshader(level.i_pref_bg_shader);
	precacheshader("menu_zm_popup");
	precacheshader("menu_zm_gamertag");
	precacheshader("ui_sliderbutt_1");
	precacheShader("damage_feedback");
	precacheModel("test_sphere_silver");
	precacheModel("defaultvehicle");
	precacheModel("defaultactor");
	precachemodel( "test_sphere_lambert" );
	precachemodel( "test_macbeth_chart" );
	precachemodel( "test_macbeth_chart_unlit" );
	precacheModel("collision_wall_128x128x10_standard");
	precacheModel("collision_wall_256x256x10_standard");
	precacheModel("collision_wall_512x512x10_standard");
	precacheModel("collision_clip_sphere_64");
	level.menu_initialized = 0;
	level.page_offset = [];
	level.menu_controls_menu = -3;
	level.menu_sliderOffsetAlign = -100;
	level._iconic_portalmodel = "test_sphere_silver";
	level.player_too_many_players_check = 0;
	level.player_too_many_players_check_func = ::player_too_many_players_check_func;
	level.player_intersection_tracker_override = ::player_intersection_tracker_override;
	level.player_out_of_playable_area_monitor_callback = ::player_out_of_playable_area_monitor_callback;
	level.player_out_of_playable_area_monitor = 0;
	level.player_too_many_weapons_monitor = 0;
	level.player_too_many_weapons_monitor_func = ::player_too_many_weapons_monitor_func;
	level.get_player_weapon_limit = ::get_player_weapon_limit;
	level.iconic_allplayers = spawnstruct();
	level.iconic_allplayers.name = "1480-4312-2914-1019-4118";
	if(isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats)
		level.zm_disable_recording_stats = false;
	level.nojoin = false;
	setDvar("ui_errorMessage", "^3Thanks for using ^2Project Iconic ^6Evanescence Edition ^3by ^2SeriousHD-");
	setDvar("ui_errorTitle", "^2Iconic");
	setDvar("perk_weapSpreadMultiplier", "0.0001");
	setDvar("party_gameStartTimerLength", "1");
	setDvar("party_gameStartTimerLengthPrivate", "1");
	setDvar("bg_viewKickScale", "0.0001");
	setDvar("g_friendlyfireDist", "0");
	level.friendlyzombies = "allies";
    level thread onPlayerConnect();
}

onPlayerConnect()
{
	level.iconic_allplayers thread onPlayerSpawned();
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
	level.Evanescence.ClientVariables[ self GetName() ] = [];
	level.page_offset[ self GetName() ] = 0;
    self endon("disconnect");
	level endon("game_ended");
	self.points_precision = 10;
    self.weapon_to_give = "NONE";
    self.zombie_weapons = "NONE";
    self.other_model = "NONE";
    self.menuModels = "NONE";
    self.powerup = "NONE";
    self.message_text = "";
    self._option_ = "zombie_score_bonus_head";
    self.zombie_vars_precision = 1;
    self.TIMESTAMPLASTDAY = 0;
    self.NoSpecialLimit = false;
    self.selected_zombie_var = "";
    self.selected_zombie_var_precision = "";
    self.rounds_precision = 1;
    self.stat_to_set = GetArrayKeys(level.players[0].pers)[0];
    self.stat_precision = 1;
    self.nixie_tube = "OFF";
    self SetCVar(self, 334, 1);
    self SetCVar(self, 361, "j_mouth_le");
    self SetCVar(self, 362, "NONE");
    self setcvar(self, 365, "NONE");
    self setcvar(self, 380, "NONE");
    self.allplayerswhost = false;
    if(self == level.iconic_allplayers)
    	return;
    self waittill("spawned_player");
    self notify("stop_player_too_many_weapons_monitor");
    if( self isHost() )
    {
    	level thread InitializeMenu();
    	level thread OnGameEndedHint( self );
    	level thread SmartOverflowEngine();
    }
    while( !level.menu_initialized )
    	wait .25;
    if(!self isHost() )
    	GetHost() thread VerifyDvarListedPlayer( self );
    self thread LoadMenu();
    self thread VerificationMonitor();
}

player_too_many_players_check_func()
{

}

player_intersection_tracker_override(player)
{
	self waittill("forever");
	return true;
}

player_out_of_playable_area_monitor_callback()
{
	return false;
}

player_too_many_weapons_monitor_func()
{
}

get_player_weapon_limit( player )
{
	if(!isdefined(player GetMenu()) || !player.NoSpecialLimit)
	{
		if ( player hasperk( "specialty_additionalprimaryweapon" ) )
			return 3;
		return 2;
	}
	return 50;
}

OnGameEndedHint( player )
{
	level waittill("end_game");
	hud = player createFontString("objective", 2);
    hud setText("^2Hold [{+gostand}] ^3and [{+usereload}] to ^2Restart the Map");
    hud.x = 0;
	hud.y = 0;
	bar.alignx = "center";
	bar.aligny = "center";
	bar.horzalign = "fullscreen";
	bar.vertalign = "fullscreen";
	hud.color = (1,1,1);
	hud.alpha = 1;
	hud.glowColor = (1,1,1);
	hud.glowAlpha = 0;
	hud.sort = 5;
	hud.archived = false;
	hud.foreground = true;
	while(1)
	{
		if(player jumpbuttonpressed() && player usebuttonpressed())
		{
			map_restart(false);
			break;
		}
		wait .05;
	}
}

IconicReviveFeature()
{
	self endon("VerificationChanged");
	self thread IconicLastStandFeature();
	for(;;)
	{
		self waittill_any( "bled_out", "fake_death", "player_suicide", "bleed_out" );
		while(self.sessionstate != "spectator")
		wait .01;
		hud = self createFontString("objective", 2);
	    hud setText("^2Hold [{+gostand}] ^3and [{+usereload}] to ^2Respawn");
	    hud.x = 0;
		hud.y = 0;
		bar.alignx = "center";
		bar.aligny = "center";
		bar.horzalign = "fullscreen";
		bar.vertalign = "fullscreen";
		hud.color = (1,1,1);
		hud.alpha = 1;
		hud.glowColor = (1,1,1);
		hud.glowAlpha = 0;
		hud.sort = 5;
		hud.archived = false;
		while(self.sessionstate == "spectator")
		{
			if ( self jumpbuttonpressed() && self usebuttonpressed() )
			{
				if ( isDefined( self.spectate_hud ) )
				{
					self.spectate_hud destroy();
				}
				self [[ level.spawnplayer ]]();
			}
			wait .1;
		}
		hud destroy();
	}
}
IconicLastStandFeature()
{
	self endon("VerificationChanged");
	while( 1 )
	{
		while(!self maps/mp/zombies/_zm_laststand::player_is_in_laststand())
			WaitMin();
		hud = self createFontString("objective", 2);
	    hud setText("^2Hold [{+gostand}] ^3and [{+usereload}] to ^2Revive yourself");
	    hud.x = 0;
		hud.y = 0;
		bar.alignx = "center";
		bar.aligny = "center";
		bar.horzalign = "fullscreen";
		bar.vertalign = "fullscreen";
		hud.color = (1,1,1);
		hud.alpha = 1;
		hud.glowColor = (1,1,1);
		hud.glowAlpha = 0;
		hud.sort = 5;
		hud.archived = false;
		while(self maps/mp/zombies/_zm_laststand::player_is_in_laststand())
		{
			if ( self jumpbuttonpressed() && self usebuttonpressed() )
			{
				self maps/mp/zombies/_zm_laststand::auto_revive( self );
			}
			WaitMin();
		}
		hud destroy();
	}
}





