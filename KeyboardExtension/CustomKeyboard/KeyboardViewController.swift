//
//  KeyboardViewController.swift
//  CustomKeyboard
//
//  Created by Robert Wong on 10/12/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    //@IBOutlet var nextKeyboardButton: UIButton!
    
    var capsLockOn = false
    
    //creating a 2-D array for keyboard layout for coding simplicity
    var primaryBoard = [
            ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
            ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
            ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
            ["Z", "X", "C", "V", "B", "N", "M"],
            ["↑", "SPS", "⇔", "Space", "←", "↵"]
        ]
    
    var secondaryBoard = [
        ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "=", "+", "-"],
        ["-", "~", "`", ":", ";","\\", "{", "}", "[", "]"],
        ["'", "\"", "<", ">", ",", ".", "?", "/", "|"],
        ["Q(._.Q)"],
        ["⇔", "A-Z", "Space", "←", "↵"]
    ]
    
    //declaring the stack view for the boards
    var primaryBoardStackView: UIStackView!
    var secondaryBoardStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //create the stack view for the keyboard layouts
        primaryBoardStackView = createKeyboardRows(rows: primaryBoard)
        primaryBoardStackView.isHidden = false
        secondaryBoardStackView = createKeyboardRows(rows: secondaryBoard)
        secondaryBoardStackView.isHidden = true
        
    }
    
    //function to create the keyboards and their UIStackView
    func createKeyboardRows(rows: [[String]]) -> UIStackView {
        var completedStackViews = [UIStackView]()
        
        for rows in rows {
            let newStackView = createButtonRow(keys: rows)
            completedStackViews.append(newStackView)
        }
        let stackView =  UIStackView(arrangedSubviews: completedStackViews)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 1
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1).isActive = true
        
        return stackView
    }
    
    func createButtonRow(keys: [String]) -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 1
        
        for key in keys {
            let button = UIButton(type: .custom)
            button.setTitle(key, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .lightGray
            button.heightAnchor.constraint(equalToConstant: 42).isActive = true
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 9)
            button.layer.cornerRadius = 3
            button.addTarget(self, action: #selector(KeyboardViewController.tappedButton(button:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        
        return stackView
    }
    
    @objc func tappedButton(button: UIButton) {
        let keyTitle = button.titleLabel!.text
        let proxy = textDocumentProxy as UITextDocumentProxy
        switch keyTitle! {
        case "↑":
            if capsLockOn {
                button.backgroundColor = .lightGray
                capsLockOn = false
            } else {
                button.backgroundColor = UIColor(red: 0.5922, green: 0.5922, blue: 0.5922, alpha: 1.0)
                capsLockOn = true
            }
        case "SPS":
            primaryBoardStackView.isHidden = true
            secondaryBoardStackView.isHidden = false
        case "A-Z":
            primaryBoardStackView.isHidden = false
            secondaryBoardStackView.isHidden = true
        case "⇔":
            advanceToNextInputMode()
        case "Space":
            proxy.insertText(" ")
        case "←":
            proxy.deleteBackward()
        case "↵":
            proxy.insertText("\n")
        default:
            let textToInset: String
            
            if capsLockOn {
                textToInset = keyTitle!.uppercased()
            } else {
                textToInset = keyTitle!.lowercased()
            }
            
            proxy.insertText(textToInset)
        }
    }

}
