integer max_health = 100;
integer health;
integer maxedHealth = TRUE;
integer need_treatment = FALSE;
float recovery_timer = 0;
float wound_timer = 0;
float treatment_reminder_timer;
integer wounds = 0;
integer healing_active = TRUE;
vector hover_text_color;
string damage_bar;
integer meter_chan = 9999;
integer unconscious = FALSE;
integer unconsciousTimer = 60;

knocked_unconscious()
{
    
    health = 0;
    llSay(0,"Health Reached 0 % at " + ConvertWallclockToTime());
    llSetText("Unconscious",<0, 0, 0>,1.0); 
    unconsciousTimer = 20;
    unconscious = TRUE;
    llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
    
}
key myUUID = "bf886d0f-063f-4fcd-9cc7-5b03ae6a532a";
key mesherUUID = "67c32cc8-ae26-4cc1-acda-e9500fe222c3";
security_check()
{
    integer x = llList2Integer(llGetObjectDetails( llGetKey() , [OBJECT_TOTAL_SCRIPT_COUNT]),0);
    
    if(x > 1)
    {
         
       llOwnerSay("Please do not add/remove scripts to this object");
       llDie();
    }
        if (llList2Key(llGetObjectDetails( llGetKey() , [OBJECT_CREATOR]),0) != myUUID)
        {
            llOwnerSay("Please do not move this script into unapproved objects. Thank you.");
            llRemoveInventory(llGetScriptName());
        }
    
    x=llGetObjectPermMask(MASK_OWNER);
    /*if (llGetOwner() != myUUID)
    {
        if (x & PERM_MODIFY)
        {
            llOwnerSay("Please do not move Revnik Labs scripts into new objects");
            llOwnerSay("Please do not move this script into unapproved objects. Thank you.");
            llRemoveInventory(llGetScriptName());
        }
    }*/
    
}
update_hover_text()
{
   if(health > 99)
   { █ ▓ ▒ ░
       hover_text_color = <0.180, 0.800, 0.251>;
       damage_bar = "████████";
        //llSetText("Health = " + (string) health + "%\nWounds = " + (string) wounds,<0.180, 0.800, 0.251>,1.0);
       //return;
    }
    if(health < 100)
    {
    if(health > 75)
            {
                hover_text_color = <0.180, 0.800, 0.251>;
                damage_bar = "██████░░";
                //llSetText("Health = " + (string) health + "%\nWounds = " + (string) wounds,<0.180, 0.800, 0.251>,1.0); 
            }
            else
            if(health > 50)
            {
                hover_text_color = <1.0, 0.863, 0.0>;
                damage_bar = "████░░░░";
            }
            else
            if(health > 25)
            {
                hover_text_color = <1.000, 0.522, 0.106>;
                damage_bar = "██░░░░░░";
                //llSetText("Health = " + (string) health + "%\nWounds = " + (string) wounds,<1.0, 0.863, 0.0>,1.0); 
            }
            else
            if(health<=25)
            {
                hover_text_color = <1.000, 0.255, 0.212>;
                damage_bar = "░░░░░░░░";
                //llSetText("Health = " + (string) health + "%\nWounds = " + (string) wounds,<1.000, 0.522, 0.106>,1.0);
            }
        }
        //llSetText("Health\n" + "[" + (string) health + "/100] \n" + "{" + damage_bar + "}" + "\nWounds = " + (string) wounds,hover_text_color,1.0);
 
        llSetText("Health\n" + "[" + (string) health + "/" + (string) max_health + "]" + "\nWounds = " + (string) wounds,hover_text_color,1.0);
}

float wound_health_reminder_timer = 0;

wounded_health_cap_text()
{
    if(llGetTime() >= wound_health_reminder_timer)
     {    
        llWhisper(0,"health capped at " + (string) health + "% because you have " + (string) wounds + " wounds");
        wound_health_reminder_timer = llGetTime() + 15;
        return;
        
    }
}
string ConvertWallclockToTime()
{
    integer now = (integer)llGetWallclock();
    integer seconds = now % 60;
    integer minutes = (now / 60) % 60;
    integer hours = now / 3600;
    return llGetSubString("0" + (string)hours, -2, -1) + ":" 
        + llGetSubString("0" + (string)minutes, -2, -1) + ":" 
        + llGetSubString("0" + (string)seconds, -2, -1);
}


