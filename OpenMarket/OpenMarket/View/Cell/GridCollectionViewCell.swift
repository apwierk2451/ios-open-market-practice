//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by bonf, kiwi on 2022/08/09.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    private let verticalStackView = UIStackView()
    private let titleLabel = UILabel()
    private let itemImageView = UIImageView()
    private let priceLabel = UILabel()
    private let discountedLabel = UILabel()
    private let stockLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttribute()
        configureLayout()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureAttribute() {
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.distribution = .equalSpacing
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 5
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textAlignment = .center
        priceLabel.isHidden = true
        
        discountedLabel.translatesAutoresizingMaskIntoConstraints = false
        discountedLabel.textAlignment = .center
        
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.textAlignment = .center
        
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.contentMode = .scaleAspectFit
    }
    
    private func configureLayout() {
        self.contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(itemImageView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(priceLabel)
        verticalStackView.addArrangedSubview(discountedLabel)
        verticalStackView.addArrangedSubview(stockLabel)
        
        NSLayoutConstraint.activate([
            itemImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    func configureContent(item: ProductDetail) {
        guard let stock = item.stock.formatNumber() else { return }
        
        titleLabel.text = "\(item.name)"
        stockLabel.text = "잔여수량: \(stock)"
        stockLabel.textColor = .systemGray
        discountedLabel.text = "\(item.currency.rawValue) \(item.discountedPrice)"
        discountedLabel.textColor = .systemGray
        itemImageView.setImageUrl(url: item.thumbnail)
        
        if item.bargainPrice != 0 {
            discountedLabel.text = "\(item.currency.rawValue) \(item.discountedPrice)"
            discountedLabel.textColor = .systemGray
            
            priceLabel.text = "\(item.currency.rawValue) \(item.price)"
            priceLabel.textColor = .systemRed
            priceLabel.isHidden = false
            
            guard let priceText = priceLabel.text else { return }
            let attribute = NSMutableAttributedString(string: priceText)
            attribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attribute.length))
            priceLabel.attributedText = attribute
        }
        
        if item.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
        }
        
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 1
    }
    
    func resetContent() {
        priceLabel.text = .none
        priceLabel.attributedText = .none
        itemImageView.image = .none
    }
}
