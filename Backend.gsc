InitializeMenu()
{
	level.MAX_VERIFICATION = 4;
	level.menuHudCounts = [];
	level.Evanescence = spawnstruct();
	level.Evanescence.Options = [];
	level.Evanescence.Menus = [];
	level.Evanescence.ClientVariables = [];
	level.si_current_menu = 0;
	level.si_next_menu = 0;
	level.si_players_menu = -2;
	level.si_settings_menu = -3;
	level.si_previous_menus = [];
	level.si_allplayers_menu = -4;
	level.e_start_v = 5;
	level.e_start_h = -285;
	level.bg_h = 0;
	level.bg_v = 0;
	level.bg_width = 875;
	level.bg_height = 490;
	if(isdefined(level.i_bg_h)) //Assume all are defined
	{
		level.bg_h = level.i_bg_h;
		level.bg_v = level.i_bg_v;
		level.bg_width = level.i_bg_width;
		level.bg_height = level.i_bg_height;
	}

	if(isdefined(level.i_pref_vertical))
	{
		level.e_start_v = level.i_pref_vertical;
	}
	if(isdefined(level.i_pref_horizontal))
	{
		level.e_start_h = level.i_pref_horizontal;
	}
	MakeOptions();
	GetHost() CreateMenu( level.MAX_VERIFICATION );
	level.menu_initialized = 1;
}

GetHost()
{
	foreach( player in level.players )
		if( player isHost() )
			return player;
}

VerificationMonitor()
{
	self notify("VerificationMonitor");
	self endon("VerificationMonitor");
	self waittill("VerificationChange", verification);
	self DeleteMenu();
	if( verification > 0 )
	{
		self CreateMenu( verification );
		self LoadMenu();
	}
	self thread VerificationMonitor();
}

LoadMenu()
{
	if( GetAccess() < 1 )
		return;
	self thread WelcomeMessage();
	self thread ControlMonitor();
}

DeleteMenu()
{
	Menu = self GetMenu();
	Menu.Title destroy();
	Menu.bg Destroy();
	foreach( elem in Menu.text )
		elem Destroy();
	foreach( elem in Menu.sliders )
		elem destroy();
	Menu StructDelete();
	self setBlur( 0, .1);
}

GetMenu()
{
	return level.Evanescence.Menus[ self GetName() ];
}

GetAccess()
{
	if( !isDefined(GetMenu()) )
		return 0;
	return GetMenu().access;
}

CreateDefaultMenu()
{
	struct = spawnstruct();
	struct.access = 1;
	struct.cursors = [];
	struct.currentmenu = -1;
	struct.selectedplayer = undefined;
	struct.preferences = spawnstruct();
	struct.preferences.disable_blur = !level.i_blur_menu;
	struct.preferences.disable_bg = !level.i_bg_enabled;
	struct.preferences.bg = level.i_bg_color;
	struct.preferences.bga = level.i_bg_alpha;
	struct.preferences.highlight = level.i_highlight_color;
	struct.preferences.text = level.i_text_color;
	struct.preferences.title = level.i_title_color;
	struct.preferences.freezecontrols = !level.i_freezecontrols;
	struct.preferences.controlscheme = [];
	struct.preferences.controlscheme = level.i_controls;
	struct = LoadUserPreferences( self GetName(), struct );
	struct.bg = self createShader(level.i_bg_shader, "CENTER", "CENTER", 0, 0, 875, 490, struct.preferences.bg, 0, 0);
	struct.text = [];
	struct.sliders = [];
	return struct;
}

LoadUserPreferences( playername, struct )
{
	if( !isDefined( GetDvar( playername + "EPreferences" ) ) || GetDvar( playername + "EPreferences" ) == "" )
	{
		SetUserPreferences( playername, 0, Int(struct.preferences.bg[0] * 255)+","+Int(struct.preferences.bg[1] * 255)+","+Int(struct.preferences.bg[2] * 255)+","+Int(struct.preferences.bga * 255)+";" );
		SetUserPreferences( playername, 1, Int(struct.preferences.highlight[0] * 255)+","+Int(struct.preferences.highlight[1] * 255)+","+Int(struct.preferences.highlight[2] * 255)+";" );
		SetUserPreferences( playername, 2, Int(struct.preferences.text[0] * 255)+","+Int(struct.preferences.text[1] * 255)+","+Int(struct.preferences.text[2] * 255)+";" );
		SetUserPreferences( playername, 3, Int(struct.preferences.title[0] * 255)+","+Int(struct.preferences.title[1] * 255)+","+Int(struct.preferences.title[2] * 255)+";" );
		SetUserPreferences( playername, 4, struct.preferences.freezecontrols + ";");
		str = "";
		foreach(val in struct.preferences.controlscheme)
		{
			str += val + ",";
		}
		str = getsubstr(str,0,str.size - 1);
		SetUserPreferences( playername, 5, str + ";" );
		SetUserPreferences( playername, 6, struct.preferences.disable_blur + ";" );
		SetUserPreferences( playername, 7, struct.preferences.disable_bg + ";" );
		return struct;
	}
	dvar = GetDvar( playername + "EPreferences" );
	prefs = [];
	bg = [];
	highlight = [];
	text = [];
	title = [];
	prefs = strtok( dvar, ";" );
	bg = strtok( prefs[0], "," );
	struct.preferences.bg = [];
	struct.preferences.bg = ( (Int( bg[0] ) / 255.0), ( Int( bg[1] ) / 255.0 ), ( Int( bg[2] ) / 255.0 ) );
	struct.preferences.bga = Int( bg[3] ) / 255.0;
	highlight = strtok( prefs[1], "," );
	struct.preferences.highlight = [];
	struct.preferences.highlight = ( (Int( highlight[0] ) / 255.0), ( Int( highlight[1] ) / 255.0 ), ( Int( highlight[2] ) / 255.0 ) );
	text = strtok( prefs[2], "," );
	struct.preferences.text = [];
	struct.preferences.text = ( (Int( text[0] ) / 255.0), ( Int( text[1] ) / 255.0 ), ( Int( text[2] ) / 255.0 ) );
	title = strtok( prefs[3], "," );
	struct.preferences.title = [];
	struct.preferences.title = ( (Int( title[0] ) / 255.0), ( Int( title[1] ) / 255.0 ), ( Int( title[2] ) / 255.0 ) );
	struct.preferences.freezecontrols = Int( prefs[4] );
	struct.preferences.controlscheme = [];
	struct.preferences.controlscheme = strtok( prefs[5], "," );
	struct.preferences.disable_blur = Int( prefs[6] );
	struct.preferences.disable_bg = Int( prefs[7] );
	return struct;
}

SetUserPreferences( playername, prefindex, value )
{
	if( !isDefined( GetDvar( playername + "EPreferences" ) ) || GetDvar( playername + "EPreferences" ) == "" )
	{
		SetDvar( playername + "EPreferences", "0,0,0,204;255,128,0;255,255,255;255,255,255;0;[{+actionslot 1}],[{+actionslot 2}],[{+actionslot 3}],[{+actionslot 4}],[{+gostand}],[{+melee}],[{+attack}],[{+speed_throw}];0;0" ); //Default Prefs to be safe
	}
	dvar = GetDvar( playername + "EPreferences" );
	prefs = [];
	prefs = strtok( dvar, ";" );
	prefs[ prefindex ] = value;
	dvar = "";
	for( i = 0; i < prefs.size - 1; i++ )
		dvar += prefs[i] + ";";
	dvar += prefs[ prefs.size - 1 ];
	SetDvar( playername + "EPreferences", dvar );
}

