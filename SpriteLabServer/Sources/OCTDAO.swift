//
//  OCTDAO.swift
//  SpriteLabServer
//
//  Created by yuhan zhang on 6/28/16.
//
//



protocol OCTDAO {
    
    associatedtype Model: OCTModel
    
    static var TableName: String { get }
    
    static var PrimaryKey: String { get }
    
    
    
    func findOne(id: String) -> Model?
    
    func findByKey(key: String, value: AnyObject) -> [Model]?

    func save(_ obj: Model)

}


extension OCTDAO {
    
    var psql: PGManager {
        return PGManager.sharedInstance
    }
    
    func findOne(id: String) -> Model? {
        
        let result = psql.exec(Self.queryFindOne(id: id))
        let status = result.status()
        
        
        var params = Dictionary<String, AnyObject>()
        
        if status == .CommandOK || status == .TuplesOK {
            
            if result.numFields() == 0 || result.numTuples() == 0 {
                return nil
            }
            
            for i in 0..<result.numFields() {
                
                let k = result.fieldName(index: i)!
                let v = result.getFieldString(tupleIndex: 0, fieldIndex: i)!
                
                if postgresResultIsArray(s: v) {
                    params.updateValue(postgresResultArray(s: v), forKey: k)
                } else {
                    params.updateValue(v, forKey: k)
                }
            }
            
        }
        else {
            Logger.error("BAD QUERY IN findOne()")
            
            return nil
        }
        
        
        return Model(fromDictionary: params)
    }
    
    
    func findByKey(key: String, value: AnyObject) -> [Model]? {
        let result = psql.exec(Self.queryFindByKey(key: key, value: value))
        let status = result.status()
        
        
        var entities: [Model]?
        
        if status == .CommandOK || status == .TuplesOK {
            print("\(status)")
            if result.numFields() == 0 || result.numTuples() == 0 {
                return nil
            }
            
            if entities == nil {
                entities = []
            }
            
            for i in 0..<result.numTuples() {
                var params = Dictionary<String, String>()
                for j in 0..<result.numFields() {
                    let value = result.getFieldString(tupleIndex: i, fieldIndex: j)
                    params.updateValue(value!, forKey: result.fieldName(index: j)!)
                }
                entities!.append(Model(fromDictionary: params))
            }
            
        }
        
        return entities
    }
    
    
    func save(_ obj: Model) {
        if hasEntity(obj) {
            _ = psql.exec(Self.queryUpdate(forModel: obj))
        } else {
            _ = psql.exec(Self.queryInsert(forModel: obj))
        }
    }
    
    
    func hasEntity(_ obj: Model) -> Bool {
        
        let value = Self.primaryValue(forEntity: obj) as! String
        
        if let _ = self.findOne(id: value) {
            return true
        }
        
        return false
    }
    
    
    static func primaryValue(forEntity obj: OCTModel) -> Any {
        let mir = Mirror(reflecting: obj)
        
        for (key, value) in mir.children {
            Logger.debug("\(key): \(value)")
            if key == Self.PrimaryKey {
                return value
            }
        }
        
        fatalError("EVERY ENTITY SHOULD HAVE A PRIMARY VALUE")
    }
    
}




//MARK:-  Query String



extension OCTDAO {
    
    static func queryFindOne(id: String) -> String {
        let query = "SELECT * FROM \(Self.TableName) WHERE \(Self.PrimaryKey) = \(postgresStyleString(forValue: id))"
        Logger.debug(query)
        return query
    }
    
    static func queryFindByKey(key: String, value: AnyObject) -> String {
        let query = "SELECT * FROM \(Self.TableName) WHERE \(key) = \(postgresStyleString(forValue: value))"
        Logger.debug(query)
        return query
    }
    
