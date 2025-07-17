//
//  HomeBannerCollectionViewCell.swift
//  APP4_CCommerce
//
//  Created by Soop on 7/3/25.
//

import UIKit
import Kingfisher

struct HomeBannerCollectionViewCellViewModel: Hashable {
  let bannerImageUrl: String
}

class HomeBannerCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  
  func setViewModel(_ viewModel: HomeBannerCollectionViewCellViewModel) {
    imageView.kf.setImage(with: URL(string: viewModel.bannerImageUrl))
  }
}

extension HomeBannerCollectionViewCell {
  static func bannerLayout() -> NSCollectionLayoutSection {
    let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))   // 그룹의 사이즈 그대로 가져간다
    let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(165 / 393))
    
    let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    
    return section
  }
}
