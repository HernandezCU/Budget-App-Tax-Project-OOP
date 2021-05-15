//
//  TaxChartViewController.swift
//  yes?
//
//  Created by Carlos Hernandez on 5/12/21.
//

import UIKit
import Charts

class TaxChartViewController: UIViewController, ChartViewDelegate {

    
    @IBOutlet weak var state_lbl: UILabel!
    
    let labels = ["Remaining Income", "Tax Amount"]
        
    var x = [Double(rt), Double(tx)]
    var pieChart = PieChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        state_lbl.text = String(st)
        
        pieChart.delegate = self
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width + 75)
        pieChart.center = view.center
        view.addSubview(pieChart)
        
        print("Chart Data: \(x)")
        var entries = [ChartDataEntry]()
        for i in 0..<x.count{
            entries.append(PieChartDataEntry(value: x[i], label: labels[i]))
            //entries.append(ChartDataEntry(x: i , y:i))  ,data: labels[i] as AnyObject
        }
        
        let set = PieChartDataSet(entries: entries)
        set.colors = colorsOfCharts(numbersOfColor: x.count)
        let data = PieChartData(dataSet: set)
        pieChart.data = data
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
    

}
