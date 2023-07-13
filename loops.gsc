loops( _option_, arg1, arg2, arg3, arg4 )
{
    self endon("toggleall" + _option_);
    if(_option_ == 1)
    {
        while(GetCBool(1))
        {
            weapon = self getcurrentweapon();
            if(weapon != "none")
            {
                self setWeaponAmmoClip(weapon, weaponClipSize(weapon));
                self giveMaxAmmo(weapon);
            }
            if(self getCurrentOffHand() != "none")
                self giveMaxAmmo(self getCurrentOffHand());
            self waittill_any("weapon_fired", "grenade_fire", "missile_fire");
        }
    }
    else if(_option_ == 4)
    {
        while(GetCBool(4))
        {
            while(self adsbuttonpressed())
            {
                trace= GetNormalTrace();
                while(self adsbuttonpressed() && isdefined(trace["entity"]))
                {
                    trace["entity"] setOrigin(self GetTagOrigin("j_head")+ anglesToForward(self GetPlayerAngles())* 200);
                    trace["entity"].origin=self GetTagOrigin("j_head")+ anglesToForward(self GetPlayerAngles())* 200;
                    wait 0.05;
                }
                WaitMin();
            }
            WaitMin();
        }
    }
    else if(_option_ == 179)
    {
        self iprintln("^2Press [{+frag}] ^3to ^2Toggle No Clip");
        arg1 = undefined;
        arg2 = undefined;
        arg3 = undefined;
        self unlink();
        self.originObj delete();
        while( GetCBool(179) )
        {
            if( self fragbuttonpressed())
            {
                self.originObj = spawn( "script_origin", self.origin, 1 );
                self.originObj.angles = self.angles;
                self playerlinkto( self.originObj, undefined );
                while( self fragbuttonpressed() )
                    WaitMin();
                self enableweapons();
                while( GetCBool(179) )
                {
                    if( self fragbuttonpressed() )
                        break;
                    if( self SprintButtonPressed() )
                    {
                        arg1 = anglesToForward( self getPlayerAngles() );
                        arg2 = vectorScale( arg1, 60 );
                        arg3 = self.origin + arg2;
                        self.originObj.origin = arg3;
                    }
                    wait .05;
                }
                self unlink();
                self.originObj delete();
                while( self fragbuttonpressed() )
                    WaitMin();
            }
            WaitMin();
        }
    }
    else if(_option_ == 8 && isDefined( arg1 ) && arg1 == 0 )
    {
        self thread loops( 8, 1);
        while( GetCBool(8) )
        {
            while(self adsButtonPressed())
            {
                Zombies = getClosest(self getOrigin(),getAiSpeciesArray("axis","all"));
                self setplayerangles( VectorToAngles( ( Zombies getTagOrigin( "j_head" ) ) - ( self getTagOrigin( "j_head" ) ) ) );
                if(isDefined(self.Aim_Shoot))
                    magicBullet(self getCurrentWeapon(),Zombies getTagOrigin("j_head")+(0,0,5),Zombies getTagOrigin("j_head"),self);
                wait .05;
            }
            wait .05;
        }
    }
    else if(_option_ == 8 && isDefined( arg1 ) && arg1 == 1 )
    {
        while( GetCBool(8) )
        {
            self.Aim_Shoot = true;
            wait .05;
            self.Aim_Shoot = undefined;
            self waittill("weapon_fired");
        }
    }
    else if( _option_ == 156 )
    {
        a_ent = self get_ahead_ent();
        g_ent = undefined;
        g_tonext = undefined;
        x = undefined;
        y = undefined;
        z = undefined;
        while( GetCBool(156) )
        {
            a_ent = self get_ahead_ent();
            if(isDefined(a_ent))
            {
                g_tonext = self get_free_space();
                if(isDefined(g_tonext))
                {
                    g_ent = self getGroundZPosition( g_tonext );
                    if(isDefined(g_ent))
                    {
                        z = g_ent[2];
                    }
                    else
                        z = (self GetOrigin())[2];
                    x = g_tonext[0];
                    y = g_tonext[1];
                    self setOrigin((x,y,z));
                }
                while(!self isOnGround())
                    wait .01;
            }
            wait .2;
        }
    }
    else if(_option_ == 9)
    {
        x = 40;
        y = 40;
        self.healthbarhudelems = [];
        self.healthbarkeys[ 0 ] = "Health";
        i = 0;
        while ( i < self.healthbarkeys.size )
        {
            key = self.healthbarkeys[ i ];
            textelem = newClientHudElem(self);
            textelem.x = x;
            textelem.y = y;
            textelem.alignx = "left";
            textelem.aligny = "top";
            textelem.horzalign = "fullscreen";
            textelem.vertalign = "fullscreen";
            textelem settext( key );
            bgbar = newClientHudElem(self);
            bgbar.x = x + 79;
            bgbar.y = y + 1;
            bgbar.alignx = "left";
            bgbar.aligny = "top";
            bgbar.horzalign = "fullscreen";
            bgbar.vertalign = "fullscreen";
            bgbar.maxwidth = 3;
            bgbar setshader( "white", bgbar.maxwidth, 10 );
            bgbar.color = vectorScale( ( 1, 1, 1 ), 0.5 );
            bar = newClientHudElem(self);
            bar.x = x + 80;
            bar.y = y + 2;
            bar.alignx = "left";
            bar.aligny = "top";
            bar.horzalign = "fullscreen";
            bar.vertalign = "fullscreen";
            bar setshader( "black", 1, 8 );
            textelem.bar = bar;
            textelem.bgbar = bgbar;
            textelem.key = key;
            y += 10;
            self.healthbarhudelems[ key ] = textelem;
            i++;
        }
        while ( GetCBool(9) )
        {
            wait 0.05;
            i = 0;
            key = self.healthbarkeys[ i ];
            
            player = self;
            width = 0;
            if ( i == 0 )
            {
                width = ( player.health / player.maxhealth ) * 300;
            }
            else if ( i == 1 )
            {
                width = ( ( self.playerinvultimeend - getTime() ) / 1000 ) * 40;
            }
            else
            {
                if ( i == 2 )
                {
                    width = ( ( self.player_deathinvulnerabletimeout - getTime() ) / 1000 ) * 40;
                }
            }
            width = int( max( width, 1 ) );
            width = int( min( width, 300 ) );
            bar = self.healthbarhudelems[ key ].bar;
            bar setshader( "black", width, 8 );
            bgbar = self.healthbarhudelems[ key ].bgbar;
            if ( ( width + 2 ) > bgbar.maxwidth )
            {
                bgbar.maxwidth = width + 2;
                bgbar setshader( "white", bgbar.maxwidth, 10 );
                bgbar.color = vectorScale( ( 1, 1, 1 ), 0.5 );
            }
            i++;
        }
    }
    else if( _option_ == 43 && arg1 ==0)
    {
        self.magic_weapon = arg2;
        if( self.magic_weapon == "NORMAL")
            return;
        while(self.magic_weapon == arg2)
        {
            magicBullet(arg2, self getTagOrigin("tag_eye"), GetNormalTrace()["position"], self);
            self waittill("weapon_fired");
        }
    }
    else if( _option_ == 43 && arg1 ==1)
    {
        self.magic_weapon1 = arg2;
        if( self.magic_weapon1 == "NORMAL")
            return;
        while(self.magic_weapon1 == arg2)
        {
            radiusdamage( GetNormalTrace()["position"], 200, 300, 100, self);
            playfx(level._effect[arg2], GetNormalTrace()["position"]);
            self waittill("weapon_fired");
        }
    }
    else if(_option_ == 34)
    {
        self iprintln("^3Press [{+usereload}] + [{+gostand}] ^3to ^2Save");
        wait .25;
        self iprintln("^3Press [{+usereload}] + [{+weapnext_inventory}] ^3to ^2Load");
        while(GetCBool(34))
        {
            if(self usebuttonpressed() && self jumpbuttonpressed())
            {
                self iprintln("Saved");
                self.Saved = self.origin;
                wait .5;
            }
            if(self usebuttonpressed() && self changeseatbuttonpressed())
            {
                if(isDefined(self.Saved))
                {
                    self setOrigin(self.Saved);
                }
                wait .5;
            }
            wait .1;
        }
    }
    else if(_option_ == 184)
    {
        start = undefined;
        end = undefined;
        while( GetCBool(184) )
        {   
            self waittill("weapon_fired", weapon);
            if( !GetCBool(184) )
                break;
            start = GetNormalTrace()["position"];
            end = ( randomintrange(-1000,1000), randomintrange(-1000,1000), randomintrange(0,1000) );
            magicBullet(weapon, start, start + end , self);
            start = bullettrace( start, end * 10000000, 0, self)["position"];
            end = -1 * start + ( randomintrange(-1000,1000), randomintrange(-1000,1000), randomintrange(0,1000) );
            magicBullet(weapon, start, start + end , self);
        }
    }
    else if(_option_ == 36 && arg1 == 0)
    {
        object1 = undefined;
        object2 = undefined;
        self dofunction( 20, level.laststandpistol );
        self.cooldowntime = 0;
        self.lastportal = undefined;
        while(GetCBool(36))
        {
            self waittill("weapon_fired", weapon);
            if(!GetCBool(36))
                break;
            if(weapon != level.laststandpistol)
                continue;
            if(isDefined(object1) && isDefined(object2))
            {
                object1 delete();
                object2 delete();
            }
            else if(isDefined(object1))
            {
                trace = GetNormalTrace();
                pos = trace["position"];
                object2 = spawn( "script_model", pos );
                object2 setModel(level._iconic_portalmodel);
                object1.portalto = pos;
                object2.portalto = object1 getOrigin();
                object2 thread loops(36, 1);
            }
            else
            {
                trace = GetNormalTrace();
                pos = trace["position"];
                object1 = spawn( "script_model", pos );
                object1 setModel(level._iconic_portalmodel);
                object1 thread loops(36, 1);
            }
        }
        object1 delete();
        object2 delete();
        self.cooldowntime = 0;
        self.lastportal = undefined;
    }
    else if( _option_ == 36 && arg1 == 1)
    {
        while(!isDefined(self.portalto))
            wait .1;
        while(isDefined(self))
        {
            foreach(player in level.players)
            {
                if(self isTouching(player) && !player.cooldowntime)
                {
                    player.cooldowntime = 1;
                    wait .1;
                    player setOrigin( self.portalto );
                }
                else if(self isTouching(player) && !isDefined(player.lastportal))
                {
                    player.lastportal = self;
                    player thread loops( 36, 2, self );
                }
            }
            wait .1;
        }
    }
    else if( _option_ == 36 && arg1 == 2)
    {
        portal = arg2;
        while( isDefined(portal) && portal isTouching(self))
            wait .1;
        self.lastportal = undefined;
        self.cooldowntime = 0;
    }
    else if(_option_ == 178)
    {
        trace = undefined;
        while(GetCBool(178))
        {
            self waittill("weapon_fired");
            if( !GetCBool(178) )
                break;
            trace = GetNormalTrace()["position"];
            level thread playHoleFX( trace );
            foreach( model in getEntArray("script_brushmodel", "classname") )
                if( Distance(model getOrigin(), trace ) < 750 )
                    model MoveTo( trace, 2);
            foreach( model in getEntArray("script_model", "classname") )
                if( Distance( model GetOrigin() , trace ) < 750 )
                    model MoveTo( trace, 2);
            foreach( player in level.players )
                player thread BlackHolePull( trace );
            foreach( zombie in getAiArray(level.zombie_team) )
                if( Distance( zombie getOrigin(), trace ) < 750 )
                    zombie forceteleport( trace, self.angles + vectorScale( ( 0, 1, 0 ), 180 ) );
            wait 3;
            playfx( loadfx("explosions/fx_default_explosion"), trace);
            playfx( loadFx("misc/fx_zombie_mini_nuke_hotness"), trace);
            foreach( model in getEntArray("script_brushmodel", "classname") )
                if( Distance(model getOrigin(), trace ) < 750 )
                    model Delete();
            foreach( model in getEntArray("script_model", "classname") )
                if( Distance(model getOrigin(), trace ) < 750 )
                    model Delete();
            wait .1;
            foreach( player in level.players) 
                RadiusDamage(trace,500,99999,99999,player);
        }
    }
    else if(_option_ == 170)
    {
        self giveweapon( level.laststandpistol );
        atf = undefined;
        pos = undefined;
        velocity = 500;
        while( GetCBool( 170 ))
        {
            self waittill("weapon_fired");
            if( !GetCBool(170) )
                break;
            atf = AnglesToForward(self getPlayerAngles());
            pos = bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"];
            playfx(level._effect["powerup_grabbed"], pos);
            foreach( zombie in getAiSpeciesArray("axis","all") )
                if( Distance( Zombie GetOrigin(), pos ) < 250 )
                {
                    playfx(level._effect["powerup_grabbed"], Zombie GetOrigin());
                    Zombie setVelocity(Zombie getVelocity() + ((atf[0]*750),(atf[1]*750),((atf[2] + 1)*750)));
                    Zombie doDamage(Zombie.health * 2, Zombie.origin, self);
                    Zombie startRagdoll();
                    Zombie launchRagdoll((atf[0] * 750, atf[1] * 750, 0));
                }
            foreach( zombie in level.players )
                if( Distance( Zombie GetOrigin(), pos ) < 250 )
                {
                    playfx(level._effect["powerup_grabbed"], Zombie GetOrigin());
                    Zombie setVelocity(((atf[0]*750),(atf[1]*750),((atf[2] + 1)*999)));
                }
            foreach( zombie in getEntArray("script_model", "classname") )
                if( Distance( Zombie GetOrigin(), pos ) < 250 )
                {
                    playfx(level._effect["powerup_grabbed"], Zombie GetOrigin());
                    Zombie PhysicsLaunch(((atf[0]*750),(atf[1]*750),((atf[2] + 1)*750)));
                    zombie setVelocity(((atf[0]*750),(atf[1]*750),((atf[2] + 1)*750)));
                }
        }
    }
    else if(_option_ == 186)
    {
        self giveweapon("dsr50_zm");
        self switchtoweapon("dsr50_zm");
        self setweaponammoclip( "dsr50_zm", 1 );
        self SetWeaponAmmoStock( "dsr50_zm", 5 );
        while( GetCBool(186) )
        {
            self waittill("weapon_fired", weapon);
            if( !GetCBool(186) )
                break;
            if( weapon != "dsr50_zm" )
                continue;
            end = GetNormalTrace()["position"];
            start = self gettagorigin("j_head");
            for( i = 0; i < 7; i++)
            {
                magicBullet("raygun_mark2_upgraded_zm", start, end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (0,0,15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (0,0,-15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (0,0,0)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (0,15,15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (0,15,-15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (0,15,0)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (0,-15,15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (0,-15,-15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (0,-15,0)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (15,0,15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (15,0,-15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (15,0,0)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (15,15,15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (15,15,-15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (15,15,0)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (15,-15,15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (15,-15,-15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (15,-15,0)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (-15,0,15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (-15,0,-15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (-15,0,0)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (-15,15,15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (-15,15,-15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (-15,15,0)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (-15,-15,15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (-15,-15,-15)), end, self);
                magicBullet("raygun_mark2_upgraded_zm", (start + (-15,-15,0)), end, self);
                magicBullet("ray_gun_upgraded_zm", start, end, self);
                wait .09;
            }
            PlayFXOnTag( loadFx("misc/fx_zombie_mini_nuke_hotness") , self, "tag_weapon_right" );
            PlayFXOnTag( level._effect["character_fire_death_sm"] , self, "tag_weapon_right" );
            self SetWeaponAmmoStock( "dsr50_zm", 1 );
            self setweaponammoclip( "dsr50_zm", 5 );
            self disableweaponcycling();
            self disableweapons();
            RadiusDamage( end, 100,99999,99999, self );
            playfx( loadfx("explosions/fx_default_explosion"), end);
            wait 3;
            self enableweaponcycling();
            self enableweapons();
            self SetWeaponAmmoStock( "dsr50_zm", 1 );
            self setweaponammoclip( "dsr50_zm", 5 );
        }
    }
    else if(_option_ == 185)
    {
        self giveweapon(arg1);
        self switchtoweapon( arg1 );
        start = [];
        newstart = [];
        starti = undefined;
        end = [];
        x = 0;
        y = 0;
        z = 0;
        while( GetCBool(185) )
        {
            self waittill("weapon_fired", weapon);
            if( !GetCBool(185) )
                break;
            self thread ShootRicochetFire( weapon, arg1 );
        }
    }
    else if(_option_ == 171)
    {
        atf =  AnglesToForward(self getPlayerAngles());
        while( level.trampoline_mode )
        {
            if( self isOnGround())
            {
                atf = AnglesToForward(self getPlayerAngles());
                self setOrigin(self.origin);
                self setVelocity( ( self GetVelocity() + ( (atf[0] * 350), (atf[1] * 350), 1937 ) ) );
                self setVelocity( ( self GetVelocity() + ( 0, 0, 1937 ) ) );
                wait .05;
                self setVelocity( ( self GetVelocity() + ( 0, 0, 1937 ) ) );
                wait .05;
                self setVelocity( ( self GetVelocity() + ( 0, 0, 1937 ) ) );
                wait .05;
            }
            wait .1;
        }
    }
    else if(_option_ == 200)
    {
        player = undefined;
        players = array_copy( level.players );
        arrayremovevalue(players, self);
        while( GetCBool(200) )
        {
            self waittill("grenade_fire", grenade, weapname);
            if( !GetCBool(200) )
                break;
            player = players[ randomIntRange(0, players.size) ];
            player playerlinkto( grenade, undefined );
            player.angles = grenade.angles + (0, 0, 40);
            grenade resetMissileDetonationTime();
            player thread wait_then_unlink( 2.5 );
        }
    }
    else if(_option_ == 204)
    {
        while( GetCBool(204) )
        {
            model = spawn("script_model", ( (self.origin[0] + randomIntRange( -1000,1001)), (self.origin[1] + randomIntRange( -1000,1001)), (self.origin[2] + 2500) ) );
            model setModel("test_sphere_silver");
            model thread loops( -204, self );
            wait .5;
        }
    }
    else if(_option_ == -204)
    {
        self PhysicsLaunch();
        while(!self isonground())
            wait 1;
        origin = self GetOrigin();
        self Delete();
        RadiusDamage( origin, 150, 99999, 99999, arg1 );
        foreach( player in level.players )
            if( player != arg1 )
                RadiusDamage( origin, 150, 99999, 99999, player );
    }
    else if(_option_ == 205)
    {
        pup = undefined;
        obj = undefined;
        while( GetCBool(205) )
        {
            model = maps/mp/zombies/_zm_powerups::get_next_powerup();
            obj = level thread maps/mp/zombies/_zm_powerups::specific_powerup_drop( model, ( (self.origin[0] + randomIntRange( -1000,1001)), (self.origin[1] + randomIntRange( -1000,1001)), (self.origin[2] + 2500) ) );
            if( isDefined(obj) )
                obj thread loops(-205);
            wait .5;
        }
    }
    else if(_option_ == -205)
    {
        self PhysicsLaunch();
        wait 15;
        self delete();
    }
    else if(_option_ == 45)
    {
        if( arg1 == "NONE")
        {
            self show();
            self.iconicmodel delete();
            return;
        }
        self.iconicmodel delete();
        self hide();
        self.iconicmodel = spawn("script_model", self.origin);
        self.iconicmodel setmodel( arg1 );
        origin = self.origin;
        angles = self.angles;
        while( self.other_model == arg1 )
        {
            if(self getOrigin() != origin)
            {
                origin = self getOrigin();
                self.iconicmodel MoveTo(self.origin, 0.01);
            }
            if( self.angles != angles)
            {
                angles = self.angles;
                self.iconicmodel RotateTo(self.angles, 0.01);
            }
            wait .1;
        }
    }
    else if(_option_ == 169)
    {
        model = spawn("script_model", arg2);
        model setModel("defaultactor");
        if( arg1 == 0 )
        {
            while( isDefined( model ) )
            {
                model RotateTo( model.angles + (45,0,0) , .1 );
                wait .1;
            }
        }
        if( arg1 == 1 )
        {
            while( isDefined( model ) )
            {
                model RotateTo( model.angles + (0,45,0), .1 );
                wait .1;
            }
        }
        if( arg1 == 2)
        {
            while( isDefined( model ) )
            {
                model RotateTo( model.angles + (0,0,45), .1 );
                wait .1;
            }
        }
        if( arg1 == 3)
        {
            while( isDefined( model ) )
            {
                model RotateTo( model.angles + (randomintrange(-180,181),randomintrange(-180,181),randomintrange(-180,181)), .1 );
                wait .1;
            }
        }
        if( arg1 == 4 )
        {
            while( isDefined( model ) )
            {
                model MoveTo( model getOrigin() + (100,0,0), .5 );
                wait .5;
                model MoveTo( model getOrigin() + (-100,0,0), .5 );
                wait .5;
            }
        }
        if( arg1 == 5 )
        {
            while( isDefined( model ) )
            {
                model MoveTo( model getOrigin() + (0,100,0), .5 );
                wait .5;
                model MoveTo( model getOrigin() + (0,-100,0), .5 );
                wait .5;
            }
        }
        if( arg1 == 6 )
        {
            while( isDefined( model ) )
            {
                model MoveTo( model getOrigin() + (0,0,100), .5 );
                wait .5;
                model MoveTo( model getOrigin() + (0,0,-100), .5 );
                wait .5;
            }
        }
        if( arg1 == 7 )
        {
            x= 0;
            y= 0;
            z = 0;
            while( isDefined( model ) )
            {
                x = randomintrange(-100,101);
                y = randomintrange(-100,101);
                z = randomintrange(-100,101);
                model MoveTo( model getOrigin() + (x,y,z), .5 );
                wait .5;
                model MoveTo( model getOrigin() - (x,y,z), .5 );
                wait .5;
            }
        }
    }
    else if(_option_ == 47)
    {
        self iprintln("^3Press ^2AIM ^3to ^2Move Objects");
        wait .25;
        self iprintln("^3Press ^2AIM + SHOOT ^3to ^2Paste Objects");
        wait .25;
        self iprintln("^3Press ^2AIM + [{+usereload}] ^3to ^2Copy Objects");
        wait .25;
        self iprintln("^3Press ^2AIM + [{+gostand}] ^3to ^2Delete Objects");
        wait .25;
        self iprintln("^3Press ^2DPAD & GRENADE BUTTONS ^3to ^2Rotate Objects");
        object = undefined;
        trace = undefined;
        cannotsetmodel = undefined;
        while(GetCBool(47))
        {
            if(self adsbuttonpressed())
            {
                trace= GetNormalTrace();
                if(!isDefined(trace["entity"]))
                {
                    cannotsetmodel = false;
                    foreach(model in getEntArray("script_brushmodel", "classname"))
                    {
                        if(!isDefined(currentent) && Distance(model.origin, trace["position"]) < 100)
                        {
                            currentent = model;
                            cannotsetmodel = true;
                        }
                        if( isDefined(currentent) && closer(trace["position"], model.origin, currentent.origin) )
                        {
                            currentent = model;
                            cannotsetmodel = true;
                        }
                    }
                    foreach(model in getEntArray("script_model", "classname"))
                    {
                        if(!isDefined(currentent) && Distance(model.origin, trace["position"]) < 100)
                        {
                            currentent = model;
                            cannotsetmodel = false;
                        }
                        if( isDefined(currentent) && closer(trace["position"], model.origin, currentent.origin) )
                        {
                            currentent = model;
                            cannotsetmodel = false;
                        }
                    }
                    trace["entity"] = currentent;
                }
                while(self adsbuttonpressed())
                {
                    trace["entity"] setOrigin(self GetTagOrigin("j_head")+ anglesToForward(self GetPlayerAngles())* 200);
                    trace["entity"].origin=self GetTagOrigin("j_head")+ anglesToForward(self GetPlayerAngles())* 200;
                    if(self attackbuttonpressed())
                    {
                        if(isDefined(object))
                        {
                            if(isDefined(trace["entity"]) && !cannotsetmodel)
                            {
                                self iprintln("Overwrote Objects Model With:^2 "+object);
                                trace["entity"] setModel(object);
                            }
                            else
                            {
                                trace= GetNormalTrace();
                                obj = spawn("script_model", trace["position"], 1);
                                obj setModel(object);
                                self iprintln("Spawned Object:^2 "+object);
                            }
                        }
                        wait .75;
                    }
                    if(self usebuttonpressed())
                    {
                        if(isDefined(trace["entity"].model))
                        {
                            object = trace["entity"].model;
                            self iprintln("Copied Model: ^2"+ object);
                        }
                        wait .75;
                        break;
                    }
                    if(self jumpbuttonpressed())
                    {
                        if(!isDefined(trace["entity"]))
                        {
                        }
                        else
                        {
                            trace["entity"] delete();
                            self iprintln("Entity Deleted");
                        }
                        wait .75;
                        break;
                    }
                    if(self actionslotonebuttonpressed())
                    {
                        if(isDefined(trace["entity"]))
                        {
                            trace["entity"] rotatePitch(6, .05);
                        }
                        else
                        {
                            wait .5;
                            break;
                        }
                        wait .1;
                    }
                    if(self actionslottwobuttonpressed())
                    {
                        if(isDefined(trace["entity"]))
                        {
                            trace["entity"] rotatePitch(-6, .05);
                        }
                        else
                        {
                            wait .5;
                            break;
                        }
                        wait .1;
                    }
                    if(self actionslotthreebuttonpressed())
                    {
                        if(isDefined(trace["entity"]))
                        {
                            trace["entity"] rotateYaw(-6, .05);
                        }
                        else
                        {
                            wait .5;
                            break;
                        }
                        wait .1;
                    }
                    if(self actionslotfourbuttonpressed())
                    {
                        if(isDefined(trace["entity"]))
                        {
                            trace["entity"] rotateYaw(6, .05);
                        }
                        else
                        {
                            wait .5;
                            break;
                        }
                        wait .1;
                    }
                    if(self secondaryoffhandbuttonpressed())
                    {
                        if(isDefined(trace["entity"]))
                        {
                            trace["entity"] rotateRoll(-6, .05);
                        }
                        else
                        {
                            wait .5;
                            break;
                        }
                        wait .1;
                    }
                    if(self fragbuttonpressed())
                    {
                        if(isDefined(trace["entity"]))
                        {
                            trace["entity"] rotateRoll(6, .05);
                        }
                        else
                        {
                            wait .5;
                            break;
                        }
                        wait .1;
                    }
                    wait 0.05;
                }
            }
            wait .1;
        }
    }
    else if(_option_ == 202)
    {
        while( arg1 GetCBool(202) )
        {
            self waittill( "damage", amount, attacker, dir, point, mod );
            if( isDefined(attacker) && attacker.is_zombie )
            {
                self setorigin( self.origin );
                self SetVelocity( ((AnglesToForward(VectorToAngles(self Getorigin() - attacker GetOrigin())) + (0,0,5)) * (1337,1337,350)) );
            }
        }
    }
    else if(_option_ == 57)
    {
        level notify("loops"+57);
        level endon("loops"+57);
        if(arg1 == "Reset")
            return;
        while(1)
        {
            foreach( zombie in getAiArray(level.zombie_team) )
            if(!isDefined(zombie.remodeled) || zombie.remodeled != arg1)
            {
                zombie setModel( arg1 );
                zombie.remodeled = arg1;
            }
            wait 1;
        }
    }
    else if(_option_ == 56)
    {
        level notify("loops"+56);
        level endon("loops"+56);
        if(arg1 == "NONE")
            return;
        while( 1 )
        {
            zombies = getAiArray(level.zombie_team);
            foreach(zombie in zombies)
                zombie maps/mp/zombies/_zm_utility::set_zombie_run_cycle(arg1);
            wait 1;
        }
    }
    else if(_option_ == 58)
    {
        while(GetCBool(58))
        {
            origin = GetNormalTrace()["position"];
            model = maps/mp/zombies/_zm_powerups::get_next_powerup();
            level thread maps/mp/zombies/_zm_powerups::specific_powerup_drop( model, origin );
            self waittill("weapon_fired");
        }
    }
    else if(_option_ == 74)
    {
        while(GetCBool(74))
        {
            foreach(player in level.players)
            {
                if(player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
                    player maps/mp/zombies/_zm_laststand::auto_revive( player );
                wait .5;
            }
        }
    }
    else if(_option_ == 80)
    {
        while( GetHost() GetCBool(80))
        {
            if(self JumpButtonPressed())
            {
                for(i = 0; i < 10; i++)
                {
                    self setVelocity(self getVelocity()+(0, 0, 999));
                    wait 0.05;
                }
            }
            wait 0.05;
        }
    }
    else if( _option_ == 83 && arg1 == 0)
    {
        hitmarker = newDamageIndicatorHudElem(self);
        hitmarker.horzAlign = "center";
        hitmarker.vertAlign = "middle";
        hitmarker.x = -12;
        hitmarker.y = -12;
        hitmarker.alpha = 0;
        hitmarker setShader("damage_feedback", 24, 48);
        while(level._iconic_hitmarkers)
        {
            self waittill("HitTarget_hma");
            hitmarker.alpha = 1;
            hitmarker fadeOverTime(1);
            hitmarker.alpha = 0;
        }
        hitmarker destroy();
    }
    else if( _option_ == 83 && arg1 == 1)
    {
        while(level._iconic_hitmarkers)
        {
            foreach( zombie in getAiArray(level.zombie_team))
                if(!isDefined(zombie._iconic_hitmarkers))
                    zombie thread loops(83, 2);
            wait .25;
        }
    }
    else if( _option_ == 83 && arg1 == 2)
    {
        self._iconic_hitmarkers = true;
        while(level._iconic_hitmarkers && isAlive(self))
        {
            self waittill( "damage", amount, attacker, dir, point, mod );
            if(isPlayer(attacker))
                attacker notify("HitTarget_hma");
        }
    }
    else if(_option_ == 190)
    {
        trace = undefined;
        while(level.friendlyfire)
        {
              self.damage_own_team = true;
              self waittill("weapon_fired",weapon);
              trace = GetNormalTrace();
              if(isDefined(trace["entity"]) && isPlayer(trace["entity"]))
              {
                    trace["entity"] doDamage( 35,(trace["entity"] getorigin())); 
                    self maps/mp/zombies/_zm_score::add_to_player_score( 500 );
              }
        }
        self.damage_own_team = false;
    }
    else if(_option_ == 206)
    {
        while( arg1 GetCBool(206) )
        {
            self waittill("weapon_fired", weapon);
            if( !arg1 GetCBool(206))
                return;
            self playsound( "zmb_vox_monkey_scream" );
        }
    }
    else if(_option_ == 165)
    {
        while(GetCBool(165))
        {
            if(self maps/mp/zombies/_zm_laststand::player_is_in_laststand())
                self maps/mp/zombies/_zm_laststand::auto_revive( self );
            else
                self dodamage( self.maxhealth, self.origin );
            wait .25;
        } 
    }
    else if(_option_ == 166)
    {
        angles = self getPlayerAngles();
        while( self GetCBool(166) )
        {
            angles = self getPlayerAngles();
            self setPlayerAngles((angles[0] + randomintrange(-180,181), angles[1] + randomintrange(-180,181), angles[2] + randomintrange(-180,181)));
            wait .1;
        }
    }
    else if(_option_ == 95)
    {
        while(level.hud_dfeedbacktroll)
        {   
            if ( self getcurrentweapon() == "jetgun_zm" )
                self setweaponoverheating( 0, 0 );
            self waittill("weapon_fired");
        }
    }
    else if(_option_ == 203)
    {
        while( GetCBool(203) )
        {
            self waittill("grenade_fire", grenade, weapname);
            if( !GetCBool(203) )
                break;
            grenade waittill_any( "stationary", "delete", "detonate" );
            self MagicGrenadeType("sticky_grenade_zm", grenade GetOrigin() , (250,0,250), 2);
            self MagicGrenadeType("sticky_grenade_zm", grenade GetOrigin() , (250,250,250), 2);
            self MagicGrenadeType("sticky_grenade_zm", grenade GetOrigin() , (250,-250,250), 2);
            self MagicGrenadeType("sticky_grenade_zm", grenade GetOrigin() , (-250,0,250), 2);
            self MagicGrenadeType("sticky_grenade_zm", grenade GetOrigin() , (-250,250,250), 2);
            self MagicGrenadeType("sticky_grenade_zm", grenade GetOrigin() , (-250,-250,250), 2);
            self MagicGrenadeType("sticky_grenade_zm", grenade GetOrigin() , (0,0,250), 2);
            self MagicGrenadeType("sticky_grenade_zm", grenade GetOrigin() , (0,250,250), 2);
            self MagicGrenadeType("sticky_grenade_zm", grenade GetOrigin() , (0,-250,250), 2);
        }
    }
    else if(_option_ == 99)
    {
        while(GetCBool(99))
        {
            level.the_bus setvehmaxspeed(2500);
            level.the_bus setspeed( 2500, 15 );
            level.the_bus.targetspeed = 2500;
            wait 1;
        }
    }
    else if(_option_ == 100)
    {
        self disableweapons();
        while(GetCBool(100))
        {
            if(self attackbuttonpressed())
            {
                enemy = getClosest( self getOrigin(), getAiArray(level.zombie_team));
                if ( isDefined( enemy ) )
                    self thread shoot_bolt( enemy );
                wait .5;
            }
            wait .1;
        }
        self enableweapons();
    }
    else if(_option_ == 118)
    {
        while(GetCBool(118))
        {
            self waittill("weapon_fired", weapon);
            if(isSubStr(weapon, "slowgun"))
            {
                self setWeaponOverHeating(0, 0);
                wait .025;
            }
            else
                wait 1;
        }
    }
    else if( _option_ == 120 )
    {
        while ( 1 )
        {
            self [[ self.update_funcs[ self.state ] ]]();
            wait 0.1;
        }
    }
    else if(_option_ == 129)
    {
        while(GetCBool(129))
        {
            flag_clear( "gramophone_placed" );
            level setclientfield( "piece_record_zm_player", 1 );
            level notify("gramophone_vinyl_player_picked_up");
            wait 1;
        }
    }
    else if(_option_ == 130)
    {
        while( GetCBool(130) )
        {
            foreach( player in level.players)
            {
                player thread devgui_award_challenge(1);
                player thread devgui_award_challenge(2);
                player thread devgui_award_challenge(3);
                player thread devgui_award_challenge(4);
            }
            wait 5;
        }
    }
    else if(_option_ == 136)
    {
        self notify("_option_"+136);
        self endon("_option_"+136);
        level.vh_tank thread n_cooldown_timer( arg1 );
        while( arg1 GetCBool(136) )
        {
            level.vh_tank maps/mp/zombies/_zm_utility::ent_flag_set( "tank_activated" );
            level.vh_tank maps/mp/zombies/_zm_utility::ent_flag_set( "tank_moving" );
            level.vh_tank.b_no_cost = 1;
            level.n_cooldown_timer = 2;
            level.vh_tank setvehmaxspeed(2500);
            level.vh_tank setspeed( 2500, 15 );
            level.vh_tank.targetspeed = 2500;
            level.vh_tank maps/mp/zombies/_zm_utility::ent_flag_wait("tank_cooldown");
            level.vh_tank.n_cooldown_timer = 0;
            level notify( "stp_cd" );
            wait 2;
        }
    }
    else if(_option_ == 35)
    {
        self iPrintln("Press [{+gostand}] & [{+usereload}]");
        self.jetboots = 100;
        while(GetCBool(35))
        {
            if(self usebuttonpressed() && self.jetboots>0)
            {
                self.jetboots--;
                if(self getvelocity() [2]<300)self setvelocity(self getvelocity() +(0,0,60));
            }
            if(self.jetboots<100 &&!self usebuttonpressed() )self.jetboots++;
            wait .05;
        }
    }
}







