//
//  Color.swift
//  CustomControlAppV2
//
//  Created by Robert Wong on 8/9/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

@IBDesignable
class Color: UIControl {
    
    var label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15.0, weight: UIFontWeightRegular)
        return label
    }()
    
    var colorGen : UIView = {
        let colorBox = UIView(frame: CGRect(x:0, y:0, width:100, height:75))
        colorBox.backgroundColor = UIColor.black
        return colorBox
    }()
    
    private var spaceConstraint : NSLayoutConstraint!
    
    var redStored: [CGFloat] = []
    var greenStored: [CGFloat] = []
    var blueStored: [CGFloat] = []
    var colorPosition: Int = 0
    
    @IBInspectable
    var text: String? {
        get {
            return label.text
        }
        set(newText) {
            label.text = newText
        }
    }
    
    @IBInspectable
    var spacing: CGFloat = 0.0 {
        didSet {
            spaceConstraint?.constant = spacing
        }
    }
    
    override init (frame: CGRect) {
        super.init(frame:frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(colorGen)
        
        spaceConstraint = label.topAnchor.constraint(equalTo: colorGen.bottomAnchor, constant: spacing)
        
        NSLayoutConstraint.activate(
            [
                colorGen.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
                colorGen.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                colorGen.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                spaceConstraint,
                label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
                colorGen.centerXAnchor.constraint(equalTo: label.centerXAnchor),
            ]
        )
        
        layer.cornerRadius = 10
        addTapGestureRecognizer()
        addSwipeGestureRecognizer()
    }

}

extension Color {
    fileprivate func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (handleColorBoxTap(sender:)))
        addGestureRecognizer(tapGesture)
    }
    
    fileprivate func addSwipeGestureRecognizer() {
        let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipeGestureRecognizerLeft.direction = .left
        addGestureRecognizer(swipeGestureRecognizerLeft)
        
        let swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipeGestureRecognizerRight.direction = .right
        addGestureRecognizer(swipeGestureRecognizerRight)
    }
    
    func handleSwipe(sender: UIGestureRecognizer) {
        if let swipeGesture = sender as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                print("left")
                if colorPosition < (redStored.count - 1) {
                    colorPosition = colorPosition + 1
                    self.colorGen.backgroundColor = UIColor(red: redStored[colorPosition], green: greenStored[colorPosition], blue: blueStored[colorPosition], alpha: 1.0)
                    let hexStringFormat = NSString(format: "%02lX%02lX%02lX", lroundf(Float(redStored[colorPosition] * 255)), lroundf(Float(greenStored[colorPosition] * 255)), lroundf(Float(blueStored[colorPosition] * 255)))
                    self.label.text = ("#\(hexStringFormat)")
                }
                
            case UISwipeGestureRecognizerDirection.right:
                print("right")
                if colorPosition >= 1 {
                    colorPosition = colorPosition - 1
                    self.colorGen.backgroundColor = UIColor(red: redStored[colorPosition], green: greenStored[colorPosition], blue: blueStored[colorPosition], alpha: 1.0)
                    let hexStringFormat = NSString(format: "%02lX%02lX%02lX", lroundf(Float(redStored[colorPosition] * 255)), lroundf(Float(greenStored[colorPosition] * 255)), lroundf(Float(blueStored[colorPosition] * 255)))
                    self.label.text = ("#\(hexStringFormat)")
                }
            default:
                print("Unexpected case")
            }
        }
    }
    
    func handleColorBoxTap(sender: UITapGestureRecognizer) {
        sendActions(for: .touchUpInside)
        
        let newRed = Int(arc4random_uniform(256))
        let newGreen = Int(arc4random_uniform(256))
        let newBlue = Int(arc4random_uniform(256))

        let red = CGFloat(newRed)/255
        let green = CGFloat(newGreen)/255
        let blue = CGFloat(newBlue)/255
        
        redStored.append(red)
        greenStored.append(green)
        blueStored.append(blue)
        
        self.colorGen.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        let hexStringFormat = NSString(format: "%02lX%02lX%02lX", lroundf(Float(red * 255)), lroundf(Float(green * 255)), lroundf(Float(blue * 255)))
        print (hexStringFormat)
        self.label.text = ("#\(hexStringFormat)")
        colorPosition = colorPosition + 1
        
    }
}
