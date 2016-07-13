//
//  BTSocketState+Disconnected.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/12/16.
//
//

import Foundation


class BTSocketDisconnected: BTSocketState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    
    override func didEnterWithPreviousState(_ previousState: OCTState?) {
        super.didEnterWithPreviousState(previousState)
        
        
        let _ = self.socket?.battleField?.stateMachine.enterState(stateClass: BTBattleFieldDisconnected.self)
        let _ = self.socket?.stateMachine?.enterState(stateClass: BTSocketEnding.self)
    }
    
}
