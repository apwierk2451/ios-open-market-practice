//
//  OpenMarket - ViewController.swift
//  Created by bonf, kiwi.
// 

import UIKit

class MainViewController: UIViewController {
    
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
        configureCollectionView()
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
