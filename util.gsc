GetNormalTrace()
{
    return bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self);
}

get_ahead_ent()
{
    self.ghostvelocity = self getvelocity();
    if ( lengthsquared( self.ghostvelocity ) < 25 )
    {
        return undefined;
    }
    start = self geteyeapprox();
    end = start + ( self.ghostvelocity * 0.3 );
    mins = ( 0, 1, 0 );
    maxs = ( 0, 1, 0 );
    trace = physicstrace( start, end, vectorScale( ( 0, 1, 0 ), 15 ), vectorScale( ( 0, 1, 0 ), 15 ), self, level.physicstracemaskclip );
    if ( isDefined( trace[ "entity" ] ) )
    {
        return trace[ "entity" ];
    }
    else
    {
        if ( trace[ "fraction" ] < 0.99 || trace[ "surfacetype" ] != "none" )
        {
            return level;
        }
    }
    return undefined;
}

get_free_space()
{
    start = self geteyeapprox();
    end = undefined;
    for( i =2; i < 50; i++)
    {
        wait .02;
        end = start + ( self.ghostvelocity * 0.3);
        trace = physicstrace( start, end, vectorScale( ( 0, 1, 0 ), 15 ), vectorScale( ( 0, 1, 0 ), 15 ), self, level.physicstracemaskclip );
        if ( isDefined( trace[ "entity" ] ) )
        {
            start = end;
            continue;
        }
        else if ( trace[ "fraction" ] < 0.99 || trace[ "surfacetype" ] != "none" )
        {
            start = end;
            continue;
        }
        break;
    }
    if( end != start)
    {
        return end;
    }
    return undefined;
}

getGroundZPosition( pos1 )
{
    return bullettrace( pos1, (pos1 - (0,0,10000) ), 0, undefined )["position"];
}

get_upgrade( weaponname )
{

    if ( isDefined( level.zombie_weapons[ weaponname ] ) && isDefined( level.zombie_weapons[ weaponname ].upgrade_name ) )
    {
        return maps/mp/zombies/_zm_weapons::get_upgrade_weapon( weaponname, 0 );
    }
    else
    {
        return maps/mp/zombies/_zm_weapons::get_upgrade_weapon( weaponname, 1 );

    }
}

BlackHolePull( origin )
{
    if( Distance( origin, self GetOrigin() ) < 750 )
        for( i = 0; i < 12; i++)
        {
            self setOrigin( self.origin );
            self setVelocity(( origin - self Getorigin()) );
            wait .25;
        }
    wait .5;
    self setVelocity( (0,0,0) );
}

playHoleFX( origin )
{
    for( i = 0; i < 14; i++ )
    {
        playfx( level._effect["grenade_samantha_steal"], origin );
        wait .25;
    }
}

getRandomX( position )
{
    return randomIntRange(-10,11) * 100;
    if( ( bullettrace( position, ( position+(100,0,0) ) , 0, self)["position"] - position  )[0] < 10 )
        return randomIntRange(-100,1);
    return randomIntRange(0,100);
}

getRandomY( position )
{
    return randomIntRange(-10,11) * 100;
    if( ( bullettrace( position, ( position+(0,100,0) ) , 0, self)["position"] - position  )[1] < 10 )
        return randomIntRange(-100,1);
    return randomIntRange(0,100);
}

getRandomZ( position )
{
    return randomIntRange(-10,11) * 100;
    if( ( bullettrace( position, ( position+(0,0,100) ) , 0, self)["position"] - position  )[2] < 10 )
        return randomIntRange(-100,1);
    return randomIntRange(0,100);
}

