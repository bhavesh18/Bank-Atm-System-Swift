//
//  Banking.swift
//  BankingSystem
//
//  Created by Bhavesh Sharma on 20/02/21.
//

import Foundation


class Banking{
    
    private func getIndex(with cin: String)->Int{
        let localData = readLocalFile()
        if(localData.accounts.isEmpty){
            return -1
        }
        return localData.accounts.firstIndex(where: {$0.cin == cin}) ?? -1
    }
    
    private func createAccount(of accountType: String){
        print("Enter CIN")
        let cin = readLine()!
        
        let localData = readLocalFile()
        var accountTypes = [String]()
        var accBalance = [String: String]()
        var accNo: String = ""
        var pin: String = ""
        
        let index = getIndex(with: cin)
        
        if(index == -1){
            // new user
            accountTypes.append(accountType)
            accBalance[accountType] = "0"
            
            print("Enter name")
            let name = readLine()!
            print("Enter Phone number")
            let phoneNo = readLine()!
            print("Enter address")
            let address = readLine()!
            print("Enter email address")
            let email = readLine()!
            
            let accountNo = String(String(Int64(Date().timeIntervalSince1970 * 1000)).suffix(10))
            accNo = accountNo
            let generatedPin = String(String(Int64(Date().timeIntervalSince1970 * 1000)).suffix(4))
            pin = generatedPin
            let account = Account(cin: cin, name: name, phoneNo: phoneNo, address: address, email: email, accountNo: [accountType:accountNo], pin: pin, accountTypes: accountTypes, accBalance: accBalance)
            
            localData.accounts.append(account)
        }else{
            //existing user data
            let storedAcc = localData.accounts[index]
            
            let accountNo = String(String(Int64(Date().timeIntervalSince1970 * 1000)).suffix(10))
            accNo = accountNo
            let generatedPin = String(String(Int64(Date().timeIntervalSince1970 * 1000)).suffix(4))
            pin = generatedPin
            
            accountTypes = storedAcc.accountTypes
            
            //adding new account no. to stored dictionary
            var updatedAccNo = storedAcc.accountNo
            updatedAccNo[accountType] = accountNo
            
            //adding new account balance. to stored dictionary
            accBalance = storedAcc.accBalance
            accBalance[accountType] = "0"
            
            if(storedAcc.accountTypes.contains(accountType)){
                // account type already exists
                print("\(accountType) account already exists. Choose another account type.")
                selectAccountType()
                return
            }else{
                accountTypes.append(accountType)
            }
            
            let account = Account(cin: storedAcc.cin, name: storedAcc.name, phoneNo: storedAcc.phoneNo, address: storedAcc.address, email: storedAcc.email, accountNo: updatedAccNo, pin: storedAcc.pin, accountTypes: accountTypes, accBalance: accBalance)
            localData.accounts[index] = account
            
            print("----------------------------------------------------------------------------")
            print("User Details:")
            print("Name: \(storedAcc.name) | Phone No. \(storedAcc.phoneNo) | Address: \(storedAcc.address) | Email: \(storedAcc.email) ")
            
        }
        
        saveJsonFile(of: localData)
        
        print("Account Created Successfully!!")
        print("----------------------------------------------------------------------------")
        print("Your Account No. is: \(accNo)    Pin: \(pin)    Account Type: \(accountType)")
        print("----------------------------------------------------------------------------")
        
        readData()
    }
    
    
    private func editAccountDetails(){
        print("Enter CIN")
        let cin = readLine()!
        var accounts = readLocalFile().accounts
        
        if(accounts.contains(where: {$0.cin == cin})){
            
            print("Enter new name")
            let name = readLine()!
            print("Enter new Phone number")
            let phoneNo = readLine()!
            print("Enter new address")
            let address = readLine()!
            print("Enter new email address")
            let email = readLine()!
            
            if let row = accounts.firstIndex(where: {$0.cin == cin}) {
                accounts[row] = Account(cin: accounts[row].cin, name: name, phoneNo: phoneNo, address: address, email: email, accountNo: accounts[row].accountNo, pin: accounts[row].pin, accountTypes: accounts[row].accountTypes, accBalance: [:])
            }
            
            //saving updated data locally
            let localData = readLocalFile()
            localData.accounts = accounts
            saveJsonFile(of: localData)
            print("Details Updated Successfully")
            readData()
        }else{
            print("CIN does not exist")
            print("1. Re-enter    2. or any no. to Exit")
            let choice = readLine()!
            choice == "1" ? editAccountDetails() : readData()
        }
    }
    
    
    private func selectAccountType(){
        print("Choose account type:")
        print("1. Savings 2. Current 3. Salary 4. Exit")
        let selectedOption = readLine()!
        
        if(selectedOption == "1"){
            createAccount(of: "savings")
        }else if(selectedOption == "2"){
            createAccount(of: "current")
        }else if(selectedOption == "3"){
            createAccount(of: "salary")
        }else if(selectedOption == "4"){
            readData()
        }else{
            print("Invalid entry!")
            selectAccountType()
        }
    }
    
    func displayAccountDetail(){
        let accounts = readLocalFile().accounts
        print("Enter CIN")
        let cin = readLine()!
        
        if let row = accounts.firstIndex(where: {$0.cin == cin}) {
            let account = accounts[row]
            print("----------------------------------------------------------------------------")
            print("Name: \(account.name) | Phone No. \(account.phoneNo) | Address: \(account.address) | Email: \(account.email)")
            print("Accounts: \(account.accountNo)")
            print("Account Balance: \(account.accBalance)")
            print("----------------------------------------------------------------------------")
            readData()
        }else{
            print("CIN does not exist")
            readData()
        }
    }
    
    func readData(){
        print("Choose your service:")
        print("1. Create Account\n2. Edit Account Details\n3. Display Account Detail\n4. Exit")
        let selectionOption = readLine()!
        
        if(selectionOption == "1"){
            //Create account
            selectAccountType()
        }else if(selectionOption == "2"){
            //Edit account details
            editAccountDetails()
        }else if(selectionOption == "3"){
            displayAccountDetail()
        }else if(selectionOption == "4"){
//            print("Thank you for using our service!!")
            startBankingSystem()
        }else{
            print("Invalid entry")
            readData()
        }
        
    }
    
    
}