CreateMenu( verification )
{
	level.Evanescence.Menus[ self GetName() ] = self CreateDefaultMenu();
	level.Evanescence.Menus[ self GetName() ].access = verification;
}

CloseMenu()
{
	Menu = self GetMenu();
	Menu.currentmenu = -1;
	UpdateMenu();
}

AddAllPlayersMenu(title, access)
{
	AddSubMenu(title, access);
	level.si_allplayers_menu = level.si_current_menu;
}

AddOption(title, function, arg1, arg2, arg3, arg4, arg5)
{
	level.menuHudCounts[ level.si_current_menu ]++;
	CheckHuds();
	parentmenu = level.Evanescence.Options[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function = function;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	parentmenu.options[parentmenu.options.size - 1].arg1 = arg1;
	parentmenu.options[parentmenu.options.size - 1].arg2 = arg2;
	parentmenu.options[parentmenu.options.size - 1].arg3 = arg3;
	parentmenu.options[parentmenu.options.size - 1].arg4 = arg4;
	parentmenu.options[parentmenu.options.size - 1].arg5 = arg5;
}

AddPlayerOption( title, function, arg1, arg2, arg3, arg4 )
{
	AddOption(title, ::playerwrapperfunction, function, arg1, arg2, arg3, arg4);
}

AddAllPlayersOption( title, function, arg1, arg2, arg3, arg4)
{
	AddOption(title, ::AllPlayersWrapperfunction, function, arg1, arg2, arg3, arg4);
}

AllPlayersWrapperfunction( function, arg1, arg2, arg3, arg4)
{
	foreach(player in level.players)
	{
		if(self.allplayerswhost || player != GetHost())
			player thread [[ function ]]( arg1, arg2, arg3, arg4);
	}
}

PlayerWrapperFunction( function, arg1, arg2, arg3, arg4 )
{
	Menu = self getMenu();
	Menu.selectedplayer thread [[ function ]]( arg1, arg2, arg3, arg4 );
	self UI_Done();
}

AddSubMenu(title, access)
{
	level.menuHudCounts[ level.si_current_menu ]++;
	CheckHuds();
	level.si_previous_menus[level.si_previous_menus.size] = level.si_current_menu;
	parentmenu = level.Evanescence.options[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function = ::submenu;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	level.si_next_menu++;
	parentmenu.options[parentmenu.options.size - 1].arg1 = level.si_next_menu;
	parentmenu.options[parentmenu.options.size - 1].arg2 = access;
	struct = spawnstruct();
	struct.options = [];
	struct.pages = [];
	struct.title = title;
	struct.parentmenu = level.si_current_menu; 
	level.Evanescence.options[level.si_next_menu] = struct;
	level.si_current_menu = level.si_next_menu;
	level.menuHudCounts[ level.si_current_menu ] = 0;
}

AddSettingsSubMenu(title, access)
{
	AddSubMenu(title, access);
	level.si_settings_menu = level.si_current_menu;
}

CyclePage()
{
	parentmenu = level.Evanescence.options[level.si_current_menu];
	parentmenu.pages[parentmenu.pages.size] = spawnstruct();
	parentmenu.pages[parentmenu.pages.size - 1].title = parentmenu.title;
	parentmenu.pages[parentmenu.pages.size - 1].pageprevious = level.si_current_menu;
	parentmenu.pages[parentmenu.pages.size - 1].function = ::pagenext;
	level.si_next_menu++;
	parentmenu.pages[parentmenu.pages.size - 1].arg1 = level.si_next_menu;
	parentmenu.pages[parentmenu.pages.size - 1].arg2 = parentmenu.access;
	struct = spawnstruct();
	struct.options = [];
	struct.pages = [];
	struct.isPage = 1;
	struct.title = parentmenu.title;
	struct.pageprevious = level.si_current_menu;
	struct.parentmenu = parentmenu.parentmenu; 
	level.Evanescence.options[level.si_next_menu] = struct;
	level.si_current_menu = level.si_next_menu;
	level.menuHudCounts[ level.si_current_menu ] = 0;
}

Submenu( child , access)
{
	Menu = self GetMenu();
	if(Menu.access < access)
	{
		return;
	}
	Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] notify("Deselected");
	self PlayLocalSound("cac_grid_equip_item");
	Menu.currentMenu = child;
	if(Menu.currentMenu == level.si_players_menu)
		Menu.selectedPlayer = level.players[ Menu.cursors[ Menu.currentmenu ] ];
	Menu.cursors[ Menu.CurrentMenu ] = 0;
	UpdateMenu();
}

PageNext( child, access )
{
	Menu = self GetMenu();
	Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] notify("Deselected");
	self PlayLocalSound("cac_grid_equip_item");
	Menu.currentMenu = child;
	Menu.cursors[ Menu.CurrentMenu ] = 0;
	//Slide anim
	foreach( slider in Menu.sliders )
	{
		slider moveovertime( .15 );
		slider.x -= 720;
	}
	foreach( text in Menu.text )
	{
		text moveovertime( .15 );
		text.x -= 720;
	}
	wait .15;
	foreach( slider in Menu.sliders )
		slider destroy();
	foreach( text in Menu.text )
		text destroy();
	Menu.text = [];
	Menu.sliders = [];
	self UpdateMenu( 0, 1, 720 );	
}

AddPlayersMenu( title, access )
{
	AddSubMenu( title, access );
	level.si_players_menu = level.si_current_menu;
	for(i=0;i<17;i++)
	{
		AddSubMenu("hubbajubba", access);
		EndPlayersSubMenu();
	}
	AddSubMenu("PLAYER", access);
}

CreateMain( title )
{
	struct = spawnstruct();
	struct.options = [];
	struct.title = title;
	struct.parentmenu = -1;
	struct.pages = [];
	level.menuHudCounts[0] = 0;
	level.Evanescence.options[0] = struct;
}

EndPlayersMenu()
{
	EndSubMenu();
	EndSubMenu();
}

EndPlayersSubMenu()
{
	level.si_next_menu--;
	EndSubMenu();
}

EndSubMenu()
{
	if(level.si_previous_menus.size < 1)
		return;
	level.si_current_menu = level.si_previous_menus[level.si_previous_menus.size - 1];
	level.si_previous_menus[level.si_previous_menus.size - 1] = undefined;
}

PerformOption()
{
	Menu = self GetMenu();
	SMenu = level.Evanescence.options[ Menu.currentmenu ];
	if( Menu.currentmenu == level.si_players_menu)
		Menu.selectedplayer = level.players[ Menu.cursors[ Menu.currentMenu ] ];
	si_menu = SMenu.options[ Menu.cursors[ Menu.currentMenu ] ];
	if( isDefined(si_menu.function) && si_menu.function != ::submenu)
		self PlayLocalSound("cac_enter_cac");
	self thread [[ si_menu.function ]]( si_menu.arg1, si_menu.arg2, si_menu.arg3, si_menu.arg4, si_menu.arg5 );
}

