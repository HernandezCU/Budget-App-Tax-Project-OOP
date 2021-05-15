//
//  AssetsDisplayViewController.swift
//  yes?
//
//  Created by Carlos Hernandez on 5/13/21.
//
import UIKit
import Charts

struct Assets: Codable{
    
    var amount_invested: Float
    var return_per_month: Float
    var return_per_year: Float
    
}

class AssetsDisplayViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var return_amnt_lbl: UILabel!
    
    var labels = ["Assets","Asset Returns"]
    var y = [Double(0.0)]
    var piechart = PieChartView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("loading")
        fetchData(from: endpoint)
        print("loaded?")

        // Do any additional setup after loading the view.
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      return colors
        
    }
    
    private func create_chart(){
        
        
        piechart.delegate = self
        piechart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width + 75)
        piechart.center = view.center
        view.addSubview(piechart)
        
        y.remove(at: 0)
        print("Chart Data: \(y)")
        var entries = [ChartDataEntry]()
        for i in 0..<y.count{
            entries.append(PieChartDataEntry(value: y[i], label: labels[i]))
            //entries.append(ChartDataEntry(x: i , y:i))  ,data: labels[i] as AnyObject
        }
        
        let set = PieChartDataSet(entries: entries)
        set.colors = colorsOfCharts(numbersOfColor: y.count)
        let data = PieChartData(dataSet: set)
        piechart.data = data
        
    }
    
    
    private func fetchData(from url: String){
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                print("Something Went Wrong!")
                return
            }
            var result: Assets?
            do{
                result = try JSONDecoder().decode(Assets.self, from: data)
            }
            catch{
                print("Failed to convert \(error)")
            }
            guard let json = result else{
                return
            }
            print(json.amount_invested)
            print(json.return_per_month)
            print(json.return_per_year)
        
            DispatchQueue.main.async {
                
                self.return_amnt_lbl.text = "$\(String(json.return_per_year)) /Yearly"
                self.y.append(Double(json.amount_invested))
                self.y.append(Double(json.return_per_year))
                self.create_chart()

            }
        }).resume()
    }
    
    public func format_number(to_format: Float) -> Double{
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency
        if let formatted_val = formatter.string(from: to_format as NSNumber) {
           print(formatted_val)
        }
        
        return Double(0.0)
    }

}
