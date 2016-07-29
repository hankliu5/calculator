//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Hank Liu on 7/22/16.
//  Copyright © 2016 Hank Liu. All rights reserved.
//

import Foundation

class CalculatorBrain {
  
  private var accumulator = 0.0
  private var internalProgram = [AnyObject]()
  
  func setOperand(operand: Double) {
    accumulator = operand
    internalProgram.append(operand)
  }
  
  var operations: Dictionary<String, Operation> = [
    "π" : Operation.Constant(M_PI),
    "e" : Operation.Constant(M_E),
    "±" : Operation.UnaryOperation({ -$0 }),
    "√" : Operation.UnaryOperation(sqrt),
    "cos" : Operation.UnaryOperation(cos),
    "×" : Operation.BinaryOperation({ $0 * $1 }),
    "÷" : Operation.BinaryOperation({ $0 / $1 }),
    "+" : Operation.BinaryOperation({ $0 + $1 }),
    "−" : Operation.BinaryOperation({ $0 - $1 }),
    "=" : Operation.Equals
  ]
  
  enum Operation {
    case Constant(Double)
    case UnaryOperation((Double) -> Double)
    case BinaryOperation((Double, Double) -> Double)
    case Equals
  }
  
  func performOperation(symbol: String) {
    internalProgram.append(symbol)
    if let operation = operations[symbol] {
      switch operation {
      case .Constant(let value):
        accumulator = value
      case .UnaryOperation(let function):
        accumulator = function(accumulator)
      case .BinaryOperation(let function):
        executePendingBinaryOperation()
        pending = PendingBinaryOpeationInfo(binaryFunction: function, firstOperand: accumulator)
      case .Equals:
        executePendingBinaryOperation()
      }
    }
  }
  
  private func executePendingBinaryOperation() {
    if pending != nil {
      accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
      pending = nil
    }
  }
  
  typealias PropertyList = AnyObject
  
  var program: PropertyList {
    get {
      return internalProgram
    }
    
    set {
      clear()
      if let arrayOfOps = newValue as? [AnyObject] {
        for op in arrayOfOps {
          if let operand = op as? Double {
            setOperand(operand)
          } else if let operation = op as? String {
            performOperation(operation)
          }
        }
      }
    }
  }
  
  func clear() {
    accumulator = 0.0
    pending = nil
    internalProgram.removeAll()
  }
  
  private var pending: PendingBinaryOpeationInfo?
  
  private struct PendingBinaryOpeationInfo {
    var binaryFunction: (Double, Double) -> Double
    var firstOperand: Double
  }
  
  var result: Double {
    get {
      return accumulator
    }
  }
}