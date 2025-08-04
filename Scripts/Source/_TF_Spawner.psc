Scriptname _TF_Spawner extends ReferenceAlias  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Keyword Property LocTypeDungeon auto
Actor Property PlayerRef auto
ActorBase Property _TF_Falmer auto
FormList Property _TF_WallList auto

Event OnInit()

    Debug.Notification("Treasure Falmers Initialized")

EndEvent


Event OnLocationChange(Location akOldLoc, Location akNewLoc)

    if(akNewLoc.HasKeyword(LocTypeDungeon))
        Debug.Notification( _TF_WallList.GetAt(0).GetFormID()) ;DEBUG Check if flm is working
        ObjectReference ClosestWall = Game.FindClosestReferenceOfAnyTypeInListFromRef(_TF_WallList,PlayerRef,3000)
        Debug.Notification("ClosestWall: " + ClosestWall.GetFormID())
        ClosestWall.PlaceAtMe(_TF_Falmer)
    endif

EndEvent