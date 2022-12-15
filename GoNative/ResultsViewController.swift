//
//  ResultsViewController.swift
//  GoNative
//
//  Created by Simran Ajwani on 10/19/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import Firebase

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var progressNativeBar: PlainHorizontalProgressBar!
    @IBOutlet weak var progressTurfBar: PlainHorizontalProgressBar!
    
    var landLengthResults: Int?
    var homeLengthResults: Int?
    var levelsResults: Int?
    
    public var loadnativePlantInfo = [String: [Double]]()
    public var loaddareaPlantInfo = [String: [Double]]()
    public var loadKeystonePlantInfo = [String: Double]()

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculateNatives()
        calculateAreas()
        calculateKeystones()
        progressNativeBar.color = UIColor(red: 0.10, green: 0.36, blue: 0.31, alpha: 1.00)
        reachedPercentageText.alpha = 0
        mapButton.alpha = 0
        propertyMapText.alpha = 0
        reachedPercentage()
    }

    var countarea = 0
    var count = 0
    var countkeys = 0

    var nativePercentage = 70
    @IBOutlet weak var nativePercentageText: UILabel!

    //calculating which native plants that the user has added are keystones
    func calculateKeystones(){
        countarea = countarea+1
        var keystoneNames = ["Black Cherry", "Black Oak", "Box Elder", "River Birch", "Sugar Maple", "White Oak", "Prairie Willow", "Black-eyed Susan", "Lanceleaf Coreopsis", "Stiff Goldenrod"]
        var totalKeystoneCountNum = 0
        self.countkeys = self.countkeys + 1

        loadKeystonesFromDatabase { (loadKeystonePlantInfo) in
            self.loadKeystonePlantInfo = loadKeystonePlantInfo
            print("LOADKEYSTONEPLANTINFO \(loadKeystonePlantInfo)")
            
            for(key,_) in loadKeystonePlantInfo{
                if(keystoneNames.contains(key)){
                    totalKeystoneCountNum = totalKeystoneCountNum + 1
                    let index = keystoneNames.firstIndex(of: key)
                    keystoneNames.remove(at: index!)
                }
            }
            
            self.keystoneText.text = "You have \(totalKeystoneCountNum) Keystone species!"
            
        }
    }
    
    @IBOutlet weak var reachedPercentageText: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var propertyMapText: UILabel!
    
    func reachedPercentage(){
        if((progressNativeBar.progress >= 1.0) && (progressTurfBar.progress >= 1.0)){
            reachedPercentageText.alpha = 1
            mapButton.alpha = 1
            propertyMapText.alpha = 1
        }
    }
    
    @IBOutlet weak var keystoneText: UILabel!
    
    //calculating the total area of native plants (from Firebase Database) that the user has added
    func calculateAreas(){
        var totalNativeArea = 0.0
        var fillSpaceArea = 0.0
        var totalSinglePlantArea: [Double] = []
        let totalLandArea = landLengthResults!
        let totalHouseArea = homeLengthResults!
        fillSpaceArea = Double(totalLandArea) - Double(totalHouseArea)

        loadAreaFromDatabase { (loaddareaPlantInfo) in
            self.countarea = self.countarea+1
            self.loaddareaPlantInfo = loaddareaPlantInfo
            for (_, value) in loaddareaPlantInfo{
                if !totalSinglePlantArea.contains(value[0]*value[1]){
                    totalSinglePlantArea.append(value[0]*value[1])
                }
            }
            
            if(totalSinglePlantArea.count == 1){
                for value in totalSinglePlantArea{
                    totalNativeArea = value
                }
            }
            if(totalSinglePlantArea.count == self.countarea-1){
                for value in totalSinglePlantArea{
                    totalNativeArea = totalNativeArea + value
                }
            }
            let nativePlantAreaPercentage = totalNativeArea/fillSpaceArea
            self.progressTurfBar.progress = (nativePlantAreaPercentage/50)*100
            if(nativePlantAreaPercentage.isNaN || nativePlantAreaPercentage.isInfinite ) {
                self.nativeAreaText.text = "Error. Recalculate."
                self.reachedPercentage()

            }
            else{
                if((Int(nativePlantAreaPercentage*100)) <= 0 ){
                self.nativeAreaText.text = "Error. Recalculate."
                self.reachedPercentage()
                }
                else if((Int(nativePlantAreaPercentage*100)) <= 50 ){
                self.nativeAreaText.text = "You are at \(Int(nativePlantAreaPercentage*100))% out of 50%"
                self.reachedPercentage()
                }
                   else{
                       self.nativeAreaText.text = "You reached the 50% area!"
                       self.reachedPercentage()
                }
            }
        }
    }
    
    @IBOutlet weak var nativeAreaText: UILabel!
    
    //calculating the total volume of native plants (from Firebase Database) that the user has added
    func calculateNatives(){
        var totalNativeVolume = 0.0
        var totalHouseVolume = 0.0
        var totalLandVolume = 0.0
        var totalSinglePlantVolume: [Double] = []
        let landAreaFt2 = landLengthResults!
        let homeAreaFt2 = homeLengthResults!
        let homeLevels = levelsResults!
        totalHouseVolume = Double(homeAreaFt2)*Double(homeLevels)*10.0
        totalLandVolume = Double(landAreaFt2)*Double(homeLevels)*10.0
        
        loadNativeFromDatabase { (loadnativePlantInfo) in
            self.count = self.count+1
            print("count inside \(self.count)")
            self.loadnativePlantInfo = loadnativePlantInfo
            
            for (_, value) in loadnativePlantInfo{
                if !totalSinglePlantVolume.contains(value[0]*value[1]){
                    totalSinglePlantVolume.append(value[0]*value[1])
                }
            }
            
            if(totalSinglePlantVolume.count == 1){
                for value in totalSinglePlantVolume{
                    totalNativeVolume = value
                }
            }
                
            if(totalSinglePlantVolume.count == self.count){
                for value in totalSinglePlantVolume{
                    totalNativeVolume = totalNativeVolume + value
                }
            }
            
            let nativePlantVolumePercentage = totalNativeVolume/(totalLandVolume-totalHouseVolume)
            self.progressNativeBar.progress = (nativePlantVolumePercentage/70)*100
            if(nativePlantVolumePercentage.isNaN || nativePlantVolumePercentage.isInfinite ) {
                self.nativePercentageText.text = "Error. Recalculate."
                self.reachedPercentage()
            }
            else{
                if(Int(nativePlantVolumePercentage*100) <= 0){
                    self.nativePercentageText.text = "Error. Recalculate."
                        self.reachedPercentage()
                }
                else if(Int(nativePlantVolumePercentage*100) >= 70){
                    self.nativePercentageText.text = "You reached the 70% volume!"
                        self.reachedPercentage()
                }
                   else{
                    self.nativePercentageText.text = "You are at \(Int(nativePlantVolumePercentage*100))% out of 70%"
                        self.reachedPercentage()
                }
            }
        }
    }
    
    //loading native plant data from Firebase databse
    func loadKeystonesFromDatabase(completion: @escaping ([String:Double]) -> Void){
        let userID = UIDevice.current.identifierForVendor?.uuidString
        for i in 0...335{
            Database.database().reference().child(String(describing: i)).child("commonName").observeSingleEvent(of: .value, with: { [self] (snapshot) in
                    Database.database().reference().child(String(describing: i)).child("numberOfPlants").child(userID ?? "").observeSingleEvent(of: .value, with: { [self] (snapshot2) in
                        
                        if(snapshot2.key == userID){
                            Database.database().reference().child(String(describing: i)).child("isKeystone").observeSingleEvent(of: .value, with: { [self] (snapshot3) in
                        //add to dictionary
                            let commonName = snapshot.value as? String ?? ""
                            let isKeystone = snapshot3.value as? String ?? ""
                            let numNative = snapshot2.value as? Double ?? 0.0
                            let intVal: Double = numNative
                                if(numNative != 0.0) {
                                    loadKeystonePlantInfo[commonName] = intVal
                                    completion(loadKeystonePlantInfo)
                                }
                                else{
                                    return
                            }
                        })
                    }
                })
            })
        }
    }
    
    //loading native plant data from Firebase databse
    func loadNativeFromDatabase(completion: @escaping ([String: [Double]]) -> Void) {
        let userID = UIDevice.current.identifierForVendor?.uuidString
        for i in 0...335{
            Database.database().reference().child(String(describing: i)).child("commonName").observeSingleEvent(of: .value, with: { [self] (snapshot) in
                    Database.database().reference().child(String(describing: i)).child("numberOfPlants").child(userID ?? "").observeSingleEvent(of: .value, with: { [self] (snapshot2) in
                        
                        if(snapshot2.key == userID){
                            Database.database().reference().child(String(describing: i)).child("VolumeFt3").observeSingleEvent(of: .value, with: { [self] (snapshot3) in
                        //add to dictionary
                            let key = snapshot.value as? String ?? ""
                            let plantVolumeFt3 = snapshot3.value as? Double ?? 0.0
                            let numNative = snapshot2.value as? Double ?? 0.0
                            let intVal: [Double] = [plantVolumeFt3,numNative]
                                if(numNative != 0.0) {
                                    loadnativePlantInfo[key] = intVal
                                    completion(loadnativePlantInfo)
                                }
                                else{
                                    return
                                }
                        })
                    }
                })
            })
        }

    }
    
    //loading native plant data from Firebase databse
    func loadAreaFromDatabase(completion: @escaping ([String: [Double]]) -> Void) {
        let userID = UIDevice.current.identifierForVendor?.uuidString
        for i in 0...335{
            Database.database().reference().child(String(describing: i)).child("commonName").observeSingleEvent(of: .value, with: { [self] (snapshot) in
                    Database.database().reference().child(String(describing: i)).child("numberOfPlants").child(userID ?? "").observeSingleEvent(of: .value, with: { [self] (snapshot2) in
                        if(snapshot2.key == userID){
                            Database.database().reference().child(String(describing: i)).child("AreaFt2").observeSingleEvent(of: .value, with: { [self] (snapshot3) in
                        //add to dictionary
                            let key = snapshot.value as? String ?? ""
                            let plantAreaFt2 = snapshot3.value as? Double ?? 0.0
                            let numNative = snapshot2.value as? Double ?? 0.0
                            let intVal2: [Double] = [plantAreaFt2,numNative]
                    
                                if(numNative != 0.0) {
                                    loaddareaPlantInfo[key] = intVal2
                                    completion(loaddareaPlantInfo)
                                }
                                else{
                                    return
                                }
                        })
                    }
                })
            })
        }
        reachedPercentage()
    }
    
    
    @IBAction func moInvasivesDidClick(_ sender: Any) {
        if let url = URL(string: "https://moinvasives.org/lists/") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func iNaturalistDidClick(_ sender: Any) {
        if let url = URL(string: "https://apps.apple.com/us/app/inaturalist/id421397028") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func mapDidClick(_ sender: Any) {
        if let url = URL(string: "https://map.homegrownnationalpark.org/Account/Register?_gl=1*2nh5a2*_ga*MjEyNjE2NDIyOS4xNjY0ODMyMzY4*_ga_4P3QW1X6L7*MTY2ODYyMjk3NS4xLjEuMTY2ODYyMjk5Mi40My4wLjA.") {
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
