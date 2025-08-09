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
GlobalVariable Property _TF_FalmerTimeLeft auto
GlobalVariable Property _TF_FalmerSpawnBaseChance auto


Function ViableWallScan()
    ;Debug.Notification("Trying to find a viable wall...") ;DEBUG
    ClosestWall = Game.FindClosestReferenceOfAnyTypeInListFromRef(_TF_WallList,PlayerRef,1000)
    ;Debug.Notification("Finished list travel") ;DEBUG
    Utility.Wait(3) ; scan every XX
endFunction


Function FalmerSpawn()
    ;Debug.Notification("Closest viable wall: " + ClosestWall.GetFormID()) ;DEBUG
    Debug.Notification("A Treasure Scamp appeared!")
    ClosestWall.PlaceAtMe(_TF_Portal) ; create portal effect at wall
    Falmer = ClosestWall.PlaceAtMe(_TF_Falmer) as Actor ; Create an object ref of the Falmer at wall
    Falmer.AddSpell(_TF_FalmerCloakAb)
    Utility.Wait(_TF_FalmerTimeLeft.GetValue()) ;;timeout until disappear
    ; Exit
    if(!Falmer.Isdead()) ;; if alive
        Falmer.PlaceAtMe(_TF_Portal)
        Falmer.Disable(abFadeOut = true)
        Falmer.Delete()
        Debug.Notification("Treasure Scamp fled away!")
    endif
endFunction


Event OnInit()

    Debug.Notification("Treasure Falmers Initialized")

EndEvent



Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    if (Falmer) ; Clean previous falmer just in case
        Falmer.Disable()
        Falmer.Delete()
    endif

    if (ClosestWall) ; Clean Last closestwall
        ClosestWall = NONE
    endif
    ;; Theres a random chance of the system even triggering
    int Roll = Utility.RandomInt(1, 100)
    int SpawnChance = _TF_FalmerSpawnBaseChance.GetValue() as int
    ;Debug.Notification("Roll: " + Roll + " vs Chance: " + SpawnChance) ;DEBUG
    if(akNewLoc.HasKeyword(LocTypeDungeon) && Roll <= SpawnChance) 
        ;Debug.Notification( _TF_WallList.GetAt(0).GetFormID()) ;DEBUG Check if flm is working
        float TScan = Utility.RandomFloat(60,420) ;bt 1 and 7 minutes to start scanning
        ;Debug.Notification("TScan: " + TScan) ;DEBUG
        RegisterForSingleUpdate(TScan) ; Register time



    endif
EndEvent




Event OnUpdate()
    ;Debug.Notification("Init scan")
    
    while(!ClosestWall && PlayerRef.GetCurrentLocation().HasKeyword(LocTypeDungeon))
        ViableWallScan()
    endwhile
    if(ClosestWall && PlayerRef.GetCurrentLocation().HasKeyword(LocTypeDungeon)) ; if exists
            
        FalmerSpawn()
        
    endif

endevent
