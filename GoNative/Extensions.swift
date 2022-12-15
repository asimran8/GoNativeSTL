//
//  Extensions.swift
//  FeedMeApp
//
//  Created by Lauren Sands on 2/20/22.
//

import Foundation
import UIKit


extension String{
    func safeDatabaseKey() -> String{
        return self.replacingOccurrences(of: "@", with: "-").self.replacingOccurrences(of: ".", with: "-")
    }
}

extension UIImageView
{
    func downloadImage(from imgURL: String!)
    {
        if(imgURL != nil){
        let url = URLRequest(url: URL(string: imgURL)!) //NIL?
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
        }
        else{
            print("cant download image")
        }
    }
}

struct AppUtility {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
   
        self.lockOrientation(orientation)
    
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

}
