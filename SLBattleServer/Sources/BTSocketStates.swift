//
//  BTSocketState.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/12/16.
//
//

import Foundation

class BTSocketConnected: BTSocketState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is BTSocketMatching.Type || stateClass is BTSOcketSynchronizing.Type
    }
    
    
    
}



class BTSocketMatching: BTSocketState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is BTSocketFighting.Type
    }
    
}



class BTSOcketSynchronizing: BTSocketState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is BTSocketFighting.Type
    }
}



class BTSocketFighting: BTSocketState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is BTSocketEnding.Type
    }
}




class BTSocketEnding: BTSocketState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
}















