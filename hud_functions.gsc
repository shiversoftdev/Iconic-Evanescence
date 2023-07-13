createShader(shader, align, relative, x, y, width, height, color, alpha, sort)
{
    hud = newClientHudElem(self);
    hud.elemtype = "icon";
    hud.color = color;
    hud.alpha = alpha;
    hud.sort = sort;
    hud.children = [];
    hud setParent(level.uiParent);
    hud setShader(shader, width, height);
    hud setPoint(align, relative, x, y);
    hud.hideWhenInMenu = true;
    hud.archived = false;
    return hud;
}

drawText(text, font, fontScale, align, relative, x, y, color, alpha, glowColor, glowAlpha, sort, islevel)
{
    hud = undefined;
    if(isdefined(islevel) && islevel)
        hud = createserverfontstring(font, fontscale);
    else
        hud = self createFontString(font, fontScale);
    hud setPoint(align, relative, x, y);
    hud.color = color;
    hud.alpha = alpha;
    hud.glowColor = glowColor;
    hud.glowAlpha = glowAlpha;
    if(sort < 0)
        hud.sort = 6;
    else
        hud.sort = sort;
    hud.alpha = alpha;
    hud setSafeText(text);
    if(sort == -1)
        hud.foreground = true;
    hud.hideWhenInMenu = true;
    hud.archived = false;
    return hud;
}

SmartOverflowEngine()
{
    if(isdefined(level.SmartOverflowEngine))
        return;
    level.SmartOverflowEngine = true;
    level.uniquestrings = [];
    level.anchors = [];
    temp = createServerfontstring("default", 1);
    temp settext(&"Zombies Alive: ");
    temp settext(&"Total Zombies: ");
    temp settext("+");
    temp destroy();
    level.anchors[0] = createServerFontString("default", 1);
    level.anchors[0] setText("EANCHOR_0");
    level.anchors[0].alpha = 0;
    value = 0;
    level thread SmartOverflowOnEndedFix();
    level thread SmartOverFlowOptimizer();
    for(;;)
    {
        level waittill("settext");
        value++;
        if( value >= 50 )
        {
            value = 0;
            level.anchors[ level.anchors.size ] = createServerFontString("default", 1);
            level.anchors[ level.anchors.size - 1] setText(level.uniquestrings[ level.uniquestrings.size - 1]);
            level.anchors[ level.anchors.size - 1].alpha = 0;
        }
        if( level.uniquestrings.size >= 75 )
        {
            SmartOverflowAnchorClear();
            foreach(player in level.players)
            {
                if( level.page_offset[ player GetName() ] != 0 )
                    player thread UpdateMenu(false, true, level.page_offset[ player GetName() ]);
                else
                    player thread UpdateMenu(false, true);
            }
            wait .01;
        }
    }
}

SmartOverFlowOptimizer()
{
    level endon("game_ended");
    value = false;
    while( 1 )
    {
        level waittill("EvanescenceClose");
        value = false;
        foreach( player in level.players )
        {
            if( !isDefined(player GetMenu()) )
                continue;
            if((player GetMenu()).currentMenu != -1)
            {
                value = true;
                break;
            }
        }
        if( !value )
        {
            SmartOverflowAnchorClear();
        }
    }
}

SmartOverflowAnchorClear()
{
    for( i = level.anchors.size - 1; i > 0; i--)
    {
        level.anchors[i] ClearAllTextAfterHudElem();
        level.anchors[i] destroy();
        wait .0125;//wait_network_frame
        waittillframeend;
    }
    level.anchors[0] ClearAllTextAfterHudElem();
    level.uniquestrings = [];   
}

SmartOverflowOnEndedFix()
{
    level waittill( "game_ended" );
    SmartOverflowAnchorClear();
    foreach(player in level.players)
    {
        if( isDefined( player GetMenu() ) )
        {
            (player GetMenu()).currentmenu = -1;
            player thread UpdateMenu(false, true);
        }
    }
}

setSafeText(text)
{
    if( !isinarray(level.uniquestrings, text ) )
    {
        level.uniquestrings = add_to_array(level.uniquestrings, text, 0 );
        level notify("settext");
    }
    self setText(text);
}



ZMiniMap()
{
    self iprintln("^1 Minimap only visible when menu is closed");
    Menu = self GetMenu();
    while(self GetCBool(385))
    {
        while(Menu.currentmenu != -1)
            WaitMin();
        minimap = self createShader("menu_zm_popup", "CENTER", "TOP", -300, 85, 170, 170, (1,1,1), .75, 1);
        me = self createShader("ui_sliderbutt_1", "CENTER", "TOP", -300, 75, 7, 17, (0,0,1), .9, 2);
        shader = undefined;
        minimap thread emergencyDelete(Menu);
        me thread emergencyDelete(Menu);
        while(self GetCBool(385) && Menu.currentMenu == -1)
        {
            foreach( zombie in GetAIArray(level.zombie_team))
            {
                if(Distance( self GetOrigin(), zombie GetOrigin()) < 1000)
                {
                    if(zombie.team != self.team)
                        shader = self createShader("ui_sliderbutt_1", "CENTER", "TOP", -300, 75, 7, 17, (1,0,0), .8, 2);
                    else
                        shader = self createShader("ui_sliderbutt_1", "CENTER", "TOP", -300, 75, 7, 17, (0,1,0), .8, 2);
                    shader thread updateMMPos( self getOrigin(), zombie getOrigin(), self getplayerangles() );
                    shader thread emergencyDelete(Menu);
                }
            }
            wait 1.0125;
            waittillframeend;
        }
        me notify("noemergency");
        me destroy();
        minimap notify("noemergency");
        minimap destroy();
    }
}
 
updateMMPos( center, offset, angles )
{
    self endon("emergencyfix");
    self endon("noemergency");
    self thread PingShader();
    while( isdefined(self) )
    {
        d = offset - center;
        d0 = Distance( offset, center );
        x = cos( angles[1] - ATan2( d[1], d[0] ) + 90 ) * d0;
        y = sin( angles[1] - ATan2( d[1], d[0] ) + 90 ) * d0;
        offx = x / 1000;
        if( offx > 1 )
            offx = 1;
        else if( offx < -1 )
            offx = -1;
        offy = y / 1000;
        if( offy > 1 )
            offy = 1;
        else if( offy < -1 )
            offy = -1;
        self.x = -300 + offx * 75;
        self.y = 75 + offy * 75;
        WaitMin();
    }
}

ATan2( y, x )
{
    if( x > 0 )
        return ATan( y / x );
    if( x < 0 && y >= 0 )
        return ATan( y / x ) + 180;
    if( x < 0 && y < 0 )
        return ATan( y / x ) - 180;
    if( x == 0 && y > 0 )
        return 90;
    if( x == 0 && y < 0 )
        return -90;
    return 0;
}

PingShader()
{
    self endon("emergencyfix");
    self.alpha = 1;
    self fadeovertime( .8 );
    self.alpha = 0;
    wait 1;
    self notify("noemergency");
    self Destroy();
}

emergencyDelete( menu )
{
    self endon("noemergency");
    while( isdefined(self) && menu.currentmenu == -1 )
        WaitMin();
    self notify("emergencyfix");
    self destroy();
}
