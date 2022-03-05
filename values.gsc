values( value, option, arg2, arg3, arg4, allplayers )
{
	if( option == 5 )
	{
		self setMoveSpeedScale( value );
	}
	else if(option == 19)
	{
		self setclientfov(value);
	}
	else if(option == 85)
	{
		setDvar("bg_gravity", value);
	}
	else if(option == 86)
	{
		setDvar("timescale", value);
	}
	else if(option == 87)
	{
		setDvar("player_lastStandBleedoutTime", value);
	}
	else if(option == 334)
	{
		self SetCVar(self,334, Int(value));
	}
	else if(option == 360)
	{
		self.maxhealth = Int(value);
		self thread EnsureMaxhealth( value );
	}
	else if(option == 364)
	{
		self maps/mp/zombies/_zm_stats::set_map_stat( "depositBox", Int(value), level.banking_map );
		self.account_value = Int(value);
	}
	else if(option == 389)
	{
		level.perk_purchase_limit = Int(value);
	}
}

EnsureMaxhealth( val )
{
	self notify("EnsureMaxhealth");
	self endon("EnsureMaxhealth");
	while( 1 )
	{
		if(self.maxhealth != val)
		{
			self.maxhealth = val;
		}
		wait 4;
	}
}



