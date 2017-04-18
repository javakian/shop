//
//  GroceryTableViewCell.swift
//  ShopingList
//
//  Created by David Kababyan on 01/04/2017.
//  Copyright © 2017 David Kababyan. All rights reserved.
//

import UIKit

class GroceryTableViewCell: ItemTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

        self.quantityLabel.isHidden = true
        self.quantityBackground.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(item: GroceryItem) {
        
        let currency = userDefaults.value(forKey: kCURRENCY) as! String

        self.nameLabel.text = item.name
        self.extraInfoLabel.text = item.info
        self.priceLabel.text = "\(currency) \(String(format: "%.2f", item.price))"
        
        self.priceLabel.sizeToFit()
        self.nameLabel.sizeToFit()
        self.extraInfoLabel.sizeToFit()
        
        if item.image != "" {
            
            imageFromData(pictureData: item.image) { (image) in

//                let newImage = image!.scaleImageToSize(newSize: itemImage.frame.size)
                self.itemImage.image = image!.circleMasked

            }
            
        } else {
            
            let image = UIImage(named: "ShoppingCartEmpty")!.scaleImageToSize(newSize: itemImage.frame.size)
            self.itemImage.image = image.circleMasked
            
        }
        
    }

    
}
