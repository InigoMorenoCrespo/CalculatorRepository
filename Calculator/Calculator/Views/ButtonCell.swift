//
//  ButtonCell.swift
//  Calculator
//
//  Created by Iñigo Moreno Crespo on 26/9/23.
//

import UIKit

class ButtonCell: UICollectionViewCell {
    
    static let identifer = "ButtonCell"
    
    private(set) var calculatorButton: CalculatorButton!
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 45, weight: .regular)
        label.text = "error"
        return label
    }()
    
    public func configure (with calculatorButton: CalculatorButton) {
        self.calculatorButton = calculatorButton
        
        self.titleLabel.text = calculatorButton.title
        self.backgroundColor = calculatorButton.color
        
        
    }
    
}
