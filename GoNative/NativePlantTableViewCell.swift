//
//  NativePlantTableViewCell.swift
//  GoNative
//
//  Created by Simran Ajwani on 10/24/22.
//

import UIKit
import FirebaseDatabase
import Firebase

protocol NativePlantTableViewCellDelegate {
    func didAdd(for cell: NativePlantTableViewCell)
    func didMinus(for cell: NativePlantTableViewCell)
}

class NativePlantTableViewCell: UITableViewCell {
    var ref:DatabaseReference!

    @IBOutlet weak var nativePlantName: UILabel!
    @IBOutlet weak var nativePlantNumber: UILabel!
    @IBOutlet weak var nativePlantStepper: UIStepper!
   // var oldValue: Int = 0
    var delegate: NativePlantTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        //nativePlantNumber.text = String(Int(nativePlantStepper.value))
        // Initialization code
        //oldValue = Int(nativePlantStepper.minimumValue)
    }

   // @IBAction func stepperPressed(sender: UIStepper) {
//        if (sender as AnyObject).value == 1.0{
//                //positive side was pressed
//            print("stepper increased")
//        }else if (sender as AnyObject).value == -1.0{
//                //negative side was pressed
//            print("stepper decreased")
//        }
//        (sender as AnyObject).value = 0
//
       // self.nativePlantNumber.text = Int(sender.value).description

       //  }
    
    var previousValue = 0
    @IBAction func stepperPressed2(_ sender: UIStepper) {
        //self.nativePlantNumber.text = Int(sender.value).description
        print("STEPPER PRESSED")
        //if(Int(sender.value) == 1){
            //handleAdd()
        //}
        //else if(Int(sender.value) == -1){
            
        //}
        //Int(sender.value) == 0
        
        if Int(nativePlantStepper.value) > previousValue {
            handleAdd()
            print("IN HANDLE ADD")
            print(nativePlantStepper.value)
            //nativePlantNumber.text = String(Int(nativePlantStepper.value))
            //sender.maximumValue = Double(sender.maximumValue) + Double(1)
        } else {
                        //sender.maximumValue = sender.maximumValue + 1
            print("PRESSED MINUS")
            handleMinus()
            }
        previousValue = Int(nativePlantStepper.value)
        nativePlantNumber.text = String(Int(nativePlantStepper.value))
        }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nativePlantNumber.text = String(0)
        //self.nativePlantNumber.isHighlighted = false
    }
    
    @objc func handleAdd() {
        delegate?.didAdd(for: self)
        //performLikeAnimation()
    }
    
    @objc func handleMinus() {
        delegate?.didMinus(for: self)
        //performLikeAnimation()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
    

