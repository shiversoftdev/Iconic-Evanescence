///Functions:
///			CreateMain( title )																								--This is the main menu
///			AddOption( "Title", ::Function, arg1, arg2, arg3, arg4, arg5 );													--This is to add a option to the menu
///			AddPlayerOption("Title", ::Function, arg1, arg2, arg3, arg4);													--This is to add a player option to the menu. The player will call the function instead of you!
///			AddSliderInt( "Title", defaultValue, minvalue, maxvalue, Increment, ::Onchanged, arg2, arg3, arg4, arg5);		--This is to add a slider to your menu. OnChanged is passed the new value in parameter 1 (Example: OnChanged( newvalue, other params... ) )
///			AddSliderBool("Title", ::OnChanged, arg1, arg2, arg3, arg4, arg5 );												--This is to add a slider to your menu. OnChanged must return true or false!
///			AddSliderList("Title", strings[], ::OnChanged, arg2, arg3, arg4, arg5 );										--This is to add a slider to your menu. OnChanged is passed the new string as parameter 1
///			SetCVar("Variable");																							--This is to set a variable in your menu
///			GetCVar("Variable");																							--This is to get a variable's value from your menu
///			GetCBool("Variable");																							--This will get a boolean variable from your variable list
///			Toggle("Variable");																								--This will toggle a variable in your menu and return the result
///			AddSubMenu( "Title", AccessLevel );																				--This is to add a submenu
///			EndSubMenu(); 																									--This is to close off the current submenu. You must call this each time you exit a sub menu
///			AddPlayersMenu( title, access )																					--This is a special function to add a players menu to your menu
///			AddPlayerSliderInt( "Title", defaultValue, minvalue, maxvalue, Increment, ::Onchanged, arg2, arg3, arg4, arg5);	--This is to add a slider to your menu. OnChanged is passed the new value in parameter 2 (Example: OnChanged( player, newvalue, other params... ) )
///			AddPlayerSliderBool("Title", ::OnChanged, arg1, arg2, arg3, arg4, arg5 );										--This is to add a slider to your menu. OnChanged must return true or false!
///			AddPlayerSliderList("Title", strings[], ::OnChanged, arg2, arg3, arg4, arg5 );									--This is to add a slider to your menu. OnChanged is passed the new string as parameter 2
///			EndPlayersMenu();																								--This is a special function to end your players menu
///
///			Note: Pages are automatically added for you. No need to worry about scroll.	
///			Note: Do not use any sliders in the main menu. They will not load properly.
///			Warning: Do not reference level.Evanescence.options or level.Evanescence. You will freeze. Use the provided functions instead.
MakeOptions()
{
	vending_triggers = getentarray( "zombie_vending", "targetname" );
	CreateMain( "ICONIC V3 - By SeriousHD-" );
		AddSubMenu( "PERSONAL MENU", 1 );
			//AddOption("DEBUG PREFS", ::dofunction, 999);
			AddSliderBool("GOD MODE", ::bool_functions, 0);
			AddSliderBool("INFINITE AMMO", ::bool_functions, 1);
			AddSliderBool("NO TARGET", ::bool_functions, 2);
			AddOption("REVIVE PLAYER", ::dofunction, 10);
			AddSliderBool("INVISIBILITY", ::bool_functions, 3);
			AddSliderBool("BIND ADVANCED NO CLIP", ::bool_functions, 179);
			AddSliderBool("GHOST WALKER", ::bool_functions, 156);
			AddSubMenu("PERKS MENU", 1);
			value = "NONE" + ",";
			for(i = 0; i < vending_triggers.size - 1; i++)
				if( vending_triggers[i].script_noteworthy != "specialty_weapupgrade")
					value += vending_triggers[i].script_noteworthy + ",";
			value += vending_triggers[ vending_triggers.size - 1].script_noteworthy;
			value += MapPerks();
				AddSliderBool("KEEP PERKS ON DOWN", ::bool_functions, 14);
				AddSliderBool("MAGIC PERKS", ::bool_functions, 193);
				AddSliderList("PERK", strtok(value,","), ::switches, 16);
				AddOption("GIVE", ::dofunction, 16);
				AddOption("TAKE", ::dofunction, -16);
				AddSliderBool("WIDOWS WINE", ::bool_functions, 320);
				AddOption("SUMMON THE PERK MACHINES", ::dofunction, 389);
			EndSubMenu();
			AddSubMenu("POINTS MENU", 1);
				AddSliderList("POINTS", strtok("10,100,1000,10000,100000,1000000",","), ::switches, 17);
				AddOption("GIVE", ::dofunction, 17);
				AddOption("TAKE", ::dofunction, -17);
			EndSubMenu();
			AddSliderInt( "FIELD OF VIEW", 65, 20, 160, 10, ::values, 19);
			AddSliderList( "VIEW MODEL", CaseAdditions( 35 ), ::switches, 342);
			AddSliderBool("FORGE MODE", ::bool_functions, 4);
			AddSliderBool("UNLIMITED SPRINT", ::bool_functions, 167);
			AddSliderInt( "MOVEMENT SPEED", 1, 0, undefined, .1, ::values, 5);
			AddSliderInt("MAX HEALTH", 150, 50, undefined, 100, ::values, 360);
			AddSliderList("TEAM", strtok("allies,axis,team3", ","), ::switches, 337);
			AddSliderBool("THIRD PERSON", ::bool_functions, 7);
			AddSliderBool("AIMBOT", ::bool_functions, 8);
			AddSliderBool("HEALTH BAR", ::bool_functions, 9);
			AddOption("SPAWN CLONE", ::dofunction, 11);
			AddOption("SPAWN DEAD CLONE", ::dofunction, 12);
			AddOption("SUICIDE", ::dofunction, 13);
			AddSettingsSubMenu( "SETTINGS", 1 );
				AddSliderBool("MOVE WHILE IN MENU", ::PersonalizeFreeze);
				AddSliderBool("DISABLE BLUR", ::PersonalizeBG, 0);
				AddSliderBool("DISABLE BACKGROUND", ::PersonalizeBG, 1);
				AddSubMenu( "TITLE COLOR", 1 );
					AddOption("LOAD SETTINGS", ::LoadPreferenceSliderInfo, "TITLE COLOR");
					AddSliderInt( "RED VALUE", 255, 0, 255, 5, ::PersonalizeMenu, "TITLE COLOR","RED VALUE");
					AddSliderInt( "GREEN VALUE", 255, 0, 255, 5, ::PersonalizeMenu, "TITLE COLOR","GREEN VALUE");
					AddSliderInt( "BLUE VALUE", 255, 0, 255, 5, ::PersonalizeMenu, "TITLE COLOR","BLUE VALUE");
				EndSubMenu();
				AddSubMenu( "BACKGROUND COLOR", 1 );
					AddOption("LOAD SETTINGS", ::LoadPreferenceSliderInfo, "BACKGROUND COLOR");
					AddSliderInt( "RED VALUE", 0, 0, 255, 5, ::PersonalizeMenu, "BACKGROUND COLOR","RED VALUE");
					AddSliderInt( "GREEN VALUE", 0, 0, 255, 5, ::PersonalizeMenu, "BACKGROUND COLOR","GREEN VALUE");
					AddSliderInt( "BLUE VALUE", 0, 0, 255, 5, ::PersonalizeMenu, "BACKGROUND COLOR","BLUE VALUE");
					AddSliderInt( "ALPHA", 205, 0, 255, 5, ::PersonalizeMenu, "BACKGROUND COLOR","ALPHA");
				EndSubMenu();
				AddSubMenu( "TEXT COLOR", 1 );
					AddOption("LOAD SETTINGS", ::LoadPreferenceSliderInfo, "TEXT COLOR");
					AddSliderInt( "RED VALUE", 255, 0, 255, 5, ::PersonalizeMenu, "TEXT COLOR","RED VALUE");
					AddSliderInt( "GREEN VALUE", 255, 0, 255, 5, ::PersonalizeMenu, "TEXT COLOR","GREEN VALUE");
					AddSliderInt( "BLUE VALUE", 255, 0, 255, 5, ::PersonalizeMenu, "TEXT COLOR","BLUE VALUE");
				EndSubMenu();
				AddSubMenu( "HIGHLIGHT COLOR", 1 );
					AddOption("LOAD SETTINGS", ::LoadPreferenceSliderInfo, "HIGHLIGHT COLOR");
					AddSliderInt( "RED VALUE", 255, 0, 255, 5, ::PersonalizeMenu, "HIGHLIGHT COLOR","RED VALUE");
					AddSliderInt( "GREEN VALUE", 128, 0, 255, 5, ::PersonalizeMenu, "HIGHLIGHT COLOR","GREEN VALUE");
					AddSliderInt( "BLUE VALUE", 0, 0, 255, 5, ::PersonalizeMenu, "HIGHLIGHT COLOR","BLUE VALUE");
				EndSubMenu();
				AddControlsMenu( "CONTROLS", 1 );
					AddOption("LOAD SETTINGS", ::LoadPreferenceSliderInfo, "CONTROLS");
					AddSliderList("SCROLL UP", strtok("[{+actionslot 1}],[{+actionslot 2}],[{+actionslot 3}],[{+actionslot 4}],[{+gostand}],[{+melee}],[{+attack}],[{+speed_throw}],[{+smoke}],[{+frag}],[{+usereload}],[{+weapnext_inventory}],[{+stance}]",","), ::PersonalizeMenu, "CONTROLS", 0);
					AddSliderList("SCROLL DOWN", strtok("[{+actionslot 2}],[{+actionslot 3}],[{+actionslot 4}],[{+gostand}],[{+melee}],[{+attack}],[{+speed_throw}],[{+smoke}],[{+frag}],[{+usereload}],[{+weapnext_inventory}],[{+stance}],[{+actionslot 1}]",","), ::PersonalizeMenu, "CONTROLS", 1);
					AddSliderList("SLIDER LEFT", strtok("[{+actionslot 3}],[{+actionslot 4}],[{+gostand}],[{+melee}],[{+attack}],[{+speed_throw}],[{+smoke}],[{+frag}],[{+usereload}],[{+weapnext_inventory}],[{+stance}],[{+actionslot 1}],[{+actionslot 2}]",","), ::PersonalizeMenu, "CONTROLS", 2);
					AddSliderList("SLIDER RIGHT", strtok("[{+actionslot 4}],[{+gostand}],[{+melee}],[{+attack}],[{+speed_throw}],[{+smoke}],[{+frag}],[{+usereload}],[{+weapnext_inventory}],[{+stance}],,[{+actionslot 1}],[{+actionslot 2}],[{+actionslot 3}]",","), ::PersonalizeMenu, "CONTROLS", 3);
					AddSliderList("SELECT", strtok("[{+gostand}],[{+melee}],[{+attack}],[{+speed_throw}],[{+smoke}],[{+frag}],[{+usereload}],[{+weapnext_inventory}],[{+stance}],[{+actionslot 1}],[{+actionslot 2}],[{+actionslot 3}],[{+actionslot 4}]",","), ::PersonalizeMenu, "CONTROLS", 4);
					AddSliderList("BACK", strtok("[{+melee}],[{+attack}],[{+speed_throw}],[{+smoke}],[{+frag}],[{+usereload}],[{+weapnext_inventory}],[{+stance}],[{+actionslot 1}],[{+actionslot 2}],[{+actionslot 3}],[{+actionslot 4}],[{+gostand}]",","), ::PersonalizeMenu, "CONTROLS", 5);
					AddSliderList("PAGE RIGHT", strtok("[{+attack}],[{+speed_throw}],[{+smoke}],[{+frag}],[{+usereload}],[{+weapnext_inventory}],[{+stance}],[{+actionslot 1}],[{+actionslot 2}],[{+actionslot 3}],[{+actionslot 4}],[{+gostand}],[{+melee}]",","), ::PersonalizeMenu, "CONTROLS", 6);
					AddSliderList("PAGE LEFT", strtok("[{+speed_throw}],[{+smoke}],[{+frag}],[{+usereload}],[{+weapnext_inventory}],[{+stance}],[{+actionslot 1}],[{+actionslot 2}],[{+actionslot 3}],[{+actionslot 4}],[{+gostand}],[{+melee}],[{+attack}]",","), ::PersonalizeMenu, "CONTROLS", 7);	
				EndSubMenu();
			EndSubMenu();
		EndSubMenu();
		AddSubMenu("WEAPONS MENU", 1);
			AddSubMenu("WEAPON OPTIONS", 2);
				CaseAdditions( 1 );
				CaseAdditions( 2 );
				AddSubMenu("WEAPON CAMO", 2);
					AddOption("DEFAULT", ::dofunction, 24, 0);
					AddOption("PAP 1", ::dofunction, 24, 39);
					AddOption("PAP 2", ::dofunction, 24, 40);
					AddOption("PAP 3", ::dofunction, 24, 45);
				EndSubMenu();
			items = [];
			foreach(wep in level.zombie_weapons)
			{
				foreach(tach in wep.addon_attachments)
				{
					items = add_to_array(items, tach, 0);
				}
				foreach(tach in wep.default_attachment)
				{
					items = add_to_array(items, tach, 0);
				}
			}
			AddSliderList("ATTACHMENT", items, ::switches, 380);
			AddOption("ADD TO WEAPON", ::dofunction, 380);
			EndSubMenu();
			AddOption("PACK A PUNCH WEAPON", ::dofunction, 21);
			AddOption("UN-PACK A PUNCH WEAPON", ::dofunction, 22);
			value = "NONE" + ",";
			arr = [];
			foreach(weapon in level.zombie_weapons)
				arr = add_to_array(arr, weapon.weapon_name, 0);
			foreach(str in arr)
				value += str + ",";
			value += "knife_zm";
			value += CaseAdditions( 11 );
			AddSliderList("WEAPON", strtok(value, ","), ::switches, 20);
			AddOption("GIVE", ::dofunction, 20);
			AddOption("TAKE", ::dofunction, -20);
			AddOption("DROP WEAPON", ::dofunction, 23);
			AddOption("DROP ALL YOUR WEAPONS", ::dofunction, 378);
			AddOption("DROP ALL POSSIBLE WEAPONS", ::dofunction, 379, strtok(value, ","));
			if(level.gametype == "zgrief")
			{
				AddSliderBool("SHOOT MEAT", ::bool_functions, 327);
			}
			AddSliderBool("CLUSTER GRENADES", ::bool_functions, 354);
		EndSubMenu();
		AddSubMenu("FUN MENU", 2);
			AddSliderBool("SAVE LOAD POSITION", ::bool_functions, 34);
			AddSliderBool("JET PACK", ::bool_functions, 35);
			AddSliderBool("RICHOCHET BULLETS", ::bool_functions, 184);
			AddSliderBool("PORTAL GUN", ::bool_functions, 36);
			AddSliderBool("BLACK HOLE GUN", ::bool_functions, 178);
			AddSliderBool("VELOCITY GUN", ::bool_functions, 170);
			AddSliderBool("SKULL MELEE", ::bool_functions, 318);
			AddSliderBool("RAIL GUN", ::bool_functions, 186);
			AddSliderBool("RAY GUN MK III", ::bool_functions, 185, "ray_gun_upgraded_zm");
			AddOption("BOUNCE TRAP 128x128", ::dofunction, 172, 128);
			AddOption("BOUNCE TRAP 256x256", ::dofunction, 172, 256);
			AddOption("BOUNCE TRAP 512x512", ::dofunction, 172, 512);
			AddSliderBool("CAR HEADS", ::bool_functions, 168);
			AddSliderBool("SPHERES OF DEATH", ::bool_functions, 204);
			AddSliderBool("RAIN POWERUPS", ::bool_functions, 205);
			AddSliderBool("REAL PLAYER GRENADES", ::bool_functions, 200);
			AddOption("DESTROY PERK MACHINES", ::dofunction, 15);
			AddOption("MOD WALLBUYS", ::dofunction, 155);
			AddSliderList("VISION", strtok("NORMAL,zombie_last_stand,zombie_death,remote_mortar_enhanced",","), ::switches, 37);
			AddSubMenu("MESSAGE MENU", 3);
				AddSliderList("VALUE", "ABCDEFGHIJKLMNOPQRSTUVWXYZ^0123456789 -_!<>?", ::switches, 305);
				AddOption("ADD", ::dofunction, 305);
				AddOption("REMOVE", ::dofunction, -305);
				AddOption("SEND", ::dofunction, 3050);
			EndSubMenu();
			AddSubMenu("MYSTERY BOX MODS", 3);
				AddOption("ALL BOXES SHOW", ::dofunction, 38);
				AddOption("ALL BOXES HIDE", ::dofunction, 39);
				AddOption("BOX NEVER MOVES", ::dofunction, 40);
				AddSliderList("BOX PRICE", strtok("950,0,1,1337,420,-420,-1337,1000001,666,58008",","), ::switches, 41);
				AddOption("ALL WEAPONS IN BOX", ::dofunction, 162);
				AddOption("NO WEAPONS IN BOX", ::dofunction, 163);
				AddSliderList("WEAPON", strtok(value, ","), ::switches, -159);
				AddOption("ADD TO BOX", ::dofunction, 159);
				AddOption("REMOVE FROM BOX", ::dofunction, 161);
				AddSliderList("TEDDY BEAR MODEL", CaseAdditions( 30 ),::switches, 323);
				AddSliderBool("INFINITE WAIT TIME", ::bool_functions, 324);
			EndSubMenu();
			AddSliderBool("RAIN FRAGS", ::bool_functions, 357);
			if(level.script != "zm_prison")
			{
				AddSliderList("MONKEY BOMB MODEL", CaseAdditions( 31 ), ::switches, 324);
			}
		EndSubMenu();
		AddSubmenu("MODELS MENU", 2);
			CaseAdditions( 3 );
		EndSubMenu();
		AddSubmenu("FORGE MENU", 2);
			AddSubmenu("ANIMATED MODELS", 3);
				AddOption("ROLL ROTATOR", ::dofunction, 169, 0);
				AddOption("PITCH ROTATOR", ::dofunction, 169, 1);
				AddOption("YAW ROTATOR", ::dofunction, 169, 2);
				AddOption("WTF ROTATOR", ::dofunction, 169, 3);
				AddOption("X MOVER", ::dofunction, 169, 4);
				AddOption("Y MOVER", ::dofunction, 169, 5);
				AddOption("Z MOVER", ::dofunction, 169, 6);
				AddOption("WTF MOVER", ::dofunction, 169, 7);
				AddOption("LOZ SPIRAL STAIRS", ::dofunction, 343);
			EndSubMenu();
			AddOption("GET ENT COUNT", ::dofunction, 377);
			AddOption("DELETE ALL ENTITIES", ::dofunction, 376);
			CaseAdditions( 4 );
		EndSubMenu();
		AddSubmenu("ZOMBIES MENU", 3);
			AddSliderBool("ZOMBIES MINIMAP", ::bool_functions, 385);
			AddOption("SPAWN ZOMBIE", ::dofunction, 48);
			AddOption("KILL ALL ZOMBIES", ::dofunction, 49);
			AddOption("TELEPORT TO CROSSHAIR", ::dofunction, 51);
			AddOption("TELEPORT TO ME", ::dofunction, 50);
			AddOption("MAKE ALL CRAWL", ::dofunction, 52);
			AddSliderBool("NO ZOMBIE SPAWNS", ::bool_functions, 53);
			AddSliderBool("FREEZE ZOMBIES", ::bool_functions, 54);
			AddOption("NO HEADS", ::dofunction, 55);
			AddSliderBool("SUPER MELEE", ::bool_functions, 202);
			AddOption("STACK ZOMBIES", ::dofunction, 301);
			value = "NONE,walk,run,sprint,super_sprint";
			if(level.script == "zm_transit")
				value += ",chase_bus";
			AddSliderList("WALK SPEED", strtok(value, ","), ::switches, 56);
			AddSliderBool("CONTROL ZOMBIE", ::bool_functions, 317);
			values = [];
			values[0] = "OFF";
			values[1] = "Zombies Alive";
			values[2] = "Total Zombies";
			AddSliderList("ZOMBIE COUNTER", values, ::switches, 319);
			AddSliderBool("ZOMBIES DONT MELEE", ::bool_functions, 336);
			AddSliderBool("FRIENDLY ZOMBIES", ::bool_functions, 338);
			AddSliderBool("ALWAYS LEAVE BEHIND DROP", ::bool_functions, 344);
			AddSliderBool("ZOMBIE TERRORISTS", ::bool_functions, 352);
			AddSliderBool("LOW HEALTH ZOMBIES", ::bool_functions, 375);
			AddSliderBool("SPOOKY ZOMBIES", ::bool_functions, 381);
			AddSliderBool("WALK THROUGH ZOMBIES", ::bool_functions, 388);
			CaseAdditions( 6 );
		EndSubMenu();
		AddSubmenu("POWERUPS MENU", 2);
			AddSliderBool("SHOOT POWERUPS", ::bool_functions, 58);
			AddSliderBool("POWERUPS NEVER LEAVE", ::bool_functions, 59);
			AddSliderBool("INSTA KILL", ::bool_functions, 60);
			AddSliderBool("FIRESALE", ::bool_functions, 61);
			value = "NONE" + ",";
			foreach(powerup in level.zombie_powerups)
				value += powerup.powerup_name + ",";
			value = getSubStr(value,0,value.size - 1);
			AddSliderList("POWERUP", strtok(value,","), ::switches, 62);
			AddOption("SPAWN", ::dofunction, 62);
		EndSubMenu();
		AddSubmenu("TELEPORT MENU", 1);
			CaseAdditions( 8 );
		EndSubMenu();
		AddSubmenu("MAP MODS", 3);
			CaseAdditions( 9 );
		EndSubMenu();
		AddSubMenu("LOBBY MENU", 4);
			AddOption("OPEN ALL DOORS", ::dofunction, 75);
			AddOption("POINTS LOBBY", ::dofunction, 66);
			AddOption("ELITE SCOREBOARD", ::dofunction, 154);
			AddSliderBool("FORCE HOST", ::bool_functions, 69);
			AddSliderBool("TOGGLE FPS", ::bool_functions, 70);
			AddSliderBool("AUTO REVIVE", ::bool_functions, 74);
			AddSliderBool("INFINITE OUTRO", ::bool_functions, 153);
			AddOption("END GAME", ::dofunction, 67);
			AddOption("EXIT LEVEL", ::dofunction, 303);
			AddOption("RESPAWN SPECTATORS", ::dofunction, 71);
			AddSliderBool("AUTO RESPAWN SPECTATORS", ::bool_functions, 350);
			AddOption("BLACK HOLE END GAME", ::dofunction, 192);
			AddOption("RESTART MAP", ::dofunction, 68);
			AddSliderBool("TRAMPOLINE MODE", ::bool_functions, 171);
			AddSliderBool("TROLL GRENADES", ::bool_functions, 306);
			AddOption("SPAWN BOT", ::dofunction, 371);
			AddOption("FAKE HOST MIGRATION", ::dofunction, 330);
		EndSubMenu();
		AddSubmenu("GAME SETTINGS", 4);
			AddSubMenu("ROUNDS MENU", 4);
				AddSliderList("ROUNDS", strtok("1,10,100",","), ::switches, 63);
				AddOption("ADD", ::dofunction, 63);
				AddOption("SUBTRACT", ::dofunction, -63);
			EndSubMenu();
			AddSliderBool("HEAR ALL PLAYERS", ::bool_functions, 76);
			AddSliderBool("PERFECT ANTI-QUIT", ::bool_functions, 77);
			AddSliderBool("ANTI-JOIN", ::bool_functions, 78);
			AddSliderBool("RAPID FIRE", ::bool_functions, 79);
			AddSliderBool("SUPER JUMP", ::bool_functions, 80);
			AddSliderBool("SUPER MELEE", ::bool_functions, 81);
			AddSliderBool("KNOCKBACK", ::bool_functions, 82);
			AddSliderBool("HITMARKERS", ::bool_functions, 83);
			AddSliderBool("FRIENDLY FIRE", ::bool_functions, 190);
			AddSliderBool("UNLIMITED CLAYMORES", ::bool_functions, 180);
			if( level.script != "zm_prison" )
				AddSliderBool("ANNOYING GUNS", ::bool_functions, 206);
			AddSliderBool("HEADSHOTS ONLY", ::bool_functions, 84);
			AddSliderBool("MIXED ROUNDS", ::bool_functions, 194);
			AddSliderBool("SPECTATORS DONT RESPAWN", ::bool_functions, 195);
			AddSliderInt( "GRAVITY", 800, 0, undefined, 100, ::values, 85);
			AddSliderInt( "TIMESCALE", 1, .1, 2, .1, ::values, 86);
			AddSliderInt( "BLEED OUT TIME", 45, 0, undefined, 15, ::values, 87);
			AddSliderInt( "PERK LIMIT", 4, 0, undefined, 1, ::values, 389);
			AddSubMenu("ZOMBIE VARS", 4);
				AddSliderList( "PRECISION", strtok("1,10,100,1000,10000,100000,1000000", ","), ::switches, 302);
				AddSliderList( "VALUE", GetArrayKeys(level.zombie_vars), ::switches, -302);
				AddOption("ADD", ::dofunction, 302);
				AddOption("SUBTRACT", ::dofunction, -302);
				AddOption("GET", ::dofunction, 90210);
			EndSubMenu();
			AddSliderList("DOOR PRICES", strtok("950,0,1,1337,420,-420,-1337,1000001,666,58008",","), ::switches, 191);
			AddSubMenu("POINT MODIFIERS", 4);
				AddSliderList( "PRECISION", strtok("1,10,100,1000,10000,100000,1000000", ","), ::switches, 88);
				AddSliderList( "VALUE", strtok("zombie_score_bonus_head,zombie_score_bonus_melee,zombie_score_bonus_neck,zombie_score_bonus_torso,zombie_score_damage_light,zombie_score_damage_normal", ","), ::switches, -88);
				AddOption("ADD", ::dofunction, 88);
				AddOption("SUBTRACT", ::dofunction, -88);
			EndSubMenu();
			AddSliderBool("DISCO LIGHTING", ::bool_functions, 313);
			AddSliderBool("DISABLE END GAME CHECK", ::bool_functions, 372);
		EndSubMenu();
		AddSubmenu("ACCOUNT MENU", 2);
			AddOption("GIVE SHOTGUNS RANK", ::dofunction, 143);
			AddSliderList("TALLIES", strtok("0,1,2,3,4,5", ","), ::switches, 144);
			AddOption("GIVE TALLIES", ::dofunction, 144);
			if(level.script == "zm_transit" || level.script == "zm_highrise" || level.script == "zm_buried")
				AddOption("ALL PERMA PERKS", ::dofunction, 145);
			AddOption("ALL TROPHIES", ::dofunction, 345);
			AddSubMenu("CUSTOM STATS", 3);
				AddSliderList("STAT", GetArrayKeys(level.players[0].pers), ::switches, 328);
				AddSliderList("PRECISION", strtok("10,100,1000,10000,100000,1000000", ","), ::switches, 329);
				AddOption("ADD", ::dofunction, 328);
			EndSubMenu();
			if(level.script == "zm_transit" || level.script == "zm_highrise" || level.script == "zm_bruried")
				AddSliderInt( "BANK MONEY", 250000, undefined, 250000, 50000, ::values, 364);
			if(level.script == "zm_transit" || level.script == "zm_highrise" || level.script == "zm_bruried")
			{
				weapons = getArrayKeys(level.zombie_weapons_upgraded);
				AddSliderList("LOCKER WEAPON", weapons, ::switches, 365);
				AddOption("SET", ::dofunction, 365);
			}
		EndSubMenu();
		AddPlayersMenu("PLAYERS MENU", 3);
			AddSubmenu("MAIN MODS", 3);
				AddPlayerSliderBool("GOD MODE", ::bool_functions, 0);
				AddPlayerSliderBool("INFINITE AMMO", ::bool_functions, 1);
				AddPlayerSliderBool("NO TARGET", ::bool_functions, 2);
				AddPlayerSliderBool("INVISIBILITY", ::bool_functions, 3);
				AddPlayerSliderBool("BIND ADVANCED NO CLIP", ::bool_functions, 179);
				AddPlayerSliderBool("GHOST WALKER", ::bool_functions, 156);
				AddSubMenu("PERKS MENU", 1);
				value = "NONE" + ",";
				for(i = 0; i < vending_triggers.size - 1; i++)
					if( vending_triggers[i].script_noteworthy != "specialty_weapupgrade")
						value += vending_triggers[i].script_noteworthy + ",";
				value += vending_triggers[ vending_triggers.size - 1].script_noteworthy;
				value += MapPerks();
					AddPlayerSliderBool("KEEP PERKS ON DOWN", ::bool_functions, 14);
					AddPlayerSliderBool("MAGIC PERKS", ::bool_functions, 193);
					AddPlayerSliderList("PERK", strtok(value,","), ::switches, 16);
					AddPlayerOption("GIVE", ::dofunction, 16);
					AddPlayerOption("TAKE", ::dofunction, -16);
				EndSubMenu();
				AddSubMenu("POINTS MENU", 1);
					AddPlayerSliderList("POINTS", strtok("10,100,1000,10000,100000,1000000",","), ::switches, 17);
					AddPlayerOption("GIVE", ::dofunction, 17);
					AddPlayerOption("TAKE", ::dofunction, -17);
				EndSubMenu();
				AddPlayerSliderInt( "FIELD OF VIEW", 65, 20, 160, 10, ::values, 19);
				AddPlayerSliderBool("FORGE MODE", ::bool_functions, 4);
				AddPlayerSliderBool("UNLIMITED SPRINT", ::bool_functions, 167);
				AddPlayerSliderInt( "MOVEMENT SPEED", 1, 0, undefined, .1, ::values, 5);
				AddPlayerSliderBool("THIRD PERSON", ::bool_functions, 7);
				AddPlayerSliderBool("AIMBOT", ::bool_functions, 8);
				AddPlayerSliderBool("HEALTH BAR", ::bool_functions, 9);
				AddPlayerSliderInt("MAX HEALTH", 150, 50, undefined, 100, ::values, 360);
				AddPlayerOption("REVIVE PLAYER", ::dofunction, 10);
				AddPlayerSliderList("TEAM", strtok("allies,axis,team3", ","), ::switches, 337);
				AddPlayerOption("SPAWN CLONE", ::dofunction, 11);
				AddPlayerOption("SPAWN DEAD CLONE", ::dofunction, 12);
				AddPlayerOption("SUICIDE", ::dofunction, 13);
			EndSubMenu();
			AddSubMenu("TROLL MENU", 3);
				AddPlayerSliderBool("KILL LOOP", ::bool_functions, 165);
				AddPlayerSliderBool("TRIP BALLS", ::bool_functions, 166);
				AddPlayerSliderBool("WHITE SCREEN", ::bool_functions, 183);
				AddPlayerSliderBool("FREEZE NO LOOK", ::bool_functions, 140);
				AddPlayerSliderBool("FREEZE WITH LOOK", ::bool_functions, 141);
				AddPlayerSliderBool("THIRSTY", ::bool_functions, 307);
				AddSliderBool("PUPPET MODE", ::bool_functions, 308);
				AddOption("SWITCH WEAPONS WITH PLAYER", ::dofunction, 314);
				AddPlayerSliderList("FORCE STANCE", strtok("OFF,crouch,prone,stand", ","), ::switches, 315);
				AddPlayerSliderBool("LAG SWITCH", ::bool_functions, 349);
				AddPlayerOption("DOWN PLAYER", ::dofunction, 374);
			EndSubMenu();
			AddSubMenu("TELEPORT MENU", 3);
				AddOption("TELEPORT TO PLAYER", ::dofunction, 151);
				AddOption("TELEPORT PLAYER TO CROSSHAIR", ::dofunction, 150);
				AddOption("TELEPORT ZOMBIES TO PLAYER", ::dofunction, 152);
				CaseAdditions( -8 );
			EndSubMenu();
			CaseAdditions(14);
			AddSubmenu("POINTS MENU", 3);
				AddPlayerSliderList("POINTS", strtok("10,100,1000,10000,100000,1000000",","), ::switches, 17);
				AddPlayerOption("GIVE", ::dofunction, 17);
				AddPlayerOption("TAKE", ::dofunction, -17);
			EndSubMenu();
			AddSubMenu("WEAPONS MENU", 1);
				AddSubMenu("WEAPON OPTIONS", 2);
					AddSubMenu("WEAPON CAMO", 2);
						AddPlayerOption("DEFAULT", ::dofunction, 24, 0);
						AddPlayerOption("PAP 1", ::dofunction, 24, 39);
						AddPlayerOption("PAP 2", ::dofunction, 24, 40);
						AddPlayerOption("PAP 3", ::dofunction, 24, 45);
					EndSubMenu();
				EndSubMenu();
				AddPlayerOption("PACK A PUNCH WEAPON", ::dofunction, 21);
				AddPlayerOption("UN-PACK A PUNCH WEAPON", ::dofunction, 22);
				value = "NONE" + ",";
				foreach(weapon in level.zombie_weapons)
					value += weapon.weapon_name + ",";
				value += "knife_zm";
				value += CaseAdditions( 11 );
				AddPlayerSliderList("WEAPON", strtok(value, ","), ::switches, 20);
				AddPlayerOption("GIVE", ::dofunction, 20);
				AddPlayerOption("TAKE", ::dofunction, -20);
				AddPlayerOption("DROP WEAPON", ::dofunction, 23);
			EndSubMenu();
			AddSubMenu("MODELS MENU", 2);
				CaseAdditions(3, 1);
			EndSubMenu();
			AddSubmenu("ACCOUNT MENU", 3);
				AddPlayerOption("GIVE SHOTGUNS RANK", ::dofunction, 143);
				AddPlayerSliderList("TALLIES", strtok("0,1,2,3,4,5", ","), ::switches, 144);
				AddPlayerOption("GIVE TALLIES", ::dofunction, 144);
				if(level.script == "zm_transit" || level.script == "zm_highrise" || level.script == "zm_buried")
					AddPlayerOption("ALL PERMA PERKS", ::dofunction, 145);
				AddPlayerOption("ALL TROPHIES", ::dofunction, 345);
				AddSubMenu("CUSTOM STATS", 3);
					AddPlayerSliderList("STAT", GetArrayKeys(level.players[0].pers), ::switches, 328);
					AddPlayerSliderList("PRECISION", strtok("10,100,1000,10000,100000,1000000", ","), ::switches, 329);
					AddPlayerOption("ADD", ::dofunction, 328);
				EndSubMenu();
				if(level.script == "zm_transit" || level.script == "zm_highrise" || level.script == "zm_bruried")
					AddPlayerSliderInt( "BANK MONEY", 250000, undefined, 250000, 50000, ::values, 364);
				if(level.script == "zm_transit" || level.script == "zm_highrise" || level.script == "zm_bruried")
				{
					weapons = getArrayKeys(level.zombie_weapons_upgraded);
					AddPlayerSliderList("LOCKER WEAPON", weapons, ::switches, 365);
					AddPlayerOption("SET", ::dofunction, 365);
				}
			EndSubMenu();
			AddSubMenu("VERIFICATION", 3);
				AddOption("UNVERIFY", ::CallerSetAccess, 0);
				AddOption("VERIFIED", ::CallerSetAccess, 1);
				AddOption("ELEVATED", ::CallerSetAccess, 2);
				AddOption("COHOST", ::CallerSetAccess, 3);
			EndSubMenu();
			AddPlayerOption("KICK PLAYER", ::dofunction, 142);
			AddOption("FREEZE CONSOLE", ::dofunction, 346);
		EndPlayersMenu();
		AddAllPlayersMenu("ALL PLAYERS MENU", 3);
		AddSliderBool("INCLUDE HOST", ::bool_functions, 370);
		AddSubMenu("MAIN MODS", 3);
			AddAllplayersSliderBool("GOD MODE", ::bool_functions, 0);
			AddAllplayersSliderBool("INFINITE AMMO", ::bool_functions, 1);
			AddAllplayersSliderBool("NO TARGET", ::bool_functions, 2);
			AddAllplayersSliderBool("INVISIBILITY", ::bool_functions, 3);
			AddAllplayersSliderBool("BIND ADVANCED NO CLIP", ::bool_functions, 179);
			AddAllplayersSliderBool("GHOST WALKER", ::bool_functions, 156);
			AddSubMenu("PERKS MENU", 1);
			value = "NONE" + ",";
			for(i = 0; i < vending_triggers.size - 1; i++)
				if( vending_triggers[i].script_noteworthy != "specialty_weapupgrade")
					value += vending_triggers[i].script_noteworthy + ",";
			value += vending_triggers[ vending_triggers.size - 1].script_noteworthy;
			value += MapPerks();
				AddAllplayersSliderBool("KEEP PERKS ON DOWN", ::bool_functions, 14);
				AddAllplayersSliderBool("MAGIC PERKS", ::bool_functions, 193);
				AddAllPlayersSliderList("PERK", strtok(value,","), ::switches, 16);
				AddAllPlayersOption("GIVE", ::dofunction, 16);
				AddAllPlayersOption("TAKE", ::dofunction, -16);
			EndSubMenu();
			AddSubMenu("POINTS MENU", 1);
				AddAllPlayersSliderList("POINTS", strtok("10,100,1000,10000,100000,1000000",","), ::switches, 17);
				AddAllPlayersOption("GIVE", ::dofunction, 17);
				AddAllPlayersOption("TAKE", ::dofunction, -17);
			EndSubMenu();
			AddAllplayersSliderBool("UNLIMITED SPRINT", ::bool_functions, 167);
			AddAllplayersSliderBool("THIRD PERSON", ::bool_functions, 7);
			AddAllplayersSliderBool("AIMBOT", ::bool_functions, 8);
			AddAllPlayersOption("REVIVE PLAYER", ::dofunction, 10);
			AddAllPlayersSliderList("TEAM", strtok("allies,axis,team3", ","), ::switches, 337);
			AddAllPlayersOption("SPAWN CLONE", ::dofunction, 11);
			AddAllPlayersOption("SPAWN DEAD CLONE", ::dofunction, 12);
			AddAllPlayersOption("SUICIDE", ::dofunction, 13);
		EndSubMenu();
		AddSubMenu("TROLL MENU", 3);
			AddAllplayersSliderBool("KILL LOOP", ::bool_functions, 165);
			AddAllplayersSliderBool("TRIP BALLS", ::bool_functions, 166);
			AddAllplayersSliderBool("WHITE SCREEN", ::bool_functions, 183);
			AddAllplayersSliderBool("FREEZE NO LOOK", ::bool_functions, 140);
			AddAllplayersSliderBool("FREEZE WITH LOOK", ::bool_functions, 141);
			AddAllplayersSliderBool("THIRSTY", ::bool_functions, 307);
			AddAllPlayersSliderList("FORCE STANCE", strtok("OFF,crouch,prone,stand", ","), ::switches, 315);
			AddAllplayersSliderBool("LAG SWITCH", ::bool_functions, 349);
			AddAllPlayersOption("DOWN PLAYER", ::dofunction, 374);
		EndSubMenu();
		AddSubMenu("TELEPORT MENU", 3);
			AddAllPlayersOption("TELEPORT PLAYER TO CROSSHAIR", ::dofunction, 150);
			CaseAdditions( -88 );
		EndSubMenu();
		AddSubmenu("POINTS MENU", 3);
			AddAllPlayersSliderList("POINTS", strtok("10,100,1000,10000,100000,1000000",","), ::switches, 17);
			AddAllPlayersOption("GIVE", ::dofunction, 17);
			AddAllPlayersOption("TAKE", ::dofunction, -17);
		EndSubMenu();
		AddSubMenu("WEAPONS MENU", 1);
			AddSubMenu("WEAPON OPTIONS", 2);
				AddSubMenu("WEAPON CAMO", 2);
					AddAllPlayersOption("DEFAULT", ::dofunction, 24, 0);
					AddAllPlayersOption("PAP 1", ::dofunction, 24, 39);
					AddAllPlayersOption("PAP 2", ::dofunction, 24, 40);
					AddAllPlayersOption("PAP 3", ::dofunction, 24, 45);
				EndSubMenu();
			EndSubMenu();
			AddAllPlayersOption("PACK A PUNCH WEAPON", ::dofunction, 21);
			AddAllPlayersOption("UN-PACK A PUNCH WEAPON", ::dofunction, 22);
			value = "NONE" + ",";
			foreach(weapon in level.zombie_weapons)
				value += weapon.weapon_name + ",";
			value += "knife_zm";
			value += CaseAdditions( 11 );
			AddAllPlayersSliderList("WEAPON", strtok(value, ","), ::switches, 20);
			AddAllPlayersOption("GIVE", ::dofunction, 20);
			AddAllPlayersOption("TAKE", ::dofunction, -20);
			AddAllPlayersOption("DROP WEAPON", ::dofunction, 23);
		EndSubMenu();
		AddSubmenu("ACCOUNT MENU", 3);
			AddAllPlayersOption("GIVE SHOTGUNS RANK", ::dofunction, 143);
			AddAllPlayersSliderList("TALLIES", strtok("0,1,2,3,4,5", ","), ::switches, 144);
			AddAllPlayersOption("GIVE TALLIES", ::dofunction, 144);
			if(level.script == "zm_transit" || level.script == "zm_highrise" || level.script == "zm_buried")
				AddAllPlayersOption("ALL PERMA PERKS", ::dofunction, 145);
			AddAllPlayersOption("ALL TROPHIES", ::dofunction, 345);
			AddSubMenu("CUSTOM STATS", 3);
				AddAllPlayersSliderList("STAT", GetArrayKeys(level.players[0].pers), ::switches, 328);
				AddAllPlayersSliderList("PRECISION", strtok("10,100,1000,10000,100000,1000000", ","), ::switches, 329);
				AddAllPlayersOption("ADD", ::dofunction, 328);
			EndSubMenu();
			if(level.script == "zm_transit" || level.script == "zm_highrise" || level.script == "zm_bruried")
			{
				weapons = getArrayKeys(level.zombie_weapons_upgraded);
				AddAllPlayersSliderList("LOCKER WEAPON", weapons, ::switches, 365);
				AddAllPlayersOption("SET", ::dofunction, 365);
			}
		EndSubMenu();
		EndSubMenu();
		if(isdefined(level.i_customOptionsEnabled) && level.i_customOptionsEnabled)
		{
			AddSubMenu("CUSTOM OPTIONS", level.i_customoptionsmenuaccess);
				[[ level.i_customoptions ]]();
			EndSubMenu();
		}
}

