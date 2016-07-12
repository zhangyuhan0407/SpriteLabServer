//
//  Logger.swift
//  ZhaiClans
//
//  Created by yuhan zhang on 12/1/15.
//  Copyright © 2015 Octopus. All rights reserved.
//

import Foundation

public class Logger {
    
    public static var sharedInstance = Logger()
    
    private init() {}
    
    public static let debugMode = true
    
    public class func info(_ s: String, function: String = #function) {
        print("✅" + function + "\n" + s)
    }
    
    public class func debug(_ s: String, filename: String = #file, line: Int = #line, function: String = #function) {
        if Logger.debugMode {
            print("⚠️\((filename as NSString).lastPathComponent): line \(line) \(function):\n --- \(s)")
        }
    }
    
    public class func error(_ s: String, filename: String = #file, line: Int = #line, function: String = #function) {
        if true {
            print("❌\((filename as NSString).lastPathComponent): line \(line) \(function):\n --- \(s)")
        }
    }
}
