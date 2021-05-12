//
//  ChartViewController.swift
//  yes?
//
//  Created by Carlos Hernandez on 5/10/21.
//

import UIKit
import Charts

class ChartViewController: UIViewController, ChartViewDelegate {

    let labels = ["Mortgage", "Car Payment", "401K", "Clothes", "Food", "Gas", "Emergency Fund", "Investments", "Travel", "Gifts", "Entertainment", "Miscellanous"]
        
    var x = chart_data
    var y = [Double(0.0)]
    
    var pieChart = PieChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width + 75)
        pieChart.center = view.center
        view.addSubview(pieChart)
        for i in x {
            if i != Float(0.0){
                y.append(Double(i))
            }
        }
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
