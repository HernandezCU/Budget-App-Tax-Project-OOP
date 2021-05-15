//
//  MainViewController.swift
//  yes?
//
//  Created by Carlos Hernandez on 5/12/21.
//

import UIKit


var api_reply: String?
public var chart_data = [Float(0.0)]
struct Reply: Codable {
    let remaining: Float
    let tax: Float
    let state: String
}

public var rt = Float(0.0)
public var tx = Float(0.0)
public var st = ""
class MainViewController: UIViewController {

    
    @IBOutlet weak var assets_btn: UIButton!
    @IBOutlet weak var create_budget_btn: UIButton!
    @IBOutlet weak var view_chart_btn: UIButton!
    
    
    
    
    @IBOutlet weak var tax_amount_lbl: UILabel!
    @IBOutlet weak var remaining_lbl: UILabel!
    @IBOutlet weak var state_lbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //http://127.0.0.1:8000
        let address = "http://\(ip):8000/tax/calculate?state="
        let address2 = "&income="
        print("updated url: \(address + address2)")
        
        
        let f_addy = address+String(state)+address2+String(income)
        style_ui()
        fetchData(from: f_addy)
        
        // Do any additional setup after loading the view.
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
            rt = json.remaining
            print(json.tax)
            tx = json.tax
            print(json.state)
            st = json.state
            
            total = json.remaining
            
            print("total \(total)")
            DispatchQueue.main.async {
                self.remaining_lbl.text = "$\(String(json.remaining))"
                self.tax_amount_lbl.text = "$\(String(json.tax))"
                self.state_lbl.text = "\(json.state)"

            }
        }).resume()
    }
    
    func style_ui(){
        
        Utilities.styleFilledButton(assets_btn)
        Utilities.styleFilledButton(create_budget_btn)
        Utilities.styleFilledButton(view_chart_btn)
    }
    
    
}
