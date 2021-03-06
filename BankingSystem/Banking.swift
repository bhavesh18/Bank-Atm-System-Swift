//
//  Banking.swift
//  BankingSystem
//
//  Created by Bhavesh Sharma on 20/02/21.
//

import Foundation

class Banking{
    
    //return the index of the accounts array(which is stored locally) where customer id matches.
    private func getIndex(with customer_id: String)->Int{
        let localData = readLocalFile()
        if(localData.accounts.isEmpty){
            return -1
        }
        return localData.accounts.firstIndex(where: {$0.customer_id == customer_id}) ?? -1
    }
    
    // this method called to create an account
    private func createAccount(of accountType: String){
        print("Set customer id")
        let customer_id = readLine()!.trim()
        
        let localData = readLocalFile()
        var accountTypes = [String]()
        var accBalance = [String: String]()
        var accNo: String = ""
        var pin: String = ""
        var c_id = ""
        
        let index = getIndex(with: customer_id)
        
        if(index == -1){
            // new user
            accountTypes.append(accountType)
            accBalance[accountType] = "0"
            c_id = customer_id
            print("Enter name")
            let name = readLine()!.trim()
            print("Enter Phone number")
            let phoneNo = readLine()!.trim()
            print("Enter address")
            let address = readLine()!.trim()
            print("Enter email address")
            let email = readLine()!.trim()
            
            let accountNo = String(String(Int64(Date().timeIntervalSince1970 * 1000)).suffix(10))
            accNo = accountNo
            let generatedPin = String(String(Int64(Date().timeIntervalSince1970 * 1000)).suffix(4))
            pin = generatedPin
            let account = Account(customer_id: customer_id, name: name, phoneNo: phoneNo, address: address, email: email, accountNo: [accountType:accountNo], pin: pin, accountTypes: accountTypes, accBalance: accBalance)
            
            localData.accounts.append(account)
        }else{
            //existing user data
            let storedAcc = localData.accounts[index]
            
            let accountNo = String(String(Int64(Date().timeIntervalSince1970 * 1000)).suffix(10))
            accNo = accountNo
//            let generatedPin = storedAcc.pin
            pin = storedAcc.pin
            
            accountTypes = storedAcc.accountTypes
            
            //adding new account no. to stored dictionary
            var updatedAccNo = storedAcc.accountNo
            updatedAccNo[accountType] = accountNo
            
            //adding new account balance. to stored dictionary
            accBalance = storedAcc.accBalance
            accBalance[accountType] = "0"
            c_id = storedAcc.customer_id
            
            if(storedAcc.accountTypes.contains(accountType)){
                // account type already exists
                print("\(accountType) account already exists. Choose another account type.")
                selectAccountType()
                return
            }else{
                accountTypes.append(accountType)
            }
            
            let account = Account(customer_id: storedAcc.customer_id, name: storedAcc.name, phoneNo: storedAcc.phoneNo, address: storedAcc.address, email: storedAcc.email, accountNo: updatedAccNo, pin: storedAcc.pin, accountTypes: accountTypes, accBalance: accBalance)
            localData.accounts[index] = account
            
            print("----------------------------------------------------------------------------")
            print("User Details:")
            print("Name: \(storedAcc.name) | Phone No. \(storedAcc.phoneNo) | Address: \(storedAcc.address) | Email: \(storedAcc.email) ")
            
        }
        
        saveJsonFile(of: localData) //saving locally
        
        print("----------------------------------------------------------------------------------")
        print("Account Created Successfully!!")
        print("Your Account No. is: \(accNo)    Customer ID: \(c_id)    Pin: \(pin)    Account Type: \(accountType)")
        print("----------------------------------------------------------------------------------")
        
        readData()
    }
    
    //editing details of existing accounts
    private func editAccountDetails(){
        print("Enter customer id")
        let customer_id = readLine()!.trim()
        var accounts = readLocalFile().accounts
        
        if(accounts.contains(where: {$0.customer_id == customer_id})){
            
            print("Enter new name")
            let name = readLine()!.trim()
            print("Enter new Phone number")
            let phoneNo = readLine()!.trim()
            print("Enter new address")
            let address = readLine()!.trim()
            print("Enter new email address")
            let email = readLine()!.trim()
            
            if let row = accounts.firstIndex(where: {$0.customer_id == customer_id}) {
                accounts[row] = Account(customer_id: accounts[row].customer_id, name: name, phoneNo: phoneNo, address: address, email: email, accountNo: accounts[row].accountNo, pin: accounts[row].pin, accountTypes: accounts[row].accountTypes, accBalance: accounts[row].accBalance)
            }
            
            //saving updated data locally
            let localData = readLocalFile()
            localData.accounts = accounts
            saveJsonFile(of: localData)
            print("\n----------------------------------------------------------------------------")
            print("Details Updated Successfully!!")
            print("----------------------------------------------------------------------------")
            readData()
        }else{
            print("customer id does not exist")
            print("1. Re-enter    2. or any no. to Exit")
            let choice = readLine()!.trim()
            choice == "1" ? editAccountDetails() : readData()
        }
    }
    
    //selecting account type
    private func selectAccountType(){
        print("\nChoose account type:")
        print("1. Savings 2. Current 3. Salary 4. Exit")
        let selectedOption = readLine()!.trim()
        
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
    
    //showing account details respecting to customer id
    func displayAccountDetail(){
        let accounts = readLocalFile().accounts
        print("Enter customer id")
        let customer_id = readLine()!.trim()
        
        if let row = accounts.firstIndex(where: {$0.customer_id == customer_id}) {
            let account = accounts[row]
            print("----------------------------------------------------------------------------")
            print("Name: \(account.name) | Phone No. \(account.phoneNo) | Address: \(account.address) | Email: \(account.email)")
            print("Accounts: \(account.accountNo)")
            print("Account Balance: \(account.accBalance)")
            print("----------------------------------------------------------------------------")
            readData()
        }else{
            print("customer id does not exist")
            readData()
        }
    }
    
    //showing menu and starting the selected service
    func readData(){
        print("Choose your service:")
        print("1. Create Account\n2. Edit Account Details\n3. Display Account Detail\n4. Exit")
        let selectionOption = readLine()!.trim()
        
        if(selectionOption == "1"){
            //Create account
            selectAccountType()
        }else if(selectionOption == "2"){
            //Edit account details
            editAccountDetails()
        }else if(selectionOption == "3"){
            displayAccountDetail()
        }else if(selectionOption == "4"){
            startBankingSystem()
        }else{
            print("Invalid entry")
            readData()
        }
    }
}
