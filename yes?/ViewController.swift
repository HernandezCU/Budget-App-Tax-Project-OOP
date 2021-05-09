//
//  ViewController.swift
//  yes?
//
//  Created by Carlos Hernandez on 3/5/21.
//

import UIKit

public var income = 0
public var state = "empty"
public var ip = ""

class ViewController: UIViewController, UITextFieldDelegate{
    var states = ["ALABAMA", "ALASKA", "ARIZONA", "ARKANSAS", "CALIFORNIA", "COLORADO", "CONNECTICUT", "DELAWARE", "FLORIDA", "GEORGIA", "HAWAII", "IDAHO", "ILLINOIS", "INDIANA", "IOWA","KANSAS", "KENTUCKY", "LOUISIANA", "MAINE", "MARYLAND", "MASSACHUSETTS", "MICHIGAN", "MINNESOTA", "MISSISSIPPI", "MISSOURI", "MONTANA", "NEBRASKA", "NEVADA","NEW HAMPSHIRE","NEW JERSEY", "NEW MEXICO", "NEW YORK", "NORTH CAROLINA", "NORTH DAKOTA", "OHIO", "OKLAHOMA", "OREGON", "PENNSYLVANIA", "RHODE ISLAND", "SOUTH CAROLINA", "SOUTH DAKOTA", "TENNESSEE", "TEXAS", "UTAH", "VERMONT", "VIRGINIA", "WASHINGTON", "WEST VIRGINIA", "WISCONSIN", "WYOMING"]
    
    var states_abb = ["AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA",
                      "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH",
                      "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX",
                      "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    
    
    @IBOutlet weak var hdn_btn: UIButton!
    @IBOutlet weak var Calculate_btn: UIButton!
    @IBOutlet weak var monthly_income_field: UITextField!{
        didSet {
            let redPlaceholderText = NSAttributedString(string: "Monthly Income",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            monthly_income_field.attributedPlaceholder = redPlaceholderText
        }
    }
    
    @IBOutlet weak var state_field: UITextField!{
        didSet {
            let redPlaceholderText = NSAttributedString(string: "State",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            state_field.attributedPlaceholder = redPlaceholderText
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.styleTextField(monthly_income_field)
        Utilities.styleTextField(state_field)
        Utilities.styleFilledButton(Calculate_btn)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.keyboarddismiss))
                    view.addGestureRecognizer(tap)
                    monthly_income_field.delegate = self
                    state_field.delegate = self
        
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        monthly_income_field.resignFirstResponder()
        state_field.resignFirstResponder()
               return true
           }
           @objc func keyboarddismiss() {
                  view.endEditing(true)
           }
    
    func animateTextField(textField: UITextField, up: Bool)
        {
            let movementDistance:CGFloat = -150
            let movementDuration: Double = 0.3

            var movement:CGFloat = 0
            if up
            {
                movement = movementDistance
            }
            else
            {
                movement = -movementDistance
            }
            UIView.beginAnimations("animateTextField", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(movementDuration)
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
            UIView.commitAnimations()
        } //Compatability Check on iPhone 11 Pro, Check smaller phones next
        func textFieldDidBeginEditing(_ textField: UITextField)
        {
            self.animateTextField(textField: textField, up:true)
        }

        func textFieldDidEndEditing(_ textField: UITextField)
        {
            self.animateTextField(textField: textField, up:false)
        }
    
    
    func create_alert(NewTitle: String, msg: String){
        let alert = UIAlertController(title: NewTitle, message: msg, preferredStyle: UIAlertController.Style.alert)

                              // add an action (button)
                              alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                              

                              // show the alert
                              self.present(alert, animated: true, completion: nil)
    
    
    }
    
    @IBAction func calc(_ sender: Any) {
        
        if (monthly_income_field.text == "" && state_field.text == "") || (state_field.text == ""){
            create_alert(NewTitle: "Error", msg: "Income and State cannot be empty!")
        }
        else if monthly_income_field.text?.isInt == true{
            if (states.contains((state_field.text?.uppercased())!)) || (states_abb.contains((state_field.text?.uppercased())!)) == true {
                
                income = Int(monthly_income_field.text!)!
                state = String(state_field.text!)
            }
            else{
                create_alert(NewTitle: "Incorrect Data", msg: "Please enter a valid state abbreviation or spell out the state!")
            }
        }
        else{
            create_alert(NewTitle: "Error", msg: "Enter a number in the Income Field!")
            
        }
    
        
    }
    
    
    @IBAction func update_ip(_ sender: Any) {
        ip = (monthly_income_field.text)!
        print(ip)
    }
    

}
extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

