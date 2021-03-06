//
//  Transaction.swift
//  BankingSystem
//
//  Created by Bhavesh Sharma on 20/02/21.
//

import Foundation

class Transaction{
    
    //enum for transaction types which defines transaction specific cases
    enum TransactionType{
        case deposit
        case withdraw
    }
    
    // storing the entered customer_id
    var customer_id: String = ""
    
    
    //this method handles two cases: deposit and withdraw.
    //deposit: deposits money to selected account.
    //withdraw: deposits money from selected account.
    func handleMoneyTransaction(account: Account, row: Int, transactionType: TransactionType){
        //param:- transactionType holds enum value either .deposit or .withdraw
        
        let accounts = account.accountNo // user account(s)
        
        print("\nChoose Account no.")
        for i in 0..<accounts.keys.count{
            let item = Array(accounts)[i]
            print("\(i+1). \(item.key) : \(item.value)") // displaying account and account type
        }
        
        let selectNo = Int(readLine()!.trim())! // asking which account to select
        
        if(selectNo > 0 && selectNo <= accounts.keys.count){ // handling wrong entries
            let selectedAcc = Array(accounts)[selectNo-1]
            let availableBalance = Int(account.accBalance[selectedAcc.key]!)!
            print("Selected account: Type-> \(selectedAcc.key) : \(selectedAcc.value) | Available balance: \(availableBalance)")
            
            print("Enter Amount to \(transactionType == .deposit ? "deposit" : "withdraw")")
            let amount = readLine()!.trim()
            if(transactionType == .deposit){
                // handling case for deposit
                account.accBalance[selectedAcc.key] = String(availableBalance + Int(amount)!) //adding balance
            }else{
                // handling case for withdraw
                if(availableBalance > 0 && Int(amount)! <= availableBalance){ //checking if balance is available
                    account.accBalance[selectedAcc.key] = String(availableBalance - Int(amount)!) //subtracting balance
                }else{
                    print("\nInsufficient Balance!!")
                    handleMoneyTransaction(account: account, row: row, transactionType: transactionType) //if insufficent balance then asking again
                    return
                }
            }
            print("----------------------------------------------------------------------------")
            print("Your new balance: \(account.accBalance)")
            print("----------------------------------------------------------------------------")
            
            //updating local file
            let localData = readLocalFile()
            localData.accounts[row] = account
            saveJsonFile(of: localData)
            
        }else{
            print("Invalid enrty!")
            //calling the function again to ask the user again.
            handleMoneyTransaction(account: account, row: row, transactionType: transactionType)
            return
        }
        
    }
    
    // this method transfer money from one account to another
    func transferMoney(account: Account, row: Int, allAccounts: [Account]){
        print("Choose your account")
        let accounts = account.accountNo // self user account(s)
        
        for i in 0..<accounts.keys.count{
            let item = Array(accounts)[i]
            print("\(i+1). \(item.key) : \(item.value)") // displaying account and account type
        }
        
        let selectNo = Int(readLine()!.trim())! // asking which account to select
        
        if(selectNo > 0 && selectNo <= accounts.keys.count){ // handling wrong entries
            let selectedAcc = Array(accounts)[selectNo-1]
            let availableBalance = Int(account.accBalance[selectedAcc.key]!)!
            print("Selected account: Type-> \(selectedAcc.key) : \(selectedAcc.value) | Available balance: \(availableBalance)")
            
            print("Enter Recipient Account no.")
            let recipientAcc = Int(readLine()!.trim())!
            
            if(String(recipientAcc) == selectedAcc.value){
                print("\nYou can't transfer to your own account from the same account. Try again!\n")
                transferMoney(account: account, row: row, allAccounts: allAccounts)
                return
            }
            
            var receipientBalance = ""
            var recipientAccType = ""
            var recipientIndex = 0
            //looping to find the receipent account and balance
            for i in 0..<allAccounts.count{
                
                for (key,value) in allAccounts[i].accountNo{
                    if(value == String(recipientAcc)){
                        receipientBalance = allAccounts[i].accBalance[key]!
                        recipientAccType = key
                        recipientIndex = i
                    }
                }
            }
            
            if(receipientBalance == ""){
                print("Account not found!\nTry again!!")
                transferMoney(account: account, row: row, allAccounts: allAccounts)
                return
            }else{
                // account found
                var askAgain = true
                repeat{
                    print("Enter Amount to transfer")
                    let transferAmt = Int(readLine()!.trim())!
                    if (transferAmt < 0 || transferAmt > availableBalance) {
                        // showing error for not entering valid entry
                        print("Error: Please enter valid amount")
                    }else{
                        askAgain = false
                        //deducting balance from self account
                        let leftBalance = availableBalance - transferAmt
                        account.accBalance[selectedAcc.key] = String(leftBalance)
                        
                        //adding balance to recipient account
                        let recepientAcc = allAccounts[recipientIndex]
                        recepientAcc.accBalance[recipientAccType] = String(Int(receipientBalance)! + transferAmt)
                        
                        //updating local file
                        let localData = readLocalFile()
                        localData.accounts[row] = account
                        localData.accounts[recipientIndex] = recepientAcc
                        saveJsonFile(of: localData)
                        
                        print("----------------------------------------------------------------------------")
                        print("Payment transfer successful!!\nYour new balance: \(account.accBalance)")
                        print("----------------------------------------------------------------------------")
                                   
                    }
                } while askAgain
            }
        }else{
            print("Invalid enrty!")
            //calling the function again to ask the user again.
            transferMoney(account: account, row: row, allAccounts: allAccounts)
            return
        }
    }
    
