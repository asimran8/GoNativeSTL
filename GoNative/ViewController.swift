//
//  ViewController.swift
//  GoNative
//
//  Created by Simran Ajwani on 10/12/22.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    var imageNames = ["Cardinal Flower", "American Beautyberry", "Butterfly Milkweed", "Royal Catchfly", "Little Bluestem Grass", "Cardinal Flower"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .dark
        //getLandSize2()
        
        let timer = Timer.scheduledTimer(withTimeInterval:2, repeats:true) {
            timer in
            let imageRandom = self.imageNames.randomElement()
            self.imageName.text = imageRandom!
            self.SlideShowViewer.image = UIImage(named: imageRandom!)
            //
        }
        timer.fire()

    }
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var SlideShowViewer: UIImageView!
}
