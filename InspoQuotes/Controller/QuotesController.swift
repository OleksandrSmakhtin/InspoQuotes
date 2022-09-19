//
//  ViewController.swift
//  InspoQuotes
//
//  Created by Oleksandr Smakhtin on 19.09.2022.
//

import UIKit
import StoreKit

class QuotesController: UIViewController {

    @IBOutlet weak var quotesTable: UITableView!
    
    let productID = "Your product ID"
    var availableQuotes = QuotesData.freeQuotes
    let premiumQuotes = QuotesData.premiumQuotes

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDelegates()
        
        // as soon as something happend to payment transaction it will be called, and it calls
        // the delegate method
        SKPaymentQueue.default().add(self)
        
        // check if premium were purchased
        if isPurchased() {
            showPremiumQuotes()
        }
        
    }

    
    // restoring a purchase
    @IBAction func restoreBtnPressed(_ sender: UIBarButtonItem) {
        // calls the delegate method
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}

//MARK: - TableView Delegete and Data Source
extension QuotesController: UITableViewDelegate, UITableViewDataSource {
    // set delegates
    func setTableViewDelegates() {
        quotesTable.delegate = self
        quotesTable.dataSource = self
    }
    // number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // cell count depends from purchased status
        if isPurchased() {
            return availableQuotes.count
        } else {
            return availableQuotes.count + 1
        }
    }
    // set cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell") as! QuoteCell
        // disable selection anim
        cell.selectionStyle = .none
        // making last cell a buy quotes button
        if indexPath.row < availableQuotes.count {
            let quote = availableQuotes[indexPath.row]
            cell.updateView(quote: quote)
        } else {
            cell.premiumCell()
        }
        
        return cell
    }
    // select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // the last buy premium quotes selected
        if indexPath.row == availableQuotes.count {
            buyPremiumQuotes()
        }
    }
    
}

//MARK: - In-App Purchased
extension QuotesController: SKPaymentTransactionObserver {

    func buyPremiumQuotes() {
        // checking if a user able to do purchase
        if SKPaymentQueue.canMakePayments() {
            //can make payments
            let paymentRequest = SKMutablePayment()
            // this request is for product of id
            paymentRequest.productIdentifier = productID
            // set our request for proper product in payments queue
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            // can't make payments
            print("User can't make payments")
        }
    }
    
    // checking the status of transation
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        // checking for transaction status
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                // user payment successfull
                print("Successfull payment")
                // add premium quotes
                showPremiumQuotes()
                // finishing transaction
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .failed {
                // user payment failed
                print(transaction.error?.localizedDescription)
                print("Failed payment")
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .restored {
                // if restore btn was pressed and calls delegate
                showPremiumQuotes()
                // hide restore btn
                navigationItem.setRightBarButton(nil, animated: true)
                print("Restored purchase")
                
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
        
        
    }
    
    
    // show premium quotes method
    func showPremiumQuotes() {
        // save for a long time with user defualts
        UserDefaults.standard.set(true, forKey: productID)
        
        availableQuotes += premiumQuotes
        quotesTable.reloadData()
    }
    
    // check if premium quotes were purchased
    func isPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID)
        
        if purchaseStatus {
            print("Were purchased")
            return true
        } else {
            print("Never purchased before")
            return false
        }
    }
    
}
