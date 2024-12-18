//
//  DetailViewController.swift
//  ProjectB
//
//  Created by Scissors on 18.12.2024.
//


import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    private let userDefaultsManager = UserDefaultsManager()
    private let notificationCenterManager = NotificationCenterManager()
    private var viewModel = DetailViewModel()
    private var product: ProductDetail?
    private var isFavorited = false
    var productId = Int()
    
    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        subtitleLabel.textColor = .gray
        return subtitleLabel
    }()
    
    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.boldSystemFont(ofSize: 16)
        priceLabel.textColor = .black
        return priceLabel
    }()
    
    private let descriptionLabelTitle: UILabel = {
        let descriptionLabelTitle = UILabel()
        descriptionLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabelTitle.numberOfLines = 0
        descriptionLabelTitle.font = UIFont.boldSystemFont(ofSize: 10)
        descriptionLabelTitle.text = "Ürün Özellikleri"
        descriptionLabelTitle.textColor = .lightGray
        return descriptionLabelTitle
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0

        return descriptionLabel
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchProductDetail()
    }
    
    // MARK: - Functions
    private func setupUI() {
        isFavorited = userDefaultsManager.containsProductId(productId)
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: isFavorited ? "heart.fill" : "heart"), style: .plain, target: self, action: #selector(toggleFavorite))
        navigationItem.rightBarButtonItem = favoriteButton
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(descriptionLabelTitle)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 500),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            priceLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabelTitle.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            descriptionLabelTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabelTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: descriptionLabelTitle.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func fetchProductDetail() {
        viewModel.onProductsDetailLoaded = { [weak self] product in
            guard let self else { return }
            self.product = product
            updateUI()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            guard let self else { return }
            print("Error: \(errorMessage)")
        }
        
        viewModel.loadProductDetail(productID: productId)
    }
    
    private func updateUI() {
        guard let product else { return }

        if let url = URL(string: product.images?.first?.images?.first?.imageURL ?? "") {
            imageView.kf.setImage(with: url)
        }
        
        titleLabel.text = product.brandName
        subtitleLabel.text = product.displayName
        priceLabel.text = product.actualPriceText
        descriptionLabel.setHTMLText(product.description?.ozellikler)
    }
    
    private func updateFavoriteButtonImage() {
        let heartImageName = isFavorited ? "heart.fill" : "heart"
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: heartImageName)
    }
    
    @objc private func toggleFavorite() {
        isFavorited.toggle()
        isFavorited ? userDefaultsManager.addProductId(productId) : userDefaultsManager.removeProductId(productId)
        notificationCenterManager.postFavoriteStatusChanged(productId: productId)
        updateFavoriteButtonImage()
    }
}
