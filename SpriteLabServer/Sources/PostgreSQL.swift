//
//  PostgreSQL.swift
//  PerfectTemplate
//
//  Created by yuhan zhang on 6/27/16.
//
//


import PostgreSQL

class PGManager {
    
    static let sharedInstance = PGManager()
    
    let psql = PGConnection()
    
    private init() {
        _ = psql.connectdb("dbname=sample_db")
    }
    
    func exec(_ query: String) -> PGResult {
        return self.psql.exec(statement: query)
    }
    
}

