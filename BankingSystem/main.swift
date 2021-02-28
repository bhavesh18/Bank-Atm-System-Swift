//
//  main.swift
//  BankingSystem
//
//  Created by Bhavesh Sharma on 19/02/21.
//

import Foundation

//showing menu and starting the selected service
func startBankingSystem(){
    print("---Welcome to Banking system---\nChoose your option: \n1. Banking Services    2. Transaction    3. Exit")
    let selectionOption = readLine()!.trim()

    if(selectionOption == "1"){
        //Banking
        let banking = Banking()
        banking.readData()

    }else if(selectionOption == "2"){
        //Transaction
        let transaction = Transaction()
        transaction.readData(currentCustomerID: "")

    }else if(selectionOption == "3"){
        print("Thank you for using our service!!")
    }else{
        print("Invalid entry")
        startBankingSystem()
    }
}


startBankingSystem() // program starts here


//extension for string to add the trim method to remove spaces
extension String{
    func trim() -> String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
