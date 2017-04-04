//
//  ShoppingListTableViewCell.swift
//  ShopingList
//
//  Created by David Kababyan on 02/04/2017.
//  Copyright © 2017 David Kababyan. All rights reserved.
//

import UIKit
import SwipeCellKit

class ShoppingListTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func bindData(item: ShoppingList) {
        
        let currency = userDefaults.value(forKey: kCURRENCY) as! String
        
        self.nameLabel.text = item.name
        self.totalItemsLabel.text = "\(item.totalItems) Items"
        self.totalPriceLabel.text = "Total \(currency) \(String(format: "%.2f", item.totalPrice))"
        
        self.totalPriceLabel.sizeToFit()
        self.nameLabel.sizeToFit()

        
    }


}
