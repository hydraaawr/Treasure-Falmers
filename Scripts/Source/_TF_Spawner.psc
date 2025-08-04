Scriptname _TF_Spawner extends ReferenceAlias  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Keyword Property LocTypeDungeon auto
Actor Property PlayerRef auto
ActorBase Property _TF_Falmer auto


Event OnInit()

    Debug.Notification("Treasure Falmers Initialized")

EndEvent


Event OnLocationChange(Location akOldLoc, Location akNewLoc)

    if(akNewLoc.HasKeyword(LocTypeDungeon))
        PlayerRef.PlaceActorAtMe(_TF_Falmer)
    endif

EndEvent