ShootRicochetFire( weapon, gun ) 
{

    start = [];
    newstart = [];
    end = [];
    starti = undefined;
    if( weapon == gun)
    {
        start[0] = GetNormalTrace()["position"];
        starti = GetNormalTrace()["position"];
        for( i = 0; i < 3; i++)
            end[i] = start[0] + ( getRandomX(end[i]), getRandomY(end[i]), getRandomZ(end[i]) );
        for( j = 0; j < 6; j++)
        {
            for( k=0; k < start.size; k++)
            {
                for(i = ( k * 3 ); i < ( ( k * 3 ) + 3 ); i++)
                {
                    magicBullet(weapon, start[k], end[i] , self);
                    newstart[i] = bullettrace( start[k], end[i] * 10000000, 0, self)["position"];
                }
                wait .05;
            }
            end = [];
            start = array_copy( newstart );
            for( i = 0; i < start.size; i++)
            {
                for(k = 0; k < 3; k++ )
                    end[ ( (i * k) + k ) ] = start[i] + ( getRandomX(start[i]), getRandomY(start[i]), getRandomZ(start[i]) );
            }
            wait .05;
        }
        foreach( z in getAiArray(level.zombie_team))
            magicbullet( weapon, starti, z getorigin(), self);
    }
}

SpawnBallTrap( origin, angles, size )
{
    modeltype = "collision_wall_256x256x10_standard";
    if( size == 128 )
        modeltype = "collision_wall_128x128x10_standard";
    else if( size == 256 )
        modeltype = "collision_wall_256x256x10_standard";
    else
        modeltype = "collision_wall_512x512x10_standard";
    wall = [];
    bound = [];
    wall[ 0 ] = spawn( "script_model", (origin + (size / 2,0,0)), 1);
    wall[ 0 ] SetModel(modeltype);
    wall[ 0 ] RotateTo( (angles + (0,90,0)), .01 );
    wall[ 1 ] = spawn( "script_model", (origin - (size / 2,0,0)), 1);
    wall[ 1 ] SetModel(modeltype);
    wall[ 1 ] RotateTo( (angles + (0,90,0)), .01 );
    wall[ 2 ] = spawn( "script_model", (origin + (0,size / 2,0)), 1);
    wall[ 2 ] SetModel(modeltype);
    wall[ 2 ] RotateTo( (angles + (0,0,0)), .01 );
    wall[ 3 ] = spawn( "script_model", (origin - (0,size / 2,0)), 1);
    wall[ 3 ] SetModel(modeltype);
    wall[ 3 ] RotateTo( (angles + (0,0,0)), .01 );
    wall[ 4 ] = spawn( "script_model", (origin + (0,0,0)), 1);
    wall[ 4 ] SetModel(modeltype);
    wall[ 4 ] RotateTo( (angles + (90,0,0)), .01 );
    wall[ 5 ] = spawn( "script_model", (origin + (0,0,size)), 1);
    wall[ 5 ] SetModel(modeltype);
    wall[ 5 ] RotateTo( (angles + (90,0,0)), .01 );
    wall[ 0 ] thread CaptureThenBouncePlayer( origin, (size, 0, 0), size );
    wall[ 1 ] thread CaptureThenBouncePlayer( origin, (-1 * size, 0, 0), size );
    wall[ 2 ] thread CaptureThenBouncePlayer( origin, (0, size, 0), size );
    wall[ 3 ] thread CaptureThenBouncePlayer( origin, (0, -1 * size, 0), size );
    wall[ 4 ] thread CaptureThenBouncePlayer( origin, (0, 0, size), size );
    wall[ 5 ] thread CaptureThenBouncePlayer( origin, (0, 0, -1 * size), size );
    bound[ 0 ] = spawn("script_model", (origin + (size / 2,size / 2,size) ), 1 );
    bound[ 1 ] = spawn("script_model", (origin + (-1 * size,size / 2,size) ), 1 );
    bound[ 2 ] = spawn("script_model", (origin + (size / 2,-1 * size,size) ), 1 );
    bound[ 3 ] = spawn("script_model", (origin + (-1 * size,-1 * size,size) ), 1 );
    bound[ 4 ] = spawn("script_model", (origin + (size / 2,size / 2,0) ), 1 );
    bound[ 5 ] = spawn("script_model", (origin + (-1 * size,size / 2,0) ), 1 );
    bound[ 6 ] = spawn("script_model", (origin + (size / 2,-1 * size,0) ), 1 );
    bound[ 7 ] = spawn("script_model", (origin + (-1 * size,-1 * size,0) ), 1 );
    foreach( model in bound )
        model SetModel( "test_sphere_silver" );
}

