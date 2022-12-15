//
//  DisplayView.swift
//  GoNative
//
//  Created by Simran Ajwani on 11/12/22.
//

import UIKit

class DisplayView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /// The value to visually display. Valid range is between 0 and 1.
    public var value: CGFloat {
        get {
            return self.modelValue
        }
        set(newValue) {
            self.modelValue = newValue
            self.update(animated: false)
        }
    }
    
    /// The color of the display bar.
    public var color: UIColor = .green {
        didSet { self.valueView.backgroundColor = UIColor.green }
    }
    
    private var modelValue: CGFloat = 0
    
    private let valueView = UIView()
    
    private var valueFrame: CGRect {
        var widthFraction = self.modelValue
        if widthFraction < 0 { widthFraction = 0 }
        if widthFraction > 1 { widthFraction = 1 }
        return CGRect(x: 0, y: 0, width: widthFraction * self.bounds.width, height: self.bounds.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.valueView.backgroundColor = color
        self.addSubview(self.valueView)
    }
    
    /// Animates the bar to the specified value. Valid range is between 0 and 1.
    public func animateValue(to newValue: CGFloat) {
        self.modelValue = newValue
        self.update(animated: true)
    }
    
    private func update(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.valueView.frame = self.valueFrame
            })
        } else {
            self.valueView.frame = self.valueFrame
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.valueView.frame = self.valueFrame
    }

}
