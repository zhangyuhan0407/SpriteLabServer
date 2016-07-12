




import PerfectLib
import Foundation

// Initialize base-level services
PerfectServer.initializeServices()


#if os(Linux)
let WebRoot = "/root/Developer/SLBattleServer/webroot"
#else
let WebRoot = "/Users/yorg/Developer/SpriteLabServer/SLBattleServer/webroot"
#endif


// Create our webroot
// This will serve all static content by default
//let webRoot = "./webroot"
//print(try Dir("\(webRoot)/logs").exists())

//do {
//    try Dir("\(webRoot)/logs").create()
//    Logger.info("create logs")
//} catch {
//    Logger.error("create dir logs")
//}
//
//
//let file = File("\(webRoot)/logs/caocaocao")
//
//
//if file.exists {
//    file.delete()
//}
//
//do {
//try file.open(File.OpenMode.write)
//
//
//let a = try file.write(string: "zhangyuhan\n")
//
//    
//file.close()
//} catch {
//    print("file open error")
//}



// Add our routes and such
// Register your own routes and handlers
// Add a default route which lets us serve the static index.html file


addURLRoutes()



do {
    
    // Launch the HTTP server on port 8181
    try HTTPServer(documentRoot: WebRoot).start(port: 8282)
    
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}



public let KeyBattleFieldKey = "battle_field_key"
public let KeyPlayerKeys = "player_keys"













