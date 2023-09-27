//
//  ViewControllerViewModel.swift
//  Calculator
//
//  Created by Iñigo Moreno Crespo on 26/9/23.
//

import Foundation

enum CurrentNumber{
    case firstNumber
    case secondNumber
}

class ViewControllerViewModel{
    
    var updateViews: (()->Void)?
    
    let calcButtonCells: [CalculatorButton] = [
        .allClear, .plusMinus, .percentage, .divide,
        .number(7), .number(8), .number(9), .multiply,
        .number(4), .number(5), .number(6), .subtract,
        .number(1), .number(2), .number(3), .add,
        .number(0), .decimal, .equals
    ]
    
    
    private(set) lazy var calHeaderLabel: String = (self.firstNumber ?? 0).description
    private(set) var currentNumber : CurrentNumber = .firstNumber
    
    private(set) var firstNumber: Int? = nil {
        didSet{
            self.calHeaderLabel = self.firstNumber?.description ?? "0"
        }
    }
    private(set) var secondNumber: Int? = nil{
        didSet{
            self.calHeaderLabel = self.secondNumber?.description ?? "0"
        }
    }
    
    private (set) var operation: CalculatorOperation? = nil
    
    private (set) var prevNumber: Int? = nil
    private (set) var prevOperation: CalculatorOperation? = nil
}

extension ViewControllerViewModel {
    
    public func didSelectButton(with calcButton: CalculatorButton){
        switch calcButton {
        case .allClear:
            self.didSelectAllClear()
        case .plusMinus: self.didSelectPlusMinus()
        case .percentage: self.didSelectPercentage()
        case .divide: self.didSelectOperation(with: .divide)
        case .multiply: self.didSelectOperation(with: .multiply)
        case .subtract: self.didSelectOperation(with: .subtract)
        case .add: self.didSelectOperation(with: .add)
        case .equals: self.didSelectEqalsButton()
        case .number(let number):
            self.didSelectNumber(with: number)
        case .decimal:
            fatalError()
        }
        self.updateViews?()
    }
    
    private func didSelectAllClear(){
        self.currentNumber = .firstNumber
        self.firstNumber = nil
        self.secondNumber = nil
        self.operation = nil
        self.prevNumber = nil
        self.prevOperation = nil
    }
}

extension ViewControllerViewModel{
    private func didSelectNumber(with number: Int){
        
        
        if self.currentNumber == .firstNumber {
            
            if let firstNumber = self.firstNumber{
                var firstNumberString = firstNumber.description
                firstNumberString.append(number.description)
                self.firstNumber = Int(firstNumberString)
                self.prevNumber = Int(firstNumberString)
                
            }else{
                self.firstNumber = Int(number)
                self.prevNumber = Int(number)
            }
            
        }else{
         
            if let secondNumber = self.secondNumber{
                var secondNumberString = secondNumber.description
                secondNumberString.append(number.description)
                self.secondNumber = Int(secondNumberString)
                self.prevNumber = Int(secondNumberString)
            }else{
                self.secondNumber = Int(number)
                self.prevNumber = Int(number)
            }
            
        }
    }
}

extension ViewControllerViewModel{
    
    private func didSelectEqalsButton() {
        if let operation = self.operation,
           let firstNumber = self.firstNumber,
           let secondNumber = self.secondNumber{
            
            let result = self.getOperarionResult(operation, firstNumber, secondNumber)
            
            self.secondNumber = nil
            self.prevOperation = operation
            self.operation = nil
            self.firstNumber = result
            self.currentNumber = .firstNumber
        }
        else if let prevOperation = self.prevOperation,
                let firstNumber = self.firstNumber,
                let prevNumber = self.prevNumber{
            
            let result = self.getOperarionResult(prevOperation, firstNumber, prevNumber)
            self.firstNumber = result
            
        }
    }
    
    private func didSelectOperation(with operation: CalculatorOperation){
        
        if self.currentNumber == .firstNumber {
            self.operation = operation
            self.currentNumber = .secondNumber
        } else if self.currentNumber == .secondNumber{
            
            if let prevOperation = self.operation, let firstNumber = self.firstNumber, let secondNumber = self.secondNumber {
                
                let result = self.getOperarionResult(prevOperation, firstNumber, secondNumber)
                
                self.secondNumber = nil
                self.firstNumber = result
                self.currentNumber = .secondNumber
                self.operation = operation
            } else {
                self.operation = operation
            }
        }
    }
    
    private func getOperarionResult(_ operation: CalculatorOperation, _ firstNumber: Int, _ secondNumber: Int) -> Int{
        
        switch operation {
        case .divide:
            return (firstNumber / secondNumber)
        case .multiply:
            return (firstNumber * secondNumber)
        case .subtract:
            return (firstNumber - secondNumber)
        case .add:
            return (firstNumber + secondNumber)
        }
        
    }
    
}

extension ViewControllerViewModel {
    
    private func didSelectPlusMinus(){
        if self.currentNumber == .firstNumber, var number = self.firstNumber{
            
            number.negate()
            self.firstNumber = number
            self.prevNumber = number
        }
        else if self.currentNumber == .secondNumber, var number = self.secondNumber {
            
            number.negate()
            self.secondNumber = number
            self.prevNumber = number
        }
    }
    
    private func didSelectPercentage() {
        if self.currentNumber == .firstNumber, var number = self.firstNumber{
            number /= 100
            self.firstNumber = number
            self.prevNumber = number
        }
        else if self.currentNumber == .secondNumber, var number = self.secondNumber {
            number /= 100
            self.secondNumber = number
            self.prevNumber = number
        }
    }
    
}
