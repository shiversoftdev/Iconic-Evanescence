V3loops( _option_, arg1, arg2, arg3, arg4 )
{
    self endon("toggleall" + _option_);
    if(_option_ == -300 && arg1 == 0)
    {
        while(self GetCBool(300))
        {
            if(self adsbuttonpressed())
            {
                self.planeSpeed -= 5;
                if(self.planeSpeed < 0) 
                    self.planeSpeed = 0;
                wait .1;
            }
            if(self AttackButtonPressed())
            {
                self.planeSpeed++;
                if(self.planeSpeed > 90) 
                    self.planeSpeed = 90;
            }
            else
            {
                self.planeSpeed--;
                if(self.planeSpeed < 0)
                    self.planeSpeed = 0;
                wait .05;
            }
            if(self meleeButtonPressed())
                break;
            wait .05;
            waittillframeend;
        }
        self SetCVar(self, 300, false);
    }
    else if(_option_ == -300 && arg1 == 1)
    {
        while(GetCBool(300))
        {
            arg2 rotateTo(self.angles+(-1 * self getPlayerAngles()[0],180,self createRoll(1)),.1,.05,.05);
            wait .11;
        }
    }
    else if(_option_ == -300 && arg1 == 2)
    {
        self.HeatSeekingRocket = 5;
        while(GetCBool(300))
        {
            if(self secondaryoffhandbuttonpressed())
            {
                if(level.script == "zm_prison")
                {
                    magicBullet("minigun_alcatraz_upgraded_zm", arg2[0] GetOrigin() , self getEye() + anglesToForward(self getPlayerAngles())*1500, self);
                }
                else if(level.script == "zm_transit")
                {
                    magicBullet("ray_gun_upgraded_zm", arg2[0] GetOrigin() , self getEye() + anglesToForward(self getPlayerAngles())*9999, self);
                }
                else
                {
                    magicBullet("mg08_upgraded_zm", arg2[0] GetOrigin() , self getEye() + anglesToForward(self getPlayerAngles())*1500, self);
                }
            }
            if(self fragbuttonpressed())
            {
                if(level.script == "zm_prison")
                {
                    magicBullet("minigun_alcatraz_upgraded_zm", arg2[1] GetOrigin() , self getEye() + anglesToForward(self getPlayerAngles())*1500, self);
                }
                else if(level.script == "zm_transit")
                {
                    magicBullet("ray_gun_upgraded_zm", arg2[1] GetOrigin() , self getEye() + anglesToForward(self getPlayerAngles())*9999, self);
                }
                else
                {
                    magicBullet("mg08_upgraded_zm", arg2[1] GetOrigin() , self getEye() + anglesToForward(self getPlayerAngles())*1500, self);
                }
            }
            if(self SprintButtonPressed())
            {
                self thread DropBomb(arg2[0] GetOrigin());
                self thread DropBomb(arg2[1] GetOrigin());
                wait .1;
            }
            wait .05;
        }
    }
    else if(_option_ == -300 && arg1 == 3)
    {
        self endon("veh_t6_dlc_zm_biplane");
        while(arg2 GetCBool(300))
        {
            self waittill( "damage", amount, attacker, dir, point, mod );
            if(isDefined(attacker) && attacker != arg2 && (attacker GetCBool(300)))
            {
                arg2 DoDamage( 60, arg2 GetOrigin());
                attacker.hitmarker.alpha = 1;
                attacker.hitmarker fadeOverTime(1);
                attacker.hitmarker.alpha = 0;
            }
            if(arg2.health < 25)
                arg2 SetCVar(arg2, 300, false);
            wait .025;
        }
    }
    else if(_option_ == 300)
    {
        veh_t6_dlc_zm_biplane = spawn("script_model", self GetOrigin() + (0,0,20), 1);
        if(level.script == "zm_prison")
        {
            veh_t6_dlc_zm_biplane SetModel("veh_t6_dlc_zombie_plane_whole");
        }
        else if(level.script == "zm_transit")
        {
            veh_t6_dlc_zm_biplane SetModel("veh_t6_civ_bus_zombie");    
        }
        else
        {
            veh_t6_dlc_zm_biplane SetModel("veh_t6_dlc_zm_biplane");
        }
        veh_t6_dlc_zm_biplane.health = 500;
        ent = spawn("script_model", self.origin + (500,0,100), 1);
        ent SetModel("tag_origin");
        tag_origin = spawn("script_model", self.origin + (100,0,70), 1);
        tag_origin SetModel("tag_origin");
        trigger = spawn("trigger_radius",self.origin + (0,0,20),1,50,50);
        trigger setCursorHint("HINT_NOICON");
        trigger setHintString("Press &&1 to Pilot!");
        cannon = [];
        cannon[0] = spawn("script_model", self GetOrigin() + (100,-220,50), 1);
        cannon[0] SetModel("tag_origin");
        cannon[1] = spawn("script_model", self GetOrigin() + (100,220,50), 1);
        cannon[1] SetModel("tag_origin");
        self DisableInvulnerability();
        self.hitmarker = newDamageIndicatorHudElem(self);
        self.hitmarker.horzAlign = "center";
        self.hitmarker.vertAlign = "middle";
        self.hitmarker.x = -12;
        self.hitmarker.y = -12;
        self.hitmarker.alpha = 0;
        self.hitmarker setShader("damage_feedback", 24, 48);
        while(GetCBool(300))
        {
            trigger waittill("trigger", player);
            wait .0125;
            if(player != self)
                continue;
            if(player useButtonPressed())
            {
                break;
            }
        }
        crosshair = drawText("+", "default", 2.5, "CENTER", "CENTER", 0, 0, (1,1,1), 1, 0, 0, 9);
        /*
        arg3 = spawn("script_brushmodel", tag_origin GetOrigin());
        arg3 SetModel("veh_t6_dlc_zm_biplane");
        arg3.team = "axis";
        arg3.maxhealth = 100;
        arg3.health = 100;
        arg3 Solid();
        arg3 SetCanDamage(1);
        arg3 hide();
        */
        //arg4 = spawn("script_brushmodel", tag_origin GetOrigin());
        //arg4 SetModel("veh_t6_dlc_zm_biplane");
        veh_t6_dlc_zm_biplane.team = "axis";
        veh_t6_dlc_zm_biplane.maxhealth = 100;
        veh_t6_dlc_zm_biplane.health = 100;
        veh_t6_dlc_zm_biplane Solid();
        veh_t6_dlc_zm_biplane SetCanDamage(1);
        veh_t6_dlc_zm_biplane thread V3loops(-300, 3, self, veh_t6_dlc_zm_biplane);
        //arg3 LinkTo(tag_origin);
        //arg4 LinkTo(tag_origin);
        trigger delete();
        self setclientthirdperson(1);
        setDvar("cg_thirdPersonRange", "270");
        self disableWeapons();
        self hide();
        if(self GetCBool(300))
        {
            ent LinkTo(tag_origin);
            veh_t6_dlc_zm_biplane.angles = (0,180,0);
            veh_t6_dlc_zm_biplane LinkTo(tag_origin);
            cannon[0] LinkTo(tag_origin);
            cannon[1] LinkTo(tag_origin);
            self hide();
            self setPlayerAngles((0,180,0));
            self PlayerLinkTo(ent, undefined);
            wait .5;
            self.planeSpeed = 0;
            self thread V3loops(-300,0);
            self thread V3loops(-300,1, tag_origin);
            self thread V3Loops(-300,2,cannon, tag_origin);
            while(GetCBool(300))
            {
                self DisableInvulnerability();
                tag_origin moveto((tag_origin GetOrigin())+ anglestoforward(self getplayerangles())*self.planeSpeed,.05);
                wait .05;
            }
        }
        crosshair Destroy();
        self.hitmarker destroy();
        arg3 notify("veh_t6_dlc_zm_biplane");
        arg4 notify("veh_t6_dlc_zm_biplane");
        self unlink(tag_origin);
        tag_origin Delete();
        ent Delete();
        if(level.script == "zm_tomb" || level.script == "zm_buried")    
            customFX = level._effect["divetonuke_groundhit"];
        else
            customFX = loadfx("explosions/fx_default_explosion");
        playFX(customFX, veh_t6_dlc_zm_biplane GetOrigin());
        veh_t6_dlc_zm_biplane Delete();
        if(!GetCBool(3))
            self show();
        if(!GetCBool(7))
            self setclientthirdperson(0);
        self enableWeapons();
    }
    else if(_option_ == 301)
    {
        self waittill("death");
        foreach(zombie in getaiarray( level.zombie_team ))
            zombie unlink();
    }
    else if(_option_ == 306)
    {
        while(arg1 getcbool(306))
        {
            self waittill("grenade_fire", grenade);
            if(arg1 getcbool(306))
                grenade detonate( self );
        }
    }
    else if(_option_ == 307)
    {
        while( GetCBool(307))
        {
            self waittill( "perk_bought" );
            if(!GetCBool(307))
                return;
            self notify("fake_death");
        }
    }
    else if(_option_ == 308)
    {
        player = (self GetMenu()).selectedplayer;
        self unlink();
        self SetOrigin(player GetOrigin());
        puppetorigin = spawn("script_model", self GetOrigin());
        puppetorigin SetModel("tag_origin");
        puppetorigin LinkTo(self, "tag_origin", (AnglesToForward(self GetPlayerAngles()) * (-40,-40,0)));
        player PlayerLinkToDelta( puppetorigin );
        player disableweapons();
        self disableweapons();
        self hide();
        player DisableInvulnerability();
        self EnableInvulnerability();
        while(GetCBool(308))
        {
            player SetPlayerAngles( self GetPlayerAngles() );
            player SetStance( self GetStance());
            wait .0125;
            waittillframeend;
        }
        if(!self GetCBool(0))
            self DisableInvulnerability();
        self show();
        puppetorigin unlink();
        puppetorigin delete();
        player unlink();
        player EnableWeapons();
        self EnableWeapons();
    }
    else if(_option_ == 311)
    {
        while( self GetCBool(311) )
        {
            foreach(elevator in level.elevators)
            {
                elevator.body rotateYaw(360, 2.5);
            }
            wait 2.6;
        }
    }
    else if(_option_ == 312)
    {
        while( self GetCBool(312) )
        {
            foreach(elevator in level.elevators)
            {
                elevator.body notify("forcego");
            }
            wait 2;
        }
    }
    else if(_option_ == 313)
    {
        original = GetDvar("r_lightTweakSunColor");
        while( self GetCBool(313))
        {
            SetDvar("r_lightTweakSunColor", randomfloatrange(0,1) + " " + randomfloatrange(0,1) + " " + randomfloatrange(0,1) + " " + randomfloatrange(0,1));
            wait .35;
        }
        SetDvar("r_lightTweakSunColor", original);
    }
    else if(_option_ == 316)
    {
        if(!isdefined(level.sloth))
            return;
        self setorigin(level.sloth GetOrigin());
        level.sloth SetPlayerCollision(false);
        level.sloth LinkTo(self);
        level.sloth NotSolid();
        self hide();
        self setclientthirdperson( true );
        while( self GetCBool(316))
        {
            level.sloth.angles = self.angles;
            wait .0125;
            waittillframeend;
        }
        level.sloth Solid();
        self show();
        self setclientthirdperson(false);
        level.sloth Unlink();
    }
    else if(_option_ == 317)
    {
        zombies = GetAIArray(level.zombie_team);
        index = randomintrange(0,zombies.size);
        zombiex = zombies[index];
        self setorigin(zombiex GetOrigin());
        self.angles = zombie.angles;
        zombiex EnableInvulnerability();
        zombiex.maxhealth = 999999;
        zombiex.health = 999999;
        zombiex SetPlayerCollision(false);
        zombiex LinkTo(self);
        zombiex notsolid();
        self hide();
        self.ignoreme = true;
        self setclientthirdperson(true);
        wait 1;
        while( self GetCBool(317) )
        {
            if(self actionslotthreebuttonpressed())
            {
                index--;
                if(index < 0 || index > getaiarray(level.zombie_team).size)
                    index = getaiarray(level.zombie_team).size - 1;
                zombiex DisableInvulnerability();
                zombiex DoDamage(zombiex.maxhealth + 1, zombiex GetOrigin());
                zombiex unlink();
                zombiex = getaiarray(level.zombie_team)[index];
                self setorigin(zombiex GetOrigin());
                self.angles = zombie.angles;
                zombiex EnableInvulnerability();
                zombiex.maxhealth = 999999;
                zombiex.health = 999999;
                zombiex SetPlayerCollision(false);
                zombiex LinkTo(self);
                zombiex notsolid();
                while(self actionslotthreebuttonpressed())
                {
                    wait .0125;
                    waittillframeend;
                }
            }
            else if(self actionslotfourbuttonpressed())
            {
                index++;
                if(index > getaiarray(level.zombie_team).size)
                    index = 0;
                zombiex DisableInvulnerability();
                zombiex DoDamage(zombiex.maxhealth + 1, zombiex GetOrigin());
                zombiex unlink();
                zombiex = getaiarray(level.zombie_team)[index];
                self setorigin(zombiex GetOrigin());
                self.angles = zombie.angles;
                zombiex EnableInvulnerability();
                zombiex.maxhealth = 999999;
                zombiex.health = 999999;
                zombiex SetPlayerCollision(false);
                zombiex LinkTo(self);
                zombiex notsolid();
                while(self actionslotfourbuttonpressed())
                {
                    wait .0125;
                    waittillframeend;
                }
            }
            zombiex.angles = self.angles;
            wait .0125;
            waittillframeend;
        }
        zombiex DisableInvulnerability();
        zombiex DoDamage(zombiex.maxhealth + 1, zombiex GetOrigin());
        zombiex unlink();
        self show();
        self.ignoreme = false;
        self setclientthirdperson(false);
    }
    else if(_option_ == 318)
    {
        self Attach("zombie_skull","tag_weapon_left");
        self giveweapon("knife_zm");
        self switchToWeapon("knife_zm");
        while( self GetCBool(318) )
        {
            while(!self ismeleeing())
            {
                wait .125;
                waittillframeend;
            }
            origin = self GetTagOrigin("tag_weapon_left");
            if(!self GetCbool(318))
            {
                break;
            }
            for(i = -1; i < 2; i++)
            {
                for(j = -1; j < 2; j++)
                {
                    for(k = -1; k < 2; k++)
                    {
                        model = spawn("script_model", origin + ((i,j,k) * (20,20,20)));
                        model SetModel("zombie_skull");
                        model thread V3Loops(-318, self);
                    }
                }
            }
            while(self ismeleeing())
            {
                wait .125;
                waittillframeend;
            }
        }
        self Detach("zombie_skull");
    }
    else if(_option_ == -318)
    {
        self physicsLaunch();
        while(!self isonground())
            wait .0125;
        if(level.script == "zm_tomb" || level.script == "zm_buried")    
            customFX = level._effect["divetonuke_groundhit"];
        else
            customFX = loadfx("explosions/fx_default_explosion");
        PlayFX(customFX, self GetOrigin());
        RadiusDamage(self GetOrigin(), 200, 999999, 999999, arg1);
        self Delete();
    }
    else if(_option_ == 320)
    {
        self giveweapon("frag_grenade_zm");
        self GiveMaxAmmo("frag_grenade_zm");
        self thread V3Loops(-320);
        fx = level._effect["powerup_grabbed"];
        while( self GetCBool(320) )
        {
            self waittill("damage", amount, attacker, dir, point, mod);
            if(!self GetCBool(320))
                return;
            if(self GetAmmoCount("frag_grenade_zm") < 1)
                continue;
            if(isDefined(attacker))
            {
                ammo = self GetAmmoCount("frag_grenade_zm");
                self setweaponammostock("frag_grenade_zm", ammo - 1);
                self EnableInvulnerability();
                self MagicGrenadeType("frag_grenade_zm",self GetOrigin(), self GetOrigin() + (0,0,50),.1);
                foreach(zombie in GetAIArray(level.zombie_team))
                {
                    if(Distance(Zombie GetOrigin(), self GetOrigin()) > 150)
                        continue;
                    PlayFXOnTag(fx, zombie, "j_spine4");
                    Zombie.ai_state = "idle";
                    Zombie.ignore_player = array_copy(level.players);
                    animstate = maps/mp/animscripts/zm_utility::append_missing_legs_suffix( "zm_idle" );
                    Zombie setAnimStateFromAsd(animstate);
                    Zombie thread DOT_WW(self, fx);
                }
                wait .3;
                self DisableInvulnerability();
            }
        }
    }
    else if(_option_ == -320)
    {
        fx = level._effect["powerup_grabbed"];
        while(self GetCBool(320))
        {
            self waittill("grenade_fire", grenade);
            origin = grenade GetOrigin();
            if(!self GetCBool(320))
                return;
            wait .5;
            grenade Detonate(self);
            foreach(zombie in GetAIArray(level.zombie_team))
            {
                if(Distance(Zombie GetOrigin(), origin) > 150)
                    continue;
                PlayFXOnTag(fx, zombie, "j_spine4");
                Zombie.ai_state = "idle";
                Zombie.ignore_player = array_copy(level.players);
                animstate = maps/mp/animscripts/zm_utility::append_missing_legs_suffix( "zm_idle" );
                Zombie setAnimStateFromAsd(animstate);
                Zombie thread DOT_WW(self, fx);
            }
        }
    }
    else if(_option_ == 327)
    {
        while(getcbool(327))
        {
            level thread maps/mp/zombies/_zm_powerups::specific_powerup_drop( "meat_stink", self GetNormalTrace()["position"] );
            self waittill("weapon_fired");
        }
    }
    else if(_option_ == 331)
    {
        level.next_leaper_round = level.round_number + 1;
        level.zombie_total = 0;
        level thread maps/mp/zombies/_zm_powerups::specific_powerup_drop("nuke", self.origin);
        old_spawn_func = level.round_spawn_func;
        old_wait_func = level.round_wait_func;
        while( self GetCBool(331))
        {
            level waittill("between_round_over");
            if(!self GetCBool(331))
                return;
            wait .25;
            level.next_leaper_round = level.round_number + 1;
            flag_clear("leaper_round");
        }
        level.round_spawn_func = old_spawn_func;
        level.round_wait_func = old_wait_func;
        level.music_round_override = 0;
        level.leaper_round_count += 1;
    }
    else if(_option_ == 336)
    {
        while(self GetCBool(336))
        {
            foreach(zombie in GetAIArray(level.zombie_team))
            {
                zombie.cant_melee = true;
                zombie.a.meleerange = 0;
            }
            wait 2;
        }
    }
    else if(_option_ == 344)
    {
        while( self GetCBool(344) )
        {
            foreach(zombie in GetAIArray(level.zombie_team))
            {
                if(!isdefined(zombie.aforcedrop))
                    zombie thread forcedrop();
            }
            wait 1;
        }
    }
    else if(_option_ == 349)
    {
        level endon("end_game");
        snapshot = [];
        self maps/mp/gametypes_zm/_globallogic_ui::closemenus();
        self EnableInvulnerability();
        snapshot[0] = self GetStance();
        snapshot[1] = self GetCurrentWeapon();
        snapshot[2] = self.score;
        snapshot[3] = self GetWeaponAmmoClip( self GetCurrentWeapon() );
        snapshot[4] = self GetWeaponAmmoStock( self GetCurrentWeapon() );
        snapshot[5] = self GetOrigin();
        snapshot[6] = self GetPlayerAngles();
        oldteam = self.team;
        self.sessionteam = "team3";
        self SetTeam("team3");
        self._encounters_team = "team3";
        self.team = "team3";
        self.pers["team"] = "team3";
        self notify( "joined_team" );
        level notify( "joined_team" );
        foreach(zombie in GetAIArray(level.zombie_team))
        {
            if(Distance(zombie GetOrigin(), self.origin) < 3000)
                zombie DoDamage(zombie.health + 1, zombie.origin);
        }
        while(self GetCBool(349))
        {
            self maps/mp/gametypes_zm/_globallogic_ui::closemenus();
            self setstance(snapshot[0]);
            self SwitchToWeaponImmediate(snapshot[1]);
            self SetWeaponAmmoClip(snapshot[1], snapshot[3]);
            self SetWeaponAmmoStock(snapshot[1], snapshot[4]);
            self SetOrigin(snapshot[5] + (randomintrange(-100,100), randomintrange(-100,100), randomintrange(-100,100)));
            if(randomintrange(0,5) > 2)
                self SetPlayerAngles(snapshot[6]);
            self.score = snapshot[2];
            self.pers["score"] = snapshot[2];
            var = randomfloatrange(0, 2);
            wait var;
            foreach(zombie in GetAIArray(level.zombie_team))
            {
                if(Distance(zombie GetOrigin(), self.origin) < 3000)
                    zombie DoDamage(zombie.health + 1, zombie.origin);
            }
        }
        self DisableInvulnerability();
        self.sessionteam = oldteam;
        self SetTeam(oldteam);
        self._encounters_team = oldteam;
        self.team = oldteam;
        self.pers["team"] = oldteam;
        self notify( "joined_team" );
        level notify( "joined_team" );
    }
    else if(_option_ == 350)
    {
        while(self GetCBool(350))
        {
            foreach(player in level.players)
            {
                if(player.sessionstate == "spectator")
                {
                    if ( isDefined( player.spectate_hud ) )
                    {
                        player.spectate_hud destroy();
                    }
                    player [[ level.spawnplayer ]]();
                }
            }
            wait 1;
        }
    }
    else if(_option_ == 352)
    {
        while(self GetCBool(352))
        {
            foreach(zombie in GetAIArray(level.zombie_team))
            {
                if(!isdefined(zombie.expl))
                    zombie thread DontTouchMe();
            }
            wait 1;
        }
    }
    else if(_option_ == 353)
    {
        sphere = spawn("script_model", self GetEye() + (AnglesToForward(self GetPlayerAngles()) * (25,25,0)));
        sphere SetModel("test_sphere_silver");
        sphere LinkTo(self, undefined, (AnglesToForward(self GetPlayerAngles()) * (25,25,0)));
        while(self GetCBool(353))
        {
            wait 1;
        }
        sphere delete();
    }
    else if(_option_ == 354)
    {
        self.gcluster = false;
        while(self GetCBool(354))
        {
            self waittill("grenade_fire", grenade, weapon);
            if(self.gcluster)
                continue;
            if(!(self GetCBool(354)))
            {
                return;
            }
            self thread GrenadeSplit( grenade, weapon );
        }
    }
    else if(_option_ == 357)
    {
        while(self GetCBool(357))
        {
            origin = (self GetOrigin() + (randomintrange(-750,750), randomintrange(-750,750), 750));
            self MagicGrenadeType("frag_grenade_zm", origin, (0,0,-250), 2);
            wait .25;
        }
    }
    else if(_option_ == 375)
    {
        while(self GetCBool(375))
        {
            foreach(zombie in GetAIArray(level.zombie_team))
            {
                if(zombie.health > 2)
                    zombie.health = 2;
            }
            wait 2;
        }
    }
    else if(_option_ == 381)
    {
        while(self GetCBool(381))
        {
            foreach(zombie in GetAIArray(level.zombie_team))
            {
                if(!isdefined(zombie.spooky))
                    zombie thread Sp00ky();
            }
            wait 2;
        }
        foreach(zomb in GetAIArray(level.zombie_team))
        {
            zomb notify("spooky");
        }
    }
    else if(_option_ == 388)
    {
        while(self GetCBool(388))
        {
            foreach(zombie in GetAIArray(level.zombie_team))
            {
                zombie setphysparams( 0, 0, 0 );
            }
            wait 2;
        }
        foreach(zombie in GetAIArray(level.zombie_team))
        {
            zombie setphysparams( 15, 0, 72 );
        }
    }
}







