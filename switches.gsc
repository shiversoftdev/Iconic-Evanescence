switches( value, __option__, arg2, arg3, arg4)
{
	if(__option__ == 16)
	{
		self.perk_to_give = value;
	}
	else if(__option__ == 17)
	{
		self.points_precision = Int(value);
	}
	else if(__option__ == 43)
	{
		self thread loops(43, arg2, value);
	}
	else if(__option__ == 20)
	{
		self.weapon_to_give = value;
	}
	else if(__option__ == 191)
	{
		foreach( door in getentarray( "zombie_door", "targetname" ) )
		{
			door.zombie_cost = Int(value);
			door maps/mp/zombies/_zm_utility::set_hint_string( door, "default_buy_door", Int(value) );
		}
		foreach( door in getentarray( "zombie_airlock_buy", "targetname" ) )
		{
			door.zombie_cost = Int(value);
			door maps/mp/zombies/_zm_utility::set_hint_string( door, "default_buy_door", Int(value) );
		}
		foreach( door in getentarray( "zombie_debris", "targetname" ) )
		{
			door.zombie_cost = Int(value);
			door maps/mp/zombies/_zm_utility::set_hint_string( door, "default_buy_door", Int(value) );
		}
	}
	else if(__option__ == 37)
	{
		if(value == "NORMAL")
		{
			self useServerVisionSet(false);
		}
		else
		{
			self useServerVisionSet(true);
			self setVisionSetforPlayer(value, 0);
		}
	}
	else if(__option__ == 41)
	{
		foreach(box in level.chests)
			box.zombie_cost = Int(value);
	}
	else if(__option__ == -159)
	{
		self.zombie_weapons = value;
	}
	else if(__option__ == 45)
	{
		self.other_model = value;
	}
	else if(__option__ == 44)
	{
		if(value == "NONE")
			return;
		self setModel( value );
	}
	else if(__option__ == 46)
	{
		self.menuModels = value;
	}
	else if(__option__ == 56)
	{
		self thread loops(__option__, value);
	}
	else if(__option__ == 57)
	{
		level thread loops(57, value);
	}
	else if(__option__ == 62)
	{
		self.powerup = value;
	}
	else if(__option__ == 63)
	{
		self.rounds_precision = Int(value);
	}
	else if(__option__ == 88)
	{
		self.zombie_vars_precision = Int(value);
	}
	else if(__option__ == -88)
	{
		self._option_ = value;
	}
	else if(__option__ == 144)
	{
		self.tallies_value = Int(value);
	}
	else if(__option__ == -302)
	{
		self.selected_zombie_var = value;
	}
	else if(__option__ == 302)
	{
		self.selected_zombie_var_precision = Int(value);
	}
	else if(__option__ == 305)
	{
		self SetCVar(self, 305, value);
	}
	else if(__option__ == 315)
	{
		self notify("_option_" + 315);
		self endon("_option_" + 315);
		if(value == "OFF")
			return;
		while( true )
		{
			while(self getstance() == value)
			{
				wait .0125;
				waittillframeend;
			}
			self setstance(value);
		}
	}
	else if(__option__ == 319)
	{
		if(!self ishost())
		{
			self iprintln("Host only!");
			return;
		}
		self SetCVar( self, 319, false );
		if(value == "OFF")
		{
			return;
		}
		wait .5;
		self SetCVar( self, 319, true );
		zcounter = createserverfontstring("default", 2);
	    zcounter setPoint( "CENTER", "TOP", 0, 0 );
		zcounter.color = (1,1,1);
		zcounter.alpha = 1;
		zcounter.glowColor = (0,0,0);
		zcounter.glowAlpha = 0;
		zcounter.sort = 9;
		zcounter.alpha = 1;
		zcounter.foreground = true;
		zcounter.hideWhenInMenu = true;
		if(value == "Zombies Alive" )
			zcounter.label = &"Zombies Alive: ";
		else
			zcounter.label = &"Total Zombies: ";
		if(value == "Zombies Alive")
		{
			while( self GetCBool(319) )
			{
				zcounter setValue(GetAIArray(level.zombie_team).size);
				wait .25;
			}
		}
		else
		{
			while( self GetCBool(319) )
			{
				zcounter setValue(level.zombie_total);
				wait .25;
			}
		}
		zcounter Destroy();
	}
	else if(__option__ == 323)
	{
		level.chest_joker_model = value;
	}
	else if(__option__ == 324)
	{
		level.cymbal_monkey_model = value;
	}
	else if(__option__ == 328)
	{
		self.stat_to_set = value;
	}
	else if(__option__ == 329)
	{
		self.stat_precision = Int(value);
	}
	else if(__option__ == 335)
	{
		self.nixie_tube = value;
	}
	else if(__option__ == 337)
	{
		self.sessionteam = value;
		self SetTeam(value);
		self._encounters_team = value;
		self.team = value;
		self.pers["team"] = value;
		self notify( "joined_team" );
		level notify( "joined_team" );
	}
	else if(__option__ == 342)
	{
		self setViewModel(value);
	}
	else if(__option__ == 361)
	{
		self SetCVar(self, 361, value);
	}
	else if(__option__ == 362)
	{
		self SetCVar(self, 362, value);
	}
	else if(__option__ == 365)
	{
		self setcvar(self, 365, value);
	}
	else if(__option__ == 380)
	{
		self setcvar(self, 380, value);
	}
}





