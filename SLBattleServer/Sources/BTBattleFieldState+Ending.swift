//
//  BTBattleFieldState+Ending.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/12/16.
//
//

import Foundation


class BTBattleFieldEnding: BTBattleFieldState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
    
    
    override func didEnterWithPreviousState(_ previousState: OCTState?) {
        super.didEnterWithPreviousState(previousState)
        
        
        BTBattleFieldManager.sharedInstance.removeBattleField(key: self.battleField!.id)
    }
    
    
}
