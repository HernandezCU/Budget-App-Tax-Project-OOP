# Tax Calculator
## OVERVIEW

The TAX CALCULATOR APP is composed of a SWIFT frontend and a Python(FastAPI) backend. The Front end is quite simple as all that is really going on is a simple request to the backend that returns a JSON object that contains the following, 
```json 
{
"remaining": 1000,  
"tax": 0.15,  
"state": "Arkansas"
}	
```
From there we create a struct and then decode the JSON object into a struct so we can interpret it in the Swift Language. 
```swift
struct Reply: Codable {
let remaining: Float
let tax: Float
let state: String
}
```
From there we use an async function to update the text fields once we receive a reply from the API and once we decode the JSON object. 
```swift
DispatchQueue.main.async{
self.remaining_income.text = "Remaining: \(String(json.remaining))"
self.tax_amount.text = "Tax Amount: \(String(json.tax))"
self.state_label.text = "State: \(json.state)"
}
```
These are the main components of the Swift frontend in relation to the Python(FastAPI) backend.

# Screens
## Home Screen (Main Screen)

![enter image description here](https://i.imgur.com/uAislWe.png)
The purpose of the main screen is to collect essential user data to send to the API. This screen collects the state that the user resides in as well as their monthly income. This ViewController validates the data that is inputted via a series of logic statements. 
```swift
@IBAction func calc(_ sender: Any) {

if (monthly_income_field.text  ==  ""  &&  state_field.text  ==  "") || (state_field.text  ==  ""){
	create_alert(NewTitle: "Error", msg: "Income and State cannot be empty!")
}
else if monthly_income_field.text?.isInt  == true{
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
```
This logic handles all of the user input and makes sure that we are sending the correct type of data to the API to ensure that we get the desired response
## Budget Screen
![enter image description here](https://i.imgur.com/9QpWuRK.png)![enter image description here](https://i.imgur.com/Udo7aPh.png)
The Budget Creation screen is the first thing the user sees after inputting his State and Income Data into the previous ViewController. Here the user sees the response that the API sent back, the user can view how much money they have left after allocating the correct amount for taxes as well as the state they inputted. 
The following code is responsible for decoding and formatting the JSON reply object that the API sent back:
```swift 
private func fetchData(from url: String){

URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in

	guard let data = data, error == nil 
	else {
		print("Something Went Wrong! Or URL is invalid!") 
		return
	}
	
var result: Reply?
do{
	result = try JSONDecoder().decode(Reply.self, from: data)
}
catch{
	print("Failed to convert \(error)") //prints the localized description of the error
}

guard let json = result 
else{
	return //simply quits the task if an error occurs while trying to copy the values from the JSON object
}

total = json.remaining

DispatchQueue.main.async {
	self.remaining_income.text = "Remaining: \(String(json.remaining))"
	self.tax_amount.text = "Tax Amount: \(String(json.tax))"
	self.state_label.text = "State: \(json.state)"
}
}).resume() //.resume() sends the request, Yes swift is wierd but REACT is worse
}
```

## Chart Screen
![enter image description here](https://i.imgur.com/gLhFw5j.png)
The Chart view allows the user to have a visual representation of the budget they created. This chart was created using the [Charts Library](https://github.com/danielgindi/Charts) for Swift. This library allows us to create a great visual for user. This visual contains all the information that they added into the Budget Creation Section of the app and displays it. There is some simple logic involved in creating the chart as we want to avoid any entry that is 0 because if we don't the chart will appear squished. 
The logic to create the charts is straightforward and contains tons of that Swift magic we all know and love.
```swift
let  labels = ["Mortgage", "Car Payment", "401K", "Clothes", "Food", "Gas", "Emergency Fund",
 "Investments", "Travel", "Gifts", "Entertainment", "Miscellanous"]

var x = chart_data
var y = [Double(0.0)]
var pieChart = PieChartView()

override func viewDidLoad() {
super.viewDidLoad()
pieChart.delegate = self
pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, 
									height: self.view.frame.size.width + 75)
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
}

let set = PieChartDataSet(entries: entries)
set.colors = colorsOfCharts(numbersOfColor: y.count)
let data = PieChartData(dataSet: set)
pieChart.data = data

}

private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {

var colors: [UIColor] = []

for _ in 0..<numbersOfColor {

	let red = Double(arc4random_uniform(256))
	let green = Double(arc4random_uniform(256))
	let blue = Double(arc4random_uniform(256))
	let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), 
						blue: CGFloat(blue/255), alpha: 1)
	colors.append(color)
}

return colors

}
```
The`colorsOfCharts()`function is responsible for creating random colors whenever it is called. This ensures that each element of the Pie Chart is a different color so there is no confusion while reading the chart. 


