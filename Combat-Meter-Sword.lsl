integer max_stamina = 10;
integer stamina;
integer victim_chan = 9999;
float Range = 2.5;
float Speed = .55;
integer animate = FALSE;
integer ready = FALSE;

update_hover_text()
{
    llSetText("5 Damage / Stamina Left : " + (string) stamina,<1, 1, 1>,1.0);
}
default
{
    attach(key AvatarKey)
    {
        if(AvatarKey)
        {
            llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS|PERMISSION_TRIGGER_ANIMATION);
        }
    }
    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TAKE_CONTROLS)
        {
            llTakeControls(CONTROL_LBUTTON|CONTROL_ML_LBUTTON,TRUE,TRUE);
        }
        if(perm & PERMISSION_TRIGGER_ANIMATION)
        {
            animate = TRUE;
        }
    }
    state_entry()
    {
        stamina = max_stamina;
        llSay(0, "Hello, Avatar!");
         update_hover_text();
         llSetTimerEvent(5);
         llListen(1,"","","");
         llSetLinkAlpha(LINK_SET,0,ALL_SIDES);
    }
    listen(integer chan, string name, key id, string msg)
    {
        if(llGetOwnerKey(id) == llGetOwner())
        {
            if(msg == "draw sword")
            {
                ready = TRUE;
         llSetLinkAlpha(LINK_SET,1,ALL_SIDES);
            llStartAnimation("1hStance");
            }
            if(msg == "sheath sword")
            {
                ready = FALSE;
                 llSetLinkAlpha(LINK_SET,0,ALL_SIDES);
                 llStopAnimation("1hStance");
            }
            if(msg == "fallen")
            {
                //llOwnerSay("fallen received");
                ready = FALSE;
                 llSetLinkAlpha(LINK_SET,0,ALL_SIDES);
                 llStopAnimation("1hStance");
            }
        }
    }

    /*touch_start(integer total_number)
    {
        llSay(0, "Touched.");
        if(stamina > 0)
        {
            stamina--;
            
            //llRegionSay(victim_chan,"hit2");///+DIV+(string)player_id);
            update_hover_text();
        }
    }*/
    timer()
    {
        if(stamina < 10)
        {
            stamina++;
            update_hover_text();
        }
    }
    control(key id, integer down, integer change)
    {
        if(!ready) return;
        integer pressed = down & change;
        if((pressed) &   (CONTROL_ML_LBUTTON | CONTROL_LBUTTON))
        {
            if(llGetTime()>=Speed)
            {
                llSensor("",NULL_KEY, AGENT, Range, PI_BY_TWO);
                if(animate)
                {
                    llStartAnimation("1hA1");
                }
            }
        }
        
    }
    sensor(integer numberDetected)
    {
        
        key id = llDetectedKey(0);
        llRegionSayTo(id, victim_chan,"hit2");
        llPlaySound("sas1",1.0);
        if(stamina>3) stamina = stamina - 3;
        else
        stamina = 0;
            
    }
    no_sensor()
    {
        if(stamina>4) stamina = stamina - 4;
        else
        stamina = 0; 
    }
    

}
