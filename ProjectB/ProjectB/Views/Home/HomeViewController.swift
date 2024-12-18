//
//  ViewController.swift
//  ProjectB
//
//  Created by Scissors on 17.12.2024.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    private let viewModel = HomeViewModel()
    private let notificationCenterManager = NotificationCenterManager()
    private var products = [Product]()
    private var isSingleColumn = true
    private var page = 1
    
    // MARK: - UI Elements
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 10
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let itemWidth = (screenWidth - 30) / 2
        let itemHeight = screenHeight / 2.5
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .lightGray
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.Identifier.customCell.rawValue)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData(page: page)
    }
    
    deinit {
        notificationCenterManager.removeObserver(self)
    }
    
    // MARK: - Functions
    private func setupUI() {
        notificationCenterManager.addFavoriteStatusObserver(observer: self, selector: #selector(handleFavoriteChange(_:)))

        configureNavigationBar(largeTitleColor: .black, backgoundColor: .white, tintColor: .black, title: "Products", preferredLargeTitle: false)
        let changeLayoutButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.1x2"), style: .plain, target: self, action: #selector(toggleLayout))
        navigationItem.rightBarButtonItem = changeLayoutButton

        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func fetchData(page: Int) {
        viewModel.onProductsListLoaded = { [weak self] products in
            guard let self else { return }
            self.products.append(contentsOf: products)
            self.collectionView.reloadData()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            guard let self else { return }
            print("Error: \(errorMessage)")
        }
        
        viewModel.loadProductList(page: page)
    }
        
    private func changeLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 10
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let itemWidth = isSingleColumn ? screenWidth - 20 : (screenWidth - 30) / 2
        let itemHeight = isSingleColumn ? screenHeight / 1.5 : screenHeight / 2.5
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }

    private func scrollToTop() {
        var contentInset = collectionView.contentInset
        contentInset.top = 10
        collectionView.contentInset = contentInset
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    }

    private func updateRightBarButtonImage() {
        let imageName = isSingleColumn ? "rectangle.grid.1x2" : "rectangle.grid.2x2"
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: imageName)
    }
    
    @objc private func toggleLayout() {
        let newLayout = changeLayout()
        isSingleColumn.toggle()
        collectionView.setCollectionViewLayout(newLayout, animated: false)
        updateRightBarButtonImage()
        scrollToTop()
    }
    
    @objc private func handleFavoriteChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let productId = userInfo["productId"] as? Int,
              let index = products.firstIndex(where: { $0.productID == productId }) else { return }

        let indexPath = IndexPath(item: index, section: 0)
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.Identifier.customCell.rawValue, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: products[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            let lastSectionIndex = collectionView.numberOfSections - 1
            let lastRowIndex = collectionView.numberOfItems(inSection: lastSectionIndex) - 1
            if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
                page += 1
                fetchData(page: page)
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        if let id = products[indexPath.row].productID {
            detailViewController.productId = id
        }
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