default
{
    state_entry()
    {
        security_check();
        llSay(0, "Max Health Set to 100!");
        llListen(meter_chan,"","","");
        health = max_health;
        update_hover_text();
        llSay(0,"Health set to max : " + (string)health + "%");
        wound_timer = llGetTime() + 30;
        treatment_reminder_timer = llGetTime() + 5;
        llSetTimerEvent(1);
    }
    run_time_permissions(integer perm)
    {
        if(PERMISSION_TAKE_CONTROLS & perm)
        {
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_UP | CONTROL_DOWN, TRUE, FALSE);
        }
    }
    listen(integer chan, string name, key id, string msg)
    {
        if(msg == "hit")
        {
            if(unconscious)return;
            
            maxedHealth = FALSE;
            
            if(health > 10)
            {
                health = health - 10;
                
                wound_timer = llGetTime() + 30;
                
                llSay(0,"Health decreased to " + (string) health + "%"); 
                
                if(health<90)
                {
                    if(health<80)
                    {
                        if(health<70)
                        {
                            if(health<60)
                            {
                                
                                if(health<50)
                                {
                                    if(health<40)
                                    {
                                        if(health<30)
                                        {
                                            if(health<20)
                                            {
                                                if(health<10)
                                                {
                                                    if(wounds<9)wounds = 9;
                                                }
                                                else
                                                if(wounds<8)wounds = 8;
                                            }
                                            else
                                            if(wounds<7)wounds = 7;
                                            
                                        }
                                        else
                                        if(wounds<6)wounds = 6;
                                    }
                                    else
                                    if(wounds<5)wounds = 5;
                                }
                                else
                                if(wounds<4)wounds = 4;
                            }
                            else
                            if(wounds<3)wounds = 3;
                            
                        }
                        else
                        if(wounds<2)wounds = 2;
                    }
                    else
                    if(wounds<1)wounds = 1;
                }
                update_hover_text();
                
                if((!need_treatment) && (wounds > 3))
                            {
                                need_treatment = TRUE;
                                llSay(0,"Severe wounds taken, you must see a physician to heal wounds above 60 percent health");
                            }
            }
            else
            if(health <= 10)
            {
                knocked_unconscious();
                llWhisper(1,"fallen");
                //llRegionSayTo(llGetOwnerKey(id),1,"fallen");
            }
        }
        if(msg == "hit2")
        {
            if(unconscious)return;
            
            maxedHealth = FALSE;
            
            if(health > 5)
            {
                health = health - 5;
                
                wound_timer = llGetTime() + 30;
                
                llSay(0,"Health decreased to " + (string) health + "%"); 
                
                if(health<90)
                {
                    if(health<80)
                    {
                        if(health<70)
                        {
                            if(health<60)
                            {
                                
                                if(health<50)
                                {
                                    if(health<40)
                                    {
                                        if(health<30)
                                        {
                                            if(health<20)
                                            {
                                                if(health<10)
                                                {
                                                    if(wounds<9)wounds = 9;
                                                }
                                                else
                                                if(wounds<8)wounds = 8;
                                            }
                                            else
                                            if(wounds<7)wounds = 7;
                                            
                                        }
                                        else
                                        if(wounds<6)wounds = 6;
                                    }
                                    else
                                    if(wounds<5)wounds = 5;
                                }
                                else
                                if(wounds<4)wounds = 4;
                            }
                            else
                            if(wounds<3)wounds = 3;
                            
                        }
                        else
                        if(wounds<2)wounds = 2;
                    }
                    else
                    if(wounds<1)wounds = 1;
                }
                update_hover_text();
                
                if((!need_treatment) && (wounds > 3))
                            {
                                need_treatment = TRUE;
                                llSay(0,"Severe wounds taken, you must see a physician to heal wounds above 60 percent health");
                            }
            }
            else
            if(health <= 5)
            {
                knocked_unconscious();
                llWhisper(1,"fallen");
                //llRegionSayTo(llGetOwnerKey(id),1,"fallen");
            }
        }
    }
    
    touch_start(integer total_number)
    {
        
            if(unconscious)return;
        maxedHealth = FALSE;
        
        if(health > 10)
        {
            health = health - 10;
            
            wound_timer = llGetTime() + 30;
            
            llSay(0,"Health decreased to " + (string) health + "%"); 
            
            if(health<90)
            {
                if(health<80)
                {
                    if(health<70)
                    {
                        if(health<60)
                        {
                            
                            if(health<50)
                            {
                                if(health<40)
                                {
                                    if(health<30)
                                    {
                                        if(health<20)
                                        {
                                            if(health<10)
                                            {
                                                if(wounds<9)wounds = 9;
                                            }
                                            else
                                            if(wounds<8)wounds = 8;
                                        }
                                        else
                                        if(wounds<7)wounds = 7;
                                        
                                    }
                                    else
                                    if(wounds<6)wounds = 6;
                                }
                                else
                                if(wounds<5)wounds = 5;
                            }
                            else
                            if(wounds<4)wounds = 4;
                        }
                        else
                        if(wounds<3)wounds = 3;
                        
                    }
                    else
                    if(wounds<2)wounds = 2;
                }
                else
                if(wounds<1)wounds = 1;
            }
            update_hover_text();
            
            if((!need_treatment) && (wounds > 3))
                        {
                            need_treatment = TRUE;
                            llSay(0,"Severe wounds taken, you must see a physician to heal wounds above 60 percent health");
                        }
        }
        else
        if(health <= 10)
        {
            knocked_unconscious();
        }
    }
    timer()
    {
        if(!unconscious)
        {
            
            if((wounds > 0) && (llGetTime() > wound_timer))
            {
                if(need_treatment && (wounds == 3))
                {
                    if(llGetTime() > treatment_reminder_timer)
                    {
                        
                        llSay(0,"You need treated by a physician before you can heal more wounds.");
                        treatment_reminder_timer = llGetTime() + 5;
                        return;
                    }
                }
                else
                wounds--;
                healing_active = TRUE;
                wound_timer = llGetTime() + 30;
            }
            if((health < max_health) && (llGetTime() >= recovery_timer))
            {
                if((health==10) && (wounds == 9))
                {
                    healing_active = FALSE;
                    wounded_health_cap_text();
                }
                else
                if((health==20) && (wounds == 8))
                {
                    healing_active = FALSE;
                    wounded_health_cap_text();
                }
                else
                if((health==30) && (wounds == 7))
                {
                    healing_active = FALSE;
                    wounded_health_cap_text();
                }
                else
                if((health==40) && (wounds == 6))
                {
                    healing_active = FALSE;
                    wounded_health_cap_text();
                }
                else
                if((health==50) && (wounds == 5))
                {
                    healing_active = FALSE;
                    wounded_health_cap_text();
                }
                else
                if((health==60) && need_treatment)
                {
                    return;
                }
                else
                if((health==60) && (wounds == 4))
                {
                    healing_active = FALSE;
                    wounded_health_cap_text();
                }
                else
                if((health==70) && (wounds == 3))
                {
                    healing_active = FALSE;
                    wounded_health_cap_text();
                }
                else
                if((health==80) && (wounds == 2))
                {
                    healing_active = FALSE;
                    wounded_health_cap_text();
                }
                else
                if((health==90) && (wounds == 1))
                {
                    healing_active = FALSE;
                    wounded_health_cap_text();
                }
                
                if(healing_active)
                {
                    health = health + 1;
                    //llSay(0,"Health recovered to " + (string) health + "%");
                    recovery_timer = llGetTime() + 2;
                }
            }
            update_hover_text();
        }
        //else
        if(unconscious)
        {
            
                //unconsciousTimer--;
                if(unconsciousTimer>0)
                {
                    unconsciousTimer--;
                    llSetText("Time Left Until Recovery : " + (string) unconsciousTimer,<0, 0, 0>,1.0);            
                    //return;
                }
                else
                //if(unconsciousTimer=0)
                {
                    llReleaseControls();
                    llSay(0,"Recovered from unconsciousness");
                    unconscious = FALSE;
                }
            
        }
         
    }
}
