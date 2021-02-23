//
//  main.swift
//  BankingSystem
//
//  Created by Bhavesh Sharma on 19/02/21.
//

import Foundation

func startBankingSystem(){
    print("Choose your option: \n1. Transaction    2. Banking Services    3. Exit")
    let selectionOption = readLine()!

    if(selectionOption == "1"){
        //Transaction
        let transaction = Transaction()
        transaction.readData(currentCIN: "")
    }else if(selectionOption == "2"){
        //Banking
        let banking = Banking()
        banking.readData()
        
    }else if(selectionOption == "3"){
        print("Thank you for using our service!!")
    }else{
        print("Invalid entry")
        startBankingSystem()
    }
}


startBankingSystem() // program starts here

