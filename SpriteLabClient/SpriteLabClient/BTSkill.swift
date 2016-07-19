//
//  BTSikll.swift
//  SpriteLabClient
//
//  Created by yuhan zhang on 7/16/16.
//  Copyright © 2016 octopus. All rights reserved.
//

import Foundation


class BTSkill: NSObject {
    
    weak var owner: BTPlayer?
    
    init(owner: BTPlayer) {
        self.owner = owner
    }
    
}


class BTSkillSystem: NSObject {
    
    var skills: [BTSkill]?
    
}
