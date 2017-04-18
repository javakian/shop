//
//  ItemTableViewCell.swift
//  ShopingList
//
//  Created by David Kababyan on 08/01/2017.
//  Copyright © 2017 David Kababyan. All rights reserved.
//

import UIKit
import SwipeCellKit

class ItemTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var extraInfoLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var quantityBackground: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.quantityBackground.layer.cornerRadius = quantityBackground.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func bindData(item: ShoppingItem) {
        
        let currency = userDefaults.value(forKey: kCURRENCY) as! String

        self.nameLabel.text = item.name
        self.extraInfoLabel.text = item.info
        self.quantityLabel.text = "\(item.quantity)"
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
