//
//  PlainHorizontalProgressBar.swift
//  GoNative
//
//  Created by Simran Ajwani on 11/13/22.
//

import UIKit

@IBDesignable
class PlainHorizontalProgressBar: UIView {
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var color: UIColor = .gray {
        didSet { setNeedsDisplay() }
    }

    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }

    private let progressLayer = CALayer()
    private let backgroundMask = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    private func setupLayers() {
        layer.addSublayer(progressLayer)
    }

    override func draw(_ rect: CGRect) {
        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.25).cgPath
        layer.mask = backgroundMask

        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))

        progressLayer.frame = progressRect
        progressLayer.backgroundColor = color.cgColor
    }

}
