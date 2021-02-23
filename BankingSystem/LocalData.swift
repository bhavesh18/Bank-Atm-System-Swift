//
//  LocalData.swift
//  BankingSystem
//
//  Created by Bhavesh Sharma on 20/02/21.
//

import Foundation

class LocalData: Codable{
    var accounts: [Account] = []
    
}

class Account: Codable{
    var cin: String
    var name: String
    var phoneNo: String
    var address: String
    var email: String
    var accountNo = [String:String]()
    var pin: String
    var accountTypes: [String]
    var accBalance = [String: String]()
    
    
    init(cin: String, name: String, phoneNo: String, address: String, email: String, accountNo: [String:String], pin: String, accountTypes: [String], accBalance: [String: String]) {
        self.cin = cin
        self.name = name
        self.phoneNo = phoneNo
        self.address = address
        self.email = email
        self.accountNo = accountNo
        self.pin = pin
        self.accountTypes = accountTypes
        self.accBalance = accBalance
        
    }
    
}
