//
//  ViewController.swift
//  Calculator
//
//  Created by Iñigo Moreno Crespo on 26/9/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.register(CalcHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CalcHeaderCell.identifer)
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.identifer)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPurple
        self.setupUI()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }
    
    private func setupUI(){
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.identifer, for: indexPath) as? ButtonCell else{
            fatalError("failed")
        }
        cell.backgroundColor = .systemPurple
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/5, height: view.frame.size.width/5)
    }
        
    
}

