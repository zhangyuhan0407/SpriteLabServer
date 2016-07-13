//
//  BTBattleFieldState+Synchronizing.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/12/16.
//
//

import Foundation


class BTBattleFieldSynchronizing: BTBattleFieldState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        if stateClass is BTBattleFieldFighting.Type {
            if self.battleField!.isAllPlayerStateMatching {
                return true
            }
            
            else if self.battleField!.isAllPlayerStateSynchronizing {
                return true
            }
            
        } else if stateClass is BTBattleFieldDisconnected.Type {
            return true
        }
        
        return false
        
    }
}
