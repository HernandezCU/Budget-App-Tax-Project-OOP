//
//  DataViewController.swift
//  yes?
//
//  Created by Carlos Hernandez on 4/27/21.
//

import UIKit


class DataViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var remaining_income: UILabel!
    @IBOutlet weak var tax_amount: UILabel!
    @IBOutlet weak var state_label: UILabel!
    @IBOutlet weak var update_budget: UIButton!
    @IBOutlet weak var chart_btn: UIButton!
    
    //TEXT FIELDS
    @IBOutlet weak var mortgage_field: UITextField!
    @IBOutlet weak var car_payment_field: UITextField!
    @IBOutlet weak var k401_field: UITextField!
    @IBOutlet weak var clothes_field: UITextField!
    @IBOutlet weak var food_field: UITextField!
    @IBOutlet weak var gas_field: UITextField!
    @IBOutlet weak var emergency_fund_field: UITextField!
    @IBOutlet weak var investments_field: UITextField!
    @IBOutlet weak var travel_field: UITextField!
    @IBOutlet weak var gifts_field: UITextField!
    @IBOutlet weak var entertainment_field: UITextField!
    @IBOutlet weak var misc_field: UITextField!
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        let txt_fields = [self.mortgage_field, self.car_payment_field, self.k401_field, self.clothes_field, self.food_field, self.gas_field, self.emergency_fund_field, self.investments_field, self.travel_field, self.gifts_field, self.entertainment_field, self.misc_field]
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
               
           // 2
           let Fill_Fields = UIAlertAction(title: "Fill Fields", style: .default)
            {_ in
            
            for i in txt_fields{
                let number = Int.random(in: 100...500)
                i?.text = String(number)
            }
            self.gifts_field.text = "0"
            self.k401_field.text = "0"

            print("Filled")
           }
           let Clear_Fields = UIAlertAction(title: "Clear Fields", style: .default)
           {_ in
            for i in txt_fields{
                i?.text = ""
            }
           print("Cleared")
          }
               
           // 3
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
           {_ in
           print("Cancelled")
          }
               
           // 4
           optionMenu.addAction(Fill_Fields)
           optionMenu.addAction(Clear_Fields)
           optionMenu.addAction(cancelAction)
               
           // 5
           self.present(optionMenu, animated: true, completion: nil)
        
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        chart_btn.isEnabled = false
        chart_btn.isHidden = true
        remaining_income.text = "Left Over: $\(String(rt))"
        tax_amount.text = "Tax Amount: $\(String(tx))"
        state_label.text = "State: \(st)"
        
        style_ui()
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.keyboarddismiss))
                    view.addGestureRecognizer(tap)
        mortgage_field.delegate = self
        car_payment_field.delegate = self
        k401_field.delegate = self
        clothes_field.delegate = self
        food_field.delegate = self
        gas_field.delegate = self
        emergency_fund_field.delegate = self
        investments_field.delegate = self
        travel_field.delegate = self
        gifts_field.delegate = self
        entertainment_field.delegate = self
        misc_field.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mortgage_field.resignFirstResponder()
        car_payment_field.resignFirstResponder()
        k401_field.resignFirstResponder()
        clothes_field.resignFirstResponder()
        food_field.resignFirstResponder()
        gas_field.resignFirstResponder()
        emergency_fund_field.resignFirstResponder()
        investments_field.resignFirstResponder()
        travel_field.resignFirstResponder()
        gifts_field.resignFirstResponder()
        entertainment_field.resignFirstResponder()
        misc_field.resignFirstResponder()
        
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
    
    
    
    func style_ui(){
        Utilities.styleFilledButton(update_budget)
        Utilities.styleFilledButton(chart_btn)
        Utilities.styleTextField(mortgage_field)
        Utilities.styleTextField(car_payment_field)
        Utilities.styleTextField(k401_field)
        Utilities.styleTextField(clothes_field)
        Utilities.styleTextField(food_field)
        Utilities.styleTextField(gas_field)
        Utilities.styleTextField(emergency_fund_field)
        Utilities.styleTextField(investments_field)
        Utilities.styleTextField(travel_field)
        Utilities.styleTextField(gifts_field)
        Utilities.styleTextField(entertainment_field)
        Utilities.styleTextField(misc_field)
    }
    
    
    @IBAction func update_chart(_ sender: Any) {
        let new_total = total
        let txt_fields = [mortgage_field, car_payment_field, k401_field, clothes_field, food_field, gas_field, emergency_fund_field, investments_field, travel_field, gifts_field, entertainment_field, misc_field]
        var to_sub = [Float(0.0)]
        var count = 0
        for x in txt_fields {
           
            if (x?.text?.isFloat == true){
                count += 1
                to_sub.append(Float((x?.text)!)!)
                //print(to_sub)
            }
            else{
                create_alert(NewTitle: "Error", msg: "\(String(describing: x?.text)) is not a Float, Please enter a Float!")
            }
        }
        var t = Float(0.0)
        for i in to_sub {
            t += i
        }
        to_sub.remove(at: 0)
        
        chart_data = to_sub
        
        if count == txt_fields.count{
            chart_btn.isEnabled = true
            chart_btn.isHidden = false
            print("enabled")
        }
        create_alert(NewTitle: "Total", msg: "Total: \(t) \n Remaining: \(new_total-t)")
        
        
    }
    
    @IBAction func show_chart(_ sender: Any) {
        let txt_fields = [mortgage_field, car_payment_field, k401_field, clothes_field, food_field, gas_field, emergency_fund_field, investments_field, travel_field, gifts_field, entertainment_field, misc_field]
       
        for i in txt_fields{
         
            if (i?.text == ""){
                create_alert(NewTitle: "Data Error", msg: "Fields cannot be empty!")
            }
            if (i?.text?.isFloat == false){
                create_alert(NewTitle: "Data Error", msg: "\((i?.text)!) is not a valid data type. Please enter and Int or a Float!")
            }
            
            
        }
        performSegue(withIdentifier: "chart", sender: nil)
        print("Done?")
    }
    
    
    func create_alert(NewTitle: String, msg: String){
        let alert = UIAlertController(title: NewTitle, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    
    }

}
extension String {
    var isFloat: Bool {
        return Float(self) != nil
    }
}


