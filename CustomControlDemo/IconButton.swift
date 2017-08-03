//
//  IconButton.swift
//  CustomControlDemo
//
//  Created by Robert Wong on 8/2/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

@IBDesignable
class IconButton: UIControl {
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
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
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
    }

}

extension IconButton {
    fileprivate func addTapGestureRecognizer() {
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleIconButtonTapped(sender:)))
        addGestureRecognizer(tapGestureRecogniser)
    }
    
    func handleIconButtonTapped(sender: UITapGestureRecognizer) {
        sendActions(for: .touchUpInside)
    }
}