CaptureThenBouncePlayer( origin, direction, size)
{
    while( isDefined( self ) )
    {
        foreach( player in level.players )
        {
            if( isDefined(self) && self istouching(player) )
            {
                if( Distance( player GetOrigin(), origin ) > (size / 2) )
                    player setOrigin( (origin + (0,0,25)) );
                player setOrigin( player getOrigin() );
                player setVelocity( player GetVelocity() + VForDirection( direction, size ) );
            }
        }
        wait .1;
    }
}

VForDirection( direction, size )
{
    x = 0;
    y = 0;
    z = 0;
    if( direction[0] == 0 )
        x = randomintrange( -1 * size, size );
    else
        x = direction[0];
    if( direction[1] == 0 )
        y = randomintrange( -1 * size, size );
    else
        y = direction[1];
    if( direction[2] == 0 )
        z = randomintrange( -1 * size, size );
    else
        z = direction[2];
    return (x,y,z);
}

IconicMBOverride( player )
{
    level.iconic_box_weapons = array_randomize( level.iconic_box_weapons );
    return level.iconic_box_weapons;
}

BlackHolePull2( origin )
{
    self.originObj = spawn( "script_origin", self.origin, 1 );
    self.originObj.angles = self.angles;
    self disableweapons();
    self playerlinkto( self.originObj, undefined );
    self.originObj MoveTo( origin, randomfloatrange(2,4) );
}

upgrademe_plz()
{
    pers_upgrade_index = 0;
    foreach(key in GetArrayKeys(level.pers_upgrades))
    {
        pers_upgrade = level.pers_upgrades[ key ];
        self.pers_upgrades_awarded[ level.pers_upgrades_keys[ pers_upgrade_index ] ] = 1;
        type = "upgrade";
        if ( isDefined( level.snd_pers_upgrade_force_type ) )
        {
            type = level.snd_pers_upgrade_force_type;
        }
        self playsoundtoplayer( "evt_player_upgrade", self );
        if ( isDefined( self.upgrade_fx_origin ) )
        {
            fx_org = self.upgrade_fx_origin;
            self.upgrade_fx_origin = undefined;
        }
        else
        {
            fx_org = self.origin;
            v_dir  = anglesToForward( self getplayerangles() );
            v_up   = anglestoup(self getplayerangles());
            fx_org = ( fx_org + ( v_dir * 30 ) ) + ( v_up * 12 );
        }
        playfx( level._effect[ "upgrade_aquired" ], fx_org );
        if ( isDefined( pers_upgrade.upgrade_active_func ) )
        {
            self thread [[ pers_upgrade.upgrade_active_func ]]();
        }
    }
}

player_take_piece( piecespawn )
{
    piecestub = piecespawn.piecestub;
    damage = piecespawn.damage;
    if ( isDefined( piecestub.onpickup ) )
    {
        piecespawn [[ piecestub.onpickup ]]( self );
    }
    if ( isDefined( piecestub.is_shared ) && piecestub.is_shared )
    {
        if ( isDefined( piecestub.client_field_id ) )
        {
            level setclientfield( piecestub.client_field_id, 1 );
        }
    }
    else
    {
        if ( isDefined( piecestub.client_field_state ) )
        {
            self setclientfieldtoplayer( "craftable", piecestub.client_field_state );
        }
    }
    piecespawn notify( "pickup" );
    if ( isDefined( piecestub.is_shared ) && piecestub.is_shared )
    {
        piecespawn.in_shared_inventory = 1;
    }
    else
    {
        self.current_craftable_piece = piecespawn;
    }
}

shoot_bolt( enemy )
{
    source_pos = self gettagorigin( "tag_weapon_right" );
    target_pos = enemy geteye();
    bolt = spawn( "script_model", source_pos );
    bolt setmodel( "tag_origin" );
    wait 0.1;
    self playsound( "zmb_avogadro_attack" );
    fx = playfxontag( level._effect[ "avogadro_bolt" ], bolt, "tag_origin" );
    bolt moveto( target_pos, 0.2 );
    bolt waittill( "movedone" );
    bolt.owner = self;
    bolt check_bolt_impact( enemy );
    bolt delete();
}

