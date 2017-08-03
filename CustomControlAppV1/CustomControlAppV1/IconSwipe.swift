//
//  IconSwipe.swift
//  CustomControlAppV1
//
//  Created by Robert Wong on 8/3/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

@IBDesignable
class IconSwipe: UIControl {
    
    private var spaceConstraint : NSLayoutConstraint!
    
    @IBInspectable
    var spacing: CGFloat = 0.0 {
        didSet {
            spaceConstraint?.constant = spacing
        }
    }
    
    @IBInspectable
    var image: UIImage? {
        get {
            return imageView.image
        }
        set(newImage) {
            imageView.image = newImage?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    @IBInspectable
    var text: String? {
        get {
            return label.text
        }
        set(newText) {
            label.text = newText
        }
    }
    
    private lazy var imageView : UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private lazy var label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15.0, weight: UIFontWeightRegular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }

    private func initialization() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(imageView)
        
        spaceConstraint = label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: spacing)
        
        NSLayoutConstraint.activate(
            [
                imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                spaceConstraint,
                label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
                imageView.centerXAnchor.constraint(equalTo: label.centerXAnchor)
            ]
        )
        
        layer.cornerRadius = 10
        addTapGestureRecognizer()
        addSwipeGestureRecognizer()
    }
}

extension IconSwipe {
    fileprivate func addTapGestureRecognizer() {
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleIconButtonTapped(sender:)))
        addGestureRecognizer(tapGestureRecogniser)
    }
    
    func handleIconButtonTapped(sender: UITapGestureRecognizer) {
        sendActions(for: .touchUpInside)
    }
    
    fileprivate func addSwipeGestureRecognizer() {
        let swipeGestureRecognizerUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipeGestureRecognizerUp.direction = .up
        addGestureRecognizer(swipeGestureRecognizerUp)
        
        let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipeGestureRecognizerDown.direction = .down
        addGestureRecognizer(swipeGestureRecognizerDown)
        
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
            case UISwipeGestureRecognizerDirection.up:
                self.image = UIImage(named: "icons8-Hammer-50.png")
                self.text = "Hammer Icon"
            case UISwipeGestureRecognizerDirection.down:
                self.image = UIImage(named: "icons8-Ruler-50.png")
                self.text = "Ruler Icon"
            case UISwipeGestureRecognizerDirection.left:
                self.image = UIImage(named: "icons8-Maintenance-50.png")
                self.text = "Maintenance Icon"
            case UISwipeGestureRecognizerDirection.right:
                self.image = UIImage(named: "icons8-Paint Bucket-50.png")
                self.text = "Paint Bucket Icon"
            default:
                self.image = UIImage(named: "icons8-Home-50.png")
                self.text = "Home Icon"

            }
        }
    }
}
