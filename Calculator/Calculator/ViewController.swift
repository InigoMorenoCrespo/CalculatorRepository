//
//  ViewController.swift
//  Calculator
//
//  Created by Iñigo Moreno Crespo on 26/9/23.
//

import UIKit

class ViewController: UIViewController {
    
    let calculatorViewModel: ViewModel
    var selectedOperatorIndex: Int? = nil
    
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.register(CalcHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CalcHeaderCell.identifer)
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.identifer)
        return collectionView
    }()
    
    init(_ viewModel: ViewModel = ViewModel()){
        self.calculatorViewModel = viewModel
        super.init(nibName: nil , bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPurple
        self.setupUI()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.calculatorViewModel.updateViews = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CalcHeaderCell.identifer, for: indexPath) as? CalcHeaderCell else {
            fatalError("Failed to dequeue")
        }
        header.configure(currentClacText: self.calculatorViewModel.setCalHeaderLabel())
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let totalCellHeight = view.frame.size.width
        let totalVerticalCellSpacing = CGFloat(10*4)
        
        let window = view.window?.windowScene?.keyWindow
        let topPadding = window?.safeAreaInsets.top ?? 0
        let bottonPadding = window?.safeAreaInsets.bottom ?? 0

        let aveilableSreenHeight = view.frame.size.height - topPadding - bottonPadding
        
        let headerHeight = aveilableSreenHeight - totalCellHeight - totalVerticalCellSpacing
        
        return CGSize(width: view.frame.size.width, height: headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.calculatorViewModel.calcButtonCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.identifer, for: indexPath) as? ButtonCell else{
            fatalError("failed")
        }
        let calcButton = self.calculatorViewModel.calcButtonCells[indexPath.row]
        
        cell.configure(with: calcButton)
        
        if calculatorViewModel.canOperate() && calculatorViewModel.setOperation().description == calcButton.title {
           
            cell.setOperationSelected()
            
        }
        
        
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let calcButton = self.calculatorViewModel.calcButtonCells[indexPath.row]
        
        switch calcButton {
        case let .number(int) where int == 0:
           return CGSize(
            width: (view.frame.size.width/5)*2 + ((view.frame.size.width/5)/3),
            height: view.frame.size.width/5
           )
            
            
        default:
            return CGSize(
                width: view.frame.size.width/5,
                height: view.frame.size.width/5
            )
        }
        
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return (self.view.frame.width/5)/3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.identifer, for: indexPath) as? ButtonCell else{
            fatalError("failed")
        }
        let buttonCell = self.calculatorViewModel.calcButtonCells[indexPath.row]
        if calculatorViewModel.isOperation(calcButton: buttonCell){
            cell.setOperationSelected()
        }
        self.calculatorViewModel.didSelectButton(with: buttonCell)
    }
    
}