    // this method pay bills from the selected account
    func payBill(account: Account, row: Int){
        let accounts = account.accountNo // user account(s)
        
        print("Pay Bill")
        print("1. Water\n2. Electricity\n3. Gas\n4. Internet")
        let choice = Int(readLine()!.trim())!
        
        if(choice < 0 || choice > 4){
            // if wrong choice then run the function again
            payBill(account: account, row: row)
            return
        }else{
            print("\nChoose Account no.")
            for i in 0..<accounts.keys.count{
                let item = Array(accounts)[i]
                print("\(i+1). \(item.key) : \(item.value)") // displaying account and account type
            }
            
            let selectNo = Int(readLine()!.trim())! // asking which account to select
            
            if(selectNo > 0 && selectNo <= accounts.keys.count){ // handling wrong entries
                let selectedAcc = Array(accounts)[selectNo-1]
                let availableBalance = Int(account.accBalance[selectedAcc.key]!)!
                print("Selected account: Type-> \(selectedAcc.key) : \(selectedAcc.value) | Available balance: \(availableBalance)")
                
                var askAgain = true
                
                repeat{
                    print("Enter bill amount")
                    let billAmt = Int(readLine()!.trim())!
                    if(billAmt < 0 || billAmt > availableBalance){
                        //wrong entry
                        print("Insufficient balance or invalid entry, Please try again!")
                    }else{
                        askAgain = false
                        account.accBalance[selectedAcc.key] = String(availableBalance - billAmt)
                        
                        //updating local file
                        let localData = readLocalFile()
                        localData.accounts[row] = account
                        saveJsonFile(of: localData)
                        print("\nYour bill paid successfully!!")
                    }
                }while askAgain
            }
        }
    }
    
    //showing menu and starting the selected service
    func readData(currentCustomerID: String){
        let localData = readLocalFile()
        currentCustomerID != "" ?  print("") : print("Enter Customer id")
        customer_id = currentCustomerID != "" ? currentCustomerID : readLine()!.trim()
        
        if let row = localData.accounts.firstIndex(where: {$0.customer_id == customer_id}) {
            // user found
            let account = localData.accounts[row]
            var askAgain = true
            
            print("Enter 4 digit pin to continue or Enter 0 to exit")
            let pin = readLine()!.trim()
            
            if(pin == "0"){
                askAgain = false
                startBankingSystem()
                return
            }
            
            if(pin == localData.accounts[row].pin){
                
                repeat{
                    print("\n1. Display the current balance\n2. Deposit money\n3. Withdraw money\n4. Transfer money to other accounts within the bank\n5. Pay utility bills\n6. Exit")
                    let choice = readLine()!.trim()
                    
                    if(choice == "1"){
                        print("----------------------------------------------------------------------------")
                        print("Your Account(s): \(account.accountNo)")
                        print("Account Balance: \(account.accBalance)")
                        print("----------------------------------------------------------------------------")
                    }else if(choice == "2"){
                        handleMoneyTransaction(account: account, row: row, transactionType: .deposit)
                    }else if(choice == "3"){
                        handleMoneyTransaction(account: account, row: row, transactionType: .withdraw)
                    }else if(choice == "4"){
                        transferMoney(account: account, row: row, allAccounts: localData.accounts)
                    }else if(choice == "5"){
                        payBill(account: account, row: row)
                    }else if(choice == "6") {
                        askAgain = false
                        startBankingSystem()
                        return
                    }else{
                        print("Wrong choice")
                        return
                    }
                }while askAgain == true
            }else{
                print("Incorrect pin.")
                readData(currentCustomerID: customer_id)
                return
            }
        }else{
            //wrong customer_id
            print("customer id does not exist")
            print("1. Re-enter    2. or any no. to Exit")
            let choice = readLine()!.trim()
            choice == "1" ? readData(currentCustomerID: "") : startBankingSystem()
        }
    }
}