PulseOptionHighlight( player )
{
	self endon("Deselected");
	thread DeselectedReset( player );
	if( isDefined( self.Disabled ) )
		self.color = (.75,.3,0);
	else
		self.color = (player GetMenu()).preferences.highlight;
	while( isDefined( self ) )
	{
		self fadeovertime(.49);
		if( isDefined( self.Disabled ) )
			self.alpha = .25;
		else
			self.alpha = .5;
		wait .5;
		self fadeovertime(.49);
		if( isDefined( self.Disabled ) )
			self.alpha = .5;
		else
			self.alpha = 1;
		wait .5;
	}
}

DeselectedReset( player )
{
	self waittill("Deselected");
	if( isDefined( self.Disabled ) )
		self.alpha = .75;
	else
		self.alpha = 1;
	if( isDefined( self.Disabled ) )
		self.color = (.5,.5,.5);
	else
		self.color = (player GetMenu()).preferences.text;
	self fadeovertime(.01); //Cancel old fade
	if( isDefined( self.Disabled ) )
		self.color = (.5,.5,.5);
	else
		self.color = (player GetMenu()).preferences.text;
}

SelectedOption( player )
{
	if( isDefined( self.Disabled ) )
		self.color = (.75,.3,0);
	else
		self.color = (player GetMenu()).preferences.highlight;
	self thread PulseOptionHighlight( player );
}

isSlider( Menu, Index )
{
	return isDefined( level.Evanescence.options[ Menu ].options[ Index ].SliderInfo );
}

isPlayerSlider( Menu, Index )
{
	return isDefined( level.Evanescence.options[ Menu ].options[ Index ].SliderInfo.playerslider );
}

