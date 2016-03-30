//
//  ViewController.swift
//  calculate-it
//
//  Created by Monica Arnon on 3/29/16.
//  Copyright © 2016 TouchingFreedom. All rights reserved.
//

import UIKit
//Add sound
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String {
        case Divide = "/"
        case Add = "+"
        case Multiply = "*"
        case Subtract = "-"
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var btnSound: AVAudioPlayer!
    
    var runningNumber = "0"
    var leftNumber = ""
    var rightNumber = ""
    var currentOperation: Operation = Operation.Empty
    var isNumberStart = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        outputLbl.text = runningNumber
        
        //Get the path of the audio file
        let path = NSBundle.mainBundle().pathForResource("click_x", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOfURL: soundUrl)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            //Swallow
            print(err.debugDescription)
        }
    }
    
    @IBAction func numberPressed(btn: UIButton!) {
        playSound()

        //Clear the current number in the label text
        if isNumberStart == true {
            outputLbl.text = ""
            runningNumber = ""
        }
        
        runningNumber += "\(btn.tag)"
        outputLbl.text = runningNumber
        isNumberStart = false
    }

    func processOperation(operatorKey: Operation) {
        playSound()
        isNumberStart = true
        
        if currentOperation != Operation.Empty {
            
            //If runningNumber is blank, user has clicked an operator and then 
            //clicked another operator
            if runningNumber != "" {
                
                //Do math
                var result: Double = 0.0
                rightNumber = runningNumber
                
                let mathString: String = "\(leftNumber)\(currentOperation.rawValue)\(rightNumber)"
                let exp: NSExpression = NSExpression(format: mathString)
                result = exp.expressionValueWithObject(nil, context: nil) as! Double
                
                //Chop off the .0 if it's a whole number (for the heck of it)
                if String(result).hasSuffix(".0") {
                    let intResult = String(result).componentsSeparatedByString(".")[0]
                    outputLbl.text = String(intResult)
                } else {
                    outputLbl.text = String(result)
                }
                
                leftNumber = String(result)
                rightNumber = ""                
            }
        } else {
            //First time an operation key has been pressed
            leftNumber = runningNumber
        }

        runningNumber = ""
        currentOperation = operatorKey

    }
 
    @IBAction func onDividePressed(sender: UIButton) {
        processOperation(Operation.Divide)
    }

    @IBAction func onMultiplyPressed(sender: UIButton) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: UIButton) {
        processOperation(Operation.Subtract)
    }
    
    @IBAction func onAddPressed(sender: UIButton) {
        processOperation(Operation.Add)
    }
    
    @IBAction func onEqualPressed(sender: UIButton) {
        processOperation(currentOperation)
    }
    
    func playSound() {
        if btnSound.playing {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
}

