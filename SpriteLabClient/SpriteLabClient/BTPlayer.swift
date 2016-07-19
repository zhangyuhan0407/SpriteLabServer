//
//  BTPlayer.swift
//  SpriteLabClient
//
//  Created by yuhan zhang on 7/16/16.
//  Copyright © 2016 octopus. All rights reserved.
//

import Foundation


class BTPlayer: NSObject {
    
    var map: BTMap!
    
    var skills: [BTSkill]!
    
    
    override init() {
        self.map = BTMap(style: .up)
    }
    
    
    
}





enum PlayerStatus {
    case Idle
    case Moving
    case CastingSpell
    case Dead
}
