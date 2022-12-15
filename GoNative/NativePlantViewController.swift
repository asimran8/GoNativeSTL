//
//  NativePlantViewController.swift
//  GoNative
//
//  Created by Simran Ajwani on 10/23/22.
//
//trees --> bushes, forbes, grasses
//trees, bushes or shrubs, all others (forbes, grasses, vines, etc.)
import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import Firebase

extension LosslessStringConvertible {
    var string: String { .init(self) }
}

var addedCellsArray: [Int] = []

class NativePlantViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, NativePlantTableViewCellDelegate, UIScrollViewDelegate, UITableViewDelegate {
    
    var ref: DatabaseReference! = Database.database().reference()
    var detailedValue: String?
    var secondArray: [String] = []
    var treeArray: [String] = []
    var shrubArray: [String] = []
    var otherArray: [String] = []
    var landLengthResults: Int?
    var homeLengthResults: Int?
    var levelsResults: Int?
    var filtersecondArray: [String] = []
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ResultsViewController
        {
            vc.landLengthResults = landLengthResults
            vc.homeLengthResults = homeLengthResults
            vc.levelsResults = levelsResults
            
        }
    }
       
    @IBAction func didClickNaturalist(_ sender: Any) {
        if let url = URL(string: "https://apps.apple.com/us/app/inaturalist/id421397028") {
            UIApplication.shared.open(url)
        }
    }
    
    var tableViewContentOffset = CGPoint()

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < tableViewContentOffset.y {
            scrollView.contentOffset = tableViewContentOffset
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableViewContentOffset = scrollView.contentOffset
    }
    
    func didMinus(for cell: NativePlantTableViewCell){
        let userID = UIDevice.current.identifierForVendor?.uuidString
        for i in 0...335{
            ref.child(String(describing: i)).child("commonName").observeSingleEvent(of: .value, with: { [self] (snapshot) in
                if(cell.nativePlantName.text ?? "" == snapshot.value as! String){
                    self.ref.child(String(describing: i)).child("numberOfPlants").child(userID ?? "").observeSingleEvent(of: .value, with: { [self] (snapshot) in
                        if(snapshot.key == userID){
                            /*
                            let updates = [
                              userID: ServerValue.increment(-1),
                            ] as? [String:Any]
                            Database.database().reference().child(String(describing:i)).child("numberOfPlants").updateChildValues(updates ?? ["":0]);
                            */
                            
                            let updates = [
                                userID: Int(cell.nativePlantStepper.value),
                            ] as? [String:Any]
                            Database.database().reference().child(String(describing:i)).child("numberOfPlants").updateChildValues(updates ?? ["":0]);
          
                        }
                    })
                }
            })
        }
    }

    @IBOutlet weak var buttonNext: UIButton!
    func didAdd(for cell: NativePlantTableViewCell) {
        //guard let indexPath = nativePlantTable?.indexPath(for: cell) else { return }
        let userID = UIDevice.current.identifierForVendor?.uuidString
        for i in 0...335{
            ref.child(String(describing: i)).child("commonName").observeSingleEvent(of: .value, with: { (snapshot) in
                if(cell.nativePlantName.text ?? "" == snapshot.value as! String){
                    self.ref.child(String(describing: i)).child("numberOfPlants").child(userID ?? "").observeSingleEvent(of: .value, with: { [self] (snapshot) in
                        if(snapshot.key == userID){
                            
                            /*
                            let updates = [
                              userID: ServerValue.increment(1),
                            ] as? [String:Any]
                            Database.database().reference().child(String(describing:i)).child("numberOfPlants").updateChildValues(updates ?? ["":0]);
                            */
                            
                            let updates = [
                                userID: Int(cell.nativePlantStepper.value),
                            ] as? [String:Any]
                            Database.database().reference().child(String(describing:i)).child("numberOfPlants").updateChildValues(updates ?? ["":0]);
                                                        

                        }
                    })
                }
            })
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
            view.backgroundColor = UIColor(red: 0.10, green: 0.36, blue: 0.31, alpha: 1.00)
           let lbl = UILabel(frame: CGRect(x: 15, y: -12, width: view.frame.width - 15, height: 50))
            lbl.textColor = UIColor.white
           lbl.font = UIFont.systemFont(ofSize: 14)
            if(section == 0) { lbl.text = "Trees"}
            if(section == 1) { lbl.text = "Shrubs"}
            if(section == 2) { lbl.text = "Others"}
            view.addSubview(lbl)
           return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return self.treeArray.count
        }
        else if(section == 1){
            return self.shrubArray.count
        }
        else {
            return self.otherArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! NativePlantTableViewCell
        cell.delegate = self
        cell.backgroundColor = UIColor.white
        if(indexPath.section == 0) {
            cell.nativePlantName.text = self.treeArray[indexPath.row]
        }
        if(indexPath.section == 1) {
            cell.nativePlantName.text = self.shrubArray[indexPath.row]
        }
        if(indexPath.section == 2) {
            cell.nativePlantName.text = self.otherArray[indexPath.row]
        }
        
        self.nativePlantTable.reloadRows(at: [indexPath],
                                  with: .automatic)
        return cell
    }
    
    @IBOutlet weak var noNativePlantButton: UIButton!
    @IBOutlet weak var yesNativePlantButton: UIButton!

    @IBAction func noNativePlantButtonClicked(_ sender: Any) {
        for i in 0...335{
            ref.child(String(describing: i)).child("numberOfPlants").observeSingleEvent(of: .value, with: { (snapshot) in
                self.ref.child(String(describing: i)).child("numberOfPlants").removeValue()
            })
        }
        
        let alert = UIAlertController(title: "No Natives", message: "Consider adding native plants to calculate their volume and area.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
       
    }
    
    @IBAction func yesNativePlantButtonClicked(_ sender: Any) {
        nativePlantTable.alpha = 1
        buttonNext.alpha = 1
        noNativePlantButton.isEnabled = false
        yesNativePlantButton.isEnabled = false
        noNativePlantButton.backgroundColor = UIColor.lightGray
        yesNativePlantButton.backgroundColor = UIColor.lightGray
        noNativePlantButton.layer.cornerRadius = 0.5
        yesNativePlantButton.layer.cornerRadius = 0.5

        for i in 0...335{
            ref.child(String(describing: i)).child("numberOfPlants").observeSingleEvent(of: .value, with: { (snapshot) in
                self.ref.child(String(describing: i)).child("numberOfPlants").removeValue()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nativePlantTable.delegate = self
        nativePlantTable.dataSource = self
        nativePlantTable.backgroundColor = UIColor.white
        let nib = UINib(nibName:"NativePlantTableViewCell", bundle: nil)
        nativePlantTable.register(nib, forCellReuseIdentifier: "customcell")
        secondArray.sort()
        LoadCalls()
        secondArray.sort()
        nativePlantTable.alpha = 0
        buttonNext.alpha = 0
            // Do any additional setup after loading the view.
    }
    
    var filter = [String]()
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtersecondArray = secondArray.filter{
            plant in
                let searchTextMatch = plant.lowercased().contains(searchText.lowercased())
                return searchTextMatch
        }
        self.filter.sort()
        nativePlantTable.reloadData()
    }
    
    @IBOutlet weak var nativePlantTable: UITableView!
    
    var indexTreeArray: [Int] = []
    var indexShrubArray: [Int] = []
    var indexOtherArray: [Int] = []

    func LoadCalls(){
        ref = Database.database().reference()
        
        for i in 0...335{

            ref.child(String(describing: i)).observeSingleEvent(of: .value, with: { snapshot in

                if(snapshot.childSnapshot(forPath: "plantType").value as! String == "Trees"){
                    self.treeArray.append(snapshot.childSnapshot(forPath: "commonName").value as! String)
                }
                if(snapshot.childSnapshot(forPath: "plantType").value as! String == "Shrubs"){
                    self.shrubArray.append(snapshot.childSnapshot(forPath: "commonName").value as! String)
                }
                if(snapshot.childSnapshot(forPath: "plantType").value as! String == "Others"){
                    self.otherArray.append(snapshot.childSnapshot(forPath: "commonName").value as! String)
                }

                self.treeArray.sort()
                self.shrubArray.sort()
                self.otherArray.sort()

               self.nativePlantTable.reloadData()
            })
            
            self.nativePlantTable.reloadData()

            for index in self.indexShrubArray{
                ref.child(String(describing: index)).child("plantType").observeSingleEvent(of: .value, with: { [self] (snapshot3) in
                    self.shrubArray.append(snapshot3.value as! String)
                })
            }
            for index in self.indexOtherArray{
                ref.child(String(describing: index)).child("plantType").observeSingleEvent(of: .value, with: { [self] (snapshot3) in
                    self.otherArray.append(snapshot3.value as! String)
                })

            }
    }
        func setIndex(value: String) {
            loadData(index: value)
        }

        func loadData(index: String) {
            ref = Database.database().reference()
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
}
