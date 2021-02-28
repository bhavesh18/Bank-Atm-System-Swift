//
//  LocalData.swift
//  BankingSystem
//
//  Created by Bhavesh Sharma on 20/02/21.
//

import Foundation

// LocalData model which holds the Account details of all users
class LocalData: Codable{
    var accounts: [Account] = []
    
}

// Account model which holds the account details of single user
class Account: Codable{
    var customer_id: String
    var name: String
    var phoneNo: String
    var address: String
    var email: String
    var accountNo = [String:String]()
    var pin: String
    var accountTypes: [String]
    var accBalance = [String: String]()
    
    
    init(customer_id: String, name: String, phoneNo: String, address: String, email: String, accountNo: [String:String], pin: String, accountTypes: [String], accBalance: [String: String]) {
        self.customer_id = customer_id
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


