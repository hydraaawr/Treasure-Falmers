Scriptname _TF_Spawner extends ReferenceAlias  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Keyword Property LocTypeDungeon auto
Actor Property PlayerRef auto
ActorBase Property _TF_Falmer auto
FormList Property _TF_WallList auto
Activator Property _TF_Portal auto

Actor Falmer

Event OnInit()

    Debug.Notification("Treasure Falmers Initialized")

EndEvent


Event OnLocationChange(Location akOldLoc, Location akNewLoc)

    if(akNewLoc.HasKeyword(LocTypeDungeon))
        Debug.Notification( _TF_WallList.GetAt(0).GetFormID()) ;DEBUG Check if flm is working
        ObjectReference ClosestWall = Game.FindClosestReferenceOfAnyTypeInListFromRef(_TF_WallList,PlayerRef,2048) ;; 29.25m aprox
        Debug.Notification("ClosestWall: " + ClosestWall.GetFormID()) ;DEBUG
        ClosestWall.PlaceAtMe(_TF_Portal) ; create portal effect at wall
        Falmer = ClosestWall.PlaceAtMe(_TF_Falmer) as Actor ; Create an object reference at wall
        Utility.Wait(10)
        ; Exit
        Falmer.PlaceAtMe(_TF_Portal)
        Falmer.Disable(abFadeOut = true)
        Falmer.Delete()
        
        
    endif

EndEvent