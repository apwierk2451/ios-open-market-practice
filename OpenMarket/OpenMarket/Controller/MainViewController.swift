//
//  OpenMarket - ViewController.swift
//  Created by bonf, kiwi.
// 

import UIKit

class MainViewController: UIViewController {
    private var items: [ProductDetail] = []
    private let networkManager = NetworkManager()
    private let openMarketRequest = OpenMarketRequest(method: .get, baseURL: URLHost.openMarket.url, query: [Product.page.text: Product.page.number, Product.itemPerPage.text: Product.itemPerPage.number], path: URLAdditionalPath.product.value)
    
    private var collectionView: UICollectionView! = nil
    
    private let listLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        
        return layout
    }()
    
    private let girdLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        return layout
    }()
    
    private let segment = UISegmentedControl(items: LayoutStyle.allCases.map { $0.text })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureSegment()
        fetchData()
        configureCollectionView()
    }
    
    private func fetchData() {
        networkManager.dataTask(with: openMarketRequest) { result in
            switch result {
            case .success(let responseData):
                guard let itemData: ProductsList = try? JSONDecoder().decode(ProductsList.self, from: responseData) else { return }
                self.items.append(contentsOf: itemData.pages)
                
                DispatchQueue.main.async { [self] in
                    self.collectionView.reloadData()
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
            print("0")
        case 1:
            print("1")
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
            let width = self.collectionView.bounds.width / 2
            let height = self.collectionView.bounds.height * 0.31
            let itemSize = CGSize(width: width, height: height)
            
            return itemSize
        }
    }
}