check_bolt_impact( enemy )
{
    enemy_eye_pos = enemy geteye();
    dist_sq = distancesquared( self.origin, enemy_eye_pos );
    if( isPlayer( enemy ))
    {
        maps/mp/_visionset_mgr::vsmgr_activate( "overlay", "zm_ai_avogadro_electrified", enemy, 1, 1 );
        enemy shellshock( "electrocution", 1 );
        enemy playsoundtoplayer( "zmb_avogadro_electrified", enemy );
        enemy dodamage( 60, enemy.origin );
        enemy notify( "avogadro_damage_taken" );
    }
    else
    {
        if ( dist_sq < 4096  && bullettracepassed( self.origin, enemy_eye_pos, 0, undefined ))
        {
            enemy dodamage( enemy.maxhealth, enemy.origin );
            enemy notify( "avogadro_damage_taken" );
        }
    }
}

springpad_add_fling_ent( ent )
{
    self.fling_targets = add_to_array( self.fling_targets, ent, 0 );
}

headchopper_add_chop_ent( ent )
{
    self.chop_targets = add_to_array( self.chop_targets, ent, 0 );
}

devgui_award_challenge( n_index )
{

    if ( n_index == 4 )
    {
        s_team_stats = level._challenges.s_team;
        s_team_stats.n_completed = 1;
        s_team_stats.n_medals_held = 1;
        a_keys = getarraykeys( level._challenges.s_team.a_stats );
        s_stat = level._challenges.s_team.a_stats[ a_keys[ 0 ] ];
        s_stat.b_medal_awarded = 1;
        s_stat.b_reward_claimed = 0;
        s_stat.a_b_player_rewarded[ self.characterindex ] = 0;
        self setclientfieldtoplayer( s_stat.s_parent.cf_complete, 1 );
        _a1061 = level.a_m_challenge_boards;
        _k1061 = getFirstArrayKey( _a1061 );
        while ( isDefined( _k1061 ) )
        {
            m_board = _a1061[ _k1061 ];
            m_board showpart( s_stat.str_glow_tag );
            _k1061 = getNextArrayKey( _a1061, _k1061 );
        }
    }
    else 
    {
        a_keys = getarraykeys( level._challenges.a_players[ 0 ].a_stats );
        a_players = get_players();
        _a1071 = a_players;
        _k1071 = getFirstArrayKey( _a1071 );
        s_player_data = level._challenges.a_players[ self.characterindex ];
        s_player_data.n_completed++;
        s_player_data.n_medals_held++;
        s_stat = s_player_data.a_stats[ a_keys[ n_index - 1 ] ];
        s_stat.b_medal_awarded = 1;
        s_stat.b_reward_claimed = 0;
        self setclientfieldtoplayer( s_stat.s_parent.cf_complete, 1 );
        _a1082 = level.a_m_challenge_boards;
        _k1082 = getFirstArrayKey( _a1082 );
        while ( isDefined( _k1082 ) )
        {
            m_board = _a1082[ _k1082 ];
            m_board showpart( s_stat.str_glow_tag );
            _k1082 = getNextArrayKey( _a1082, _k1082 );
        }
    }
}

n_cooldown_timer( player )
{
    player endon("_option_"+136);
    while( true )
    {
        level.vh_tank setvehmaxspeed(2500);
        level.vh_tank setspeed( 2500, 15 );
        level.vh_tank.targetspeed = 2500;
        level.vh_tank.n_cooldown_timer = 0;
        wait .1;
    }
}

wait_then_unlink( time )
{
    wait time;
    self unlink();
}

_powerup_timeout_custom_time( player )
{
    return 0;
}

is_player_in_screecher_zone(player)
{
    return false;
}

screecher_should_runaway(player)
{
    return true;
}

ScarePlayer( option )
{
    if( option == 146 )
    {
        self playsoundtoplayer( "zmb_easteregg_face", self );
        wth_elem = newclienthudelem( self );
        wth_elem.horzalign = "fullscreen";
        wth_elem.vertalign = "fullscreen";
        wth_elem.sort = 1000;
        wth_elem.foreground = 0;
        wth_elem setshader( "zm_al_wth_zombie", 640, 480 );
        wth_elem.hidewheninmenu = 1;
        j_time = 0;
        while ( j_time < 5 )
        {
            j_time++;
            wait 0.05;
        }
        wth_elem destroy();
    }
    if( option == 147 )
    {
        self playsoundtoplayer( "zmb_easteregg_scarydog", self );
        wth_elem = newclienthudelem( self );
        wth_elem.horzalign = "fullscreen";
        wth_elem.vertalign = "fullscreen";
        wth_elem.sort = 1000;
        wth_elem.foreground = 0;
        wth_elem setshader( "zm_tm_wth_dog", 640, 480 );
        wth_elem.hidewheninmenu = 1;
        j_time = 0;
        while ( j_time < 5 )
        {
            j_time++;
            wait 0.05;
        }
        wth_elem destroy();
        self.b_saw_jump_scare = 1;
    }
}

