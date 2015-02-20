//
//  ViewController.swift
//  Calculator
//
//  Created by Nielson Rolim on 2/19/15.
//  Copyright (c) 2015 Nielson Rolim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UITextView!
    
    var userIsInTheMiddleOfTypingANumber = false
    var operandStack = Array<Double>()
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        var digit: String
        switch sender.currentTitle! {
        case "π": digit = "\(M_PI)"
        default: digit = sender.currentTitle!
        }
        
        if (userIsInTheMiddleOfTypingANumber) {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func appendDot(sender: UIButton) {
        if (display.text!.rangeOfString(".") == nil || userIsInTheMiddleOfTypingANumber == false) {
            appendDigit(sender)
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
        case "×": performOperation(operation) { $0 * $1 }
        case "÷": performOperation(operation) {$1 / $0}
        case "+": performOperation(operation) {$0 + $1}
        case "−": performOperation(operation) {$1 - $0}
        case "√": performOperation(operation) { sqrt($0) }
        case "sin": performOperation(operation) { sin($0) }
        case "cos": performOperation(operation) { cos($0) }
        default: break
        }
    }
    
    func performOperation(operationSymbol:String, operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            var op1 = operandStack.removeLast()
            var op2 = operandStack.removeLast()
            displayValue = operation(op1, op2)
            enter()
            
            history.text = history.text! + "\(op2) " + operationSymbol + " \(op1) = " + "\(displayValue)\n"
            historyScrollDown()
        }
    }
    
    func performOperation(operationSymbol:String, operation: (Double) -> Double) {
        if operandStack.count >= 1 {
            var op1 = operandStack.removeLast()
            displayValue = operation(op1)
            enter()
            
            history.text = history.text! + operationSymbol + "(\(op1)) = "  + "\(displayValue)\n"
            historyScrollDown()
        }
    }
    
    func historyScrollDown() {
        var range = NSMakeRange(countElements(history.text) - 1, 1)
        history.scrollRangeToVisible(range)
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        
        println("operandStack = \(operandStack)")
    }
    
    @IBAction func clear() {
        displayValue = 0
        history.text = ""
        operandStack.removeAll(keepCapacity: false)
        
        println("operandStack = \(operandStack)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

