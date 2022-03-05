bool_functions(_option, arg1, arg2, arg3, arg4, allplayers )
{
	self notify("toggleall" + _option);
	if(!isdefined(allplayers) || !allplayers)
		result = self Toggle( _option );
	else
		result = self GetCBool( _option, allplayers);
	if( _option == 0 )
	{
		if( result )
		{
			self EnableInvulnerability();
		}
		else
		{
			self DisableInvulnerability();
		}
	}
	else if(_option == 1)
	{
		if(result)
			self thread loops( _option );
	}
	else if(_option == 2)
	{
		self.ignoreMe = result;
	}
	else if(_option == 3)
	{
		if(result)
		{
			self.ignoreMe = true;
			self hide();
		}
		else
		{
			self.ignoreMe = false;
			self show();
		}
	}
	else if(_option == 4)
	{
		if(result)
			self thread loops(_option);
	}
	else if(_option == 167)
	{
		if(result)
		{
			self setperk( "specialty_unlimitedsprint" );
			self setsprintcooldown( 0 );
		}
		else
		{
			self unsetperk( "specialty_unlimitedsprint" );
			self setsprintcooldown( 1 );
		}
	}
	else if(_option == 179)
	{
		if(result)
			self thread loops(_option);
	}
	else if(_option == 7)
	{
		self setclientthirdperson( result );
	}
	else if(_option == 8)
	{
		if( result )
			self thread loops(_option, 0);
	}
	else if(_option == 156)
	{
		self thread loops( _option );
	}
	else if( _option == 9)
	{
		if(result)
		{
			self thread loops(9);
		}
		else
		{
			if ( !isDefined( self.healthbarhudelems ) )
			{
				return;
			}
			i = 0;
			while ( i < self.healthbarkeys.size )
			{
				self.healthbarhudelems[ self.healthbarkeys[ i ] ].bgbar destroy();
				self.healthbarhudelems[ self.healthbarkeys[ i ] ].bar destroy();
				self.healthbarhudelems[ self.healthbarkeys[ i ] ] destroy();
				i++;
			}
		}
	}
	else if(_option == 14)
	{
		self._retain_perks = result;
	}
	else if(_option == 193)
	{
		perks = strtok("specialty_additionalprimaryweapon,specialty_armorpiercing,specialty_armorvest,specialty_bulletaccuracy,specialty_bulletdamage,specialty_bulletflinch,specialty_bulletpenetration,specialty_deadshot,specialty_delayexplosive,specialty_detectexplosive,specialty_disarmexplosive,specialty_earnmoremomentum,specialty_explosivedamage,specialty_extraammo,specialty_fallheight,specialty_fastads,specialty_fastequipmentuse,specialty_fastladderclimb,specialty_fastmantle,specialty_fastmeleerecovery,specialty_fastreload,specialty_fasttoss,specialty_fastweaponswitch,specialty_finalstand,specialty_fireproof,specialty_flakjacket,specialty_flashprotection,specialty_gpsjammer,specialty_grenadepulldeath,specialty_healthregen,specialty_holdbreath,specialty_immunecounteruav,specialty_immuneemp,specialty_immunemms,specialty_immunenvthermal,specialty_immunerangefinder,specialty_killstreak,specialty_longersprint,specialty_loudenemies,specialty_marksman,specialty_movefaster,specialty_nomotionsensor,specialty_noname,specialty_nottargetedbyairsupport,specialty_nokillstreakreticle,specialty_nottargettedbysentry,specialty_pin_back,specialty_pistoldeath,specialty_proximityprotection,specialty_quickrevive,specialty_quieter,specialty_reconnaissance,specialty_rof,specialty_scavenger,specialty_showenemyequipment,specialty_stunprotection,specialty_shellshock,specialty_sprintrecovery,specialty_showonradar,specialty_stalker,specialty_twogrenades,specialty_twoprimaries,specialty_unlimitedsprint", ",");
		foreach( perk in perks )
			if( result )
				self setperk( perk );
			else
				self unsetperk( perk );
	}
	else if(_option == 34)
	{
		if(result)
			self thread loops(34);
	}
	else if(_option == 35)
	{
		if(result)
			self thread loops(35);
	}
	else if( _option == 184 )
	{
		if(result)
			self thread loops(184);
	}
	else if(_option == 36)
	{
		if(result)
			self thread loops(36, 0);
	}
	else if(_option == 178 || _option == 170)
	{
		if(result)
			self thread loops(_option);
	}
	else if(_option == 186)
	{
		if(result)
			self thread loops(_option);
	}
	else if(_option == 185)
	{
		if(result)
			self thread loops(_option, arg1);
	}
	else if(_option == 171)
	{
		level.trampoline_mode = result;
		foreach( player in level.players )
			player thread loops(_option);
	}
	else if(_option == 168)
	{
		if(result)
			foreach(player in level.players)
				player attach("defaultvehicle", "j_head", true);
		else
			foreach(player in level.players)
				player detach("defaultvehicle", "j_head", true);
	}
	else if(_option == 200)
	{
		if(result)
			self thread loops(_option);
	}
	else if( _option == 204 )
	{
		if( !self isHost() )
		{
			self iprintln("Host only!");
			return;
		}
		if( GetCBool(205) )
			self SetCVar( self, 205, false );
		if( result )
			self thread loops(204);
	}
	else if( _option == 205)
	{	
		if( !self isHost() )
		{
			self iprintln("Host only!");
			return;
		}
		if( GetCBool(204) )
			SetCVar(self, 204, false);
		if( result )
			self thread loops(205);
	}
	else if(_option == 47)
	{
		if(result)
		{
			self iprintln("^1Menu Controls changed: Use [{+melee}] + [{+speed_throw}] to open menu!");
			wait 2;
		}
		if(result)
			self thread loops(47);
	}
	else if(_option == 53)
	{
		if(result)
		{
			flag_clear("spawn_zombies");
		}
		else
		{
			flag_set("spawn_zombies");
		}
		level.zombie_total=0;
		level thread maps/mp/zombies/_zm_powerups::specific_powerup_drop("nuke", self.origin);
	}
	else if(_option == 54)
	{
		setDvar("g_ai", !result);
	}
	else if( _option == 202 )
	{
		if( result )
			foreach( player in level.players )
				player thread loops(202, self );
	}
	else if(_option == 58)
	{
		if(result)
			self thread loops( 58 );
	}
	else if(_option == 59)
	{
		if(result)
			level._powerup_timeout_custom_time = ::_powerup_timeout_custom_time;
		else
			level._powerup_timeout_custom_time = undefined;
	}
	else if(_option == 60)
	{
		if(result)
		{
			foreach(player in level.players)
			{
				player.personal_instakill = true;
			}
			level.zombie_vars[ self.team ][ "zombie_powerup_insta_kill_on" ] = 1;
			level.zombie_vars[ self.team ][ "zombie_insta_kill" ] = 1;
		}
		else
		{
			foreach(player in level.players)
			{
				player.personal_instakill = undefined;
			}
			level.zombie_vars[ self.team ][ "zombie_powerup_insta_kill_on" ] = 0;
			level.zombie_vars[ self.team ][ "zombie_insta_kill" ] = 0;
		}
	}
	else if(_option == 61)
	{
		level.zombie_vars[ "zombie_powerup_fire_sale_on" ] = result;
		if(result)
		{
			level thread maps/mp/zombies/_zm_powerups::toggle_fire_sale_on();
			level.disable_firesale_drop = 1;
		}
		else
		{
			level notify("fire_sale_off");
			level.disable_firesale_drop = 0;
		}
	}
	else if(_option == 69)
	{
		if(result)
		{
			setDvar("party_connectToOthers" , "0");
			setDvar("partyMigrate_disabled" , "1");
			setDvar("party_mergingEnabled" , "0");
		}
		else
		{
			setDvar("party_connectToOthers" , "1");
			setDvar("partyMigrate_disabled" , "0");
			setDvar("party_mergingEnabled" , "1");
		}
	}
	else if(_option == 70)
	{
		if(result)
		{
			setDvar("cg_drawFPS", "1");
			setDvar("cg_drawBigFPS", "1");
		}
		else
		{
			setDvar("cg_drawFPS", "0");
			setDvar("cg_drawBigFPS", "0");
		}
	}
	else if(_option == 74)
	{
		if(result)
			self thread loops(74);
	}
	else if(_option == 153)
	{
		if(result)
		{
			level.zombie_vars[ "zombie_intermission_time" ] = 99999;
		}
		else
		{
			level.zombie_vars[ "zombie_intermission_time" ] = 15;
		}
	}
	else if(_option == 76)
	{
		setmatchtalkflag( "EveryoneHearsEveryone", result);
	}
	else if(_option == 77)
	{
		if(result)
		{
			setmatchflag( "disableIngameMenu", 1 );
			foreach(player in level.players)
			{
				player closemenu();
				player closeingamemenu();
			}
		}
		else
			setmatchflag( "disableIngameMenu", 0 );
	}
	else if(_option == 78)
	{
		level.nojoin = result;
	}
	else if(_option == 79)
	{
		if(result)
		{
			setDvar("perk_weapRateMultiplier","0.001");
			setDvar("perk_weapReloadMultiplier","0.001");
			setDvar("perk_fireproof","0.001");
			setDvar("cg_weaponSimulateFireAnims","0.001");
			foreach(player in level.players)
			{
				player setperk("specialty_rof");
				player setperk("specialty_fastreload");
			}
		}
		else
		{
			setDvar("perk_weapRateMultiplier","1");
			setDvar("perk_weapReloadMultiplier","1");
			setDvar("perk_fireproof","1");
			setDvar("cg_weaponSimulateFireAnims","1");
		}
	}
	else if(_option == 80)
	{
		if(result)
			foreach(player in level.players)
				player thread loops(80, self);
	}
	else if(_option == 81)
	{
		if(result)
			setDvar("player_meleeRange", 999);
		else
			setDvar("player_meleeRange", 1);
	}
	else if(_option == 82)
	{
		if(result)
		{
			setDvar("g_knockback", 99999);
		}
		else
		{
			setDvar("g_knockback", 1);
		}
	}
	else if(_option == 83)
	{
		level._iconic_hitmarkers = result;
		if(level._iconic_hitmarkers)
		{
			foreach( player in level.players )
				player thread loops(83,0);
			level thread loops(83, 1);
		}
	}
	else if(_option == 190)
	{
		if( result )
		{
			level.friendlyfire = true;
			foreach( player in level.players )
				player thread loops(190);	
		}
		else
			level.friendlyfire = false;
	}
	else if(_option == 180)
	{
		if( result )
		{
			level.claymores_max_per_player = 999;
		}
		else
		{
			level.claymores_max_per_player = 12;
		}
	}
	else if(_option == 206)
	{
		if( result )
			foreach( player in level.players )
				player thread loops( 206, self );
	}
	else if(_option == 84)
	{
		level.headshots_only = result;
	}
	else if(_option == 194)
	{
		level.mixed_rounds_enabled = result;
	}
	else if(_option == 195)
	{
		level.zombie_vars["spectators_respawn"] = result;
	}
	else if(_option == 165)
	{
		if(result)
			self thread loops(165);
	}
	else if(_option == 166)
	{
		if(result)
			self thread loops(166);
	}
	else if(_option == 183)
	{
		if(result)
		{
			self.hud_dfeedbacktroll = newClientHudElem( self );
			self.hud_dfeedbacktroll.horzalign = "top";
			self.hud_dfeedbacktroll.vertalign = "left";
			self.hud_dfeedbacktroll.x = -100;
			self.hud_dfeedbacktroll.y = 0;
			self.hud_dfeedbacktroll.alpha = 1;
			self.hud_dfeedbacktroll.foreground = 1;
			self.hud_dfeedbacktroll.archived = 1;
			self.hud_dfeedbacktroll setshader( "white", 900, 900 );
		}
		else
		{
			self.hud_dfeedbacktroll destroy();
		}
	}
	else if(_option == 140)
	{
		self freezecontrols(result);
	}
	else if(_option == 141)
	{
		self freezecontrolsallowlook(result);
	}
	else if(_option == 94)
	{
		if(result)
		{
			level.zombie_vars["emp_stun_range"] = 9999;
			level.zombie_vars["emp_stun_time"] = 9999;
			level.zombie_vars["emp_perk_off_range"] = 9999;
			level.zombie_vars["emp_perk_off_time"] = 90;
		}
		else
		{
			level.zombie_vars["emp_stun_range"] = 600;
			level.zombie_vars["emp_stun_time"] = 20;
			level.zombie_vars["emp_perk_off_range"] = 420;
			level.zombie_vars["emp_perk_off_time"] = 90;
		}
	}
	else if(_option == 95)
	{
		level.hud_dfeedbacktroll = result; //To fix a string :)
		if(level.hud_dfeedbacktroll)
		{
			foreach(player in level.players)
			{
				player notify( "never_overheat" );
				player thread loops(95);
			}
		}
	}
	else if(_option == 96)
	{
		if(result)
		{
			level.zombie_vars["riotshield_fling_range"]=9999;
			level.zombie_vars["riotshield_gib_range"]= 9999;
			level.zombie_vars["riotshield_gib_damage"]= 99999;
			level.zombie_vars["riotshield_knockdown_range"]= 9999;
			level.zombie_vars["riotshield_knockdown_damage"]= 99999;
			level.zombie_vars["riotshield_hit_points"]= 99999;
			level.zombie_vars["riotshield_fling_damage_shield"]= 0;
			level.zombie_vars["riotshield_knockdown_damage_shield"]= 0;
		}
		else
		{
			level.zombie_vars["riotshield_fling_range"]=90 ;
			level.zombie_vars["riotshield_gib_range"]= 90;
			level.zombie_vars["riotshield_gib_damage"]= 75;
			level.zombie_vars["riotshield_knockdown_range"]= 90;
			level.zombie_vars["riotshield_knockdown_damage"]= 15;
			level.zombie_vars["riotshield_hit_points"]= 2250;
			level.zombie_vars["riotshield_fling_damage_shield"]= 100;
			level.zombie_vars["riotshield_knockdown_damage_shield"]= 15;
		}
	}
	else if(_option == 203)
	{
		if(result)
			self thread loops(203);
	}
	else if(_option == 99)
	{
		if(result)
		{
			foreach(player in level.the_bus.destinations)
			{
				player.busspeedleaving=2500;
			}
			level.the_bus setvehmaxspeed(2500);
			level.the_bus setspeed( 2500, 15 );
			level.the_bus.targetspeed = 2500;
			self thread loops(99);
		}
	}
	else if(_option == 100)
	{
		if(result)
			self thread loops(100);
	}
	else if(_option == 108)
	{
		if(!result)
		{
			level.zombie_vars["slipgun_chain_radius"] = 120;
			level.zombie_vars["slipgun_chain_wait_min"] = 0.8;
			level.zombie_vars["slipgun_chain_wait_max"] = 1.9;
			level.zombie_vars["slipgun_max_kill_chain_depth"] = 16;
			level.zombie_vars["slipgun_max_kill_round"] = 100;
		}
		else
		{
			level.zombie_vars["slipgun_chain_radius"] = 9999;
			level.zombie_vars["slipgun_chain_wait_min"] = .75;
			level.zombie_vars["slipgun_chain_wait_max"] = 2.0;
			level.zombie_vars["slipgun_max_kill_chain_depth"] = 9999;
			level.zombie_vars["slipgun_max_kill_round"] = 1555;
		}
	}
	else if(_option == 199)
	{
		if( result )
		{
			self.str_living_view = self getviewmodel();
			self setviewmodel("c_zom_ghost_viewhands");
		}
		else
		{
			self setviewmodel(self.str_living_view);
		}	
	}
	else if(_option == 117)
	{
		if(!result)
		{
			level.slowgun_damage = 40;
			level.slowgun_damage_ug = 60;
		}
		else
		{
			level.slowgun_damage = 999999;
			level.slowgun_damage_ug = 999999;
		}
	}
	else if(_option == 118)
	{
		if(result)
			self thread loops(118);
	}
	else if(_option == 129)
	{
		if(result)
			self thread loops( 129 );
	}
	else if(_option == 130)
	{
		if(result)
			self thread loops(130);
	}
	else if(_option == 136)
	{
		level.vh_tank thread loops(136, self);
	}
	else if(_option == 137)
	{
		level.sneakyrobots = result;
		if(result)
			foreach( robot in level.a_giant_robots )
				robot thread hidetherobots();
	}
	else if(_option == 138)
	{
		if(result)
			 foreach( box in getentarray( "foot_box", "script_noteworthy" ))
			 	box.n_souls_absorbed = -9999;
		else
			foreach( box in getentarray( "foot_box", "script_noteworthy" ))
			 	box.n_souls_absorbed = 0;
	}
	else if(_option == 300)
	{
		if(result)
			self thread V3Loops(300);
	}
	else if(_option == 306)
	{
		if(result)
			foreach(player in level.players)
				player thread V3Loops(306, self);
	}
	else if(_option == 307)
	{
		if(result)
			self thread V3Loops(307);
	}
	else if(_option == 308)
	{
		if(result)
			self thread V3Loops(308);
	}
	else if(_option == 310)
	{
		if(result)
		{
			foreach(elevator in level.elevators)
			{
				elevator.body.door_state = 0;
				elevator.body.lock_doors = true;
				elevator.body setanim( level.perk_elevators_door_close_state, 1, 1, 1 );
				elevator.body notify( "PerkElevatorDoor" );
			}
		}
		else
		{
			foreach(elevator in level.elevators)
			{
				elevator.body.door_state = 1;
				elevator.body.lock_doors = false;
				elevator.body setanim( level.perk_elevators_door_open_state, 1, 1, 1 );
				elevator.body notify( "PerkElevatorDoor" );
			}
		}
	}
	else if(_option == 311)
	{
		if(result)
			self thread V3Loops(311);
	}
	else if(_option == 312)
	{
		if(result)
			self thread V3Loops(312);
	}
	else if(_option == 313)
	{
		if(result)
			self thread V3Loops(313);
	}
	else if(_option == 316)
	{
		if(result)
			self thread V3Loops(316);
	}
	else if(_option == 317)
	{
		if(result)
			self thread V3Loops(317);
	}
	else if(_option == 318)
	{
		if(result)
			self thread V3Loops(318);
	}
	else if(_option == 320)
	{
		if(result)
			self thread V3Loops(320);
	}
	else if(_option == 321)
	{
		if(result)
			self thread V3Loops(321);
	}
	else if(_option == 324)
	{
		if(result)
		{
			level.custom_magic_box_weapon_wait = ::MBWait;
		}
		else
		{
			level.custom_magic_box_weapon_wait = undefined;
		}
	}
	else if(_option == 327)
	{
		if(result)
			self thread V3Loops(327);
	}
	else if(_option == 330)
	{
		getent( "the_bus", "targetname" ).doorsdisabledfortime = result;
		if(result)
		{
			doorstrigger = getentarray( "bus_door_trigger", "targetname" );
			foreach(trig in doorstrigger)
			{
				trig setinvisibletoall();
			}
		}
		else
		{
			doorstrigger = getentarray( "bus_door_trigger", "targetname" );
			foreach(trig in doorstrigger)
			{
				trig setvisibletoall();
			}
		}
	}
	else if(_option == 331)
	{
		if(result)
			self thread V3Loops(331);
	}
	else if(_option == 332)
	{
		if(result)
			level.next_leaper_round = 256;
		else
			level.next_leaper_round = level.round_number + 1;
	}
	else if(_option == 336)
	{
		if(result)
			self thread V3Loops(336);
	}
	else if(_option == 338)
	{
		
		if(result)
		{
			foreach(zombie in GetAIArray(level.zombie_team))
			{
				zombie.team = self.team;
			}
			level.old_zombie_team = level.zombie_team;
			level.zombie_team = self.team;
		}
		else
		{
			foreach(zombie in GetAIArray(level.zombie_team))
			{
				zombie.team = level.old_zombie_team;
			}
			level.zombie_team = level.old_zombie_team;
		}
	}
	else if(_option == 340)
	{
		self.infinite_mana = result;
	}
	else if(_option == 344)
	{
		if(result)
			self thread V3Loops(344);
	}
	else if(_option == 349)
	{
		if(result)
			self thread V3Loops(349);
	}
	else if(_option == 350)
	{
		if(result)
			self thread V3Loops(350);
	}
	else if(_option == 351)
	{
		if(result)
			self thread V3Loops(351);
	}
	else if(_option == 352)
	{
		if(result)
			self thread V3Loops(352);
	}
	else if(_option == 353)
	{
		if(result)
			self thread V3Loops(353);
	}
	else if(_option == 354)
	{
		if(result)
			self thread V3Loops(354);
	}
	else if(_option == 357)
	{
		if(result)
			self thread V3Loops(357);
	}
	else if(_option == 370)
	{
		self.allplayerswhost = result;
	}
	else if(_option == 372)
	{
		level.no_end_game_check = result;
	}
	else if(_option == 375)
	{
		if(result)
			self thread V3Loops(375);
	}
	else if(_option == 381)
	{
		if(result)
			self thread V3Loops(381);
	}
	else if(_option == 385)
	{
		if(result)
			self thread ZMiniMap();
	}
	else if(_option == 388)
	{
		if(result)
			self thread V3Loops( 388 );
	}
	return result;
}





















