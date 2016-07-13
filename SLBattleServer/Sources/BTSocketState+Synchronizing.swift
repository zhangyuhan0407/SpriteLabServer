//
//  BTSocketState+Synchronizing.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/12/16.
//
//

import Foundation


class BTSocketSynchronizing: BTSocketState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is BTSocketFighting.Type || stateClass is BTSocketDisconnected.Type
    }
    
    override func didEnterWithPreviousState(_ previousState: OCTState?) {
        super.didEnterWithPreviousState(previousState)
        
        let _ = self.socket?.battleField?.stateMachine.enterState(stateClass: BTBattleFieldFighting.self)
    }
    
}
