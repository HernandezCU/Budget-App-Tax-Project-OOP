//
//  DataViewController.swift
//  yes?
//
//  Created by Carlos Hernandez on 4/27/21.
//

import UIKit

var api_reply: String?

struct Reply: Codable {
    let remaining: Float
    let tax: Float
    let state: String
}

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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //http://127.0.0.1:8000
        var address = ""
        var address2 = ""
        if (ip == ""){
            address = "http://192.168.0.2:8000/tax/calculate?state="
            address2 = "&income="
        }
        else{
            address = "http://\(ip):8000/tax/calculate?state="
            address2 = "&income="
            print("updated url")
        }
        

        
        
        let f_addy = address+String(state)+address2+String(income)
        style_ui()
        fetchData(from: f_addy)
        
        
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
    
    private func fetchData(from url: String){
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                print("Something Went Wrong!")
                return
            }
            var result: Reply?
            do{
                result = try JSONDecoder().decode(Reply.self, from: data)
            }
            catch{
                print("Failed to convert \(error)")
            }
            guard let json = result else{
                return
            }
            print(json.remaining)
            print(json.tax)
            print(json.state)
            total = json.remaining
            
            print("total \(total)")
            DispatchQueue.main.async {
                self.remaining_income.text = "Remaining: \(String(json.remaining))"
                self.tax_amount.text = "Tax Amount: \(String(json.tax))"
                self.state_label.text = "State: \(json.state)"

                
            }
            
        }).resume()
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
        var new_total = total
        var txt_fields = [mortgage_field, car_payment_field, k401_field, clothes_field, food_field,
                          gas_field, emergency_fund_field, investments_field, travel_field,
                          gifts_field, entertainment_field, misc_field]
        var to_sub = [Float(0.0)]
        for x in txt_fields {
            if (x?.text?.isFloat == true){
                to_sub.append(Float((x?.text)!)!)
                print(to_sub)
            }
            else{
                create_alert(NewTitle: "Error", msg: "\(String(describing: x?.text)) is not a Float, Please enter a Float!")
            }
        }
        var t = Float(0.0)
        for i in to_sub {
            t += i
        }
        
        create_alert(NewTitle: "Total", msg: "Total: \(t) \n Remaining: \(new_total-t)")
        
        
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


