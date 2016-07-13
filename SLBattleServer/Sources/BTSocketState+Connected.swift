//
//  BTSocketState+Connected.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/12/16.
//
//

import Foundation


class BTSocketConnected: BTSocketState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is BTSocketMatching.Type || stateClass is BTSocketSynchronizing.Type || stateClass is BTSocketDisconnected.Type
    }
    
    
    
}
