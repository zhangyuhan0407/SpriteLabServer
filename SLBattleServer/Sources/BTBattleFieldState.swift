//
//  BTBattleFieldStates.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/12/16.
//
//

import Foundation


class BTBattleFieldState: OCTState {
    
    weak var battleField: BTBattleField?
    
    
    init(_ bf: BTBattleField) {
        self.battleField = bf
    }
    
    
    
}

//socket Synchronizing和Fighting状态是由服务器来更改，其他状态都客户端自行更改



class BTBattleFieldCreated: BTBattleFieldState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        if stateClass is BTBattleFieldSynchronizing.Type {
            
            return true
            
        } else if stateClass is BTBattleFieldDisconnected.Type {
            return true
        }
        
        return false
        
    }
    
    
    
    
}