WelcomeMessage()
{
	self iprintln("Welcome. Press [{+actionslot 1}] to open the menu!");
}

ControlMonitor()
{
	self endon("disconnect");
	self endon("VerificationChange");
	self notify("ControlMonitor");
	self endon("ControlMonitor");
	self thread IconicReviveFeature();
	Menu = self GetMenu();
	Buttons = array_copy(Menu.preferences.controlscheme);
	CLOSED = -1;
	MAIN = 0;
	oldmenu = -1;
	acceleration_wait_time = .5;
	self freezecontrols( false );
	while( 1 )
	{
		if( !isAlive( self ) || self.sessionstate == "spectator" )
		{
			oldmenu = Menu.currentmenu;
			Menu.currentmenu = CLOSED;
			self UpdateMenu();
			while( !isAlive( self ) || self.sessionstate == "spectator" )
				wait 1;
			if( oldmenu != CLOSED )
			{
				Menu.currentmenu = oldmenu;
				self UpdateMenu( true );
			}
		}
		if( self IsButtonPressed( "[{+actionslot 1}]" ) && Menu.currentmenu == CLOSED && !self AttackButtonPressed())
		{
			Menu.currentmenu = MAIN;
			self UpdateMenu( true );
			while( self IsButtonPressed( Buttons[0] ) )
				wait .05;
		}
		else if( self IsButtonPressed( Buttons[5] ) && Menu.currentmenu == MAIN )
		{
			self PlayLocalSound("uin_main_exit");
			Menu.currentmenu = CLOSED;
			UpdateMenu();
			while( self IsButtonPressed( Buttons[5] ) )
				wait .05;
		}
		else if( self IsButtonPressed( Buttons[5] ) && Menu.currentmenu != CLOSED )
		{
			self PlayLocalSound("uin_main_exit");//TODO
			if( Menu.currentmenu == level.menu_controls_menu )
			{
				ControlsValidate();
				Buttons = array_copy(Menu.preferences.controlscheme); //This updates our controls AFTER we exit the settings menu
			}
			if(Menu.currentmenu == level.si_players_menu )
				Menu.selectedplayer = undefined;
			Menu.currentmenu = level.Evanescence.options[ Menu.currentmenu ].parentmenu;
			UpdateMenu();
			while( self IsButtonPressed( Buttons[5] ) )
				wait .05;
		}
		else if( self IsButtonPressed( Buttons[0] ) )
		{
			if( Menu.text.size > 1 )
			{
				Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] notify("Deselected");
				self PlayLocalSound("cac_grid_nav");
				if( isSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) )
				{
					Menu.sliders[ level.Evanescence.options[ Menu.currentmenu ].options[ Menu.cursors[ Menu.currentMenu ] ].title ] notify("Deselected");
				}
				if( Menu.CurrentMenu != level.si_players_menu )
				{
					if( Menu.cursors[ Menu.CurrentMenu ] < 1 )
					{
						Menu.cursors[ Menu.CurrentMenu ] = ( level.Evanescence.options[ Menu.CurrentMenu ].options.size - 1 );		
					}
					else
						Menu.cursors[ Menu.CurrentMenu ]--;
				}
				else
				{
					if( Menu.cursors[ Menu.CurrentMenu ] < 1 )
					{
						Menu.cursors[ Menu.CurrentMenu ] = ( level.players.size - 1 );		
					}
					else
						Menu.cursors[ Menu.CurrentMenu ]--;
				}
				Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] thread SelectedOption( self );
				if( isSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) )
				{
					Menu.sliders[ level.Evanescence.options[ Menu.currentmenu ].options[ Menu.cursors[ Menu.currentMenu ] ].title ] thread SelectedOption( self );
				}
			}
			while( self IsButtonPressed( Buttons[0] ) )
				wait .05;
		}
		else if( self IsButtonPressed( Buttons[1] ) && Menu.currentmenu != CLOSED )
		{
			if( Menu.text.size > 1 )
			{
				self PlayLocalSound("cac_grid_nav");
				if( isSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) )
				{
					Menu.sliders[ level.Evanescence.options[ Menu.currentmenu ].options[ Menu.cursors[ Menu.currentMenu ] ].title ] notify("Deselected");
				}
				Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] notify("Deselected");
				if( Menu.CurrentMenu != level.si_players_menu )
				{
					if( Menu.cursors[ Menu.CurrentMenu ] >= ( level.Evanescence.options[ Menu.CurrentMenu ].options.size - 1 ) )
					{
						Menu.cursors[ Menu.CurrentMenu ] = 0;		
					}
					else
						Menu.cursors[ Menu.CurrentMenu ]++;
				}
				else
				{
					if( Menu.cursors[ Menu.CurrentMenu ] >= ( level.players.size - 1 ) )
					{
						Menu.cursors[ Menu.CurrentMenu ] = 0;		
					}
					else
						Menu.cursors[ Menu.CurrentMenu ]++;
				}
				Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] thread SelectedOption( self );
				if( isSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) )
				{
					Menu.sliders[ level.Evanescence.options[ Menu.currentmenu ].options[ Menu.cursors[ Menu.currentMenu ] ].title ] thread SelectedOption( self );
				}
			}
			while( self IsButtonPressed( Buttons[1] ) )
				wait .05;
		}
		else if( self IsButtonPressed( Buttons[4] ) && Menu.currentmenu != CLOSED)
		{
			if( !isSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) )
				self thread PerformOption();
			while( self IsButtonPressed( Buttons[4] ) )
				wait .05;
		}
		else if( self IsButtonPressed( Buttons[2] ) && Menu.currentmenu != CLOSED)
		{
			self thread Slider( -1 );
			for(i=0; i < acceleration_wait_time && self IsButtonPressed( Buttons[2] ); i+= .0125)
				wait .0125;
			if( self IsButtonPressed( Buttons[2] ) )
			{
				acceleration_wait_time *= .3;
			}
		}
		else if( self IsButtonPressed( Buttons[6] ) && Menu.currentmenu != CLOSED)
		{
			NextPage();
			while( self IsButtonPressed( Buttons[6] ) )
				wait .05;
		}
		else if( self IsButtonPressed( Buttons[7] ) && Menu.currentmenu != CLOSED)
		{
			PreviousPage();
			while( self IsButtonPressed( Buttons[7] ) )
				wait .05;
		}
		else if( self IsButtonPressed( Buttons[3] ) && Menu.currentmenu != CLOSED)
		{
			self thread Slider( 1 );
			for(i=0; i < acceleration_wait_time && self IsButtonPressed( Buttons[3] ); i+= .0125)
				wait .0125;
			if( self IsButtonPressed( Buttons[3] ) )
			{
				acceleration_wait_time *= .3;
			}
		}
		else if( acceleration_wait_time != .35 )
		{
			acceleration_wait_time = .35;
		}
		wait .05;
	}
	CloseMenu();
}

