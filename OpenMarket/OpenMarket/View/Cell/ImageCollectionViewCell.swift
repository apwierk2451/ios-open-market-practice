//
//  ImageCollectionViewCell.swift
//  OpenMarket
//
//  Created by bonf, kiwi on 2022/08/12.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    let productImage = UIImageView()
    static var addImagebutton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configureContent()
       
//        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
//        productImage.addGestureRecognizer(tapGR)
//        productImage.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
//    @objc func imageTapped(sender: UITapGestureRecognizer) {
//
//        }
    
    private func configureCell() {
//        productImage.translatesAutoresizingMaskIntoConstraints = false
        ImageCollectionViewCell.addImagebutton.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.addSubview(productImage)
        self.contentView.addSubview(ImageCollectionViewCell.addImagebutton)
        
//        NSLayoutConstraint.activate([
//            productImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
//            productImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
//            productImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
//            productImage.topAnchor.constraint(equalTo: self.contentView.topAnchor)
//        ])
//
        NSLayoutConstraint.activate([
            ImageCollectionViewCell.addImagebutton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            ImageCollectionViewCell.addImagebutton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            ImageCollectionViewCell.addImagebutton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            ImageCollectionViewCell.addImagebutton.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        ])
    }
    
    private func configureContent() {
//        productImage.backgroundColor = .systemGray5
//        productImage.image = UIImage(systemName: "plus")
//
        ImageCollectionViewCell.addImagebutton.setImage(UIImage(systemName: "plus"), for: .normal)
        ImageCollectionViewCell.addImagebutton.backgroundColor = .systemGray3
    }
    
    
}