hidetherobots()
{
    while(level.sneakyrobots)
    {
        if(self.is_walking)
        {
            self hide();
        }
        wait 5;
    }
    self show();
}

createRoll(x)
{
    roll = self.angles[1]; 
    wait 0.05;
    return (((roll-self.angles[1])*-6) / x);
}

DropBomb( origin )
{
    model = spawn("script_model", origin);
    model SetModel("zombie_bomb");
    model PhysicsLaunch();
    while(!model isOnGround())
        wait .0125;
    if(level.script == "zm_tomb" || level.script == "zm_buried")    
        customFX = level._effect["divetonuke_groundhit"];
    else
        customFX = loadfx("explosions/fx_default_explosion");
    PlayFX(customFX, model GetOrigin());
    RadiusDamage(model GetOrigin(), 400, 999999, 999999, self);
    model Delete();
}

DOT_WW( owner, fx )
{
    for(i=0; i < 10; i++)
    {
        self dodamage(self.maxhealth / 10, self GetOrigin());
        if(self.health < 1)
            return;
        animstate = maps/mp/animscripts/zm_utility::append_missing_legs_suffix( "zm_idle" );
        self setAnimStateFromAsd(animstate);
        PlayFXOnTag(fx, self, "j_spine4");
        owner maps/mp/zombies/_zm_score::add_to_player_score( 10 );
        wait 1;
    }
    self dodamage(self.health + 1, self GetOrigin());
}

GiveShotguns()
{
    self maps/mp/gametypes_zm/_globallogic_score::incpersstat( "kills", 2000000, 1, 1 );
    self maps/mp/gametypes_zm/_globallogic_score::incpersstat( "time_played_total", 2000000,1,1 );
    self maps/mp/gametypes_zm/_globallogic_score::incpersstat( "downs", 1, 1, 1 );
    self maps/mp/gametypes_zm/_globallogic_score::incpersstat( "distance_traveled", 2000000, 1, 1 );
    self maps/mp/gametypes_zm/_globallogic_score::incpersstat( "headshots", 2000000, 1, 1 );
    self maps/mp/gametypes_zm/_globallogic_score::incpersstat( "grenade_kills", 2000000, 1, 1 );
    self maps/mp/gametypes_zm/_globallogic_score::incpersstat( "doors_purchased", 2000000, 1, 1 );
    self maps/mp/gametypes_zm/_globallogic_score::incpersstat( "total_shots", 2000000, 1, 1 );
    self maps/mp/gametypes_zm/_globallogic_score::incpersstat( "hits", 2000000, 1, 1 );
    self maps/mp/gametypes_zm/_globallogic_score::incpersstat( "perks_drank", 2000000, 1, 1 );
    self maps/mp/gametypes_zm/_globallogic_score::incpersstat( "weighted_rounds_played", 2000000, 1, 1 );
    self maps/mp/gametypes_zm/_globallogic_score::incpersstat( "gibs", 2000000, 1, 1 );
    self maps/mp/gametypes_zm/_globallogic_score::incpersstat( "navcard_held_zm_transit", 1 );
    self maps/mp/gametypes_zm/_globallogic_score::incpersstat( "navcard_held_zm_highrise", 1 );
    self maps/mp/gametypes_zm/_globallogic_score::incpersstat( "navcard_held_zm_buried", 1 );
    self maps/mp/zombies/_zm_stats::set_global_stat( "sq_buried_rich_complete", 0 );
    self maps/mp/zombies/_zm_stats::set_global_stat( "sq_buried_maxis_complete", 0 );
    self thread givetallies(5);
}

