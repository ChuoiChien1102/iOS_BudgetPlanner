//
//  CategoriesCollectionViewCell.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 11/9/20.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configUI(category: CategoryModel) -> Void {
        icon.image = UIImage(named: category.imageName)
        lbContent.text = category.name
    }
}