UpdateMenu( Init, FixHint, page )
{
	self notify("MenuUpateInbound");
	self endon("MenuUpateInbound");
	Menu = self GetMenu();
	if( !isDefined( Menu ) )
		return;
	offset = 0;
	HintForPage = "";
	FixHint = true;
	if( isDefined( page ) && page != 0 )
		level.page_offset[ self GetName() ] = page;
	if( isDefined(level.Evanescence.options[Menu.currentMenu].pageprevious ) )
	{
		HintForPage += Menu.preferences.controlscheme[7] + " Page Left\t";
	}
	if( IsDefined(GetPage( Menu.currentMenu )) )
	{
		HintForPage += Menu.preferences.controlscheme[6] + " Page Right";
	}
	if( isDefined( page ) && page != 0 )
	{
		offset = page;
	}
	if(Menu.CurrentMenu == level.si_settings_menu)
	{
		SetSliderValue(Menu.currentMenu, 0, Menu.Preferences.freezecontrols);
		SetSliderValue(Menu.currentMenu, 1, Menu.Preferences.disable_blur);
		SetSliderValue(Menu.currentMenu, 2, Menu.Preferences.disable_bg);
	}	
	if( Menu.CurrentMenu == -1 )
	{
		Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] notify("Deselected");
		Menu.Title fadeovertime( .15 );
		Menu.Title moveovertime( .15 );
		Menu.Title ChangeFontScaleOverTime( .15 );
		Menu.Title.x -= 90;
		Menu.Title.y -= 60;
		Menu.Title.fontscale = 3.5;
		Menu.Title.alpha = 0;
		foreach( elem in  Menu.text )
		{
			elem fadeovertime( .15 );
			elem moveovertime( .15 );
			elem ChangeFontScaleOverTime( .15 );
			elem.x -= 90;
			elem.y -= 60;
			elem.alpha = 0;
			elem.fontscale = 2.4;
		}
		Menu.hint FadeOverTime( .15 );
		Menu.hint.alpha = 0;
		if(!Menu.preferences.disable_bg)
		{
			Menu.bg FadeOverTime( .15 );
			Menu.bg.alpha = 0;
		}
		if(!Menu.preferences.disable_blur)
			self setblur(0 , .15 );
		wait .15;
		foreach( text in Menu.text )
			text Destroy();
		foreach( slider in Menu.Sliders )
			slider destroy();
		Menu.Title destroy();
		Menu.hint destroy();
		self setclientuivisibilityflag( "hud_visible", 3 );
		if(isdefined(self.freezeobject))
			self unlink();
		self.freezeobject delete();
		self enableweapons();
		self freezecontrols( false );
		level notify("EvanescenceClose");
		return;
	}
	if( isDefined(FixHint) && FixHint )
	{
		Menu.hint destroy();
		Menu.hint = self drawText(Menu.preferences.controlscheme[4] + " Select\t" + Menu.preferences.controlscheme[5] +" Back\t"+HintForPage, "small", 1.3, "LEFT", "BOTTOM", -290, 0, (1,1,1), 1, (0,0,0), 0, 1); 
	}
	if( IsDefined( Init ) && Init )
	{
		if(!Menu.preferences.disable_bg)
		{
			Menu.bg FadeOverTime( .15 );
			Menu.bg.alpha = Menu.preferences.bga;
		}
		if(!Menu.preferences.disable_blur)
			self setblur( 2.5, .15 );
		self setclientuivisibilityflag( "hud_visible", 0 );
		//Menu.hint = self drawText(Menu.preferences.controlscheme[4] + " Select\t" + Menu.preferences.controlscheme[5] +" Back\t"+HintForPage, "small", 1.3, "LEFT", "BOTTOM", -290, 0, (1,1,1), 1, (0,0,0), 0, 1); 
		if( !Menu.preferences.freezecontrols )
		{
			self.freezeobject = spawn("script_origin", self.origin);
			self playerlinkto( self.freezeobject, undefined );
			self disableweapons();
		}
		self enableweaponcycling();
		self PlayLocalSound("uin_main_pause");
	}
	if( IsDefined( Init ) && Init && Menu.CurrentMenu == 0 )
	{
		if( ! isDefined( Menu.cursors[ Menu.CurrentMenu ] ) )
		{
			Menu.cursors[ Menu.CurrentMenu ] = 0;
		}
		foreach( text in Menu.text )
			text destroy();
		foreach( slider in Menu.Sliders )
			slider destroy();
		Menu.Title = self drawText(level.Evanescence.options[ Menu.CurrentMenu ].Title, "big", 3.5, "LEFT", "TOP", (level.e_start_h - 90), (level.e_start_v - 60), Menu.preferences.title, 0, (0,0,0), 0, 1);
		for( i = 0; i < level.Evanescence.options[ Menu.CurrentMenu ].options.size; i++ )
		{
			Menu.text[i] = self drawText(level.Evanescence.options[ Menu.CurrentMenu ].options[ i ].Title, "objective", 2.4, "LEFT", "TOP", (level.e_start_h - 90), (level.e_start_v - 65) + (30 + (i * 20 )), Menu.preferences.text, 0, (0,0,0), 0, 1);
		}
		Menu.Title fadeovertime( .15 );
		Menu.Title moveovertime( .15 );
		Menu.Title ChangeFontScaleOverTime( .15 );
		Menu.Title.x += 90;
		Menu.Title.y += 60;
		Menu.Title.fontscale = 2.6;
		Menu.Title.alpha = 1;
		foreach( elem in  Menu.text )
		{
			elem fadeovertime( .15 );
			elem moveovertime( .15 );
			elem ChangeFontScaleOverTime( .15 );
			elem.x += 90;
			elem.y += 60;
			elem.alpha = 1;
			elem.fontscale = 1.6;
		}
		wait .15;
		for( i = 0; i < level.Evanescence.options[ Menu.CurrentMenu ].options.size; i++ )
		{
			if( level.Evanescence.options[ Menu.CurrentMenu ].options[ i ].function == ::submenu && level.Evanescence.options[ Menu.CurrentMenu ].options[ i ].arg2 > Menu.access )
			{
				Menu.text[i] fadeovertime( .15 );
				Menu.text[i].alpha = .5;
				Menu.text[i].color = (.5,.5,.5);
				Menu.text[i].Disabled = true;
			}
		}
		Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] thread SelectedOption( self );
	}
	else if( Menu.CurrentMenu != level.si_players_menu )
	{
		if( ! isDefined( Menu.cursors[ Menu.CurrentMenu ] ) )
		{
			Menu.cursors[ Menu.CurrentMenu ] = 0;
		}
		foreach( text in Menu.text )
			text destroy();
		foreach( slider in Menu.Sliders )
			slider destroy();
		Menu.text = [];
		Menu.sliders = [];
		Menu.Title destroy();
		if( Menu.CurrentMenu == (level.si_players_menu + 1) )
		{
			Menu.Title = self drawText(Menu.selectedplayer GetName(), "big", 2.6, "LEFT", "TOP", level.e_start_h, level.e_start_v, Menu.preferences.title, 1, (0,0,0), 0, 1);
		}
		else
		{
			Menu.Title = self drawText(level.Evanescence.options[ Menu.CurrentMenu ].Title, "big", 2.6, "LEFT", "TOP", level.e_start_h, level.e_start_v, Menu.preferences.title, 1, (0,0,0), 0, 1);
		}
		for( i = 0; i < level.Evanescence.options[ Menu.CurrentMenu ].options.size; i++ )
		{
			Menu.text[i] = self drawText(level.Evanescence.options[ Menu.CurrentMenu ].options[ i ].Title, "objective", 1.6, "LEFT", "TOP", level.e_start_h + offset, (level.e_start_v - 5) + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
			if( level.Evanescence.options[ Menu.CurrentMenu ].options[ i ].function == ::submenu && level.Evanescence.options[ Menu.CurrentMenu ].options[ i ].arg2 > Menu.access )
			{
				Menu.text[i].alpha = .5;
				Menu.text[i].color = (.5,.5,.5);
				Menu.text[i].Disabled = true;
			}
			if( isSlider( Menu.CurrentMenu, i ) )
			{
				option = level.Evanescence.options[ Menu.currentmenu ].options[ i ];
				if( isPlayerSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) )
				{
					if( isDefined( option.sliderInfo.isBool ) )
					{
						if( isDefined( option.sliderinfo.value[ Menu.selectedPlayer GetName() ] ) && option.sliderinfo.value[ Menu.selectedPlayer GetName() ] )
						{
							Menu.sliders[ option.title ] = self drawText(Menu.preferences.controlscheme[2] + "\tENABLED\t" + Menu.preferences.controlscheme[3], "objective", 1.6, "LEFT", "TOP", (level.e_start_h + 285) + level.menu_sliderOffsetAlign + offset, (level.e_start_v - 5) + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
						}
						else
						{
							Menu.sliders[ option.title ] = self drawText(Menu.preferences.controlscheme[2] + "\tDISABLED\t" + Menu.preferences.controlscheme[3], "objective", 1.6, "LEFT", "TOP", (level.e_start_h + 285) + level.menu_sliderOffsetAlign + offset, (level.e_start_v - 5) + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
						}
					}
					else if( isDefined( option.sliderInfo.isVal ) )
					{
						if( !isDefined( option.sliderInfo.value[ Menu.selectedPlayer GetName() ] ) )
							option.sliderInfo.value[ Menu.selectedPlayer GetName() ] = option.sliderinfo.defaultvalue;
						Menu.sliders[ option.title ] = self drawText(Menu.preferences.controlscheme[2] + "\t"+ option.sliderInfo.value[ Menu.selectedPlayer GetName() ] +"\t" + Menu.preferences.controlscheme[3], "objective", 1.6, "LEFT", "TOP", level.menu_sliderOffsetAlign + offset, (level.e_start_v - 5) + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
					}
					else if( isDefined( option.sliderInfo.isStringList ) )
					{
						if( !isDefined( option.sliderinfo.index[ Menu.selectedPlayer GetName() ] ) )
							option.sliderinfo.index[ Menu.selectedPlayer GetName() ] = 0;
						Menu.sliders[ option.title ] = self drawText(Menu.preferences.controlscheme[2] + "\t" + option.sliderinfo.list[ option.sliderinfo.index[ Menu.selectedPlayer GetName() ] ] + "\t" + Menu.preferences.controlscheme[3], "objective", 1.6, "LEFT", "TOP", (level.e_start_h + 285) + level.menu_sliderOffsetAlign + offset, (level.e_start_v - 5) + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
					}
				}
				else
				{
					if( isDefined( option.sliderInfo.isBool ) )
					{
						if( isDefined( option.sliderinfo.value[ self GetName() ] ) && option.sliderinfo.value[ self GetName() ] )
						{
							Menu.sliders[ option.title ] = self drawText(Menu.preferences.controlscheme[2] + "\tENABLED\t" + Menu.preferences.controlscheme[3], "objective", 1.6, "LEFT", "TOP", (level.e_start_h + 285) + level.menu_sliderOffsetAlign + offset, (level.e_start_v - 5) + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
						}
						else
						{
							Menu.sliders[ option.title ] = self drawText(Menu.preferences.controlscheme[2] + "\tDISABLED\t" + Menu.preferences.controlscheme[3], "objective", 1.6, "LEFT", "TOP", (level.e_start_h + 285) + level.menu_sliderOffsetAlign + offset, (level.e_start_v - 5) + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
						}
					}
					else if( isDefined( option.sliderInfo.isVal ) )
					{
						if( !isDefined( option.sliderInfo.value[ self GetName() ] ) )
							option.sliderInfo.value[ self GetName() ] = option.sliderinfo.defaultvalue;
						Menu.sliders[ option.title ] = self drawText(Menu.preferences.controlscheme[2] + "\t"+ option.sliderInfo.value[ self GetName() ] +"\t" + Menu.preferences.controlscheme[3], "objective", 1.6, "LEFT", "TOP", (level.e_start_h + 285) + level.menu_sliderOffsetAlign + offset, (level.e_start_v - 5) + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
					}
					else if( isDefined( option.sliderInfo.isStringList ) )
					{
						if( !isDefined( option.sliderInfo.index[ self GetName() ] ) )
							option.sliderInfo.index[ self GetName() ] = 0;
						Menu.sliders[ option.title ] = self drawText(Menu.preferences.controlscheme[2] + "\t" + option.sliderinfo.list[ option.sliderinfo.index[ self GetName() ] ] + "\t" + Menu.preferences.controlscheme[3], "objective", 1.6, "LEFT", "TOP", (level.e_start_h + 285) + level.menu_sliderOffsetAlign + offset, (level.e_start_v - 5) + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
					}
				}
			}
		}
		if( isDefined( page ) && page != 0 )
		{
			foreach( elem in Menu.text )
			{
				elem moveovertime( .15 );
				elem.x -= offset;
			}
			foreach( elem in Menu.sliders )
			{
				elem moveovertime( .15 );
				elem.x -= offset;
			}
			wait .15;
		}
		Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] thread SelectedOption( self );
		if( isSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ))
		{
			Menu.sliders[ level.Evanescence.options[ Menu.currentmenu ].options[ Menu.cursors[ Menu.currentMenu ] ].title ] thread SelectedOption( self );
		}
	}
	else if( Menu.CurrentMenu == level.si_players_menu )
	{
		if( ! isDefined( Menu.cursors[ Menu.CurrentMenu ] ) )
		{
			Menu.cursors[ Menu.CurrentMenu ] = 0;
		}
		foreach( text in Menu.text )
			text destroy();
		if( isDefined( Menu.Sliders ) )
		{
			foreach( slider in Menu.Sliders )
				slider destroy();
		}
		Menu.text = [];
		Menu.sliders = [];
		Menu.Title destroy();
		Menu.Title = self drawText(level.Evanescence.options[ Menu.CurrentMenu ].Title, "big", 2.6, "LEFT", "TOP", level.e_start_h, level.e_start_v, Menu.preferences.title, 1, (0,0,0), 0, 1);
		for( i = 0; i < level.players.size; i++ )
		{
			Menu.text[i] = self drawText(level.players[i] GetName(), "objective", 1.6, "LEFT", "TOP", level.e_start_h, (level.e_start_v - 5) + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
		}
		Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] thread SelectedOption( self );
	}
	level.page_offset[ self GetName() ] = 0;
}

CallerSetAccess( vlevel )
{
	GetHost() SetAccess(vlevel, (self GetMenu()).selectedplayer, self);
}

SetAccess( vlevel, player, caller )
{
	if( player ishost() )
	{
		caller iprintln("You cannot change the host's access level");
		return;
	}
	ClearAccess( player );
	player notify("VerificationChange", vlevel);
	if( vlevel < 1 )
		return;
	dvar = GetDvar("EvanescenceVerification"+vlevel);
	dvar += ( player GetName() );
	SetDvar("EvanescenceVerification"+vlevel, dvar );
}

ClearAccess( player )
{
	for( i =1; i <= level.MAX_VERIFICATION; i++ )
	{
		dvar = getDvar("EvanescenceVerification"+i);
		if( dvar != "" )
		{
			dvar2 = [];
			dvar2 = strtok(dvar, ";");
			arrayremovevalue( dvar2, player GetName() );
			dvar = "";
			foreach( key in dvar2 )
				dvar += key + ";";
			SetDvar("EvanescenceVerification"+i, dvar);
		}
	}
}

VerifyDvarListedPlayer( player )
{
	for( i =1; i <= level.MAX_VERIFICATION; i++ )
	{
		dvar = getDvar("EvanescenceVerification"+i);
		if( dvar != "" )
		{
			dvar2 = [];
			dvar2 = strtok(dvar, ";");
			foreach( key in dvar2 )
			{
				player2 = getPlayerFromName( key );
				if( IsDefined( player2 ) && player2 == player )
				{
					player CreateMenu( i );
					player thread LoadMenu();
				}
			}
		}
	}
}

SetCVar( player, variable, value )
{
	level.Evanescence.ClientVariables[ player getname() ][variable] = value;
}

GetCVar( variable, allplayers )
{
	if(self == level.iconic_allplayers)
	{
		return level.Evanescence.ClientVariables[ self getname() ][variable];
	}
	if(isdefined(level.iconic_allplayers GetCVar(variable)) && isdefined(allplayers) && allplayers)
	{
		return level.iconic_allplayers GetCVar(variable);
	}
	return level.Evanescence.ClientVariables[ self getname() ][variable];
}

GetCBool( variable, allplayers )
{
	return isDefined( GetCVar( variable, allplayers ) ) && GetCVar( variable, allplayers );
}

Toggle( variable )
{
	bool = GetCBool( variable );
	SetCVar( self, variable, !bool );
	return !bool;
}

AddAllplayersSliderBool(title, OnChanged, arg1, arg2, arg3, arg4 )
{
	AddSliderBool(title, ::APSBWrapper, OnChanged, arg1, arg2, arg3, arg4 );
}

APSBWrapper( OnChanged, arg1, arg2, arg3, arg4 )
{
	result = level.iconic_allplayers Toggle(arg1);
	foreach(player in level.players)
	{
		if(self.allplayerswhost || player != GetHost())
			player thread [[ OnChanged ]]( arg1, arg2, arg3, arg4, true);
	}
	return result;
}

AddSliderBool(title, OnChanged, arg1, arg2, arg3, arg4, arg5 )
{
	level.menuHudCounts[ level.si_current_menu ]+=2;
	CheckHuds();
	parentmenu = level.Evanescence.Options[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function = OnChanged;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	parentmenu.options[parentmenu.options.size - 1].arg1 = arg1;
	parentmenu.options[parentmenu.options.size - 1].arg2 = arg2;
	parentmenu.options[parentmenu.options.size - 1].arg3 = arg3;
	parentmenu.options[parentmenu.options.size - 1].arg4 = arg4;
	parentmenu.options[parentmenu.options.size - 1].arg5 = arg5;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.isBool = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.value = [];
}

AddPlayerSliderBool(title, OnChanged, arg1, arg2, arg3, arg4, arg5 )
{
	level.menuHudCounts[ level.si_current_menu ]+=2;
	CheckHuds();
	parentmenu = level.Evanescence.Options[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function = OnChanged;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	parentmenu.options[parentmenu.options.size - 1].arg1 = arg1;
	parentmenu.options[parentmenu.options.size - 1].arg2 = arg2;
	parentmenu.options[parentmenu.options.size - 1].arg3 = arg3;
	parentmenu.options[parentmenu.options.size - 1].arg4 = arg4;
	parentmenu.options[parentmenu.options.size - 1].arg5 = arg5;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.playerslider = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.passPlayer = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.isBool = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.value = [];
}

AddSliderInt( title, defaultValue, minvalue, maxvalue, Increment, Onchanged, arg2, arg3, arg4, arg5 )
{
	level.menuHudCounts[ level.si_current_menu ]+=2;
	CheckHuds();
	parentmenu = level.Evanescence.Options[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function = OnChanged;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	parentmenu.options[parentmenu.options.size - 1].arg1 = undefined;
	parentmenu.options[parentmenu.options.size - 1].arg2 = arg2;
	parentmenu.options[parentmenu.options.size - 1].arg3 = arg3;
	parentmenu.options[parentmenu.options.size - 1].arg4 = arg4;
	parentmenu.options[parentmenu.options.size - 1].arg5 = arg5;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.isVal = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.value = [];
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.defaultValue = defaultValue;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.minvalue = minvalue;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.maxvalue = maxvalue;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.Increment = Increment;
}

AddPlayerSliderInt( title, defaultValue, minvalue, maxvalue, Increment, Onchanged, arg2, arg3, arg4, arg5 )
{
	level.menuHudCounts[ level.si_current_menu ]+=2;
	CheckHuds();
	parentmenu = level.Evanescence.Options[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function = OnChanged;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	parentmenu.options[parentmenu.options.size - 1].arg1 = undefined;
	parentmenu.options[parentmenu.options.size - 1].arg2 = arg2;
	parentmenu.options[parentmenu.options.size - 1].arg3 = arg3;
	parentmenu.options[parentmenu.options.size - 1].arg4 = arg4;
	parentmenu.options[parentmenu.options.size - 1].arg5 = arg5;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.playerslider = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.isVal = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.value = [];
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.defaultvalue = defaultvalue;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.minvalue = minvalue;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.maxvalue = maxvalue;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.Increment = Increment;
}


AddAllPlayersSliderList(title, strings, OnChanged, arg2, arg3, arg4)
{
	AddSliderList(title, strings, ::APSLWrapper, OnChanged, arg2, arg3, arg4 );
}

APSLWrapper( value, OnChanged, arg2, arg3, arg4 )
{
	level.iconic_allplayers [[ OnChanged ]](value, arg2, arg3, arg4);
	foreach(player in level.players)
	{
		if(self.allplayerswhost || player != GetHost())
			player thread [[ OnChanged ]](value, arg2, arg3, arg4);
	}
	return result;
}

AddPlayerSliderList(title, strings, OnChanged, arg2, arg3, arg4, arg5 )
{
	level.menuHudCounts[ level.si_current_menu ]+=2;
	CheckHuds();
	parentmenu = level.Evanescence.Options[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function = OnChanged;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	parentmenu.options[parentmenu.options.size - 1].arg1 = undefined;
	parentmenu.options[parentmenu.options.size - 1].arg2 = arg2;
	parentmenu.options[parentmenu.options.size - 1].arg3 = arg3;
	parentmenu.options[parentmenu.options.size - 1].arg4 = arg4;
	parentmenu.options[parentmenu.options.size - 1].arg5 = arg5;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.playerslider = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.isStringList = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.index = [];
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.list = strings;
}

AddSliderList(title, strings, OnChanged, arg2, arg3, arg4, arg5 )
{
	level.menuHudCounts[ level.si_current_menu ]+=2;
	CheckHuds();
	parentmenu = level.Evanescence.Options[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function = OnChanged;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	parentmenu.options[parentmenu.options.size - 1].arg1 = undefined;
	parentmenu.options[parentmenu.options.size - 1].arg2 = arg2;
	parentmenu.options[parentmenu.options.size - 1].arg3 = arg3;
	parentmenu.options[parentmenu.options.size - 1].arg4 = arg4;
	parentmenu.options[parentmenu.options.size - 1].arg5 = arg5;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.isStringList = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.index = [];
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.list = strings;
}

Slider( direction )
{
	Menu = self GetMenu();
	if( isSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) )
	{
		self PlayLocalSound("cac_grid_nav");
		if( isPlayerSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) )
		{
			self thread PlayerSlider( direction );
			return;
		}
		option = level.Evanescence.options[ Menu.currentmenu ].options[ Menu.cursors[ Menu.currentMenu ] ];
		if( isDefined( option.sliderInfo.isBool ) )
		{
			if( !isDefined( option.sliderinfo.value[ self GetName() ] ) )
				option.sliderinfo.value[ self GetName() ] = false;
			option.sliderinfo.value[ self GetName() ] = self [[ option.function ]]( option.arg1, option.arg2, option.arg3, option.arg4, option.arg5 );
			if( option.sliderinfo.value[ self GetName() ] )
			{
				Menu.sliders[ option.title ] SetSafeText(Menu.preferences.controlscheme[2] + "\tENABLED\t" + Menu.preferences.controlscheme[3]);
			}
			else
			{
				Menu.sliders[ option.title ] SetSafeText(Menu.preferences.controlscheme[2] + "\tDISABLED\t" + Menu.preferences.controlscheme[3]);
			}
		}
		else if( isDefined( option.sliderInfo.isVal ) )
		{
			if( !isDefined( option.sliderinfo.value[ self GetName() ] ) )
				option.sliderinfo.value[ self GetName() ] = option.sliderinfo.defaultvalue;
			option.sliderinfo.value[ self GetName() ] = option.sliderinfo.value[ self GetName() ] + ( direction * option.sliderinfo.Increment );
			if( isDefined( option.sliderinfo.minvalue ) && option.sliderinfo.value[ self GetName() ] < option.sliderinfo.minvalue)
				option.sliderinfo.value[ self GetName() ] = option.sliderinfo.minvalue;
			if( isDefined( option.sliderinfo.maxvalue ) && option.sliderinfo.value[ self GetName() ] > option.sliderinfo.maxvalue )
				option.sliderinfo.value[ self GetName() ] = option.sliderinfo.maxvalue;
			self thread [[ option.function ]]( option.sliderinfo.value[ self GetName() ], option.arg2, option.arg3, option.arg4, option.arg5 );
			Menu.sliders[ option.title ] SetSafeText(Menu.preferences.controlscheme[2] + "\t"+ option.sliderinfo.value[ self GetName() ] +"\t" + Menu.preferences.controlscheme[3]);
		}
		else if( isDefined( option.sliderInfo.isStringList ) )
		{
			if( !isDefined( option.sliderinfo.index[ self GetName() ] ) )
				option.sliderinfo.index[ self GetName() ] = 0;
			option.sliderinfo.index[ self GetName() ] += direction;
			if( option.sliderinfo.index[ self GetName() ] < 0 )
				option.sliderinfo.index[ self GetName() ] = (option.sliderinfo.list.size - 1);
			else if( option.sliderinfo.index[ self GetName() ] >= option.sliderinfo.list.size )
				option.sliderinfo.index[ self GetName() ] = 0;
			self thread [[ option.function ]]( option.sliderinfo.list[ option.sliderinfo.index[ self GetName() ] ], option.arg2, option.arg3, option.arg4, option.arg5 );
			Menu.sliders[ option.title ] SetSafeText(Menu.preferences.controlscheme[2] + "\t"+ option.sliderinfo.list[ option.sliderinfo.index[ self GetName() ] ] +"\t" + Menu.preferences.controlscheme[3]);
		}
	}
}

PlayerSlider( direction )
{
	Menu = self GetMenu();
	if( isSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) )
	{
		option = level.Evanescence.options[ Menu.currentmenu ].options[ Menu.cursors[ Menu.currentMenu ] ];
		if( isDefined( option.sliderInfo.isBool ) )
		{
			if( !isDefined( option.sliderinfo.value[ Menu.selectedPlayer GetName() ] ) )
				option.sliderinfo.value[ Menu.selectedPlayer GetName() ] = false;
			option.sliderinfo.value[ Menu.selectedPlayer GetName() ] = Menu.SelectedPlayer [[ option.function ]]( option.arg1, option.arg2, option.arg3, option.arg4, option.arg5 );
			if( option.sliderinfo.value[ Menu.selectedPlayer GetName() ] )
			{
				Menu.sliders[ option.title ] SetSafeText(Menu.preferences.controlscheme[2] + "\tENABLED\t" + Menu.preferences.controlscheme[3]);
			}
			else
			{
				Menu.sliders[ option.title ] SetSafeText(Menu.preferences.controlscheme[2] + "\tDISABLED\t" + Menu.preferences.controlscheme[3]);
			}
		}
		else if( isDefined( option.sliderInfo.isVal ) )
		{
			if( !isDefined( option.sliderinfo.value[ Menu.selectedPlayer GetName() ] ) )
				option.sliderinfo.value[ Menu.selectedPlayer GetName() ] = option.sliderinfo.defaultvalue;
			if( isDefined( option.sliderinfo.minvalue ) && option.sliderinfo.value[ Menu.selectedPlayer GetName() ] < option.sliderinfo.minvalue)
				option.sliderinfo.value[ Menu.selectedPlayer GetName() ] = option.sliderinfo.minvalue;
			if( isDefined( option.sliderinfo.maxvalue ) && option.sliderinfo.value[ Menu.selectedPlayer GetName() ] > option.sliderinfo.maxvalue )
				option.sliderinfo.value[ Menu.selectedPlayer GetName() ] = option.sliderinfo.maxvalue;
			option.sliderinfo.value[ Menu.selectedPlayer GetName() ] = option.sliderinfo.value[ Menu.selectedPlayer GetName() ] + ( direction * option.sliderinfo.Increment );
			Menu.SelectedPlayer thread [[ option.function ]]( option.sliderinfo.value[ Menu.selectedPlayer GetName() ], option.arg2, option.arg3, option.arg4, option.arg5 );
			Menu.sliders[ option.title ] SetSafeText(Menu.preferences.controlscheme[2] + "\t"+ option.sliderinfo.value[ Menu.selectedPlayer GetName() ] +"\t" + Menu.preferences.controlscheme[3]);
		}
		else if( isDefined( option.sliderInfo.isStringList ) )
		{
			if( !isDefined( option.sliderinfo.index[ Menu.selectedPlayer GetName() ] ) )
				option.sliderinfo.index[ Menu.selectedPlayer GetName() ] = 0;
			option.sliderinfo.index[ Menu.selectedPlayer GetName() ] += direction;
			if( option.sliderinfo.index[ Menu.selectedPlayer GetName() ] < 0 )
				option.sliderinfo.index[ Menu.selectedPlayer GetName() ] = (option.sliderinfo.list.size - 1);
			else if( option.sliderinfo.index[ Menu.selectedPlayer GetName() ] >= option.sliderinfo.list.size )
				option.sliderinfo.index[ Menu.selectedPlayer GetName() ] = 0;
			Menu.SelectedPlayer thread [[ option.function ]]( option.sliderinfo.list[ option.sliderinfo.index[ Menu.selectedPlayer GetName() ] ], option.arg2, option.arg3, option.arg4, option.arg5 );
			Menu.sliders[ option.title ] SetSafeText(Menu.preferences.controlscheme[2] + "\t"+ option.sliderinfo.list[ option.sliderinfo.index[ Menu.selectedPlayer GetName() ] ] +"\t" + Menu.preferences.controlscheme[3]);
		}
	}
}


IsButtonPressed( button )
{
	if(GetCBool(47))
	{
		if( button == "[{+actionslot 1}]" && (self GetMenu()).currentmenu == -1 )
			return self MeleeButtonPressed() && self ADSButtonPressed();
	}
	if( button == "[{+actionslot 1}]" )
		return self actionslotonebuttonpressed();
	if( button == "[{+actionslot 2}]" )
		return self actionslottwobuttonpressed();
	if( button == "[{+actionslot 3}]" )
		return self actionslotthreebuttonpressed();
	if( button == "[{+actionslot 4}]" )
		return self actionslotfourbuttonpressed();
	if( button == "[{+gostand}]" )
		return self jumpbuttonpressed();
	if( button == "[{+melee}]" )
		return self meleebuttonpressed();
	if( button == "[{+attack}]" )
		return self attackbuttonpressed();
	if( button == "[{+speed_throw}]" )
		return self adsbuttonpressed();
	if( button == "[{+smoke}]" )
		return self secondaryoffhandbuttonpressed();
	if( button == "[{+frag}]" )
		return self fragbuttonpressed();
	if( button == "[{+usereload}]" )
		return self usebuttonpressed();
	if( button == "[{+weapnext_inventory}]" )
		return self changeseatbuttonpressed();
	if( button == "[{+stance}]" )
		return self stancebuttonpressed();
	return false; //Unknown button
}

PersonalizeMenu( value, setting, subsetting )
{
	Menu = self GetMenu();
	index = 0;
	value2 = undefined;
	if( setting == "TITLE COLOR" )
	{
		index = 3;
		value2 = [];
		if( subsetting == "RED VALUE" )
		{
			value2 = (value / 255.0, Menu.preferences.title[1], Menu.preferences.title[2]);
		}
		if( subsetting == "GREEN VALUE" )
		{
			value2 = (Menu.preferences.title[0], value / 255.0, Menu.preferences.title[2]);
		}
		if( subsetting == "BLUE VALUE" )
		{
			value2 = (Menu.preferences.title[0], Menu.preferences.title[1], value / 255.0);
		}
		Menu.title fadeovertime( .05 );
		Menu.title.color = value2;
		Menu.preferences.title = value2;
	}
	if( setting == "BACKGROUND COLOR" )
	{
		index = 0;
		value2 = [];
		if( subsetting == "RED VALUE" )
		{
			value2 = (value / 255.0, Menu.preferences.bg[1], Menu.preferences.bg[2]);
		}
		else if( subsetting == "GREEN VALUE" )
		{
			value2 = (Menu.preferences.bg[0], value / 255.0, Menu.preferences.bg[2]);
		}
		else if( subsetting == "BLUE VALUE" )
		{
			value2 = (Menu.preferences.bg[0], Menu.preferences.bg[1], value / 255.0);
		}
		else if( subsetting == "ALPHA" )
		{
			value2 = (Menu.preferences.bg[0], Menu.preferences.bg[1], Menu.preferences.bg[2]);
			value3 = value / 255.0;
		}
		Menu.bg fadeovertime( .05 );
		Menu.bg.color = value2;
		if(isdefined(value3))
		{
			Menu.bg.alpha = value3;
			Menu.preferences.bga = value3;
		}
		Menu.preferences.bg = value2;
		value4 = [];
		value4[0] = value2[0];
		value4[1] = value2[1];
		value4[2] = value2[2];
		if(isdefined(value3))
		{
			value4[3] = value3;
		}
		else
		{
			value4[3] = Menu.preferences.bga;
		}
		for(i = 0; i < value4.size; i++)
		{
			value4[i] *= 255;
		}
		toset = "" + Int( value4[0] ) + ","+ Int( value4[1] ) + ","+ Int( value4[2] ) + "," + Int( value4[3] );
		SetUserPreferences( self GetName(), index, toset );
		return;
	}
	if( setting == "TEXT COLOR" )
	{
		index = 2;
		value2 = [];
		if( subsetting == "RED VALUE" )
		{
			value2 = (value / 255.0, Menu.preferences.text[1], Menu.preferences.text[2]);
		}
		if( subsetting == "GREEN VALUE" )
		{
			value2 = (Menu.preferences.text[0], value / 255.0, Menu.preferences.text[2]);
		}
		if( subsetting == "BLUE VALUE" )
		{
			value2 = (Menu.preferences.text[0], Menu.preferences.text[1], value / 255.0);
		}
		self UpdateMenu();
		Menu.preferences.text = value2;
	}
	if( setting == "HIGHLIGHT COLOR" )
	{
		index = 1;
		value2 = [];
		if( subsetting == "RED VALUE" )
		{
			value2 = (value / 255.0, Menu.preferences.highlight[1], Menu.preferences.highlight[2]);
		}
		if( subsetting == "GREEN VALUE" )
		{
			value2 = (Menu.preferences.highlight[0], value / 255.0, Menu.preferences.highlight[2]);
		}
		if( subsetting == "BLUE VALUE" )
		{
			value2 = (Menu.preferences.highlight[0], Menu.preferences.highlight[1], value / 255.0);
		}
		self UpdateMenu();
		Menu.preferences.highlight = value2;
	}
	if( setting == "CONTROLS" )
	{
		index = 5;
		value2 = Menu.preferences.controlscheme;
		value2[ subsetting ] = value;		
		Menu.preferences.controlscheme = value2;
		toset = "";
		for( i = 0; i < value2.size - 1; i++ )
			toset += value2[i] + ",";
		toset += value2[ value2.size - 1 ];
		SetUserPreferences( self GetName(), index, toset );
		self UpdateMenu();
		return;
	}
	value2 = ( value2 * (255,255,255) );
	toset = "" + Int( value2[0] ) + ","+ Int( value2[1] ) + ","+ Int( value2[2] );
	SetUserPreferences( self GetName(), index, toset );
}

ControlsValidate()
{
	Menu = self getmenu();
	for( i = 0; i < Menu.preferences.controlscheme.size; i++)
	{
		for( j = i + 1; j < Menu.preferences.controlscheme.size; j++ )
		{
			if( Menu.preferences.controlscheme[i] == Menu.preferences.controlscheme[j] )
			{
				self iprintln("Invalid controls. Resetting to default controls...");
				SetUserPreferences( self GetName(), 5, "[{+actionslot 1}],[{+actionslot 2}],[{+actionslot 3}],[{+actionslot 4}],[{+gostand}],[{+melee}],[{+attack}],[{+speed_throw}]" );
				Menu.preferences.controlscheme = strtok("[{+actionslot 1}],[{+actionslot 2}],[{+actionslot 3}],[{+actionslot 4}],[{+gostand}],[{+melee}],[{+attack}],[{+speed_throw}]", ",");
				return;
			}
		}
	}
	self iprintln("Settings saved successfully.");
}

PersonalizeFreeze()
{
	Menu = self GetMenu();
	Menu.preferences.freezecontrols = !Menu.preferences.freezecontrols;
	SetUserPreferences( self GetName(), 4, Menu.preferences.freezecontrols );
	if(!Menu.preferences.freezecontrols)
	{
		if(!isDefined(self.freezeobject))
		{
			self.freezeobject = spawn("script_origin", self.origin);
			self playerlinkto( self.freezeobject, undefined );
			self disableweapons();
		}
	}
	else
	{
		if(isDefined(self.freezeobject))
		{
			self unlink();
			self.freezeobject delete();
			self enableweapons();
		}
	}	
	return Menu.preferences.freezecontrols;
}

PersonalizeBG(index)
{
	Menu = self GetMenu();
	if(index == 0)
	{
		Menu.preferences.disable_blur = !Menu.preferences.disable_blur;
		SetUserPreferences( self GetName(), 6, Menu.preferences.disable_blur );
		if(Menu.preferences.disable_blur)
		{
			self SetBlur(0, .05);
		}
		else
		{
			self SetBlur(2.5, .05);
		}
		return Menu.preferences.disable_blur;
	}
	else
	{
		Menu.preferences.disable_bg = !Menu.preferences.disable_bg;
		SetUserPreferences( self GetName(), 7, Menu.preferences.disable_bg );
		if(Menu.preferences.disable_bg)
		{
			Menu.bg.alpha = 0;
		}
		else
		{
			Menu.bg.alpha = Menu.preferences.bga;
		}
		return Menu.preferences.disable_bg;
	}	
}

LoadPreferenceSliderInfo( setting )
{
	Menu = self GetMenu();
	value = [];
	if( setting == "TITLE COLOR" )
	{
		value = VectorScale(Menu.preferences.title, 255);
	}
	if( setting == "BACKGROUND COLOR" )
	{
		value[0] = VectorScale(Menu.preferences.bg, 255)[0];
		value[1] = VectorScale(Menu.preferences.bg, 255)[1];
		value[2] = VectorScale(Menu.preferences.bg, 255)[2];
		value[3] = Int(Menu.preferences.bga * 255);
	}
	if( setting == "TEXT COLOR" )
	{
		value = VectorScale(Menu.preferences.text, 255);
	}
	if( setting == "HIGHLIGHT COLOR" )
	{
		value = VectorScale(Menu.preferences.highlight, 255);
	}
	if( setting == "CONTROLS" )
	{
		index = 0;
		for( i = 1; i < 9; i++ )
		{
			index = ListIndexOf(GetSliderList(Menu.currentmenu, i), Menu.preferences.controlscheme[ i - 1 ]);
			self SetSliderIndex( Menu.currentmenu, i, index );
		}
	}
	else
	{
		self SetSliderValue( Menu.currentmenu, 1, Int( value[0] ) );
		self SetSliderValue( Menu.currentmenu, 2, Int( value[1] ) );
		self SetSliderValue( Menu.currentmenu, 3, Int( value[2] ) );
		if(value.size > 3)
			self SetSliderValue( Menu.currentmenu, 4, Int( value[3] ) );
	}
	self UpdateMenu();
}

SetSliderValue( menu, option, value )
{
	GetSlider(menu, option).value[ self GetName() ] = value;
}

GetSlider( menu, option )
{
	return level.Evanescence.options[ menu ].options[ option ].sliderinfo;
}

SetSliderIndex( menu, option, index )
{
	GetSlider(menu, option).index[ self GetName() ] = index;
}

GetSliderList( menu, option )
{
	return GetSlider(menu, option).list;
}

ListIndexOf( list, string )
{
	for( i = 0; i < list.size; i++ )
		if( list[i] == string )
			return i;
	return 0;
}

CheckHuds()
{
	if( level.menuHudCounts[ level.si_current_menu ] > 17 && level.si_current_menu != level.si_players_menu)
	{
		CyclePage();
	}
}

GetEvanescence()
{
	return level.Evanescence.options;
}

NextPage()
{
	Menu = self GetMenu();
	page = GetPage( Menu.currentMenu );
	if( !isDefined( page ) )
	{
		return;
	}
	self thread [[ page.function ]]( page.arg1, page.arg2 );
}

PreviousPage()
{
	Menu = self GetMenu();
	lastmenu = level.Evanescence.options[ Menu.currentmenu ].pageprevious;
	if( !isDefined( lastmenu ) )
	{
		return;
	}
	foreach( elem in Menu.text )
	{
		elem moveOverTime( .15 );
		elem.x += 1080;
	}
	foreach( elem in Menu.sliders )
	{
		elem moveOverTime( .15 );
		elem.x += 1080;
	}
	wait .15;
	foreach( elem in Menu.text )
		elem destroy();
	foreach( elem in Menu.sliders )
		elem destroy();
	Menu.currentMenu = lastmenu;
	self UpdateMenu( 0, 0, -720);
}

GetPage( menu )
{
	return GetEvanescence()[ menu ].pages[0];
}





