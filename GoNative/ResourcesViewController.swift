//
//  ResourcesViewController.swift
//  GoNative
//
//  Created by Simran Ajwani on 11/16/22.
//

import UIKit

class ResourcesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func hnpButton(_ sender: Any) {
        if let url = URL(string: "https://homegrownnationalpark.org") {
            UIApplication.shared.open(url)
        }
    }
   
    @IBAction func howNativeButton(_ sender: Any) {
        if let url = URL(string: "https://missourilife.com/heres-guide-growing-native-plants/") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func keystoneButton(_ sender: Any) {
        if let url = URL(string: "https://www.nwf.org/Garden-for-Wildlife/About/Native-Plants/keystone-plants-by-ecoregion") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func invasiveButton(_ sender: Any) {
        if let url = URL(string: "https://moinvasives.org/lists/") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func growNativeButton(_ sender: Any) {
        if let url = URL(string: "https://grownative.org/resource-guide/") {
            UIApplication.shared.open(url)
        }
    }
    
    //let email = "greenresources@mobot.org"
    //let email = URL(string: "mailto:greenresources@mobot.org")!

    @IBAction func contactButton(_ sender: Any) {
        let email = "greenresources@mobot.org"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
       
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