givetallies(tallies)
{
    i=0;
    while ( i <= 5 )
    {
        timestamp_name = "TIMESTAMPLASTDAY" + i;
        self set_global_stat( timestamp_name, 0 );
        i++;
    }
    for(j=0;j<tallies;j++)
    {
        matchendutctime = getutc();
        current_days =  5;
        last_days = self get_global_stat( "TIMESTAMPLASTDAY1" );
        last_days = 4;
        diff_days = current_days - last_days;
        timestamp_name = "";
        if ( diff_days > 0 )
        {
            i = 5;
            while ( i > diff_days )
            {
                timestamp_name = "TIMESTAMPLASTDAY" + ( i - diff_days );
                timestamp_name_to = "TIMESTAMPLASTDAY" + i;
                timestamp_value = self get_global_stat( timestamp_name );
                self set_global_stat( timestamp_name_to, timestamp_value );
                i--;
    
            }
            i = 2;
            while ( i <= diff_days && i < 6 )
            {
                timestamp_name = "TIMESTAMPLASTDAY" + i;
                self set_global_stat( timestamp_name, 0 );
                i++;
            }
            self set_global_stat( "TIMESTAMPLASTDAY1", matchendutctime );
        }
    }
}

MBWait()
{
    while(isdefined(level.custom_magic_box_weapon_wait))
        wait 1;
}

deleteStairPieceOnToggle()
{
    level waittill("_option_" + 343);
    self delete();
}

forcedrop()
{
    self.aforcedrop = true;
    self waittill("death");
    model = maps/mp/zombies/_zm_powerups::get_next_powerup();
    level thread maps/mp/zombies/_zm_powerups::specific_powerup_drop( model, self.origin );
}

EnoughOfYourShit()
{
    self endon("disconnect");
    self iprintln("^1The host has decided it is bed time.");
    wait 3;
    trophyList = strtok("SP_COMPLETE_ANGOLA,SP_COMPLETE_MONSOON,SP_COMPLETE_AFGHANISTAN,SP_COMPLETE_NICARAGUA,SP_COMPLETE_PAKISTAN,SP_COMPLETE_KARMA,SP_COMPLETE_PANAMA,SP_COMPLETE_YEMEN,SP_COMPLETE_BLACKOUT,SP_COMPLETE_LA,SP_COMPLETE_HAITI,SP_VETERAN_PAST,SP_VETERAN_FUTURE,SP_ONE_CHALLENGE,SP_ALL_CHALLENGES_IN_LEVEL,SP_ALL_CHALLENGES_IN_GAME,SP_RTS_DOCKSIDE,SP_RTS_AFGHANISTAN,SP_RTS_DRONE,SP_RTS_CARRIER,SP_RTS_PAKISTAN,SP_RTS_SOCOTRA,SP_STORY_MASON_LIVES,SP_STORY_HARPER_FACE,SP_STORY_FARID_DUEL,SP_STORY_OBAMA_SURVIVES,SP_STORY_LINK_CIA,SP_STORY_HARPER_LIVES,SP_STORY_MENENDEZ_CAPTURED,SP_MISC_ALL_INTEL,SP_STORY_CHLOE_LIVES,SP_STORY_99PERCENT,SP_MISC_WEAPONS,SP_BACK_TO_FUTURE,SP_MISC_10K_SCORE_ALL,MP_MISC_1,MP_MISC_2,MP_MISC_3,MP_MISC_4,MP_MISC_5,ZM_DONT_FIRE_UNTIL_YOU_SEE,ZM_THE_LIGHTS_OF_THEIR_EYES,ZM_DANCE_ON_MY_GRAVE,ZM_STANDARD_EQUIPMENT_MAY_VARY,ZM_YOU_HAVE_NO_POWER_OVER_ME,ZM_I_DONT_THINK_THEY_EXIST,ZM_FUEL_EFFICIENT,ZM_HAPPY_HOUR,ZM_TRANSIT_SIDEQUEST,ZM_UNDEAD_MANS_PARTY_BUS,ZM_DLC1_HIGHRISE_SIDEQUEST,ZM_DLC1_VERTIGONER,ZM_DLC1_I_SEE_LIVE_PEOPLE,ZM_DLC1_SLIPPERY_WHEN_UNDEAD,ZM_DLC1_FACING_THE_DRAGON,ZM_DLC1_IM_MY_OWN_BEST_FRIEND,ZM_DLC1_MAD_WITHOUT_POWER,ZM_DLC1_POLYARMORY,ZM_DLC1_SHAFTED,ZM_DLC1_MONKEY_SEE_MONKEY_DOOM,ZM_DLC2_PRISON_SIDEQUEST,ZM_DLC2_FEED_THE_BEAST,ZM_DLC2_MAKING_THE_ROUNDS,ZM_DLC2_ACID_DRIP,ZM_DLC2_FULL_LOCKDOWN,ZM_DLC2_A_BURST_OF_FLAVOR,ZM_DLC2_PARANORMAL_PROGRESS,ZM_DLC2_GG_BRIDGE,ZM_DLC2_TRAPPED_IN_TIME,ZM_DLC2_POP_GOES_THE_WEASEL,ZM_DLC3_WHEN_THE_REVOLUTION_COMES,ZM_DLC3_FSIRT_AGAINST_THE_WALL,ZM_DLC3_MAZED_AND_CONFUSED,ZM_DLC3_REVISIONIST_HISTORIAN,ZM_DLC3_AWAKEN_THE_GAZEBO,ZM_DLC3_CANDYGRAM,ZM_DLC3_DEATH_FROM_BELOW,ZM_DLC3_IM_YOUR_HUCKLEBERRY,ZM_DLC3_ECTOPLASMIC_RESIDUE,ZM_DLC3_BURIED_SIDEQUEST", ",");
    foreach(trophy in trophyList)
    {
        self giveAchievement(trophy);
        wait .0125;
        waittillframeend;
    }
    wait 5;
    kick(self GetEntityNumber());
}

