//
//  OpenMarket - ViewController.swift
//  Created by bonf, kiwi.
// 

import UIKit

class MainViewController: UIViewController {
    private var items: [ProductDetail] = []
    private let networkManager = NetworkManager()
    private var openMarketRequest = OpenMarketRequest(method: .get, baseURL: URLHost.openMarket.url, query: [Product.page.text: String(Product.page.number), Product.itemPerPage.text: String(Product.itemPerPage.number)], path: URLAdditionalPath.product.value)
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.backgroundColor = .black.withAlphaComponent(0.3)
        indicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        return indicator
    }()
    private var isPageRefreshing = true
    
    private var collectionView: UICollectionView! = nil
    
    private var currentPage = 1
    
    private let listLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        
        return layout
    }()
    
    private let gridLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        
        return layout
    }()
    
    private let segment = UISegmentedControl(items: LayoutStyle.allCases.map { $0.text })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureSegment()
        fetchData(openMarketRequest)
        configureCollectionView()
        addIndicatorLayout()
        self.activityIndicator.startAnimating()
    }
    
    private func fetchData(_ request: OpenMarketRequest) {
        networkManager.dataTask(with: request) { result in
            switch result {
            case .success(let responseData):
                guard let itemData: ProductsList = try? JSONDecoder().decode(ProductsList.self, from: responseData) else { return }
                self.items.append(contentsOf: itemData.pages)
                
                DispatchQueue.main.async { [self] in
                    collectionView.reloadData()
                    activityIndicator.stopAnimating()
                }
                if itemData.hasNext {
                    self.isPageRefreshing = true
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
}

//MARK: SegmentControl
extension MainViewController {
    private func configureSegment() {
        self.navigationItem.titleView = segment
        segment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segment.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        segment.frame.size.width = view.bounds.width * 0.3
        segment.setWidth(view.bounds.width * 0.15, forSegmentAt: 0)
        segment.setWidth(view.bounds.width * 0.15, forSegmentAt: 1)
        segment.layer.borderWidth = 1.0
        segment.layer.borderColor = UIColor.systemBlue.cgColor
        segment.selectedSegmentTintColor = .systemBlue
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(tapSegment(sender:)), for: .valueChanged)
    }
    
    @objc private func tapSegment(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            DispatchQueue.main.async { [self] in
                let indexPath = collectionView.indexPathsForVisibleItems
                collectionView.reloadItems(at: indexPath)
            }
            collectionView.setCollectionViewLayout(listLayout, animated: true)
        case 1:
            DispatchQueue.main.async { [self] in
                let indexPath = collectionView.indexPathsForVisibleItems
                collectionView.reloadItems(at: indexPath)
            }
            collectionView.setCollectionViewLayout(gridLayout, animated: true)
        default:
            return
        }
    }
}

//MARK: ListFlowLayout
extension MainViewController {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = .fast
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "ListCell")
        collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: "GridCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: DataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if segment.selectedSegmentIndex == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath)
                    as? ListCollectionViewCell else { return UICollectionViewCell() }
            cell.resetContent()
            cell.configureContent(item: items[indexPath.row])
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath)
                as? GridCollectionViewCell else { return UICollectionViewCell() }
        cell.resetContent()
        cell.configureContent(item: items[indexPath.row])
        return cell
    }
}

// MARK: - FlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if segment.selectedSegmentIndex == 0 {
            let width = self.collectionView.bounds.width
            let height = self.collectionView.bounds.height * 0.1
            let itemSize = CGSize(width: width, height: height)
            
            return itemSize
        } else {
            let width = self.collectionView.bounds.width * 0.48
            let height = self.collectionView.bounds.height * 0.34
            let itemSize = CGSize(width: width, height: height)
            
            return itemSize
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height - scrollView.frame.height
        
        if offsetY > contentHeight && isPageRefreshing {
            activityIndicator.startAnimating()
            currentPage += 1
            isPageRefreshing = false
            openMarketRequest.query = [Product.page.text: String(Product.page.number + currentPage), Product.itemPerPage.text: String(Product.itemPerPage.number)]
            fetchData(openMarketRequest)
        }
       
    }
}

extension MainViewController {
    private func addIndicatorLayout() {
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