    static func queryUpdate(forModel obj: Model) -> String {
        var query = "UPDATE \(Self.TableName) SET "
        
        let params = obj.toDictionary()
        
        for param in params {
            if let value = param.1 {
                let key = param.0
                if postgresIsArray(obj: value) {
                    query.append("\(key) = \(postgresArrayString(array: value as! [AnyObject])),")
                } else {
                    query.append("\(key) = \(postgresStyleString(forValue: value)),")
                }
            }
        }
        
        query.removeLastCharacter()
        
        
        let primaryValue = Self.primaryValue(forEntity: obj)
        
        query.append(" WHERE \(Self.PrimaryKey) = \(postgresStyleString(forValue: primaryValue))")
        
        Logger.debug(query)
        
        return query
    }
    
    
    static func queryInsert(forModel obj: Model) -> String {
        var query = "INSERT INTO \(Self.TableName) "
        var keys = "("
        var values = " VALUES("
        
        let params = obj.toDictionary()
        
        for param in params {
            if let value = param.1 {
                let key = param.0
                
                keys.append(key + ",")
                
                
                if postgresIsArray(obj: value) {
                    values.append("\(postgresArrayString(array: value as! [AnyObject])),")
                } else {
                    values.append("\(postgresStyleString(forValue: value)),")
                }
                
            }
            
        }
        
        keys.removeLastCharacter()
        values.removeLastCharacter()
        
        keys.append(")")
        values.append(")")
        
        query += keys
        query += values
        
        Logger.debug(query)
        
        return query
    }
    
    
}













/*

enum PGQuery<M: OCTModel> {
    
//    associatedtype T: OCTDAO
    
    typealias T = SLUserDAO
    
    case FindOne(id: String)
    case FindByKey(key: String, value: AnyObject)
    
    case Update(obj: M)
    
    case Insert(obj: M)
    
    
    var query: String {
        switch self {
        case let .FindOne(id):
            return "SELECT * FROM \(T.TableName) WHERE \(T.PrimaryKey) = \(postgresStyleString(forValue: id))"
        case let .FindByKey(key, value):
            return "SELECT * FROM \(T.TableName) WHERE \(key) = \(postgresStyleString(forValue: value))"
        case let .Update(obj):
            var query = "UPDATE \(T.TableName) SET "
            
            let params = obj.toDictionary()
            
            for param in params {
                if let value = param.1 {
                    let key = param.0
                    query.append("\(key) = \(postgresStyleString(forValue: value)),")
                }
            }
            
            query.removeLastCharacter()
            
            
            let primaryValue = PGQuery.primaryValue(forEntity: obj)
            
            query.append(" WHERE \(T.PrimaryKey) = \(postgresStyleString(forValue: primaryValue))")
            
            return query
        case let .Insert(obj):
            var query = "INSERT INTO \(T.TableName) "
            var keys = "("
            var values = " VALUES("
            
            let params = obj.toDictionary()
            
            for param in params {
                if let value = param.1 {
                    let key = param.0
                    
                    keys.append(key + ",")
                    
                    values.append("\(postgresStyleString(forValue: value)),")
                    
                }
                
            }
            
            keys.removeLastCharacter()
            values.removeLastCharacter()
            
            keys.append(")")
            values.append(")")
            
            query += keys
            query += values
            
            return query
//        default:
//            return ""
        }
    }
    
    
    static func primaryValue(forEntity obj: OCTModel) -> Any {
        let mir = Mirror(reflecting: obj)
        
        for (key, value) in mir.children {
            if key == T.PrimaryKey {
                return value
            }
        }
        
        fatalError("EVERY ENTITY SHOULD HAVE A PRIMARY VALUE")
    }
    
}


 */
 
 

//MARK:- convenient func




func postgresStyleString(forValue value: Any) -> String {
    if value is String {
        return "'\(value)'"
    } else {
        return "\(value)"
    }
}


func postgresIsArray(obj: AnyObject) -> Bool {
    if obj is [String] {
        return true
    } else if obj is [Int] {
        return true
    }
    
    return false
}



func postgresResultIsArray(s: String) -> Bool {
    return s.hasPrefix("{") && s.hasSuffix("}")
}



func postgresArrayString(array: [AnyObject]) -> String {
    var ret = "'{"
    for a in array {
        ret.append("\(a),")
    }
    
    ret.removeLastCharacter()
    ret.append("}'")
    
    
    return ret
}


func postgresResultArray(s: String) -> [AnyObject] {
    var ss = String(s.characters.dropFirst())
    ss = String(ss.characters.dropLast())
    
    var ret = [AnyObject]()
    
    let values = ss.components(separatedBy: ",")
    
    if values.count == 0 {
        return ret
    }
    
    for v in values {
        ret.append(v)
    }
    
    return ret
}


private extension String {
    mutating func removeLastCharacter() {
        self = String(self.characters.dropLast())
    }
    
    mutating func replaceLastCharacter(by char: Character) {
        self.removeLastCharacter()
        self.append(char)
    }
}



























