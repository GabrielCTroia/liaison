//
//  ViewController.swift
//  Liaison
//
//  Created by gabriel troia on 3/18/17.
//  Copyright © 2017 gabriel troia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var wordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        wordTextField.delegate = self
    }
    
    //MARK: Actions
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        wordLabel.text = "Reset value"
        wordTextField.placeholder = "hmm"
    }
    
    //MARK: Text Field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        wordLabel.text = textField.text
    }

}