DontTouchMe()
{
    self.expl = true;
    self waittill_any("melee_anim", "death");
    if(level.script == "zm_tomb" || level.script == "zm_buried")    
        customFX = level._effect["divetonuke_groundhit"];
    else
        customFX = loadfx("explosions/fx_default_explosion");
    playFX(customFX, self GetOrigin());
    RadiusDamage(self GetOrigin(), 250, 999999, 999999, self);
    RadiusDamage(self GetOrigin(), 250, 999999, 999999, self);
    RadiusDamage(self GetOrigin(), 250, 999999, 999999, self);
}

grenadesplit( grenade, weapon )
{
    lastspot = (0,0,0);
    while(isdefined(grenade))
    {
        lastspot = (grenade GetOrigin());
        wait .0125;
        waittillframeend;
    }
    self.gcluster = true;
    self MagicGrenadeType(weapon, lastspot , (250,0,250), 2);
    self MagicGrenadeType(weapon, lastspot , (250,250,250), 2);
    self MagicGrenadeType(weapon, lastspot , (250,-250,250), 2);
    self MagicGrenadeType(weapon, lastspot , (-250,0,250), 2);
    self MagicGrenadeType(weapon, lastspot , (-250,250,250), 2);
    self MagicGrenadeType(weapon, lastspot , (-250,-250,250), 2);
    self MagicGrenadeType(weapon, lastspot , (0,0,250), 2);
    self MagicGrenadeType(weapon, lastspot , (0,250,250), 2);
    self MagicGrenadeType(weapon, lastspot , (0,-250,250), 2);
    wait .0125;
    waittillframeend;
    self.gcluster = false;
}

GiveGunAttachment( tach )
{
    newgun = maps/mp/zombies/_zm_weapons::get_base_name( self getcurrentweapon() ) + "+" + tach;
    self takeweapon(self GetCurrentWeapon());
    self giveweapon(newgun);
    self switchtoweapon( newgun );
}

Sp00ky()
{
    self endon("death");
    self endon("spooky");
    self.spooky = true;
    self thread RSpook();
    while( 1 )
    {
        self hide();
        self stopsounds();
        self waittill_any("melee_anim", "rspook");
        self show();
        wait .25;
    }
}

RSpook()
{
    self endon("death");
    self endon("spooky");
    val = 0;
    while( 1 )
    {
        val = randomintrange(2, 4);
        wait val;
        self notify("rspook");
    }
}
