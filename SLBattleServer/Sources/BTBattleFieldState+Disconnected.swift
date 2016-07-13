//
//  BTBattleFieldState+Disconnected.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/12/16.
//
//

import Foundation


class BTBattleFieldDisconnected: BTBattleFieldState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is BTBattleFieldEnding.Type
    }
    
    override func didEnterWithPreviousState(_ previousState: OCTState?) {
        super.didEnterWithPreviousState(previousState)
        
        
        self.battleField?.broadcast(BTMessage(command: BTCommand.PlayerDisconnected))
        let _ = self.stateMachine?.enterState(stateClass: BTBattleFieldEnding.self)
    }
    
}
