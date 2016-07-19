//
//  BTMap.swift
//  SpriteLabClient
//
//  Created by yuhan zhang on 7/16/16.
//  Copyright © 2016 octopus. All rights reserved.
//

import Foundation


enum MapStyle {
    case up
    case down
}


class BTMap: NSObject {
    
    let style: MapStyle
    
    var cells: [BTMapCell]!
    
    
    lazy var objects = [BTMapCellStandable]()
    
    
    var row = 0
    var column = 0
    
    
    
    
    
    init(style: MapStyle) {
        self.style = style
    }
    
}
