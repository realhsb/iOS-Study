//
//  HomeBannerCollectionViewCell.swift
//  APP4_CCommerce
//
//  Created by Soop on 7/3/25.
//

import UIKit

class HomeBannerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
}
