//
//  QuoteCell.swift
//  InspoQuotes
//
//  Created by Oleksandr Smakhtin on 19.09.2022.
//

import UIKit

class QuoteCell: UITableViewCell {

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var label: UILabel!
    
    func updateView(quote: String) {
        label.text = quote
        label.font = UIFont(name: "Courier New", size: 19)
        label.textAlignment = .left
        customView.layer.borderWidth = 0
        customView.layer.cornerRadius = 15
    }
    
    func premiumCell() {
        label.text = "Buy premium cells"
        label.font = UIFont(name: "Courier New", size: 33)
        label.textAlignment = .center
        customView.layer.cornerRadius = 15
        customView.layer.borderWidth = 1
        customView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
}
