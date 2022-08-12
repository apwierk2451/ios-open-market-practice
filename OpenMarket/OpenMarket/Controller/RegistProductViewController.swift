//
//  RegistProductViewController.swift
//  OpenMarket
//
//  Created by bonf, kiwi on 2022/08/12.
//

import UIKit

class RegistProductViewController: UIViewController, UICollectionViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private var collectionView: UICollectionView! = nil
    private var layout = UICollectionViewFlowLayout()
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        ImageCollectionViewCell.addImagebutton.addTarget(self, action: #selector(didAddImageButtonTapped), for: .touchUpInside)
        configureCollectionView()
        configureNavigationBar()
    }
    
    @objc func didAddImageButtonTapped() {
       present(imagePicker, animated: true)
    }
   
    private func configureNavigationBar() {
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didCancelButtonTapped))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didUpdateButtonTapped))
        navigationItem.title = "상품등록"
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    @objc func didCancelButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didUpdateButtonTapped() {
        
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RegistProductInfoCollectionViewCell.self, forCellWithReuseIdentifier: "ProductInfoCell")
        collectionView.register(RegistProductImageCollectionViewCell.self, forCellWithReuseIdentifier: "ProductImageCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension RegistProductViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath)
                    as? RegistProductImageCollectionViewCell else { return RegistProductImageCollectionViewCell() }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductInfoCell", for: indexPath)
                    as? RegistProductInfoCollectionViewCell else { return RegistProductInfoCollectionViewCell() }
            
            return cell
        }
    }
    
}

extension RegistProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let width = collectionView.frame.width
            let size = CGSize(width: width, height: collectionView.frame.height * 0.21)
            
            return size
        } else {
            let width = collectionView.frame.width
            let size = CGSize(width: width, height: collectionView.frame.height * 0.79)
            
            return size
        }
    }
}
