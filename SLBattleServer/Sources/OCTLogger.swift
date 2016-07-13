//
//  Logger.swift
//  ZhaiClans
//
//  Created by yuhan zhang on 12/1/15.
//  Copyright © 2015 Octopus. All rights reserved.
//

import Foundation

#if os(iOS)
    let SaveToFile = false
#else
    import PerfectLib
let SaveToFile = true
#endif

    
let DebugMode = true

let LogDirPath = "\(WebRoot)/logs"


public class Logger {
    
    private init() {}
    
    public class func info(_ s: String, function: String = #function) {
        print("INFO: \(function) --- \(s)")
    }
    
    public class func debug(_ s: String, filename: String = #file, line: Int = #line, function: String = #function) {
        if DebugMode {
            
            let mode = "DEBUG"
            if let file = filename.components(separatedBy: "/").last {
                print("DEBUG: \(function) --- \(s)")
            
                if SaveToFile {
                    do {
                        let time = localTime()
                        let logfile = File(LogDirPath + "/" + time.components(separatedBy: " ")[0])
                        try logfile.open(File.OpenMode.append)
                        let _ = try logfile.write(string: "\(time),\(mode),\(file),\(function),\(line),\(s)\n")
                    } catch {
                        print("save log failed")
                    }
                }
            }
            
        }
    }
    
    
    public class func warn(_ s: String, filename: String = #file, line: Int = #line, function: String = #function) {
        print("WARN: \(function) --- \(s)")
//        let mode = "WARN"
//        if let file = filename.components(separatedBy: "/").last {
//            print("\(mode): \(file)---\(function)---\(line)\n\t\(s)")
//        }
        
    }
    
    
    public class func error(_ s: String, filename: String = #file, line: Int = #line, function: String = #function) {
        let mode = "ERROR"
        if let file = filename.components(separatedBy: "/").last {
//            print("\(mode): \(file)---\(function)---\(line)\n\t\(s)")
            print("ERROR: \(function) --- \(s)")
            
            if SaveToFile {
                do {
                    let time = localTime()
                    let logfile = File(LogDirPath + "/" + time.components(separatedBy: " ")[0])
                    try logfile.open(File.OpenMode.append)
                    let _ = try logfile.write(string: "\(time),\(mode),\(file),\(function),\(line),\(s)\n")
                } catch {
                    print("save log failed")
                }
            }
        }
    }
    
    
    
    public class func localTime() -> String {
        
//        let date = Date()
//        let zone = TimeZone.system()
//        let interval = zone.secondsFromGMT(for: date)
//        let localDate = date.addingTimeInterval(TimeInterval(interval))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd HH:mm:ss:SSS"
        return formatter.string(from: Date())
    }
    
    
}



















