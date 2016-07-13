//
//  BTSocketState+Ending.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/12/16.
//
//

import Foundation



class BTSocketEnding: BTSocketState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
    
    override func didEnterWithPreviousState(_ previousState: OCTState?) {
        super.didEnterWithPreviousState(previousState)
        
        
        //zyh!
        //如果有战场，则通过战场移除，否则直接移除
        
        //每一个socket被BTSocketManager引用
        //在战场中的socket同时被它的BattleField引用
        //当游戏正常结束，先将socket从BTSocketManager中移除。10s之内从BattleField中移除。
        //从两者中移除后，由于没人引用socket，则调用socket的deinit方法断开连接。
        //如果玩家在游戏结束的10s之内再次进入游戏，则该玩家的userid和socket连接将会同时出现在BattleField中和BTSocketManager中（两个完全相同的对象）
        if self.socket!.isInBattleField {
            let _ = self.socket?.battleField?.stateMachine.enterState(stateClass: BTBattleFieldEnding.self)
        } 
        
        BTSocketManager.sharedInstance.removeSocket(key: self.socket!.id)
        
        
    }
    
    
    
    
    
    
    
}




























