//
//  BTBattleFieldState+Fighting.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/12/16.
//
//

import Foundation


class BTBattleFieldFighting: BTBattleFieldState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        if stateClass is BTBattleFieldEnding.Type {
            if self.battleField!.isAllPlayerStateEnding {
                return true
            }
        } else if stateClass is BTBattleFieldDisconnected.Type {
            return true
        }
        
        return false
    }
    
    override func didEnterWithPreviousState(_ previousState: OCTState?) {
        super.didEnterWithPreviousState(previousState)
        
        //zyh!! 不应该由Battle Field调用Socket
        for sock in self.battleField!.playerSockets {
            let _ = sock.stateMachine.enterState(stateClass: BTSocketFighting.self)
        }
        self.battleField?.broadcast(BTMessage(command: BTCommand.StartFighting))
        
    }
    
//    override func willExitWithNextState(_ nextState: OCTState) {
//        if nextState is BTBattleFieldEnding {
//            self.battleField?.broadcast(BTMessage(command: BTCommand.EndFighting))
//        }
//    }
    
    
}
