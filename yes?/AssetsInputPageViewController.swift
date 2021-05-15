//
//  AssetsInputPageViewController.swift
//  yes?
//
//  Created by Carlos Hernandez on 5/14/21.
//

import UIKit

class AssetsInputPageViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var asset_field: UITextField!{
        didSet {
            let redPlaceholderText = NSAttributedString(string: "Enter Number Here",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            asset_field.attributedPlaceholder = redPlaceholderText
        }
    }
    @IBOutlet weak var btn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.styleFilledButton(btn)
        Utilities.styleTextField(asset_field)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.keyboarddismiss))
                    view.addGestureRecognizer(tap)
        asset_field.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        asset_field.resignFirstResponder()
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
    
    
    
    @IBAction func validate_data(_ sender: Any) {
        
        if asset_field.text?.isEmpty == true{
            create_alert(NewTitle: "Data Error!", msg: "The field cannot be empty!")
        }
        if (asset_field.text?.isFloat == true){
            let address = "http://\(ip):8000/tax/calculate_asset?invested=\(asset_field.text!)"
           
            print("updated url: \(address)")
            
            
            endpoint = address
            
            performSegue(withIdentifier: "show_assets", sender: nil)
            
        }
        
        
        
    }
    
    
    func create_alert(NewTitle: String, msg: String){
        let alert = UIAlertController(title: NewTitle, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    
    }

}
