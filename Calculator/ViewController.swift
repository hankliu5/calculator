//
//  ViewController.swift
//  Calculator
//
//  Created by Hank Liu on 7/22/16.
//  Copyright © 2016 Hank Liu. All rights reserved.
//

import UIKit

var calculatorCount = 0

class ViewController: UIViewController {
  
  @IBOutlet private weak var display: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorCount += 1
        print("Loaded up a new Calculator (count = \(calculatorCount))")
        brain.addUnaryOperation("Z") { [ weak weakSelf = self ] in
            weakSelf?.display.textColor = UIColor.redColor()
            return sqrt($0)
        }
    }
    
    deinit {
        calculatorCount -= 1
        print("Calculator left the heap (count = \(calculatorCount))")
    }
  
  private var userTyping = false
  
  @IBAction private func touchDigit(sender: UIButton) {
    let digit = sender.currentTitle!
    if userTyping {
      let textCurrentlyInDisplay = display.text!
      display.text = textCurrentlyInDisplay + digit
    } else {
      display.text = digit
    }
    userTyping = true
  }
  
  private var displayValue: Double {
    get {
      return Double(display.text!)!
    }
    
    set {
      display.text = String(newValue)
    }
  }
  
  var savedProgram: CalculatorBrain.PropertyList?
  
  @IBAction func save() {
    savedProgram = brain.program
  }
  
  @IBAction func restore() {
    if savedProgram != nil {
      brain.program = savedProgram!
      displayValue = brain.result
    }
  }
  
  private var brain = CalculatorBrain()
  
  @IBAction private func performOperation(sender: UIButton) {
    if userTyping {
      brain.setOperand(displayValue)
      userTyping = false
    }
    if let mathematicalSymbol = sender.currentTitle {
      brain.performOperation(mathematicalSymbol)
    }
    displayValue = brain.result
  }
  
}

