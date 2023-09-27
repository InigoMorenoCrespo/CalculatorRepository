//
//  ViewControllerViewModel.swift
//  Calculator
//
//  Created by Iñigo Moreno Crespo on 26/9/23.
//

import Foundation

class ViewControllerViewModel{
    
    let calcButtonCells: [CalculatorButton] = [
        .allClear, .plusMinus, .percentage, .divide,
        .number(7), .number(8), .number(9), .multiply,
        .number(4), .number(5), .number(6), .subtract,
        .number(1), .number(2), .number(3), .add,
        .number(0), .decimal, .equals
    ]

    private(set) lazy var calHeaderLabel: String = "42"
    
}
