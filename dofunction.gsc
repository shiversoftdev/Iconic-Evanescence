dofunction(option, arg1, arg2, arg3, arg4)
{
	__option = option;
	if(option == 10)
	{
		if(self maps/mp/zombies/_zm_laststand::player_is_in_laststand())
			self maps/mp/zombies/_zm_laststand::auto_revive( self );
	}
	else if(option == 11)
	{
		self clonePlayer(1);
	}
	else if(option == 12)
	{
		deadClone = self clonePlayer(1);
		deadClone startRagdoll(1);
	}
	else if(option == 13)
	{
		self notify("player_suicide");
		self maps/mp/zombies/_zm_laststand::bleed_out();
	}
	else if( option == 16 )
	{
		if(isdefined(self.perk_to_give) && self.perk_to_give != "NONE")
		{
			self thread maps/mp/zombies/_zm_perks::give_perk( self.perk_to_give, 1 );
		}
	}
	else if( option == -16)
	{
		if(isdefined(self.perk_to_give) && self.perk_to_give != "NONE")
			self notify( self.perk_to_give + "_stop");
	}
	else if(option == 17)
	{
		self maps/mp/zombies/_zm_score::add_to_player_score( self.points_precision );
	}
	else if(option == -17)
	{
		self maps/mp/zombies/_zm_score::minus_to_player_score( self.points_precision, 1 );
	}
	else if(option == 20)
	{
		temp = self.weapon_to_give;
		if(isdefined(arg1))
			self.weapon_to_give = arg1;
		if(self.weapon_to_give == "NONE")
			return;
		self.NoSpecialLimit = true;
		weapon = self.weapon_to_give;
		self EnableWeapons();
		self notify( "stop_player_too_many_weapons_monitor" );
		if( weapon == "staff_fire_upgraded_zm" || weapon == "staff_lightning_upgraded_zm" || weapon == "staff_water_upgraded_zm" || weapon == "staff_air_upgraded_zm")
		{
			self setactionslot( 3, "weapon", "staff_revive_zm" );
			self giveweapon( "staff_revive_zm" );
			self setweaponammostock( "staff_revive_zm", 3 );
			self setweaponammoclip( "staff_revive_zm", 1 );
			if(!isDefined(level.superstaffs))
			{
				_a90 = level.a_elemental_staffs;
				_k90 = getFirstArrayKey( _a90 );
				while ( isDefined( _k90 ) )
				{
					staff = _a90[ _k90 ];
					staff.charger.charges_received = 999;
					staff.charger.is_inserted = 1;
					staff.charger.full = 1;
					_k90 = getNextArrayKey( _a90, _k90 );
				}
				_a147 = level.a_elemental_staffs_upgraded;
				_k147 = getFirstArrayKey( _a147 );
				while ( isDefined( _k147 ) )
				{
					staff_upgraded = _a147[ _k147 ];
					staff_upgraded.charger.charges_received = 9999;
					staff_upgraded.charger.is_inserted = 1;
					staff_upgraded.charger.is_charged = 1;
					staff_upgraded.prev_ammo_clip = weaponclipsize( staff_upgraded.weapname );
					staff_upgraded.prev_ammo_stock = weaponmaxammo( staff_upgraded.weapname );
					staff_upgraded.charger.full = 1;
					_k147 = getNextArrayKey( _a147, _k147 );
				}
				level.staffs_charged = 4;
				flag_set( "staff_air_zm_enabled" );
				flag_set( "staff_fire_zm_enabled" );
				flag_set( "staff_lightning_zm_enabled" );
				flag_set( "staff_water_zm_enabled" );
				level.superstaffs = true;
			}
		}
		if( weapon == "upgraded_tomahawk_zm" || weapon == "bouncing_tomahawk_zm")
		{
			flag_set("soul_catchers_charged");
			level notify( "bouncing_tomahawk_zm_aquired" );
			self notify( "tomahawk_picked_up" );
			self notify( "player_obtained_tomahawk" );
			gun = self getcurrentweapon();
			if(weapon == "upgraded_tomahawk_zm"){
				self.current_tomahawk_weapon = "upgraded_tomahawk_zm";
				self setclientfieldtoplayer( "tomahawk_in_use", 1 );
				self setclientfieldtoplayer( "upgraded_tomahawk_in_use", 1 );
			}
			else
			{
				self.current_tomahawk_weapon = "bouncing_tomahawk_zm";
				self setclientfieldtoplayer( "tomahawk_in_use", 1 );
				self setclientfieldtoplayer( "upgraded_tomahawk_in_use", 0 );
			}
			self giveweapon( "zombie_tomahawk_flourish" );
			self switchtoweapon( "zombie_tomahawk_flourish" );
			self.loadout.hastomahawk = 1;
			self switchtoweapon( gun );
			if(weapon == "upgraded_tomahawk_zm")
			{
				self maps/mp/zombies/_zm_weapons::weapon_give( "upgraded_tomahawk_zm",0,0 );
			}
			else
			{
				self maps/mp/zombies/_zm_weapons::weapon_give( "bouncing_tomahawk_zm_aquired",0,0 );
			}
			self notify( "new_tactical_grenade" );
			self.current_tactical_grenade = self.current_tomahawk_weapon;
			return;
		}
		self maps/mp/zombies/_zm_weapons::weapon_give( weapon, 0, 0 );
		self switchtoweapon( weapon );
		self.NoSpecialLimit = false;
		if(isdefined(arg1))
			self.weapon_to_give = temp;
	}
	else if(option == -20)
	{
		self enableweapons();
		self takeweapon(self.weapon_to_give);
	}
	else if( option == 23 )
	{
		self enableweapons();
		self dropitem(self getcurrentweapon());
	}
	else if( option == 24 )
	{
		self enableweapons();
		weapon = self getcurrentweapon();
		self takeweapon( weapon );
		self giveweapon( weapon, 0, true(arg1,0,0,0,0));
		self givestartammo( weapon );
		self switchtoweapon( weapon );
	}
	else if( option == 21 )
	{
		self enableweapons();
		if ( !self maps/mp/zombies/_zm_laststand::player_is_in_laststand() )
		{
			weap = maps/mp/zombies/_zm_weapons::get_base_name( self getcurrentweapon() );
			weapon = get_upgrade( weap );
			if ( isDefined( weapon ) )
			{
				self takeweapon( weap );
				self giveweapon( weapon, 0, self maps/mp/zombies/_zm_weapons::get_pack_a_punch_weapon_options( weapon ) );
				self givestartammo( weapon );
				self switchtoweapon( weapon );
			}
		}
	}
	else if( option == 22 )
	{
		self enableweapons();
		if ( !self maps/mp/zombies/_zm_laststand::player_is_in_laststand() )
		{
			weap = self getcurrentweapon();
			weapon = maps/mp/zombies/_zm_weapons::get_base_weapon_name( weap, 1 );
			if ( isDefined( weapon ) )
			{
				self takeweapon( weap );
				self giveweapon( weapon, 0, self maps/mp/zombies/_zm_weapons::get_pack_a_punch_weapon_options( weapon ) );
				self givestartammo( weapon );
				self switchtoweapon( weapon );
			}
		}
	}
	else if(option == 172)
	{
		self thread SpawnBallTrap( bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"] , AnglesToForward(self getPlayerAngles()) , arg1);
	}
	else if(option == 15)
	{
		foreach( vending in getentarray( "zombie_vending", "targetname" ))
			vending delete();
		foreach( vending in level.machine_assets)
			vending delete();
		foreach( vending in getstructarray( "zm_perk_machine", "targetname" ))
			vending delete();
	}
	else if(option == 38)
	{
		foreach(box in level.chests)
			box thread maps/mp/zombies/_zm_magicbox::show_chest();
	}
	else if(option == 39)
	{
		foreach(box in level.chests)
			box thread maps/mp/zombies/_zm_magicbox::hide_chest(0);
	}
	else if(option == 40)
	{
		level.chest_min_move_usage = 999;
	}
	else if( option == 162 )
	{
		level.iconic_modded_box = 1;
		if( isDefined( level.custom_magic_box_selection_logic ) )
			level.custom_magic_box_selection_logic = undefined;
		if( isDefined(level.special_weapon_magicbox_check) )
			level.special_weapon_magicbox_check = undefined;
		if( isDefined(level.content_weapon) )
			level.content_weapon = undefined;
		foreach( weapon in level.zombie_weapons)
			weapon.is_in_box = 1;
		level.limited_weapons = [];
		level.iconic_box_weapons = [];
		level.iconic_box_weapons = array_copy( level.zombie_weapons );
		level.customrandomweaponweights = ::IconicMBOverride;
	}
	else if( option == 163 )
	{
		if(!isDefined(level.iconic_modded_box))
		{
			level.iconic_modded_box = 1;
			if( isDefined( level.custom_magic_box_selection_logic ) )
				level.custom_magic_box_selection_logic = undefined;
			if( isDefined(level.special_weapon_magicbox_check) )
				level.special_weapon_magicbox_check = undefined;
			if( isDefined(level.content_weapon) )
				level.content_weapon = undefined;
			foreach( weapon in level.zombie_weapons)
				weapon.is_in_box = 1;
			level.limited_weapons = [];
			level.iconic_box_weapons = [];
			level.iconic_box_weapons = array_copy( level.zombie_weapons );
			level.customrandomweaponweights = ::IconicMBOverride;
		}
		level.limited_weapons = [];
		level.iconic_box_weapons = [];
	}
	else if(option == 159)
	{
		if(!isDefined(level.iconic_modded_box))
		{
			level.iconic_modded_box = 1;
			if( isDefined( level.custom_magic_box_selection_logic ) )
				level.custom_magic_box_selection_logic = undefined;
			if( isDefined(level.special_weapon_magicbox_check) )
				level.special_weapon_magicbox_check = undefined;
			if( isDefined(level.content_weapon) )
				level.content_weapon = undefined;
			foreach( weapon in level.zombie_weapons)
				weapon.is_in_box = 1;
			level.limited_weapons = [];
			level.iconic_box_weapons = [];
			level.iconic_box_weapons = array_copy( level.zombie_weapons );
			level.customrandomweaponweights = ::IconicMBOverride;
		}
		level.zombie_weapons[ value ].is_in_box = 1;
		level.limited_weapons[ value ] = undefined;
		level.iconic_box_weapons = add_to_array( level.iconic_box_weapons, self.zombie_weapons, 0);
	}
	else if(option == 162)
	{
		if(!isDefined(level.iconic_modded_box))
		{
			level.iconic_modded_box = 1;
			if( isDefined( level.custom_magic_box_selection_logic ) )
				level.custom_magic_box_selection_logic = undefined;
			if( isDefined(level.special_weapon_magicbox_check) )
				level.special_weapon_magicbox_check = undefined;
			if( isDefined(level.content_weapon) )
				level.content_weapon = undefined;
			foreach( weapon in level.zombie_weapons)
				weapon.is_in_box = 1;
			level.limited_weapons = [];
			level.iconic_box_weapons = [];
			level.iconic_box_weapons = array_copy( level.zombie_weapons );
			level.customrandomweaponweights = ::IconicMBOverride;
		}
		level.zombie_weapons[ value ].is_in_box = 1;
		level.limited_weapons[ value ] = undefined;
		level.iconic_box_weapons = [];
		level.iconic_box_weapons[0] = self.zombie_weapons;
	}
	else if(option == 45)
	{
		self thread loops(option, self.other_model);
	}
	else if(option == 155)
	{
		value = "Get a ^21337 ^6Hacked ^2Weapon ^1for only: ^7";
		precachestring( value );
		foreach(weapon in level.zombie_weapons)
		{
			weapon.hint = value;
			weapon.cost = -1337;
			level.zombie_include_weapons[ weapon ] = 1;
			weapon.is_in_box = 1;
			weapon.ammo_cost = -1337;
		}
	}
	else if(option == 169)
	{
		direction = self getplayerangles();
		direction_vec = anglesToForward( direction );
		eye = self geteye();
		scale = 200;
		direction_vec = ( direction_vec[ 0 ] * scale, direction_vec[ 1 ] * scale, direction_vec[ 2 ] * scale );
		trace = bullettrace( eye, eye + direction_vec, 0, undefined );
		self thread loops( option, arg1 ,trace["position"] );
	}
	else if(option == 46)
	{
		if(self.menuModels == "NONE")
			return;
		direction = self getplayerangles();
		direction_vec = anglesToForward( direction );
		eye = self geteye();
		scale = 200;
		direction_vec = ( direction_vec[ 0 ] * scale, direction_vec[ 1 ] * scale, direction_vec[ 2 ] * scale );
		trace = bullettrace( eye, eye + direction_vec, 0, undefined );
		obj = spawn("script_model", trace[ "position" ], 1);
	    obj SetModel(self.menuModels);
	}
	else if(option == 48)
	{
		spawnername = undefined;
		spawnername = "zombie_spawner";
		direction = self getplayerangles();
		direction_vec = anglesToForward( direction );
		eye = self geteye();
		scale = 10;
		direction_vec = ( direction_vec[ 0 ] * scale, direction_vec[ 1 ] * scale, direction_vec[ 2 ] * scale );
		trace = bullettrace( eye, eye + direction_vec, 0, undefined );
		guy = undefined;
		spawners = getentarray( spawnername, "script_noteworthy" );
		spawner = spawners[ 0 ];
		guy = maps/mp/zombies/_zm_utility::spawn_zombie( spawner );
		if ( isDefined( guy ) )
		{
			wait 0.5;
			guy.origin = trace[ "position" ];
			guy.angles = self.angles + vectorScale( ( 0, 1, 0 ), 180 );
			guy forceteleport( trace[ "position" ], self.angles + vectorScale( ( 0, 1, 0 ), 180 ) );
			guy thread maps/mp/zombies/_zm_ai_basic::find_flesh();
		}
	}
	else if(option == 49)
	{
		ai = getaiarray( level.zombie_team );
		_a2225 = ai;
		_k2225 = getFirstArrayKey( _a2225 );
		while ( isDefined( _k2225 ) )
		{
			zombie = _a2225[ _k2225 ];
			if ( isDefined( zombie ) )
			{
				zombie dodamage( zombie.maxhealth * 2, zombie.origin, zombie, zombie, "none", "MOD_SUICIDE" );
				wait 0.05;
			}
			_k2225 = getNextArrayKey( _a2225, _k2225 );
		}
	}
	else if(option == 50)
	{
		position = self.origin;
		ai = getaiarray( level.zombie_team );
		_a2225 = ai;
		_k2225 = getFirstArrayKey( _a2225 );
		while ( isDefined( _k2225 ) )
		{
			zombie = _a2225[ _k2225 ];
			if ( isDefined( zombie ) )
			{
				zombie forceTeleport(position);
				zombie maps\mp\zombies\_zm_spawner::reset_attack_spot();
				wait 0.05;
			}
			_k2225 = getNextArrayKey( _a2225, _k2225 );
		}
	}
	else if(option == 51)
	{
		position = self.origin;
		position = bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"];
		ai = getaiarray( level.zombie_team );
		_a2225 = ai;
		_k2225 = getFirstArrayKey( _a2225 );
		while ( isDefined( _k2225 ) )
		{
			zombie = _a2225[ _k2225 ];
			if ( isDefined( zombie ) )
			{
				zombie forceTeleport(position);
				zombie maps\mp\zombies\_zm_spawner::reset_attack_spot();
				wait 0.05;
			}
			_k2225 = getNextArrayKey( _a2225, _k2225 );
		}
	}
	else if(option == 52)
	{
		enemy = getAiArray(level.zombie_team);
		foreach(zombie in enemy)
			if(!zombie.forcedCrawler)
			{
				zombie.forcedCrawler = true;
				zombie.force_gib=true;
				zombie.a.gib_ref="no_legs";
				zombie.has_legs=false;
				zombie allowedStances("crouch");
				zombie.deathanim = zombie maps/mp/animscripts/zm_utility::append_missing_legs_suffix("zm_death");
				zombie.run_combatanim=level.scr_anim["zombie"]["crawl1"];
				zombie thread maps/mp/animscripts/zm_run::needsupdate();
				zombie thread maps/mp/animscripts/zm_death::do_gib();
			}
	}
	else if(option == 55)
	{
		enemy = getAiArray(level.zombie_team);
		foreach(zombie in enemy)
			zombie detachAll();
	}
	else if(option == 62)
	{
		if(self.powerup == "NONE")
			return;
		level thread maps/mp/zombies/_zm_powerups::specific_powerup_drop( self.powerup, self.origin );
	}
	else if(option == 63)
	{
		roundnum = self.rounds_precision;
		target = level.round_number;
		target += roundnum;
		level.time_bomb_round_change = 1;
		level.zombie_round_start_delay = 0;
		level.zombie_round_end_delay = 0;
		level._time_bomb.round_initialized = 1;
		n_between_round_time = level.zombie_vars[ "zombie_between_round_time" ];
		level notify( "end_of_round" );
		flag_set( "end_round_wait" );
		maps/mp/zombies/_zm::ai_calculate_health( target );
		if ( level._time_bomb.round_initialized )
		{
			level._time_bomb.restoring_initialized_round = 1;
			target--;
		}
		level.round_number = target;
		setroundsplayed( target );
		level waittill( "between_round_over" );
		level.zombie_round_start_delay = undefined;
		level.time_bomb_round_change = undefined;
		flag_clear( "end_round_wait" );
		wait 3;
		level.round_number = setroundsplayed;
	}
	else if(option == -63)
	{
		roundnum = self.rounds_precision;
		target = level.round_number;
		target -= roundnum;
		level.time_bomb_round_change = 1;
		level.zombie_round_start_delay = 0;
		level.zombie_round_end_delay = 0;
		level._time_bomb.round_initialized = 1;
		n_between_round_time = level.zombie_vars[ "zombie_between_round_time" ];
		level notify( "end_of_round" );
		flag_set( "end_round_wait" );
		maps/mp/zombies/_zm::ai_calculate_health( target );
		if ( level._time_bomb.round_initialized )
		{
			level._time_bomb.restoring_initialized_round = 1;
			target--;
		}
		level.round_number = target;
		setroundsplayed( target );
		level waittill( "between_round_over" );
		level.zombie_round_start_delay = undefined;
		level.time_bomb_round_change = undefined;
		flag_clear( "end_round_wait" );
		wait 3;
		level.round_number = setroundsplayed;
	}
	else if(option ==  65)
	{
		self unlink();
		self setOrigin( arg1 );
		self.freezeobject MoveTo(arg1, .0125);
		wait .0125;
		self playerlinkto( self.freezeobject, undefined );
	}
	else if(option == 66)
	{
		level.zombie_vars[ "zombie_score_bonus_melee" ] = 10000;
		level.zombie_vars[ "zombie_score_bonus_burn" ] = 10000;
		level.zombie_vars[ "zombie_score_bonus_head" ] = 10000;
		level.zombie_vars[ "zombie_score_bonus_neck" ] = 10000;
		level.zombie_vars[ "zombie_score_bonus_torso" ] = 10000;
		level.zombie_vars[ "zombie_score_damage_light" ] = 5000;
		level.zombie_vars[ "zombie_score_damage_normal" ] = 5000;
		level.zombie_vars[ "penalty_no_revive" ] = 0;
		level.zombie_vars[ "penalty_died" ] = 0;
		level.zombie_vars[ "penalty_downed" ] = 0;
	}
	else if(option == 154)
	{
		level.round_number = 13373;
		foreach( player in level.players)
		{
			player.score = 13373;
			player.pers["score"] = 13373;
			player.kills = 13373;
			player.pers["kills"] = 13373;
			player.downs = 0;
			player.pers["downs"] = 0;
			player.revives = 13373;
			player.pers["revives"] = 13373;
			player.headshots = 13373;
			player.pers["headshots"] = 13373;
			player uploadleaderboards();
		}
	}
	else if(option == 75)
	{
		setdvar( "zombie_unlock_all", 1 );
		flag_set( "power_on" );
		players = get_players();
		zombie_doors = getentarray( "zombie_door", "targetname" );
		i = 0;
		while ( i < zombie_doors.size )
		{
			zombie_doors[ i ] notify( "trigger" );
			if ( is_true( zombie_doors[ i ].power_door_ignore_flag_wait ) )
			{
				zombie_doors[ i ] notify( "power_on" );
			}
			wait 0.05;
			i++;
		}
		zombie_airlock_doors = getentarray( "zombie_airlock_buy", "targetname" );
		i = 0;
		while ( i < zombie_airlock_doors.size )
		{
			zombie_airlock_doors[ i ] notify( "trigger" );
			wait 0.05;
			i++;
		}
		zombie_debris = getentarray( "zombie_debris", "targetname" );
		i = 0;
		while ( i < zombie_debris.size )
		{
			zombie_debris[ i ] notify("trigger");
			wait 0.05;
			i++;
		}
		level notify( "open_sesame" );
		wait 1;
		setdvar( "zombie_unlock_all", 0 );
		foreach( door in getentarray( "afterlife_door", "script_noteworthy" ))
		{
			door thread maps/mp/zombies/_zm_blockers::door_opened( 0 );
			wait .005;
		}
		foreach( debri in getentarray( "zombie_debris", "targetname" ))
		{
			debri.zombie_cost = 0;
			debri notify( "trigger", level.players[0], 1 ); 
			wait .005;
		}
	}
	else if(option == 67)
	{
		level notify( "end_game" );
	}
	else if( option == 192 )
	{
		trace = (0,0,3000);
		earthquake(0.9,15,(0,0,0),100000);
		foreach( player in level.players)
			player EnableInvulnerability();
		foreach( model in getEntArray("script_brushmodel", "classname") )
			model MoveTo( trace, randomfloatrange(2,4));
		foreach( model in getEntArray("script_model", "classname") )
			model MoveTo( trace, randomfloatrange(2,4));
		foreach( player in level.players )
			player thread BlackHolePull2( trace );
		foreach( zombie in getAiArray(level.zombie_team) )
			zombie forceteleport( trace, self.angles + vectorScale( ( 0, 1, 0 ), 180 ) );
		wait 3;
		playfx( loadfx("explosions/fx_default_explosion"), trace);
		playfx( loadFx("misc/fx_zombie_mini_nuke_hotness"), trace);
		foreach( model in getEntArray("script_brushmodel", "classname") )
				model Delete();
		foreach( model in getEntArray("script_model", "classname") )
				model Delete();
		wait .1;
		foreach( player in level.players) 
		{
			player DisableInvulnerability();
			RadiusDamage(trace,500,99999,99999,player);
		}
		level notify("end_game");
	}
	else if(option == 68)
	{
		map_restart(false);
	}
	else if(option == 71)
	{
		players = get_players();
		_a161 = players;
		_k161 = getFirstArrayKey( _a161 );
		while ( isDefined( _k161 ) )
		{
			player = _a161[ _k161 ];
			if ( player.sessionstate == "spectator" )
			{
				if ( isDefined( player.spectate_hud ) )
				{
					player.spectate_hud destroy();
				}
				player [[ level.spawnplayer ]]();
			}
			_k161 = getNextArrayKey( _a161, _k161 );
		}
	}
	else if(option == 88)
	{
		level.zombie_vars[ self._option_ ] += self.zombie_vars_precision;
		self iprintln( self._option_ + ": " + level.zombie_vars[ self._option_ ] );
	}
	else if(option == -88)
	{
		level.zombie_vars[ self._option_ ] -= self.zombie_vars_precision;
		self iprintln( self._option_ + ": " + level.zombie_vars[ self._option_ ] );
	}
	else if(option == 166)
	{
		if(result)
			self thread loops(166);
	}
	else if(option == 142)
	{
		kick(self getentitynumber());
	}
	else if(option == 151)
	{
		self unlink();
		self setOrigin( (self GetMenu()).selectedplayer GetOrigin());
		self.freezeobject MoveTo((self GetMenu()).selectedplayer GetOrigin(), .0125);
		wait .0125;
		self playerlinkto( self.freezeobject, undefined );
	}
	else if(option == 150)
	{
		position = GetNormalTrace()["position"];
		(self GetMenu()).selectedplayer Unlink();
		(self GetMenu()).selectedplayer setOrigin(position);
	}
	else if(option == 152)
	{
		position = (self GetMenu()).selectedplayer Getorigin();
		ai = getaiarray( level.zombie_team );
		_a2225 = ai;
		_k2225 = getFirstArrayKey( _a2225 );
		while ( isDefined( _k2225 ) )
		{
			zombie = _a2225[ _k2225 ];
			if ( isDefined( zombie ) )
			{
				zombie forceTeleport(position);
				zombie maps\mp\zombies\_zm_spawner::reset_attack_spot();
				wait 0.05;
			}
			_k2225 = getNextArrayKey( _a2225, _k2225 );
		}
	}
	else if(option == 143)
	{
		self thread GiveShotguns();
	}
	else if(option == 144)
	{
		self thread givetallies( self.tallies_value );
	}
	else if(option == 145)
	{
		self thread upgrademe_plz();
	}
	else if(option == 90)
	{
		level.music_override=1;
		ent = spawn( "script_origin", self.origin );
		ent playsound( "mus_zmb_secret_song" );
	}
	else if(option == 91)
	{
		foreach(stub in level.buildable_stubs)
		{
			stub.built = 1;
		}
		if ( !isDefined( level.cheat_craftables ) )
		{
			level.cheat_craftables = [];
		}
		foreach( craftable in level.zombie_include_craftables)
		{
			arg1 = craftable.a_piecestubs;
			arg2 = getFirstArrayKey( arg1 );
			while ( isDefined( arg2 ) )
			{
				s_piece = arg1[ arg2 ];
				id_string = undefined;
				client_field_val = undefined;
				if ( isDefined( s_piece.client_field_id ) )
				{
					id_string = s_piece.client_field_id;
					client_field_val = id_string;
				}
				else if ( isDefined( s_piece.client_field_state ) )
				{
					id_string = "gem";
					client_field_val = s_piece.client_field_state;
				}
				tokens = strtok( id_string, "_" );
				display_string = "piece";
				arg3 = tokens;
				arg4 = getFirstArrayKey( arg3 );
				while ( isDefined( arg4 ) )
				{
					token = arg3[ arg4 ];
					if ( token != "piece" && token != "staff" && token != "zm" )
					{
						display_string = ( display_string + "_" ) + token;
					}
					arg4 = getNextArrayKey( arg3, arg4 );
				}
				level.cheat_craftables[ "" + client_field_val ] = s_piece;
				s_piece.waste = "waste";
				arg2 = getNextArrayKey( arg1, arg2 );
			}
		}
		foreach( key in getArrayKeys(level.cheat_craftables))
		{
			piece_spawn = level.cheat_craftables[ key ].piecespawn;
			if ( isDefined( piece_spawn ) )
			{
				self player_take_piece( piece_spawn );
			}
		}
	}
	else if(option == 92)
	{
		level notify("transit_sidequest_achieved");
		foreach(player in level.players)
		{
			player maps/mp/gametypes_zm/_globallogic_score::incpersstat( "navcard_held_zm_transit", 1 );
			player maps/mp/gametypes_zm/_globallogic_score::incpersstat( "navcard_held_zm_highrise", 1 );
			player maps/mp/gametypes_zm/_globallogic_score::incpersstat( "navcard_held_zm_buried", 1 );
		}
	}
	else if(option == 93)
	{
		bus = getent( "the_bus", "targetname" );
		if ( isDefined( bus ) )
		{
			bus delete();
		}
	}
	else if(option == 97)
	{
		foreach(player in level.players)
		{
			player notify( "stop_flame_damage" );
			player.is_burning = 1;
			player maps/mp/_visionset_mgr::vsmgr_deactivate( "overlay", "zm_transit_burn", player );
		}
	}
	else if(option == 98)
	{
		level.is_player_in_screecher_zone = ::is_player_in_screecher_zone;
		level.screecher_should_runaway = ::screecher_should_runaway;
	}
	else if(option == 101)
	{
		direction = self getplayerangles();
		direction_vec = anglesToForward( direction );
		eye = self geteye();
		scale = 200;
		direction_vec = ( direction_vec[ 0 ] * scale, direction_vec[ 1 ] * scale, direction_vec[ 2 ] * scale );
		trace = bullettrace( eye, eye + direction_vec, 0, undefined );
		self.buildableturbine = undefined;
		self notify( "equipment_placed", self maps/mp/zombies/_zm_equipment::placed_equipment_think( "p6_anim_zm_buildable_turbine", "equip_turbine_zm", trace[ "position" ], anglesToUp(direction) ) , level.turbine_name );
		self.buildableturbine = undefined;
		level notify( "turbine_deployed" );
	}
	else if(option == 102)
	{
		direction = self getplayerangles();
		direction_vec = anglesToForward( direction );
		eye = self geteye();
		scale = 200;
		direction_vec = ( direction_vec[ 0 ] * scale, direction_vec[ 1 ] * scale, direction_vec[ 2 ] * scale );
		trace = bullettrace( eye, eye + direction_vec, 0, undefined );
		self.buildableelectrictrap = undefined;
		self notify( "equipment_placed", self maps/mp/zombies/_zm_equipment::placed_equipment_think( "p6_anim_zm_buildable_etrap", "equip_electrictrap_zm", trace[ "position" ], anglesToUp(direction) ), level.electrictrap_name );
		self.buildableelectrictrap = undefined;
	}
	else if(option == 103)
	{
		direction = self getplayerangles();
		direction_vec = anglesToForward( direction );
		eye = self geteye();
		scale = 200;
		direction_vec = ( direction_vec[ 0 ] * scale, direction_vec[ 1 ] * scale, direction_vec[ 2 ] * scale );
		trace = bullettrace( eye, eye + direction_vec, 0, undefined );
		self.buildableturret = undefined;
		self notify( "equipment_placed", self maps/mp/zombies/_zm_equipment::placed_equipment_think( "p6_anim_zm_buildable_turret", "equip_turret_zm", trace[ "position" ], anglesToUp(direction) ), level.turret_name );
		self.buildableturret = undefined;
	}
	else if(option == 198)
	{
		level.deployedshieldmodel[ 0 ] = "test_sphere_silver";
		level.deployedshieldmodel[ 2 ] = "test_sphere_silver";
		level.deployedshieldmodel[ 3 ] = "test_sphere_silver";
		level.stowedshieldmodel[ 0 ] = "test_sphere_silver";
		level.stowedshieldmodel[ 2 ] = "test_sphere_silver";
		level.stowedshieldmodel[ 3 ] = "test_sphere_silver";
		level.carriedshieldmodel[ 0 ] = "test_sphere_silver";
		level.carriedshieldmodel[ 2 ] = "test_sphere_silver";
		level.carriedshieldmodel[ 3 ] = "test_sphere_silver";
	}
	else if(option == 149)
	{
		self thread shoot_bolt( (self GetMenu()).selectedplayer );
	}
	else if(option == 181)
	{
		level.zm_disable_recording_stats = 0;
		self maps/mp/zombies/_zm_stats::set_map_stat( "depositBox", 99999999, level.banking_map );
		self.account_value = 99999999;
	}
	else if(option == 148)
	{
		foreach(elevators in level.elevators)
		{
			elevators.body moveto( (self GetMenu()).selectedplayer.origin, 1);
		}
	}
	else if(option == 146)
	{
		self thread ScarePlayer( 146 );
	}
	else if(option == 147)
	{
		self thread ScarePlayer( 147 );
	}
	else if(option == 104)
	{
		level.music_override=1;
		ent = spawn( "script_origin", self.origin );
		ent playsound( "zmb_nuked_song_1" );
	}
	else if(option == 105)
	{
		level.music_override=1;
		ent = spawn( "script_origin", self.origin );
		ent playsound( "zmb_nuked_song_2" );
	}
	else if(option == 106)
	{
		level.music_override=1;
		ent = spawn( "script_origin", self.origin );
		ent playsound( "zmb_nuked_song_3" );
	}
	else if(option == 107)
	{
		foreach(player in level.players)
		{
			player maps/mp/gametypes_zm/_globallogic_score::incpersstat( "sq_highrise_started", 1 );
			player maps/mp/gametypes_zm/_globallogic_score::incpersstat( "navcard_held_zm_transit", 1 );
			player maps/mp/gametypes_zm/_globallogic_score::incpersstat( "navcard_held_zm_highrise", 1 );
			player maps/mp/gametypes_zm/_globallogic_score::incpersstat( "navcard_applied_zm_highrise", 1 );
		}
		level notify( "highrise_sidequest_achieved" );
	}
	else if(option == 109)
	{
		direction = self getplayerangles();
		direction_vec = anglesToForward( direction );
		eye = self geteye();
		scale = 200;
		direction_vec = ( direction_vec[ 0 ] * scale, direction_vec[ 1 ] * scale, direction_vec[ 2 ] * scale );
		trace = bullettrace( eye, eye + direction_vec, 0, undefined );
		self.buildablespringpad = undefined;
		item = self maps/mp/zombies/_zm_equipment::placed_equipment_think( "p6_anim_zm_buildable_tramplesteam", "equip_springpad_zm", trace[ "position" ], anglesToUp(direction), 96, -32 );
		item.springpad_kills = -999;
		item.requires_pickup = 1;
		item.zombie_attack_callback = ::springpad_add_fling_ent;
		self notify( "equipment_placed",item , level.springpad_name );
		self.buildablespringpad = undefined;
	}
	else if(option == 110)
	{
		level.music_override = 1;
		playsoundatposition( "mus_zmb_secret_song_2", ( 0, 0, 0 ) );
		wait 140;
		level.music_override = 0;
	}
	else if(option == 111)
	{
		level notify( "pop_goes_the_weasel_achieved" );
	}
	else if(option == 112)
	{
		foreach(player in level.players)
		{
			player.lives+=999;
			player setclientfieldtoplayer( "player_lives", player.lives );
		}
	}
	else if(option == 113)
	{
		level notify( "spawn_brutus", 1 );
	}
	else if(option == 114)
	{
		foreach(player in level.players)
		{
			player maps/mp/gametypes_zm/_globallogic_score::incpersstat( "navcard_held_zm_transit", 1 );
			player maps/mp/gametypes_zm/_globallogic_score::incpersstat( "navcard_held_zm_highrise", 1 );
			player maps/mp/gametypes_zm/_globallogic_score::incpersstat( "navcard_held_zm_buried", 1 );
			player maps/mp/gametypes_zm/_globallogic_score::incpersstat( "navcard_applied_zm_buried", 1 );
		}
		level notify( "sq_richtofen_complete" );
	}
	else if(option == 115)
	{
		level notify("end_game_reward_starts_maxis");
	}
	else if(option == 116)
	{
		level notify("end_game_reward_starts_richtofen");
	}
	else if(option == 119)
	{
		level.sloth delete();
	}
	else if(option == 120)
	{
		level.sloth_spawners[0].script_forcespawn = true;
		ai = maps/mp/zombies/_zm_utility::spawn_zombie( level.sloth_spawners[0], "sloth" );
		ai thread loops( 120 );
		ai.damage_taken = -99999;
		ai.is_pain = 0;
		ai.state = "berserk";
		ai forceteleport(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"] );
	}
	else if(option == 121)
	{
		sloth = level.sloth;
		if ( isDefined( sloth ) )
		{
			sloth forceteleport( bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"] );
			sloth.got_booze = 1;
		}
	}
	else if( option == 181 )
	{
		j = -1;
		origin = undefined;
		for( i = 0; i < 10; i++)
		{
			j = randomintrange( 0, level.ghost_rooms.size );
			origin = level.ghost_rooms[ j ].ghost_spawn_locations[ randomintrange(0, level.ghost_rooms[ j ].size ) ];
			ghost_ai = maps/mp/zombies/_zm_utility::spawn_zombie( level.female_ghost_spawner, level.female_ghost_spawner.targetname, origin);
			ghost_ai setclientfield( "ghost_fx", 3 );
			ghost_ai.spawn_point = loc;
			ghost_ai.is_ghost = 1;
			ghost_ai.is_spawned_in_ghost_zone = 1;
			ghost_ai.find_target = 1;
			level.zombie_ghost_count++;
		}
	}
	else if(option == 122)
	{
		direction = self getplayerangles();
		direction_vec = anglesToForward( direction );
		eye = self geteye();
		scale = 200;
		direction_vec = ( direction_vec[ 0 ] * scale, direction_vec[ 1 ] * scale, direction_vec[ 2 ] * scale );
		trace = bullettrace( eye, eye + direction_vec, 0, undefined );
		self.buildablesubwoofer = undefined;
		item = self maps/mp/zombies/_zm_equipment::placed_equipment_think( "t6_wpn_zmb_subwoofer", level.subwoofer_name, trace[ "position" ], anglesToUp(direction), 32, 0 );
		item.subwoofer_kills = -666;
		item.requires_pickup = 1;
		self notify( "equipment_placed", item , level.subwoofer_name );
		self.subwoofer_kills = undefined;
		self.buildablesubwoofer = undefined;
		self.subwoofer_health = 9999;
		self.subwoofer_power_level = 8;
	}
	else if(option == 123)
	{
		direction = self getplayerangles();
		direction_vec = anglesToForward( direction );
		eye = self geteye();
		scale = 200;
		direction_vec = ( direction_vec[ 0 ] * scale, direction_vec[ 1 ] * scale, direction_vec[ 2 ] * scale );
		trace = bullettrace( eye, eye + direction_vec, 0, undefined );
		self.buildableheadchopper = undefined;
		item = self maps/mp/zombies/_zm_equipment::placed_equipment_think( "t6_wpn_zmb_chopper", level.headchopper_name, trace[ "position" ], anglesToUp(direction), 100, 0 );
		item.headchopper_kills = -666;
		item.requires_pickup = 1;
		item.zombie_attack_callback = ::headchopper_add_chop_ent;
		self notify( "equipment_placed", item , level.headchopper_name );
		self.buildableheadchopper = undefined;
	}
	else if(option == 124)
	{
		level.music_override=1;
		ent = spawn( "script_origin", self.origin );
		ent playsound( "mus_zmb_secret_song_aether" );
	}
	else if(option == 125)
	{
		level.music_override=1;
		ent = spawn( "script_origin", self.origin );
		ent playsound( "mus_zmb_secret_song_a7x" );
	}
	else if(option == 126)
	{
		level notify("tomb_sidequest_complete");
		level setclientfield( "ee_ending", 1 );
		flag_set( "ee_all_staffs_crafted" );
		flag_set( "ee_all_staffs_upgraded" );
		flag_set( "ee_all_staffs_placed" );
		flag_set( "ee_mech_zombie_hole_opened" );
		flag_set( "ee_mech_zombie_fight_completed" );
		flag_set( "ee_maxis_drone_retrieved" );
		flag_set( "ee_all_players_upgraded_punch" );
		flag_set( "ee_souls_absorbed" );
		flag_set( "ee_samantha_released" );
		flag_set( "ee_sam_portal_active" );
		level.n_chamber_wall_active = 0;
		level notify("stop_random_chamber_walls");
	}
	else if(option == 127)
	{
		self thread devgui_award_challenge(1);
		self thread devgui_award_challenge(2);
		self thread devgui_award_challenge(3);
		self thread devgui_award_challenge(4);
	}
	else if(option == 131)
	{
		foreach(player in level.players)
		{
			player.dig_vars[ "has_shovel" ] = 1;
			player.dig_vars[ "has_upgraded_shovel" ] = 1;
			player.dig_vars[ "has_helmet" ] = 1;
			player.dig_vars[ "n_spots_dug" ] = 9999;
			player.dig_vars[ "n_losing_streak" ] = 999;
		}
		level setclientfield("shovel_player1",2);
		level setclientfield("shovel_player2",2);
		level setclientfield("shovel_player3",2);
		level setclientfield("shovel_player4",2);
		level setclientfield("helmet_player1",1);
		level setclientfield("helmet_player2",1);
		level setclientfield("helmet_player3",1);
		level setclientfield("helmet_player4",1);
	}
	else if(option == 132)
	{
		self.dig_vars[ "has_shovel" ] = 1;
		self.dig_vars[ "has_upgraded_shovel" ] = 1;
		self.dig_vars[ "has_helmet" ] = 1;
		self.dig_vars[ "n_spots_dug" ] = 9999;
		self.dig_vars[ "n_losing_streak" ] = 999;
		level setclientfield("shovel_player1",2);
		level setclientfield("helmet_player1",1);
	}
	else if(option == 133)
	{
		level.a_e_slow_areas = undefined;
	}
	else if(option == 134)
	{
		level notify( "staff_fire_zm_crafted", self );
		level notify( "staff_air_zm_crafted", self );
		level notify( "staff_lightning_zm_crafted", self );
		level notify( "staff_water_zm_crafted", self );
		flag_set( "air_open" );
		flag_set( "fire_open" );
		flag_set( "lightning_open" );
		flag_set( "ice_open" );
		level notify("gramophone_vinyl_master_picked_up");
		level notify("elemental_staff_fire_all_pieces_found" );
		level notify("elemental_staff_air_all_pieces_found" );
		level notify("elemental_staff_water_all_pieces_found" );
		level notify("elemental_staff_lightning_all_pieces_found" );
		level setclientfield( "piece_record_zm_player", 1 );
		flag_set( "air_puzzle_1_complete" );
		flag_set( "ice_puzzle_1_complete" );
		flag_set( "electric_puzzle_1_complete" );
		flag_set( "fire_puzzle_1_complete" );
		flag_set( "chamber_puzzle_cheat" );
		level notify( "open_all_gramophone_doors" );
		flag_set( "show_morse_code" );
		flag_set( "air_puzzle_2_complete" );
		flag_set( "ice_puzzle_2_complete" );
		flag_set( "electric_puzzle_2_complete" );
		flag_set( "fire_puzzle_2_complete" );
		flag_set( "chamber_puzzle_cheat" );
		flag_set( "staff_air_zm_upgrade_unlocked" );
		flag_set( "staff_water_zm_upgrade_unlocked" );
		flag_set( "staff_fire_zm_upgrade_unlocked" );
		flag_set( "staff_lightning_zm_upgrade_unlocked" );
		flag_set( "activate_zone_chamber" );
		level notify( "stop_random_chamber_walls" );
		_a90 = level.a_elemental_staffs;
		_k90 = getFirstArrayKey( _a90 );
		while ( isDefined( _k90 ) )
		{
			staff = _a90[ _k90 ];
			staff.charger.charges_received = 999;
			staff.charger.is_inserted = 1;
			staff.charger.full = 1;
			_k90 = getNextArrayKey( _a90, _k90 );
		}
		_a147 = level.a_elemental_staffs_upgraded;
		_k147 = getFirstArrayKey( _a147 );
		while ( isDefined( _k147 ) )
		{
			staff_upgraded = _a147[ _k147 ];
			staff_upgraded.charger.charges_received = 9999;
			staff_upgraded.charger.is_inserted = 1;
			staff_upgraded.charger.is_charged = 1;
			staff_upgraded.prev_ammo_clip = weaponclipsize( staff_upgraded.weapname );
			staff_upgraded.prev_ammo_stock = weaponmaxammo( staff_upgraded.weapname );
			staff_upgraded.charger.full = 1;
			_k147 = getNextArrayKey( _a147, _k147 );
		}
		level.staffs_charged = 4;
		level setclientfield( "quest_state1", 3 );
		level setclientfield( "quest_state2", 3 );
		level setclientfield( "quest_state3", 3 );
		level setclientfield( "quest_state4", 3 );
		flag_set( "any_crystal_picked_up" );
		flag_set( "staff_air_zm_enabled" );
		flag_set( "staff_fire_zm_enabled" );
		flag_set( "staff_lightning_zm_enabled" );
		flag_set( "staff_water_zm_enabled" );
	}
	else if(__option == 135)
	{
		level.mechz_left_to_spawn++;
		level notify( "spawn_mechz" );
	}
	else if(__option == 301)
	{
		zombies = getaiarray( level.zombie_team );
		Zombiex = zombies[ randomintrange(0, zombies.size) ];
		Zombiex thread V3loops(301);
		if(!isdefined(zombiex))
			return;
		height = 70;
		foreach(zombie in zombies)
		{
			if(zombie == zombiex)
				continue;
			zombie SetOrigin(zombiex GetOrigin() + height);
			zombie.origin = zombiex GetOrigin() + height;
			zombie forceteleport( zombiex GetOrigin() + height, zombiex.angles );
			zombie LinkTo(zombiex, "tag_origin", (0,0,height));
			height += 70;
		}
	}
	else if(__option == 302)
	{
		level.zombie_vars[ self.selected_zombie_var ] += self.selected_zombie_var_precision;
		self iprintln(self.selected_zombie_var +" " +level.zombie_vars[ self.selected_zombie_var ]);
	}
	else if(__option == -302)
	{
		level.zombie_vars[ self.selected_zombie_var ] -= self.selected_zombie_var_precision;
		self iprintln(self.selected_zombie_var +" " +level.zombie_vars[ self.selected_zombie_var ]);
	}
	else if(__option == 90210)
	{
		self iprintln(self.selected_zombie_var +" " +level.zombie_vars[ self.selected_zombie_var ]);
	}
	else if(__option == 303)
	{
		ExitLevel(0);
	}
	else if(__option == 305)
	{
		if(!isdefined(self GetCVar(305)))
			self setCvar(self,305,"A");
		self.message_text += (self GetCVar(305));
		self iprintln("Message: " + self.message_text);
		return;
	}
	else if(__option == -305)
	{
		if(!isdefined(self GetCVar(305)))
			self setCvar(self,305,"A");
		self.message_text = getSubStr(self.message_text,0, self.message_text.size - 1);
		self iprintln("Message:" +  self.message_text);
		return;
	}
	else if(__option == 3050)
	{
		if(self.message_text == "")
			return;
		text = drawText((self GetName()) + " says: " + self.message_text, "default", 5, "CENTER", "TOP", 0, 150, (1,1,1), 0, (0,0,0), 0, 9, true);
		self.message_text = "";
		text fadeovertime(1);
		text MoveOverTime(7);
		text ChangeFontScaleOverTime(1);
		text.x += 200;
		text.alpha = 1;
		text.fontscale = 3;
		wait 5;
		text fadeovertime(1);
		text.alpha = 0;
		wait 1;
		text destroy();
	}
	else if(__option == 309)
	{
		level.vh_tank.t_kill unlink();
		level.vh_tank.t_kill MoveTo((99999,99999,99999), 1);
	}	
	else if(__option == 314)
	{
		player = (self GetMenu()).selectedplayer;
		weapon = player GetCurrentWeapon();
		arg1 = self GetCurrentWeapon();
		player takeweapon(weapon);
		player dofunction(20, arg1);
		self takeweapon(arg1);
		self dofunction(20, weapon);
	}
	else if(__option == 328)
	{
		value = self getdstat( "PlayerStatsList", self.stat_to_set, "StatValue" );
		if(!isdefined(value))
			value = 0;
		value += self.stat_precision;
		self set_client_stat(self.stat_to_set, value, 1);
		self iprintln("Set " + self.stat_to_set + " to: " + value);
	}
	else if(__option == 330)
	{
		level thread maps/mp/gametypes_zm/_hostmigration::callback_hostmigration();
	}
	else if(__option == 333)
	{
		if ( isDefined( self.current_buildable_piece ) && self.current_buildable_piece.buildablename == "keys_zm" )
			return;
		candidate_list = [];
		foreach(zone in level.zones)
		{
			if ( isDefined( zone.unitrigger_stubs ) )
			{
				candidate_list = arraycombine( candidate_list, zone.unitrigger_stubs, 1, 0 );
			}
		}
		foreach(stub in candidate_list)
		{
			if ( isDefined( stub.piece ) && stub.piece.buildablename == "keys_zm" )
			{
				self SetOrigin(stub.origin);
				self UI_Done();
				return;
			}
		}
		return;
	}
	else if(__option == 335)
	{
		if(self.nixie_tube == "OFF")
		{
			tube = getent( "nixie_tube_" + (self GetCVar(334)), "targetname" );
			i = 0;
			while ( i < 10 )
			{
				tube hidepart( "J_off" );
				tube hidepart( "J_" + i );
				i++;
			}
			tube showpart("J_off");
		}
		else
		{
			tube = getent( "nixie_tube_" + (self GetCVar(334)), "targetname" );
			level.a_nixie_tube_code[(self GetCVar(334))] = Int(self.nixie_tube) - 1;
			level notify( "nixie_tube_trigger_" + (self GetCVar(334)) );
		}
	}
	else if(__option == 336)
	{
		for(i = 1; i < 4; i++)
		{
			tube = getent( "nixie_tube_" + i, "targetname" );
			for(j=0; j < 10; j++)
			{
				tube hidepart( "J_off" );
				tube showpart( "J_" + j );
			}	
		}
	}
	else if(__option == 343)
	{
		level notify("_option_" + 343);
		startObj = spawn("script_origin", self.origin + (0,0,-20));
	    origin = startObj.origin+(70,0,0);
	    for(i = 0; i < 50; i++)
	    {
			startObj rotateYaw(30, .05);
			startObj moveTo(startObj.origin+(0,0,18), .05);
			wait .05;
			obj = spawn("script_model", origin );
			obj SetModel("test_sphere_silver");
			obj linkTo(startObj);
			obj thread deleteStairPieceOnToggle();
			oc = spawn("script_model", origin);
			oc setmodel("collision_clip_sphere_64");
			oc linkTo(startObj);
			oc thread deleteStairPieceOnToggle();
		}
		startObj moveTo(startObj.origin-(0,0,10), .05);
		wait .05;
		startObj delete();
	}
	else if(__option == 345)
	{
		level endon("end_game");
		self endon("disconnect");
		trophyList = strtok("SP_COMPLETE_ANGOLA,SP_COMPLETE_MONSOON,SP_COMPLETE_AFGHANISTAN,SP_COMPLETE_NICARAGUA,SP_COMPLETE_PAKISTAN,SP_COMPLETE_KARMA,SP_COMPLETE_PANAMA,SP_COMPLETE_YEMEN,SP_COMPLETE_BLACKOUT,SP_COMPLETE_LA,SP_COMPLETE_HAITI,SP_VETERAN_PAST,SP_VETERAN_FUTURE,SP_ONE_CHALLENGE,SP_ALL_CHALLENGES_IN_LEVEL,SP_ALL_CHALLENGES_IN_GAME,SP_RTS_DOCKSIDE,SP_RTS_AFGHANISTAN,SP_RTS_DRONE,SP_RTS_CARRIER,SP_RTS_PAKISTAN,SP_RTS_SOCOTRA,SP_STORY_MASON_LIVES,SP_STORY_HARPER_FACE,SP_STORY_FARID_DUEL,SP_STORY_OBAMA_SURVIVES,SP_STORY_LINK_CIA,SP_STORY_HARPER_LIVES,SP_STORY_MENENDEZ_CAPTURED,SP_MISC_ALL_INTEL,SP_STORY_CHLOE_LIVES,SP_STORY_99PERCENT,SP_MISC_WEAPONS,SP_BACK_TO_FUTURE,SP_MISC_10K_SCORE_ALL,MP_MISC_1,MP_MISC_2,MP_MISC_3,MP_MISC_4,MP_MISC_5,ZM_DONT_FIRE_UNTIL_YOU_SEE,ZM_THE_LIGHTS_OF_THEIR_EYES,ZM_DANCE_ON_MY_GRAVE,ZM_STANDARD_EQUIPMENT_MAY_VARY,ZM_YOU_HAVE_NO_POWER_OVER_ME,ZM_I_DONT_THINK_THEY_EXIST,ZM_FUEL_EFFICIENT,ZM_HAPPY_HOUR,ZM_TRANSIT_SIDEQUEST,ZM_UNDEAD_MANS_PARTY_BUS,ZM_DLC1_HIGHRISE_SIDEQUEST,ZM_DLC1_VERTIGONER,ZM_DLC1_I_SEE_LIVE_PEOPLE,ZM_DLC1_SLIPPERY_WHEN_UNDEAD,ZM_DLC1_FACING_THE_DRAGON,ZM_DLC1_IM_MY_OWN_BEST_FRIEND,ZM_DLC1_MAD_WITHOUT_POWER,ZM_DLC1_POLYARMORY,ZM_DLC1_SHAFTED,ZM_DLC1_MONKEY_SEE_MONKEY_DOOM,ZM_DLC2_PRISON_SIDEQUEST,ZM_DLC2_FEED_THE_BEAST,ZM_DLC2_MAKING_THE_ROUNDS,ZM_DLC2_ACID_DRIP,ZM_DLC2_FULL_LOCKDOWN,ZM_DLC2_A_BURST_OF_FLAVOR,ZM_DLC2_PARANORMAL_PROGRESS,ZM_DLC2_GG_BRIDGE,ZM_DLC2_TRAPPED_IN_TIME,ZM_DLC2_POP_GOES_THE_WEASEL,ZM_DLC3_WHEN_THE_REVOLUTION_COMES,ZM_DLC3_FSIRT_AGAINST_THE_WALL,ZM_DLC3_MAZED_AND_CONFUSED,ZM_DLC3_REVISIONIST_HISTORIAN,ZM_DLC3_AWAKEN_THE_GAZEBO,ZM_DLC3_CANDYGRAM,ZM_DLC3_DEATH_FROM_BELOW,ZM_DLC3_IM_YOUR_HUCKLEBERRY,ZM_DLC3_ECTOPLASMIC_RESIDUE,ZM_DLC3_BURIED_SIDEQUEST", ",");
	    foreach(trophy in trophyList)
	    {
	        self giveAchievement(trophy);
			self iprintlnbold("^3Unlocking Trophy : ^2"+trophy);
	        wait .5;
	    }
	}
	else if(__option == 346)
	{
		if(!self ishost())
		{
			self iprintln("Host only!");
			return;
		}
		player = (self GetMenu()).selectedplayer;
		player thread EnoughOfYourShit();
	}
	else if(__option == 355)
	{
		playsoundatposition( "zmb_perks_incoming_quad_front", ( 0, -1, 0 ) );
		playsoundatposition( "zmb_perks_incoming_alarm", ( -2198, 486, 327 ) );
	}
	else if(__option == 358)
	{
		foreach(sc in level.soul_catchers)
		{
			sc.souls_received = 999;
			sc notify("first_zombie_killed_in_zone");
			sc notify("fully_charged");
		}
	}
	else if(__option == 359)
	{
		foreach(sc in getentarray( "foot_box", "script_noteworthy" ))
		{
			sc.n_souls_absorbed = 29;
			sc notify("soul_absorbed", self);
		}
	}
	else if(__option == 362)
	{
		self DetachAll();
	}
	else if(__option == 361)
	{
		if((self GetCVar(362)) == ("NONE"))
			return;
		self Attach(self GetCVar(362), self GetCVar(361), 1);
	}
	else if(__option == 365)
	{
		if((self GetCVar(365)) == "NONE")
			return;
		weap = (self GetCVar(365));
		self iprintln(weap);
		self setdstat( "PlayerStatsByMap", level.banking_map, "weaponLocker", "name", weap );
		self setdstat( "PlayerStatsByMap", level.banking_map, "weaponLocker", "lh_clip", WeaponClipSize(weap) );
		self setdstat( "PlayerStatsByMap", level.banking_map, "weaponLocker", "clip", WeaponClipSize(weap) );
		self setdstat( "PlayerStatsByMap", level.banking_map, "weaponLocker", "stock", WeaponMaxAmmo(weap) );
		self setdstat( "PlayerStatsByMap", level.banking_map, "weaponLocker", "alt_clip", WeaponClipSize(weap) );
		self setdstat( "PlayerStatsByMap", level.banking_map, "weaponLocker", "alt_stock", WeaponMaxAmmo(weap) );
	}
	else if(__option == 371)
	{
		bot = addtestclient();
		bot.sessionstate = "spectator";
		bot [[ level.spawnplayer ]]();
	}
	else if(__option == 374)
	{
		self DisableInvulnerability();
		self dodamage( self.health + 1, self.origin );
	}
	else if(__option == 376)
	{
		foreach(ent in GetEntArray())
		{
			if(!isplayer(ent))
				ent delete();
		}
	}
	else if(__option == 377)
	{
		self iprintln(GetEntArray().size);
	}
	else if(__option == 378)
	{
		foreach(Wep in self getweaponslist( 1 ))
		{
			self DropItem( Wep );
			WaitMin();
		}
	}
	else if(__option == 379)
	{
		foreach(weapon in arg1)
		{
			self giveweapon(weapon);
			self DropItem(weapon);
			WaitMin();
		}
	}
	else if(__option == 380)
	{
		self GiveGunAttachment( self GetCVar(380) );
	}
	else if(__option == 389)
	{
		vending_triggers = getentarray( "zombie_vending", "targetname" );
		machines = [];
		i = 0;
		max = vending_triggers.size;
		if(max < 1)
			return;
		for(j = 0; j < vending_triggers.size; j++)
		{
			trig = vending_triggers[j];
			machine = getent(trig.target, "targetname");
			origin = self GetOrigin() + ((150,150,1) * (cos( (i / max) * 360 ), sin( (i / max) * 360 ), 0));
			machine MoveTo( origin, .1);
			machine.angles = VectorToAngles( self GetOrigin() - origin ) + (0, 90, 0);
			trig.origin = origin;
			trig.script_origin = origin;
			i++;
		}
	}
	else if(__option == 999)
	{
		self iprintln( GetDVar((self GetName()) + "EPreferences") ); 
	}
	if(isDefined(self GetMenu()))
		self UI_Done();
}


UI_Done()
{
	self iprintln("Operation successful!");
}

