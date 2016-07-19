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
        
        
        
        self.battleField?.broadcast(BTMessage(command: BTCommand.SStartFighting))
        for sock in self.battleField!.playerSockets {
            let _ = sock.stateMachine.enterState(stateClass: BTSocketFighting.self)
        }
        
        //zyh!!暂时没用，后面同步时间过长则判定掉线逻辑
        //如果一个进入Fighting，另一个没有进入Fighting，则永远不能进入Ending状态
        
        
        
        
//        self.battleField?.broadcast(BTMessage(command: BTCommand.SStartFighting))
        //zyh!! 不应该由Battle Field调用Socket
//        for sock in self.battleField!.playerSockets {
//            let _ = sock.stateMachine.enterState(stateClass: BTSocketFighting.self)
//        }
        
        
        
//        self.battleField?.broadcast(BTMessage(command: BTCommand.StartFighting))
        
    }
    
    
}
