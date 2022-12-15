//
//  CalculationsViewController.swift
//  GoNative
//
//  Created by Simran Ajwani on 10/19/22.
//

import UIKit

class CalculationsViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //zillowWebsiteButton.addTarget(self, action: "visitZillowWebsite", for: .touchUpInside)
        // Do any additional setup after loading the view.
        landLengthField.delegate = self
        homeLengthField.delegate = self
        levelField.delegate = self
        setUpTextFields()
    }
    
    func setUpTextFields(){
        levelField.layer.borderColor = UIColor.lightGray.cgColor
        landLengthField.layer.borderColor = UIColor.lightGray.cgColor
        homeLengthField.layer.borderColor = UIColor.lightGray.cgColor
        levelField.layer.masksToBounds = true
        landLengthField.layer.masksToBounds = true
        homeLengthField.layer.masksToBounds = true
        levelField.layer.borderWidth = 1.0
        landLengthField.layer.borderWidth = 1.0
        homeLengthField.layer.borderWidth = 1.0
        levelField.layer.cornerRadius = 11.0
        landLengthField.layer.cornerRadius = 11.0
        homeLengthField.layer.cornerRadius = 11.0
    }
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBOutlet weak var zillowAppButton: UIButton!
    @IBOutlet weak var zillowWebsiteButton: UIButton!
    
    var landLength: Int?
    var homeLength: Int?
    var levelsHome: Int?

    @IBOutlet weak var levelField: UITextField!
    @IBOutlet weak var landLengthField: UITextField!
    @IBOutlet weak var homeLengthField: UITextField!

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
        if (textField == landLengthField) || (textField == homeLengthField)  || (textField == levelField){
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789 ")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        landLengthField.resignFirstResponder()
        homeLengthField.resignFirstResponder()
        levelField.resignFirstResponder()
     
        if((landLengthField.text == "") || (homeLengthField.text == "") || (levelField.text == "")){
            let alert = UIAlertController(title: "Empty Values", message: "Ensure all dimension fields are filled out", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
        }
        
        landLength = Int(landLengthField.text ?? "")
        homeLength = Int(homeLengthField.text ?? "")
        levelsHome = Int(levelField.text ?? "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NativePlantViewController
        {
            vc.landLengthResults = landLength
            vc.homeLengthResults = homeLength
            vc.levelsResults = levelsHome
        }
    }
    
    @IBAction func visitZillowApp(_ sender: Any) {
        if let url = URL(string: "https://apps.apple.com/us/app/zillow-real-estate-rentals/id310738695") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func visitZillowWebsite(_ sender: Any) {
        if let url = URL(string: "http://www.zillow.com") {
             UIApplication.shared.open(url, options: [:])
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
