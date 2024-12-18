//
//  CollectionViewCell.swift
//  ProjectB
//
//  Created by Scissors on 18.12.2024.
//

import UIKit
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    enum Identifier: String {
        case customCell = "HomeCollectionViewCell"
    }
        
    private let userDefaultsManager = UserDefaultsManager()
    private var productId = Int()
    
    
    // MARK: - UI Elements
    private let productImageView: UIImageView = {
        let productImageView = UIImageView()
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        return productImageView
    }()
    
    private let brandTitleLabel: UILabel = {
        let brandTitleLabel = UILabel()
        brandTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        brandTitleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        brandTitleLabel.textColor = .black
        return brandTitleLabel
        
    }()
    private let productTitleLabel: UILabel = {
        let productTitleLabel = UILabel()
        productTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        productTitleLabel.font = UIFont.boldSystemFont(ofSize: 8)
        productTitleLabel.textColor = .gray
        productTitleLabel.numberOfLines = 0
        return productTitleLabel
    }()
    
    lazy private var favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        favoriteButton.tintColor = .systemRed
        favoriteButton.isHidden = true
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return favoriteButton
    }()

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
    }
    
    // MARK: - Functions
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(productImageView)
        contentView.addSubview(brandTitleLabel)
        contentView.addSubview(productTitleLabel)
        contentView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.85),
            
            brandTitleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            brandTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            brandTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            productTitleLabel.topAnchor.constraint(equalTo: brandTitleLabel.bottomAnchor, constant: 4),
            productTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
    
    func configure(with model: Product) {
        if let url = URL(string: model.imageURL ?? ""),
           let brandTitle = model.brandName,
           let productTitle = model.displayName,
           let id = model.productID
        {
            let processor = ResizingImageProcessor(referenceSize: CGSize(width: 500, height: 500), mode: .aspectFit)
            productImageView.kf.setImage(with: url, options: [
                .processor(processor),
                .cacheOriginalImage,
                .transition(.fade(0.3))
            ])
            brandTitleLabel.text = brandTitle
            productTitleLabel.text = productTitle
            productId = id
            favoriteButton.isHidden = !userDefaultsManager.containsProductId(productId)
        }
    }
    
    @objc func favoriteButtonTapped() {
        userDefaultsManager.removeProductId(productId)
        favoriteButton.isHidden = true
    }
}
