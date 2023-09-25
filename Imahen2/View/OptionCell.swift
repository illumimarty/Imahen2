//
//  OptionCell.swift
//  Imahen2
//
//  Created by Marty Nodado on 9/17/23.
//

import UIKit

class OptionCell: UICollectionViewCell {
    
    @IBOutlet weak var optionImage: UIImageView!
    @IBOutlet weak var optionName: UILabel!
    var img: UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        optionImage.image = img
        contentView.backgroundColor = .quaternarySystemFill
        layer.cornerRadius = 8.0
    }
}
