Scriptname _TF_Spawner extends ReferenceAlias  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Keyword Property LocTypeDungeon auto
Actor Property PlayerRef auto
ActorBase Property _TF_Falmer auto
FormList Property _TF_WallList auto
Activator Property _TF_Portal auto
Spell Property _TF_FalmerCloakAb auto
Actor Falmer
ObjectReference ClosestWall


Function ViableWallScan()
    Debug.Notification("Trying to find a viable wall...") ;DEBUG
    ClosestWall = Game.FindClosestReferenceOfAnyTypeInListFromRef(_TF_WallList,PlayerRef,2048)
    Utility.Wait(10) ; scan every XX
endFunction


Function FalmerSpawn()
    Debug.Notification("Closest viable wall: " + ClosestWall.GetFormID()) ;DEBUG
    Utility.Wait(2) ; timeout for when loading new dungeon
    Debug.Notification("A Treasure Falmer appeared!")
    ClosestWall.PlaceAtMe(_TF_Portal) ; create portal effect at wall
    Falmer = ClosestWall.PlaceAtMe(_TF_Falmer) as Actor ; Create an object ref of the Falmer at wall
    Falmer.AddSpell(_TF_FalmerCloakAb)
    Utility.Wait(10) ;;timeout until disappear
    ; Exit
    if(!Falmer.Isdead()) ;; if alive
        Debug.Notification("Treasure Falmer fled away!")
        Falmer.PlaceAtMe(_TF_Portal)
        Falmer.Disable(abFadeOut = true)
        Falmer.Delete()
    endif
endFunction


Event OnInit()

    Debug.Notification("Treasure Falmers Initialized")

EndEvent



Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    if(akNewLoc.HasKeyword(LocTypeDungeon)) 
        ;Debug.Notification( _TF_WallList.GetAt(0).GetFormID()) ;DEBUG Check if flm is working
        ;; This will determine the mode
        int SpawnMode = Utility.RandomInt(0,1)
        if(SpawnMode == 0) ;this is the standard trigger (on location change, find first available wall)
            Debug.Notification("Standard Mode") ;DEBUG

            ;; Look for viable wall
            while(!ClosestWall || !PlayerRef.HasLOS(ClosestWall))

                ViableWallScan()

            endwhile
            
            if(ClosestWall && PlayerRef.HasLOS(ClosestWall)) ; if exists and can see it
                
                FalmerSpawn()
            
            endif
        Else
            GoToState("DelMode") ; Delayed mode
            Debug.Notification("Delayed Mode") ;DEBUG
            float InitDelScan = Utility.RandomFloat(30,300)
            Debug.Notification("InitDelScan: " + InitDelScan) ;DEBUG
            RegisterForSingleUpdate(InitDelScan) ; Delayed Scan
        endif
    endif
EndEvent


State DelMode
;Delayed mode; waits to start looking for a viable wall

    Event OnUpdate()
        Debug.Notification("Init delayed scan")

        ;; repeat the scanning
        while(!ClosestWall || !PlayerRef.HasLOS(ClosestWall))

            ViableWallScan()

        endwhile

        if(ClosestWall && PlayerRef.HasLOS(ClosestWall)) ; if exists and can see it
                
            FalmerSpawn()
            
        endif

        GoToState("")

    endevent
endState