AddControlsMenu( title, access )
{
	AddSubMenu( title, access );
	level.menu_controls_menu = level.si_current_menu;
}

MapPerks()
{
	if(level.script == "zm_tomb")
	{
		return ",specialty_grenadepulldeath,specialty_deadshot,specialty_flakjacket,specialty_rof";
	}
	return "";
}

CaseAdditions( option, players )
{
	if( option == 1)
	{
		value = "NORMAL,ray_gun_zm,ray_gun_upgraded_zm,raygun_mark2_zm,raygun_mark2_upgraded_zm,dsr50_upgraded_zm,";
		if( level.script == "zm_transit" || level.script == "zm_highrise" || level.script == "zm_buried")
		{
			value += "usrpg_upgraded_zm,m1911_upgraded_zm";
		}
		if( level.script == "zm_prison")
		{
			value += "m1911_upgraded_zm,blundersplat_bullet_zm,minigun_alcatraz_upgraded_zm";
		}
		if( level.script == "zm_tomb")
		{
			value += "staff_lightning_upgraded3_zm,staff_fire_upgraded3_zm,staff_water_upgraded3_zm,staff_air_zm,c96_upgraded_zm";
		}
		AddSliderList("BULLET TYPE", strtok(value,","), ::switches, 43, 0);
	}
	else if( option == 2 )
	{
		value = "NORMAL,grenade_samantha_steal,zomb_gib,powerup_grabbed,character_fire_death_sm,zombie_guts_explosion,rise_burst";
		if( level.script == "zm_transit" )
		{
			value += "turbine_on,avogadro_health_half,lava_burning,screecher_death,etrap_on,jetgun_meat_grinder";
		}
		if( level.script == "zm_highrise" )
		{
			value += "slipgun_explode,poltergeist,fx_highrise_dragon_breath_max,slipgun_explode,leaper_death,elec_torso";
		}
		if( level.script == "zm_prison" )
		{
			value += "electric_cherry_explode,brutus_death,elec_torso,electric_cherry_reload_large,tomahawk_charge_up_ug,tomahawk_charge_up";
		}
		if( level.script == "zm_buried" )
		{
			value += "zombie_slowgun_explosion_ug,barrier_break,zombie_slowgun_sizzle_ug,subwoofer_audio_wave,time_bomb_kills_enemy,time_bomb_set";
		}
		if( level.script == "zm_tomb" )
		{
			value += "teleport_3p,tesla_elec_kill,mech_wpn_flamethrower,digging,crypt_wall_drop,capture_complete";
		}
		AddSliderList("BULLET EFFECT", strtok(value,","), ::switches, 43, 1);
	}
	else if( option == 11 )
	{
		value = "";
		if( level.script == "zm_transit" )
		{
			value = ",riotshield_zm,bowie_knife_zm,equip_turbine_zm,equip_turret_zm,equip_electrictrap_zm";
		}
		if( level.script == "zm_prison" )
		{
			value = ",lightning_hands_zm,knife_zm_alcatraz,spork_zm_alcatraz,alcatraz_shield_zm";
		}
		if( level.script == "zm_buried" )
		{
			value = ",bowie_knife_zm,equip_springpad_zm,equip_subwoofer_zm,equip_headchopper_zm,equip_turbine_zm";
		}
		if( level.script == "zm_tomb" )
		{
			value = ",tomb_shield_zm,staff_air_melee_zm,staff_fire_melee_zm,staff_lightning_melee_zm,staff_water_melee_zm";
		}
		return value;
	}
	else if( option == 3)
	{
		value = "NONE,test_sphere_lambert,test_macbeth_chart,test_macbeth_chart_unlit" + ",";
		arg1 = "NONE,defaultactor" + ",";
		if(level.script == "zm_transit")
		{
			arg1 += "c_zom_player_reporter_fb,c_zom_player_engineer_fb,c_zom_player_farmgirl_fb,c_zom_player_oldman_fb,c_zom_avagadro_fb,p6_anim_zm_bus_driver,c_zom_zombie1_body01,c_zom_zombie1_body02";
			value += "p6_anim_zm_magic_box_fake,p6_anim_zm_magic_box,p_rus_door_white_window_plain_left,p_rus_door_white_plain_right,storefront_door02_window,p_cub_door01_wood_fullsize,p6_zm_bank_vault_door,p6_zm_core_reactor_top,p6_door_metal_no_decal_left,p6_zm_window_dest_glass_big,p6_zm_garage_door_01,p6_zm_door_security_depot,veh_t6_civ_bus_zombie,p6_anim_zm_bus_driver,veh_t6_civ_movingtrk_cab_dead,veh_t6_civ_bus_zombie_roof_hatch,p6_anim_zm_buildable_turret,p6_anim_zm_buildable_etrap,p6_anim_zm_buildable_turbine,p6_anim_zm_buildable_sq,zombie_teddybear,p6_anim_zm_buildable_pap,zombie_sign_please_wait,ch_tombstone1,zombie_bomb,zombie_skull,zombie_ammocan,zombie_x2_icon,zombie_carpenter,t6_wpn_zmb_shield_dmg1_world,t6_wpn_zmb_shield_dmg2_world,p6_zm_screecher_hole,p6_zm_buildable_battery,t6_wpn_zmb_shield_dolly,t6_wpn_zmb_shield_door,p6_zm_buildable_pap_body,p6_zm_buildable_pap_table,p6_zm_buildable_turbine_fan,p6_zm_buildable_turbine_rudder,p6_zm_buildable_turbine_mannequin,p6_zm_buildable_turret_mower,p6_zm_buildable_turret_ammo,p6_zm_buildable_etrap_base,p6_zm_buildable_etrap_tvtube,p6_zm_buildable_jetgun_wires,p6_zm_buildable_jetgun_engine,p6_zm_buildable_jetgun_guages,p6_zm_buildable_jetgun_handles,p6_zm_buildable_sq_electric_box,p6_zm_buildable_sq_meteor,p6_zm_buildable_sq_scaffolding,p6_zm_buildable_sq_transceiver,p_glo_tools_chest_tall";
		}
		if(level.script == "zm_nuked")
		{
			arg1 += "c_zom_player_cdc_fb,c_zom_player_cia_fb,c_zom_dlc0_zom_haz_body1,c_zom_dlc0_zom_haz_body2";
			value += "p6_anim_zm_magic_box_fake,p6_anim_zm_magic_box,zombie_wolf,p6_zm_nuked_chair_01,p6_zm_nuked_couch_02,p6_zm_door_white,p6_zm_door_brown,p6_zm_cratepile,defaultvehicle,fxanim_gp_shirt01_mod,fxanim_gp_tanktop_mod,fxanim_gp_dress_mod,fxanim_gp_pant01_mod,fxanim_gp_shirt_grey_mod,fxanim_gp_roaches_mod,fxanim_zom_nuketown_shutters_mod,fxanim_zom_curtains_yellow_a_mod,fxanim_zom_curtains_yellow_b_mod,fxanim_zom_curtains_yellow_c_mod,fxanim_zom_curtains_blue_a_mod,fxanim_zom_curtains_blue_c_mod,fxanim_zom_nuketown_cabinets_brwn_mod,fxanim_zom_nuketown_cabinets_red_mod,fxanim_zom_nuketown_shutters02_mod,fxanim_gp_cloth_sheet_med01_mod,fxanim_zom_nuketown_cabinets_brwn02_mod,fxanim_gp_roofvent_small_mod,fxanim_gp_wirespark_long_mod,fxanim_gp_wirespark_med_mod,mp_nuked_townsign_counter,dest_zm_nuked_male_01_d0,p_rus_clock_green_sechand,p_rus_clock_green_minhand,p_rus_clock_green_hourhand,p6_zm_nuked_clocktower_sec_hand,p6_zm_nuked_clocktower_min_hand,dest_zm_nuked_female_01_d0,dest_zm_nuked_female_02_d0,dest_zm_nuked_female_03_d0,dest_zm_nuked_male_02_d0,zombie_teddybear,t6_wpn_zmb_perk_bottle_doubletap_world,t6_wpn_zmb_perk_bottle_jugg_world,t6_wpn_zmb_perk_bottle_revive_world,t6_wpn_zmb_perk_bottle_sleight_world,zombie_bomb,zombie_skull,zombie_ammocan,zombie_x2_icon,zombie_firesale";
		}
		if(level.script == "zm_highrise")
		{
			arg1 += "c_zom_player_reporter_fb,c_zom_player_engineer_fb,c_zom_player_farmgirl_fb,c_zom_player_oldman_fb,c_zom_leaper_body,c_zom_zombie_civ_shorts_body";
			value += "p6_anim_zm_magic_box_fake,p6_anim_zm_magic_box,p6_zm_hr_luxury_door,p6_zm_nuked_couch_02,p6_zm_hr_lion_statue_ball,p6_anim_zm_hr_buildable_sq,p6_anim_zm_buildable_tramplesteam,zombie_teddybear,zombie_pickup_perk_bottle,p6_zm_buildable_tramplesteam_door,p6_zm_buildable_tramplesteam_bellows,p6_zm_buildable_tramplesteam_compressor,p6_zm_buildable_tramplesteam_flag,t6_zmb_buildable_slipgun_extinguisher,t6_zmb_buildable_slipgun_cooker,t6_zmb_buildable_slipgun_foot,t6_zmb_buildable_slipgun_throttle,p6_zm_buildable_sq_electric_box,p6_zm_buildable_sq_meteor,p6_zm_buildable_sq_scaffolding,p6_zm_buildable_sq_transceiver";
		}
		if(level.script == "zm_prison")
		{
			arg1 += "c_zom_player_arlington_fb,c_zom_player_deluca_fb,c_zom_player_handsome_fb,c_zom_player_oleary_fb,c_zom_cellbreaker_fb,c_zom_guard_body,c_zom_inmate_body1,c_zom_inmate_body2";
			value += "p6_anim_zm_al_magic_box,storefront_door02_window,p6_zm_al_cell_door_collmap,p6_zm_al_cell_isolation,p6_zm_al_large_generator,fxanim_zom_al_trap_fan_mod,p6_zm_al_gondola,p6_zm_al_gondola_gate,p6_zm_al_gondola_door,p6_zm_al_shock_box_off,p6_zm_al_cell_door,veh_t6_dlc_zombie_plane_whole,p6_zm_al_electric_chair,p6_zm_al_infirmary_case,p6_zm_al_industrial_dryer,p6_zm_al_clothes_pile_lrg,veh_t6_dlc_zombie_part_engine,p6_zm_al_dream_catcher_off,c_zom_wolf_head,zombie_bomb,zombie_skull,zombie_ammocan,zombie_x2_icon,zombie_firesale,zombie_teddybear,t6_wpn_zmb_shield_dlc2_dmg0_view,p6_zm_al_packasplat_suitcase,p6_zm_al_packasplat_engine,p6_zm_al_packasplat_iv,veh_t6_dlc_zombie_part_fuel,veh_t6_dlc_zombie_part_rigging,p6_anim_zm_al_packasplat,p6_zm_al_shock_box_on,p6_zm_al_audio_headset_icon,p6_zm_al_power_station_panels_03";
		}
		if( level.script == "zm_buried" )
		{
			arg1 += "c_zom_player_reporter_fb,c_zom_player_engineer_fb,c_zom_player_farmgirl_fb,c_zom_player_oldman_fb,c_zom_buried_sloth_fb,c_zom_zombie_buried_sgirl_body1,c_zom_zombie_buried_sgirl_body2";
			value += "p6_anim_zm_magic_box_fake,p6_anim_zm_magic_box,p6_zm_work_bench,p6_anim_zm_buildable_view_tramplesteam,p6_anim_zm_buildable_turbine,t6_wpn_zmb_subwoofer,p6_anim_zm_buildable_tramplesteam,p6_anim_zm_hr_buildable_sq,fxanim_zom_buried_orbs_mod,p6_zm_bu_gallows,p6_zm_bu_guillotine,p6_zm_bu_end_game_machine,t6_wpn_zmb_chopper,zombie_teddybear,zombie_pickup_perk_bottle,p6_zm_bu_hedge_gate,p6_zm_buildable_turbine_fan,p6_zm_buildable_turbine_rudder,p6_zm_buildable_turbine_mannequin,p6_zm_buildable_tramplesteam_door,p6_zm_buildable_tramplesteam_bellows,p6_zm_buildable_tramplesteam_compressor,p6_zm_buildable_tramplesteam_flag,p6_zm_buildable_sq_electric_box,p6_zm_buildable_sq_meteor,p6_zm_buildable_sq_scaffolding,p6_zm_buildable_sq_transceiver,p6_zm_bu_sq_vaccume_tube,p6_zm_bu_sq_buildable_battery,p6_zm_bu_sq_crystal,p6_zm_bu_sq_satellite_dish,p6_zm_bu_sq_antenna,p6_zm_bu_sq_wire_spool,p6_zm_bu_booze,p6_zm_bu_sloth_candy_bowl,p6_zm_bu_chalk,p6_zm_bu_sloth_booze_jug";
		}
		if(level.script == "zm_tomb")
		{
			arg1 += "c_zom_tomb_dempsey_fb,c_zom_tomb_nikolai_fb,c_zom_tomb_richtofen_fb,c_zom_tomb_takeo_fb,c_zom_mech_body,c_zom_tomb_german_body2";
			value += "p6_anim_zm_tm_magic_box,veh_t6_dlc_mkiv_tank,veh_t6_dlc_zm_biplane,fxanim_zom_tomb_portal_mod,p6_zm_tm_packapunch,fxanim_zom_tomb_generator_pump_mod,p6_zm_tm_wind_ceiling_ring_2,p6_zm_tm_wind_ceiling_ring_3,p6_zm_tm_wind_ceiling_ring_4,p6_zm_tm_wind_ceiling_ring_1,p6_zm_tm_challenge_box,p6_zm_tm_soul_box,veh_t6_dlc_zm_quadrotor,zombie_teddybear,veh_t6_dlc_zm_zeppelin,p6_zm_tm_gramophone,veh_t6_dlc_zm_robot_2";
		}
		level.menuModels = []; 
		foreach(model in getEntArray("script_model", "classname"))
			if(!isInArray(level.menuModels, model.model) )
				level.menuModels[ level.menuModels.size ] = model.model;
		foreach(model in strtok(value,","))
			if(!isInArray(level.menuModels, model) )
				level.menuModels[ level.menuModels.size ] = model;
		foreach( model in level.menuModels )
		{
			precachemodel( model );
		}
		if(isdefined(players) && players)
		{
			AddPlayerSliderList("PLAYER MODEL", StrTok(arg1, ","), ::switches, 44);
			AddPlayerSliderList("PLAYER PROP", level.menuModels, ::switches, 45);
			AddPlayerOption("SET MODEL", ::dofunction, 45);
			AddPlayerSliderList( "BONE", strtok("j_mouth_le,j_jaw,j_cheek_le,j_cheek_ri,j_head,j_neck,j_spine4,tag_weapon_right,tag_weapon_left,j_wrist_ri,j_wrist_le,j_elbow_ri,j_elbow_le,j_shoulder_ri,j_shoulder_le,j_clavicle_ri,j_clavicle_le,j_ankle_ri,j_ankle_le,back_mid,j_knee_ri,j_knee_le,back_low,j_hip_ri,j_hip_le,pelvis,j_mainroot", ","), ::switches, 361);
			AddPlayerSliderList( "MODEL", level.menuModels, ::switches, 362);
			AddPlayerOption("ATTACH", ::dofunction, 361);
			AddPlayerOption("DETACH ALL", ::dofunction, 362);
			return;
		}
		AddSliderList("PLAYER MODEL", StrTok(arg1, ","), ::switches, 44);
		AddSliderList("PLAYER PROP", level.menuModels, ::switches, 45);
		AddOption("SET MODEL", ::dofunction, 45);
		AddSliderList( "BONE", strtok("j_mouth_le,j_jaw,j_cheek_le,j_cheek_ri,j_head,j_neck,j_spine4,tag_weapon_right,tag_weapon_left,j_wrist_ri,j_wrist_le,j_elbow_ri,j_elbow_le,j_shoulder_ri,j_shoulder_le,j_clavicle_ri,j_clavicle_le,j_ankle_ri,j_ankle_le,back_mid,j_knee_ri,j_knee_le,back_low,j_hip_ri,j_hip_le,pelvis,j_mainroot", ","), ::switches, 361);
		AddSliderList( "MODEL", level.menuModels, ::switches, 362);
		AddOption("ATTACH", ::dofunction, 361);
		AddOption("DETACH ALL", ::dofunction, 362);
	}
	else if( option == 4 )
	{
		AddSliderBool("FORGE TOOL", ::bool_functions, 47);
		AddSliderList("MODEL", level.menuModels, ::switches, 46);
		AddOption("SPAWN", ::dofunction, 46);
	}
	else if(option == 6)
	{
		arg1 = "NONE,defaultactor" + ",";
		if(level.script == "zm_transit")
		{
			arg1 += "c_zom_player_reporter_fb,c_zom_player_engineer_fb,c_zom_player_farmgirl_fb,c_zom_player_oldman_fb,c_zom_avagadro_fb,p6_anim_zm_bus_driver,c_zom_zombie1_body01,c_zom_zombie1_body02";
		}
		if(level.script == "zm_nuked")
		{
			arg1 += "c_zom_player_cdc_fb,c_zom_player_cia_fb,c_zom_dlc0_zom_haz_body1,c_zom_dlc0_zom_haz_body2";
		}
		if(level.script == "zm_highrise")
		{
			arg1 += "c_zom_player_reporter_fb,c_zom_player_engineer_fb,c_zom_player_farmgirl_fb,c_zom_player_oldman_fb,c_zom_leaper_body,c_zom_zombie_civ_shorts_body";
		}
		if(level.script == "zm_prison")
		{
			arg1 += "c_zom_player_arlington_fb,c_zom_player_deluca_fb,c_zom_player_handsome_fb,c_zom_player_oleary_fb,c_zom_cellbreaker_fb,c_zom_guard_body,c_zom_inmate_body1,c_zom_inmate_body2";
		}
		if( level.script == "zm_buried" )
		{
			arg1 += "c_zom_player_reporter_fb,c_zom_player_engineer_fb,c_zom_player_farmgirl_fb,c_zom_player_oldman_fb,c_zom_buried_sloth_fb,c_zom_zombie_buried_sgirl_body1,c_zom_zombie_buried_sgirl_body2";
		}
		if(level.script == "zm_tomb")
		{
			arg1 += "c_zom_tomb_dempsey_fb,c_zom_tomb_nikolai_fb,c_zom_tomb_richtofen_fb,c_zom_tomb_takeo_fb,c_zom_mech_body,c_zom_tomb_german_body2";
		}
		AddSliderList("ZOMBIES MODEL", StrTok(arg1, ","), ::switches, 57);
	}
	else if(option == 8)
	{
		if( level.script == "zm_transit" )
		{
			AddOption("Spawn", ::dofunction, 65,(-6852.98,4944.63,-53.875));
			AddOption("Tunnel", ::dofunction, 65,(-11816.2,-2245.94,228.125));
			AddOption("Diner", ::dofunction, 65,  (-5306.84,-7328.29,-56.5403));
			AddOption("Diner Roof", ::dofunction, 65,  (-6170.19,-7939.07,180.192));
			AddOption("Farm", ::dofunction, 65,  (7806.3,-5716.07,4.52546));
			AddOption("Power", ::dofunction, 65,  (10958.1,7579.58,-592.101));
			AddOption("Town", ::dofunction, 65,  (763.336,-482.006,-61.875));
			AddOption("Nav Table", ::dofunction, 65,  (7600.26,-471.402,-204.472));
			AddOption("Nacht", ::dofunction, 65,  (13722.2,-705.697,-188.875));
			AddOption("Cabin in Woods", ::dofunction, 65, (5218.29,6870.22,-20.8699));
			AddOption("Pack A Punch", ::dofunction, 65, (1173.77,820.117,-303.875));
		}
		if( level.script == "zm_nuked" )
		{
			 AddOption("Top of Green House", ::dofunction, 65, (967.235,201.494,223.084));
			 AddOption("Behind Green House", ::dofunction, 65, (1673.89,408.651,-63.6207));
			 AddOption("Top of Blue House", ::dofunction, 65, (-886.562,540.505,272.317));
			 AddOption("Behind Blue House", ::dofunction, 65,(-1523.24,425.746,-61.8431));
		}
		if( level.script == "zm_highrise" )
		{
			 AddOption("First Room", ::dofunction, 65,  (1498,1342.32,3395.94));
			 AddOption("Box 1", ::dofunction, 65,  (3124.36,2601.92,2948.72));
			 AddOption("Box 2", ::dofunction, 65,  (2142.74,2562.82,3041.53));
			 AddOption("Box 3", ::dofunction, 65,  (2817.59,373.126,2880.13));
			 AddOption("Galvaknuckles", ::dofunction, 65,  (3510.61,2084.9,2535.1));
			 AddOption("Red Room", ::dofunction, 65,  (3135.35,1433.27,1289.87));
			 AddOption("Power", ::dofunction, 65,  (2844.53,-96.6862,1296.13));
			 AddOption("The Showers", ::dofunction, 65,  (2265.68,625.208,1296.13));
			 AddOption("Trample Steam", ::dofunction, 65,  (1976.78,1387.82,3040.13));
			 AddOption("Sliquifier", ::dofunction, 65,  (2369.36,-381.108,1120.13));
			 AddOption("Roof", ::dofunction, 65,  (1893.91,-4.78527,2880.13));
		}
		if( level.script == "zm_prison" )
		{
			 AddOption("Spawn Room", ::dofunction, 65, (1272.42,10613.1,1336.13));
			 AddOption("Dog 1", ::dofunction, 65, (748.504,9670.55,1443.13));
			 AddOption("Dog 2", ::dofunction, 65,  (3846.05,9703.98,1528.13));
			 AddOption("Dog 3", ::dofunction, 65,  (56.074,6133.9,20.7776));
			 AddOption("Wardens Office", ::dofunction, 65,  (-926.433,9296.4,1336.13));
			 AddOption("Cafeteria", ::dofunction, 65,  (3199.7,9656.43,1337.13));
			 AddOption("Roof", ::dofunction, 65,  (3422.3,9657.43,1713.13));
			 AddOption("Docks", ::dofunction, 65, (-342.532,5506.14,-71.875));
			 AddOption("Well", ::dofunction, 65,  (443.324,8710.93,831.733));
			 AddOption("Laundry Room", ::dofunction, 65, (1934.44,10388.5,1144.13));
			 AddOption("Bridge", ::dofunction, 65, (-1094.95,-3411.52,-8447.88));
		}
		if( level.script == "zm_buried" )
		{
			 AddOption("First Room", ::dofunction, 65, (-3011.71,-77.8997,1367.15));
			 AddOption("Bottom FR", ::dofunction, 65,  (-2546.58,-216.273,1224.13));
			 AddOption("Bank", ::dofunction, 65, (-398.294,-147.479,8.125));
			 AddOption("Quick Revive", ::dofunction, 65, (-1011.55,-348.669,288.125));
			 AddOption("Jug", ::dofunction, 65, (-648.281,543.501,8.125));
			 AddOption("Gun Smith", ::dofunction, 65, (-611.806,-1117.24,11.1486));
			 AddOption("Candy Store", ::dofunction, 65, (631.541,-225.173,8.125));
			 AddOption("Saloon", ::dofunction, 65,(746.584,-1498.28,54.0697));
			 AddOption("Witch House", ::dofunction, 65, (2060.23,561.052,-1.71439));
			 AddOption("Speed Cola", ::dofunction, 65,  (38.557,735.95,176.125));
			 AddOption("Mid Maze", ::dofunction, 65,  (4738.87,574.212,4.125));
			 AddOption("PAP Top", ::dofunction, 65, (6939.76,413.833,108.125));
			 AddOption("Tree Glitch", ::dofunction, 65,  (1233.59,673.951,65.1979));
			 AddOption("Church", ::dofunction, 65, (1670.69,2318.92,40.125));
		}
		if( level.script == "zm_tomb" )
		{
			 AddOption("Gen 1", ::dofunction, 65,  (2165.59,4928.62,-299.875));
			 AddOption("Gen 2", ::dofunction, 65,  (-223.924,3581.41,-291.875));
			 AddOption("Gen 3", ::dofunction, 65,  (530.175,2154.68,-121.875));
			 AddOption("Gen 4", ::dofunction, 65,  (2354.08,168.991,120.125));
			 AddOption("Gen 5", ::dofunction, 65,  (-2490.62,211.856,236.625));
			 AddOption("Gen 6", ::dofunction, 65,  (976.592,-3579.86,306.125));
			 AddOption("Crazy Place", ::dofunction, 65,  (10339.8,-7903.15,-411.875));
			 AddOption("Bottom PAP", ::dofunction, 65,  (10.8768,-4.48838,-751.875));
			 AddOption("Top PAP", ::dofunction, 65,  (-173.191,-1.632,320.125));
			 AddOption("Tank at Curch", ::dofunction, 65,  (123.48,-2696.25,37.8717));
			 AddOption("Church Outside", ::dofunction, 65,  (36.0072,-1614.33,240.956));
			 AddOption("Fire Tunnel", ::dofunction, 65, (3050.47,4415.63,-606.064));
			 AddOption("Ice Tunnel", ::dofunction, 65, (1409.45,-1807.33,-122.086));
			 AddOption("Wind Tunnel", ::dofunction, 65, (3331.91,1185.32,-345.817));
			 AddOption("Lightning Tunnel", ::dofunction, 65, (-3249.52,-358.075,-189.778));
			 AddOption("Right Robot", ::dofunction, 65, (-6195.95,-6423.42,156.492));
			 AddOption("Left Robot", ::dofunction, 65, (-5696.4,-6543.79,159.375));
			 AddOption("Middle Robot", ::dofunction, 65, (-6762.56,-6541.9,159.375));
		}
	}
	else if(option == -8)
	{
		if( level.script == "zm_transit" )
		{
			AddPlayerOption("Spawn", ::dofunction, 65,(-6852.98,4944.63,-53.875));
			AddPlayerOption("Tunnel", ::dofunction, 65,(-11816.2,-2245.94,228.125));
			AddPlayerOption("Diner", ::dofunction, 65,  (-5306.84,-7328.29,-56.5403));
			AddPlayerOption("Diner Roof", ::dofunction, 65,  (-6170.19,-7939.07,180.192));
			AddPlayerOption("Farm", ::dofunction, 65,  (7806.3,-5716.07,4.52546));
			AddPlayerOption("Power", ::dofunction, 65,  (10958.1,7579.58,-592.101));
			AddPlayerOption("Town", ::dofunction, 65,  (763.336,-482.006,-61.875));
			AddPlayerOption("Nav Table", ::dofunction, 65,  (7600.26,-471.402,-204.472));
			AddPlayerOption("Nacht", ::dofunction, 65,  (13722.2,-705.697,-188.875));
			AddPlayerOption("Cabin in Woods", ::dofunction, 65, (5218.29,6870.22,-20.8699));
			AddPlayerOption("Pack A Punch", ::dofunction, 65, (1173.77,820.117,-303.875));
		}
		if( level.script == "zm_nuked" )
		{
			 AddPlayerOption("Top of Green House", ::dofunction, 65, (967.235,201.494,223.084));
			 AddPlayerOption("Behind Green House", ::dofunction, 65, (1673.89,408.651,-63.6207));
			 AddPlayerOption("Top of Blue House", ::dofunction, 65, (-886.562,540.505,272.317));
			 AddPlayerOption("Behind Blue House", ::dofunction, 65,(-1523.24,425.746,-61.8431));
		}
		if( level.script == "zm_highrise" )
		{
			 AddPlayerOption("First Room", ::dofunction, 65,  (1498,1342.32,3395.94));
			 AddPlayerOption("Box 1", ::dofunction, 65,  (3124.36,2601.92,2948.72));
			 AddPlayerOption("Box 2", ::dofunction, 65,  (2142.74,2562.82,3041.53));
			 AddPlayerOption("Box 3", ::dofunction, 65,  (2817.59,373.126,2880.13));
			 AddPlayerOption("Galvaknuckles", ::dofunction, 65,  (3510.61,2084.9,2535.1));
			 AddPlayerOption("Red Room", ::dofunction, 65,  (3135.35,1433.27,1289.87));
			 AddPlayerOption("Power", ::dofunction, 65,  (2844.53,-96.6862,1296.13));
			 AddPlayerOption("The Showers", ::dofunction, 65,  (2265.68,625.208,1296.13));
			 AddPlayerOption("Trample Steam", ::dofunction, 65,  (1976.78,1387.82,3040.13));
			 AddPlayerOption("Sliquifier", ::dofunction, 65,  (2369.36,-381.108,1120.13));
			 AddPlayerOption("Roof", ::dofunction, 65,  (1893.91,-4.78527,2880.13));
		}
		if( level.script == "zm_prison" )
		{
			 AddPlayerOption("Spawn Room", ::dofunction, 65, (1272.42,10613.1,1336.13));
			 AddPlayerOption("Dog 1", ::dofunction, 65, (748.504,9670.55,1443.13));
			 AddPlayerOption("Dog 2", ::dofunction, 65,  (3846.05,9703.98,1528.13));
			 AddPlayerOption("Dog 3", ::dofunction, 65,  (56.074,6133.9,20.7776));
			 AddPlayerOption("Wardens Office", ::dofunction, 65,  (-926.433,9296.4,1336.13));
			 AddPlayerOption("Cafeteria", ::dofunction, 65,  (3199.7,9656.43,1337.13));
			 AddPlayerOption("Roof", ::dofunction, 65,  (3422.3,9657.43,1713.13));
			 AddPlayerOption("Docks", ::dofunction, 65, (-342.532,5506.14,-71.875));
			 AddPlayerOption("Well", ::dofunction, 65,  (443.324,8710.93,831.733));
			 AddPlayerOption("Laundry Room", ::dofunction, 65, (1934.44,10388.5,1144.13));
			 AddPlayerOption("Bridge", ::dofunction, 65, (-1094.95,-3411.52,-8447.88));
		}
		if( level.script == "zm_buried" )
		{
			 AddPlayerOption("First Room", ::dofunction, 65, (-3011.71,-77.8997,1367.15));
			 AddPlayerOption("Bottom FR", ::dofunction, 65,  (-2546.58,-216.273,1224.13));
			 AddPlayerOption("Bank", ::dofunction, 65, (-398.294,-147.479,8.125));
			 AddPlayerOption("Quick Revive", ::dofunction, 65, (-1011.55,-348.669,288.125));
			 AddPlayerOption("Jug", ::dofunction, 65, (-648.281,543.501,8.125));
			 AddPlayerOption("Gun Smith", ::dofunction, 65, (-611.806,-1117.24,11.1486));
			 AddPlayerOption("Candy Store", ::dofunction, 65, (631.541,-225.173,8.125));
			 AddPlayerOption("Saloon", ::dofunction, 65,(746.584,-1498.28,54.0697));
			 AddPlayerOption("Witch House", ::dofunction, 65, (2060.23,561.052,-1.71439));
			 AddPlayerOption("Speed Cola", ::dofunction, 65,  (38.557,735.95,176.125));
			 AddPlayerOption("Mid Maze", ::dofunction, 65,  (4738.87,574.212,4.125));
			 AddPlayerOption("PAP Top", ::dofunction, 65, (6939.76,413.833,108.125));
			 AddPlayerOption("Tree Glitch", ::dofunction, 65,  (1233.59,673.951,65.1979));
			 AddPlayerOption("Church", ::dofunction, 65, (1670.69,2318.92,40.125));
		}
		if( level.script == "zm_tomb" )
		{
			 AddPlayerOption("Gen 1", ::dofunction, 65,  (2165.59,4928.62,-299.875));
			 AddPlayerOption("Gen 2", ::dofunction, 65,  (-223.924,3581.41,-291.875));
			 AddPlayerOption("Gen 3", ::dofunction, 65,  (530.175,2154.68,-121.875));
			 AddPlayerOption("Gen 4", ::dofunction, 65,  (2354.08,168.991,120.125));
			 AddPlayerOption("Gen 5", ::dofunction, 65,  (-2490.62,211.856,236.625));
			 AddPlayerOption("Gen 6", ::dofunction, 65,  (976.592,-3579.86,306.125));
			 AddPlayerOption("Crazy Place", ::dofunction, 65,  (10339.8,-7903.15,-411.875));
			 AddPlayerOption("Bottom PAP", ::dofunction, 65,  (10.8768,-4.48838,-751.875));
			 AddPlayerOption("Top PAP", ::dofunction, 65,  (-173.191,-1.632,320.125));
			 AddPlayerOption("Tank at Curch", ::dofunction, 65,  (123.48,-2696.25,37.8717));
			 AddPlayerOption("Church Outside", ::dofunction, 65,  (36.0072,-1614.33,240.956));
			 AddPlayerOption("Fire Tunnel", ::dofunction, 65, (3050.47,4415.63,-606.064));
			 AddPlayerOption("Ice Tunnel", ::dofunction, 65, (1409.45,-1807.33,-122.086));
			 AddPlayerOption("Wind Tunnel", ::dofunction, 65, (3331.91,1185.32,-345.817));
			 AddPlayerOption("Lightning Tunnel", ::dofunction, 65, (-3249.52,-358.075,-189.778));
			 AddPlayerOption("Right Robot", ::dofunction, 65, (-6195.95,-6423.42,156.492));
			 AddPlayerOption("Left Robot", ::dofunction, 65, (-5696.4,-6543.79,159.375));
			 AddPlayerOption("Middle Robot", ::dofunction, 65, (-6762.56,-6541.9,159.375));
		}
	}
	else if(option == -88)
	{
		if( level.script == "zm_transit" )
		{
			AddAllPlayersOption("Spawn", ::dofunction, 65,(-6852.98,4944.63,-53.875));
			AddAllPlayersOption("Tunnel", ::dofunction, 65,(-11816.2,-2245.94,228.125));
			AddAllPlayersOption("Diner", ::dofunction, 65,  (-5306.84,-7328.29,-56.5403));
			AddAllPlayersOption("Diner Roof", ::dofunction, 65,  (-6170.19,-7939.07,180.192));
			AddAllPlayersOption("Farm", ::dofunction, 65,  (7806.3,-5716.07,4.52546));
			AddAllPlayersOption("Power", ::dofunction, 65,  (10958.1,7579.58,-592.101));
			AddAllPlayersOption("Town", ::dofunction, 65,  (763.336,-482.006,-61.875));
			AddAllPlayersOption("Nav Table", ::dofunction, 65,  (7600.26,-471.402,-204.472));
			AddAllPlayersOption("Nacht", ::dofunction, 65,  (13722.2,-705.697,-188.875));
			AddAllPlayersOption("Cabin in Woods", ::dofunction, 65, (5218.29,6870.22,-20.8699));
			AddAllPlayersOption("Pack A Punch", ::dofunction, 65, (1173.77,820.117,-303.875));
		}
		if( level.script == "zm_nuked" )
		{
			 AddAllPlayersOption("Top of Green House", ::dofunction, 65, (967.235,201.494,223.084));
			 AddAllPlayersOption("Behind Green House", ::dofunction, 65, (1673.89,408.651,-63.6207));
			 AddAllPlayersOption("Top of Blue House", ::dofunction, 65, (-886.562,540.505,272.317));
			 AddAllPlayersOption("Behind Blue House", ::dofunction, 65,(-1523.24,425.746,-61.8431));
		}
		if( level.script == "zm_highrise" )
		{
			 AddAllPlayersOption("First Room", ::dofunction, 65,  (1498,1342.32,3395.94));
			 AddAllPlayersOption("Box 1", ::dofunction, 65,  (3124.36,2601.92,2948.72));
			 AddAllPlayersOption("Box 2", ::dofunction, 65,  (2142.74,2562.82,3041.53));
			 AddAllPlayersOption("Box 3", ::dofunction, 65,  (2817.59,373.126,2880.13));
			 AddAllPlayersOption("Galvaknuckles", ::dofunction, 65,  (3510.61,2084.9,2535.1));
			 AddAllPlayersOption("Red Room", ::dofunction, 65,  (3135.35,1433.27,1289.87));
			 AddAllPlayersOption("Power", ::dofunction, 65,  (2844.53,-96.6862,1296.13));
			 AddAllPlayersOption("The Showers", ::dofunction, 65,  (2265.68,625.208,1296.13));
			 AddAllPlayersOption("Trample Steam", ::dofunction, 65,  (1976.78,1387.82,3040.13));
			 AddAllPlayersOption("Sliquifier", ::dofunction, 65,  (2369.36,-381.108,1120.13));
			 AddAllPlayersOption("Roof", ::dofunction, 65,  (1893.91,-4.78527,2880.13));
		}
		if( level.script == "zm_prison" )
		{
			 AddAllPlayersOption("Spawn Room", ::dofunction, 65, (1272.42,10613.1,1336.13));
			 AddAllPlayersOption("Dog 1", ::dofunction, 65, (748.504,9670.55,1443.13));
			 AddAllPlayersOption("Dog 2", ::dofunction, 65,  (3846.05,9703.98,1528.13));
			 AddAllPlayersOption("Dog 3", ::dofunction, 65,  (56.074,6133.9,20.7776));
			 AddAllPlayersOption("Wardens Office", ::dofunction, 65,  (-926.433,9296.4,1336.13));
			 AddAllPlayersOption("Cafeteria", ::dofunction, 65,  (3199.7,9656.43,1337.13));
			 AddAllPlayersOption("Roof", ::dofunction, 65,  (3422.3,9657.43,1713.13));
			 AddAllPlayersOption("Docks", ::dofunction, 65, (-342.532,5506.14,-71.875));
			 AddAllPlayersOption("Well", ::dofunction, 65,  (443.324,8710.93,831.733));
			 AddAllPlayersOption("Laundry Room", ::dofunction, 65, (1934.44,10388.5,1144.13));
			 AddAllPlayersOption("Bridge", ::dofunction, 65, (-1094.95,-3411.52,-8447.88));
		}
		if( level.script == "zm_buried" )
		{
			 AddAllPlayersOption("First Room", ::dofunction, 65, (-3011.71,-77.8997,1367.15));
			 AddAllPlayersOption("Bottom FR", ::dofunction, 65,  (-2546.58,-216.273,1224.13));
			 AddAllPlayersOption("Bank", ::dofunction, 65, (-398.294,-147.479,8.125));
			 AddAllPlayersOption("Quick Revive", ::dofunction, 65, (-1011.55,-348.669,288.125));
			 AddAllPlayersOption("Jug", ::dofunction, 65, (-648.281,543.501,8.125));
			 AddAllPlayersOption("Gun Smith", ::dofunction, 65, (-611.806,-1117.24,11.1486));
			 AddAllPlayersOption("Candy Store", ::dofunction, 65, (631.541,-225.173,8.125));
			 AddAllPlayersOption("Saloon", ::dofunction, 65,(746.584,-1498.28,54.0697));
			 AddAllPlayersOption("Witch House", ::dofunction, 65, (2060.23,561.052,-1.71439));
			 AddAllPlayersOption("Speed Cola", ::dofunction, 65,  (38.557,735.95,176.125));
			 AddAllPlayersOption("Mid Maze", ::dofunction, 65,  (4738.87,574.212,4.125));
			 AddAllPlayersOption("PAP Top", ::dofunction, 65, (6939.76,413.833,108.125));
			 AddAllPlayersOption("Tree Glitch", ::dofunction, 65,  (1233.59,673.951,65.1979));
			 AddAllPlayersOption("Church", ::dofunction, 65, (1670.69,2318.92,40.125));
		}
		if( level.script == "zm_tomb" )
		{
			 AddAllPlayersOption("Gen 1", ::dofunction, 65,  (2165.59,4928.62,-299.875));
			 AddAllPlayersOption("Gen 2", ::dofunction, 65,  (-223.924,3581.41,-291.875));
			 AddAllPlayersOption("Gen 3", ::dofunction, 65,  (530.175,2154.68,-121.875));
			 AddAllPlayersOption("Gen 4", ::dofunction, 65,  (2354.08,168.991,120.125));
			 AddAllPlayersOption("Gen 5", ::dofunction, 65,  (-2490.62,211.856,236.625));
			 AddAllPlayersOption("Gen 6", ::dofunction, 65,  (976.592,-3579.86,306.125));
			 AddAllPlayersOption("Crazy Place", ::dofunction, 65,  (10339.8,-7903.15,-411.875));
			 AddAllPlayersOption("Bottom PAP", ::dofunction, 65,  (10.8768,-4.48838,-751.875));
			 AddAllPlayersOption("Top PAP", ::dofunction, 65,  (-173.191,-1.632,320.125));
			 AddAllPlayersOption("Tank at Curch", ::dofunction, 65,  (123.48,-2696.25,37.8717));
			 AddAllPlayersOption("Church Outside", ::dofunction, 65,  (36.0072,-1614.33,240.956));
			 AddAllPlayersOption("Fire Tunnel", ::dofunction, 65, (3050.47,4415.63,-606.064));
			 AddAllPlayersOption("Ice Tunnel", ::dofunction, 65, (1409.45,-1807.33,-122.086));
			 AddAllPlayersOption("Wind Tunnel", ::dofunction, 65, (3331.91,1185.32,-345.817));
			 AddAllPlayersOption("Lightning Tunnel", ::dofunction, 65, (-3249.52,-358.075,-189.778));
			 AddAllPlayersOption("Right Robot", ::dofunction, 65, (-6195.95,-6423.42,156.492));
			 AddAllPlayersOption("Left Robot", ::dofunction, 65, (-5696.4,-6543.79,159.375));
			 AddAllPlayersOption("Middle Robot", ::dofunction, 65, (-6762.56,-6541.9,159.375));
		}
	}
	else if(option == 9)
	{	
		AddOption("SONG 1", ::dofunction, 90);
		AddOption("GIVE BUILDABLES PIECES", ::dofunction, 91);
		if( level.script == "zm_transit" )
		{
			AddOption("EASTER EGG", ::dofunction, 92);
			AddOption("DELETE BUS", ::dofunction, 93);
			AddSliderBool("SUPER EMP GRENADES", ::bool_functions, 94);
			AddSliderBool("UNLIMITED JET GUN", ::bool_functions, 95);
			AddSliderBool("SUPER RIOT SHIELD", ::bool_functions, 96);
			AddSliderBool("SUPER SEMTEXES", ::bool_functions, 203);
			AddSliderBool("FLYABLE BUS", ::bool_functions, 300);
			AddOption("NO LAVA DAMAGE", ::dofunction, 97);
			AddOption("NO SCREECHERS", ::dofunction, 98);
			AddSliderBool("SUPER BUS", ::bool_functions, 99);
			AddSliderBool("SHOOT LIGHTNING", ::bool_functions, 100);
			AddOption("SPAWN TURBINE", ::dofunction, 101);
			AddOption("SPAWN ELECTRIC TRAP", ::dofunction, 102);
			AddOption("SPAWN TURRET", ::dofunction, 103);
			AddOption("DEV SPHERE SHEILD", ::dofunction, 198);
			AddSliderBool("DISABLE BUS DOORS", ::bool_functions, 330);
		}
		if( level.script == "zm_nuked" )
		{
			AddOption("SONG 2", ::dofunction, 104);
			AddOption("SONG 3", ::dofunction, 105);
			AddOption("SONG 4", ::dofunction, 106);
			AddSliderBool("SUPER SEMTEXES", ::bool_functions, 203);
			AddOption("TROLL PERK SIREN", ::dofunction, 355);
		}
		if( level.script == "zm_highrise" )
		{
			AddOption("EASTER EGG", ::dofunction, 107);
			AddSliderBool("SUPER SLIQUIFIER", ::bool_functions, 108);
			AddOption("SPAWN TRAMPLESTEAM", ::dofunction, 109);
			AddSliderBool("SUPER SEMTEXES", ::bool_functions, 203);
			AddSliderBool("ELEVATORS CLOSED", ::bool_functions, 310);
			AddSliderBool("SPINNING ELEVATORS", ::bool_functions, 311);
			AddSliderBool("ELEVATORS ALWAYS MOVING", ::bool_functions, 312);
			AddSliderBool("INFINITE LEAPER ROUNDS", ::bool_functions, 331);
			AddSliderBool("DISABLE LEAPER ROUNDS", ::bool_functions, 332);
			AddOption("TELEPORT TO ELEVATOR KEY", ::dofunction, 333);
		}
		if( level.script == "zm_prison" )
		{
			AddOption("SONG 2", ::dofunction, 110);
			AddOption("EASTER EGG", ::dofunction, 111);
			AddSliderBool("FLYABLE PLANE", ::bool_functions, 300);
			AddOption("INFINITE AFTERLIFES", ::dofunction, 112);
			AddOption("SUPER RIOT SHIELD", ::dofunction, 96);
			AddOption("SPAWN A BRUTUS", ::dofunction, 113);
			AddOption("DEV SPHERE SHIELD", ::dofunction, 198);
			AddSliderBool("BLUE HANDS", ::bool_functions, 199);
			AddSliderBool("INFINITE AFTERLIFE MANA", ::bool_functions, 340);
			AddOption("FEED DOGS", ::dofunction, 358);
			AddSubMenu("NIXIE TUBES", 3);
				AddSliderInt("TUBE", 1, 1, 3, 1, ::values, 334);
				AddSliderList("VALUE", strtok("OFF,0,1,2,3,4,5,6,7,8,9", ","), ::switches, 335);
				AddOption("SET", ::dofunction, 335);
				AddOption("MESS ALL TUBES UP", ::dofunction, 336);
			EndSubMenu();
		}
		if( level.script == "zm_buried" )
		{
			AddOption("EASTER EGG", ::dofunction, 114);
			AddOption("MAXIS ENDING", ::dofunction, 115);
			AddOption("RICHTOFEN ENDING", ::dofunction, 116);
			AddSliderBool("SUPER PARALYZER", ::bool_functions, 117);
			AddSliderBool("UNLIMITED PARALYZER", ::bool_functions, 118);
			AddOption("DELETE LEROY", ::dofunction, 119);
			AddOption("SPAWN LEROY", ::dofunction, 120);
			AddOption("TELEPORT LEROY", ::dofunction, 121);
			AddOption("SPAWN 10 GHOSTS", ::dofunction, 181);
			AddOption("SPAWN TRAMPLESTEAM", ::dofunction, 109);
			AddOption("SPAWN TURBINE", ::dofunction, 101);
			AddOption("SPAWN SUBWOOFER", ::dofunction, 122);
			AddOption("SPAWN HEADCHOPPER", ::dofunction, 123);
			AddSliderBool("CONTROL LEROY", ::bool_functions, 316);
		}
		if( level.script == "zm_tomb" )
		{
			AddOption("SONG 2", ::dofunction, 124);
			AddOption("SONG 3", ::dofunction, 125);
			AddOption("EASTER EGG", ::dofunction, 126);
			AddSliderBool("FLYABLE PLANE", ::bool_functions, 300);
			AddOption("PERSONAL BOX REWARDS", ::dofunction, 127);
			AddSliderBool("INFINITE GRAMAPHONES", ::bool_functions, 129);
			AddSliderBool("INFINITE REWARDS BOX", ::bool_functions, 130);
			AddOption("SHOVEL AND HARDHAT", ::dofunction, 132);
			AddOption("SHOVEL AND HARDHAT FOR ALL", ::dofunction, 131);
			AddOption("DELETE MUD", ::dofunction, 133);
			AddOption("UPGRADE STAFFS", ::dofunction, 134);
			AddOption("SUPER RIOT SHIELD", ::dofunction, 96);
			AddOption("SPAWN PANZER SOLDAT", ::dofunction, 135);
			AddSliderBool("SUPER TANK", ::bool_functions, 136);
			AddOption("REMOVE TANK KILL BRUSH", ::dofunction, 309);
			AddSliderBool("SUPER SEMTEXES", ::bool_functions, 203);
			AddSliderBool("HIDE ROBOTS", ::bool_functions, 137);
			AddSliderBool("BOTTOMLESS SOUL BOXES", ::bool_functions, 138);
			AddOption("DEV SPHERE SHEILD", ::dofunction, 198);
			AddOption("FILL SOUL BOXES", ::dofunction, 359);
		}
	}
	else if(option == 14)
	{
		if( level.script == "zm_transit" )
		{
			AddOption("SHOCK PLAYER", ::dofunction, 149);
		}	
		if( level.script == "zm_transit" || level.script == "zm_highrise" || level.script == "zm_buried")
		{
			AddPlayerOption("INFINITE BANK MONEY", ::dofunction, 181);
		}
		if( level.script == "zm_highrise" )
			AddOption("ELEVATORS TO PLAYER", ::dofunction, 148);
		if( level.script == "zm_prison" )
			AddPlayerOption("JUMPSCARE", ::dofunction, 146);
		if( level.script == "zm_tomb" )
			AddPlayerOption("JUMPSCARE", ::dofunction, 147);
	}
	else if(option == 30)
	{
		value = "test_sphere_lambert,test_macbeth_chart,test_macbeth_chart_unlit,";
		arg1 = "zombie_teddybear,defaultactor" + ",";
		if(level.script == "zm_transit")
		{
			arg1 += "c_zom_player_reporter_fb,c_zom_player_engineer_fb,c_zom_player_farmgirl_fb,c_zom_player_oldman_fb,c_zom_avagadro_fb,p6_anim_zm_bus_driver,c_zom_zombie1_body01,c_zom_zombie1_body02";
			value += "p6_anim_zm_magic_box_fake,p6_anim_zm_magic_box,p_rus_door_white_window_plain_left,p_rus_door_white_plain_right,storefront_door02_window,p_cub_door01_wood_fullsize,p6_zm_bank_vault_door,p6_zm_core_reactor_top,p6_door_metal_no_decal_left,p6_zm_window_dest_glass_big,p6_zm_garage_door_01,p6_zm_door_security_depot,veh_t6_civ_bus_zombie,p6_anim_zm_bus_driver,veh_t6_civ_movingtrk_cab_dead,veh_t6_civ_bus_zombie_roof_hatch,p6_anim_zm_buildable_turret,p6_anim_zm_buildable_etrap,p6_anim_zm_buildable_turbine,p6_anim_zm_buildable_sq,zombie_teddybear,p6_anim_zm_buildable_pap,zombie_sign_please_wait,ch_tombstone1,zombie_bomb,zombie_skull,zombie_ammocan,zombie_x2_icon,zombie_carpenter,t6_wpn_zmb_shield_dmg1_world,t6_wpn_zmb_shield_dmg2_world,p6_zm_screecher_hole,p6_zm_buildable_battery,t6_wpn_zmb_shield_dolly,t6_wpn_zmb_shield_door,p6_zm_buildable_pap_body,p6_zm_buildable_pap_table,p6_zm_buildable_turbine_fan,p6_zm_buildable_turbine_rudder,p6_zm_buildable_turbine_mannequin,p6_zm_buildable_turret_mower,p6_zm_buildable_turret_ammo,p6_zm_buildable_etrap_base,p6_zm_buildable_etrap_tvtube,p6_zm_buildable_jetgun_wires,p6_zm_buildable_jetgun_engine,p6_zm_buildable_jetgun_guages,p6_zm_buildable_jetgun_handles,p6_zm_buildable_sq_electric_box,p6_zm_buildable_sq_meteor,p6_zm_buildable_sq_scaffolding,p6_zm_buildable_sq_transceiver,p_glo_tools_chest_tall";
		}
		if(level.script == "zm_nuked")
		{
			arg1 += "c_zom_player_cdc_fb,c_zom_player_cia_fb,c_zom_dlc0_zom_haz_body1,c_zom_dlc0_zom_haz_body2";
			value += "p6_anim_zm_magic_box_fake,p6_anim_zm_magic_box,zombie_wolf,p6_zm_nuked_chair_01,p6_zm_nuked_couch_02,p6_zm_door_white,p6_zm_door_brown,p6_zm_cratepile,defaultvehicle,fxanim_gp_shirt01_mod,fxanim_gp_tanktop_mod,fxanim_gp_dress_mod,fxanim_gp_pant01_mod,fxanim_gp_shirt_grey_mod,fxanim_gp_roaches_mod,fxanim_zom_nuketown_shutters_mod,fxanim_zom_curtains_yellow_a_mod,fxanim_zom_curtains_yellow_b_mod,fxanim_zom_curtains_yellow_c_mod,fxanim_zom_curtains_blue_a_mod,fxanim_zom_curtains_blue_c_mod,fxanim_zom_nuketown_cabinets_brwn_mod,fxanim_zom_nuketown_cabinets_red_mod,fxanim_zom_nuketown_shutters02_mod,fxanim_gp_cloth_sheet_med01_mod,fxanim_zom_nuketown_cabinets_brwn02_mod,fxanim_gp_roofvent_small_mod,fxanim_gp_wirespark_long_mod,fxanim_gp_wirespark_med_mod,mp_nuked_townsign_counter,dest_zm_nuked_male_01_d0,p_rus_clock_green_sechand,p_rus_clock_green_minhand,p_rus_clock_green_hourhand,p6_zm_nuked_clocktower_sec_hand,p6_zm_nuked_clocktower_min_hand,dest_zm_nuked_female_01_d0,dest_zm_nuked_female_02_d0,dest_zm_nuked_female_03_d0,dest_zm_nuked_male_02_d0,zombie_teddybear,t6_wpn_zmb_perk_bottle_doubletap_world,t6_wpn_zmb_perk_bottle_jugg_world,t6_wpn_zmb_perk_bottle_revive_world,t6_wpn_zmb_perk_bottle_sleight_world,zombie_bomb,zombie_skull,zombie_ammocan,zombie_x2_icon,zombie_firesale";
		}
		if(level.script == "zm_highrise")
		{
			arg1 += "c_zom_player_reporter_fb,c_zom_player_engineer_fb,c_zom_player_farmgirl_fb,c_zom_player_oldman_fb,c_zom_leaper_body,c_zom_zombie_civ_shorts_body";
			value += "p6_anim_zm_magic_box_fake,p6_anim_zm_magic_box,p6_zm_hr_luxury_door,p6_zm_nuked_couch_02,p6_zm_hr_lion_statue_ball,p6_anim_zm_hr_buildable_sq,p6_anim_zm_buildable_tramplesteam,zombie_teddybear,zombie_pickup_perk_bottle,p6_zm_buildable_tramplesteam_door,p6_zm_buildable_tramplesteam_bellows,p6_zm_buildable_tramplesteam_compressor,p6_zm_buildable_tramplesteam_flag,t6_zmb_buildable_slipgun_extinguisher,t6_zmb_buildable_slipgun_cooker,t6_zmb_buildable_slipgun_foot,t6_zmb_buildable_slipgun_throttle,p6_zm_buildable_sq_electric_box,p6_zm_buildable_sq_meteor,p6_zm_buildable_sq_scaffolding,p6_zm_buildable_sq_transceiver";
		}
		if(level.script == "zm_prison")
		{
			arg1 += "c_zom_player_arlington_fb,c_zom_player_deluca_fb,c_zom_player_handsome_fb,c_zom_player_oleary_fb,c_zom_cellbreaker_fb,c_zom_guard_body,c_zom_inmate_body1,c_zom_inmate_body2";
			value += "p6_anim_zm_al_magic_box,storefront_door02_window,p6_zm_al_cell_door_collmap,p6_zm_al_cell_isolation,p6_zm_al_large_generator,fxanim_zom_al_trap_fan_mod,p6_zm_al_gondola,p6_zm_al_gondola_gate,p6_zm_al_gondola_door,p6_zm_al_shock_box_off,p6_zm_al_cell_door,veh_t6_dlc_zombie_plane_whole,p6_zm_al_electric_chair,p6_zm_al_infirmary_case,p6_zm_al_industrial_dryer,p6_zm_al_clothes_pile_lrg,veh_t6_dlc_zombie_part_engine,p6_zm_al_dream_catcher_off,c_zom_wolf_head,zombie_bomb,zombie_skull,zombie_ammocan,zombie_x2_icon,zombie_firesale,zombie_teddybear,t6_wpn_zmb_shield_dlc2_dmg0_view,p6_zm_al_packasplat_suitcase,p6_zm_al_packasplat_engine,p6_zm_al_packasplat_iv,veh_t6_dlc_zombie_part_fuel,veh_t6_dlc_zombie_part_rigging,p6_anim_zm_al_packasplat,p6_zm_al_shock_box_on,p6_zm_al_audio_headset_icon,p6_zm_al_power_station_panels_03";
		}
		if( level.script == "zm_buried" )
		{
			arg1 += "c_zom_player_reporter_fb,c_zom_player_engineer_fb,c_zom_player_farmgirl_fb,c_zom_player_oldman_fb,c_zom_buried_sloth_fb,c_zom_zombie_buried_sgirl_body1,c_zom_zombie_buried_sgirl_body2";
			value += "p6_anim_zm_magic_box_fake,p6_anim_zm_magic_box,p6_zm_work_bench,p6_anim_zm_buildable_view_tramplesteam,p6_anim_zm_buildable_turbine,t6_wpn_zmb_subwoofer,p6_anim_zm_buildable_tramplesteam,p6_anim_zm_hr_buildable_sq,fxanim_zom_buried_orbs_mod,p6_zm_bu_gallows,p6_zm_bu_guillotine,p6_zm_bu_end_game_machine,t6_wpn_zmb_chopper,zombie_teddybear,zombie_pickup_perk_bottle,p6_zm_bu_hedge_gate,p6_zm_buildable_turbine_fan,p6_zm_buildable_turbine_rudder,p6_zm_buildable_turbine_mannequin,p6_zm_buildable_tramplesteam_door,p6_zm_buildable_tramplesteam_bellows,p6_zm_buildable_tramplesteam_compressor,p6_zm_buildable_tramplesteam_flag,p6_zm_buildable_sq_electric_box,p6_zm_buildable_sq_meteor,p6_zm_buildable_sq_scaffolding,p6_zm_buildable_sq_transceiver,p6_zm_bu_sq_vaccume_tube,p6_zm_bu_sq_buildable_battery,p6_zm_bu_sq_crystal,p6_zm_bu_sq_satellite_dish,p6_zm_bu_sq_antenna,p6_zm_bu_sq_wire_spool,p6_zm_bu_booze,p6_zm_bu_sloth_candy_bowl,p6_zm_bu_chalk,p6_zm_bu_sloth_booze_jug";
		}
		if(level.script == "zm_tomb")
		{
			arg1 += "c_zom_tomb_dempsey_fb,c_zom_tomb_nikolai_fb,c_zom_tomb_richtofen_fb,c_zom_tomb_takeo_fb,c_zom_mech_body,c_zom_tomb_german_body2";
			value += "p6_anim_zm_tm_magic_box,veh_t6_dlc_mkiv_tank,veh_t6_dlc_zm_biplane,fxanim_zom_tomb_portal_mod,p6_zm_tm_packapunch,fxanim_zom_tomb_generator_pump_mod,p6_zm_tm_wind_ceiling_ring_2,p6_zm_tm_wind_ceiling_ring_3,p6_zm_tm_wind_ceiling_ring_4,p6_zm_tm_wind_ceiling_ring_1,p6_zm_tm_challenge_box,p6_zm_tm_soul_box,veh_t6_dlc_zm_quadrotor,zombie_teddybear,veh_t6_dlc_zm_zeppelin,p6_zm_tm_gramophone,veh_t6_dlc_zm_robot_2";
		}
		menuModels = []; 
		foreach(model in strtok(arg1,","))
			if(!isInArray(menuModels, model) )
				menuModels[ menuModels.size ] = model;
		foreach(model in getEntArray("script_model", "classname"))
			if(!isInArray(menuModels, model.model) )
				menuModels[ menuModels.size ] = model.model;
		foreach(model in strtok(value,","))
			if(!isInArray(menuModels, model) )
				menuModels[ menuModels.size ] = model;
		return menuModels;
	}
	else if(option == 31)
	{
		if ( isDefined( level.legacy_cymbal_monkey ) && level.legacy_cymbal_monkey )
		{
			arg1 = "weapon_zombie_monkey_bomb,";
		}
		else
		{
			arg1 = "t6_wpn_zmb_monkey_bomb_world,";
		}
		if(level.script == "zm_transit")
		{
			arg1 += "c_zom_player_reporter_fb,c_zom_player_engineer_fb,c_zom_player_farmgirl_fb,c_zom_player_oldman_fb,c_zom_avagadro_fb,p6_anim_zm_bus_driver,c_zom_zombie1_body01,c_zom_zombie1_body02";
		}
		if(level.script == "zm_nuked")
		{
			arg1 += "c_zom_player_cdc_fb,c_zom_player_cia_fb,c_zom_dlc0_zom_haz_body1,c_zom_dlc0_zom_haz_body2";
		}
		if(level.script == "zm_highrise")
		{
			arg1 += "c_zom_player_reporter_fb,c_zom_player_engineer_fb,c_zom_player_farmgirl_fb,c_zom_player_oldman_fb,c_zom_leaper_body,c_zom_zombie_civ_shorts_body";
		}
		if(level.script == "zm_prison")
		{
			arg1 += "c_zom_player_arlington_fb,c_zom_player_deluca_fb,c_zom_player_handsome_fb,c_zom_player_oleary_fb,c_zom_cellbreaker_fb,c_zom_guard_body,c_zom_inmate_body1,c_zom_inmate_body2";
		}
		if( level.script == "zm_buried" )
		{
			arg1 += "c_zom_player_reporter_fb,c_zom_player_engineer_fb,c_zom_player_farmgirl_fb,c_zom_player_oldman_fb,c_zom_buried_sloth_fb,c_zom_zombie_buried_sgirl_body1,c_zom_zombie_buried_sgirl_body2";
		}
		if(level.script == "zm_tomb")
		{
			arg1 += "c_zom_tomb_dempsey_fb,c_zom_tomb_nikolai_fb,c_zom_tomb_richtofen_fb,c_zom_tomb_takeo_fb,c_zom_mech_body,c_zom_tomb_german_body2";
		}
		return strtok(arg1, ",");
	}
	else if(option == 35)
	{
		if(level.script == "zm_transit" || level.script == "zm_highrise")
			vms = strTok("c_zom_farmgirl_viewhands,c_zom_oldman_viewhands,c_zom_engineer_viewhands,c_zom_reporter_viewhands", ",");
		if(level.script == "zm_buried")
			vms = strTok("c_zom_farmgirl_viewhands,c_zom_oldman_viewhands,c_zom_engineer_viewhands", ",");
		if(level.script == "zm_tomb")
			vms = strTok("c_zom_richtofen_viewhands,c_zom_nikolai_viewhands,c_zom_takeo_viewhands,c_zom_dempsey_viewhands", ",");
		if(level.script == "zm_prison")
			vms = strTok("c_zom_arlington_coat_viewhands,c_zom_deluca_longsleeve_viewhands,c_zom_handsome_sleeveless_viewhands,c_zom_oleary_shortsleeve_viewhands", ",");
		if(level.script == "zm_nuked")
			vms = strTok("c_zom_hazmat_viewhands_light,c_zom_suit_viewhands", ",");
		return vms;
	}
	return "";
}























