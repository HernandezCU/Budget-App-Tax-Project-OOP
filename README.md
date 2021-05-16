

# Tax Calculator
## OVERVIEW

The TAX CALCULATOR APP is composed of a SWIFT frontend and a Python(FastAPI) backend. The Front end is quite simple as all that is going on is a simple request to the backend that returns a JSON object that contains the following, 
```json 
{
"remaining": 1000,  
"tax": 0.15,  
"state": "Arkansas"
}	
```
```json
{
"amount_invested": 1200.00,
"return_per_month": 12.00,
"return_per_year": 120.00
```
From there we create a struct and then decode the JSON object into a struct so we can interpret it in the Swift Language. 
```swift
struct Reply: Codable {
	let remaining: Float
	let tax: Float
	let state: String
}
```
```swift
struct Assets: Codable{
	var amount_invested: Float
	var return_per_month: Float
	var return_per_year: Float
}
```
From there we use an async function to update the text fields once we receive a reply from the API and once we decode the JSON object. 
- Tax Calculation
```swift
DispatchQueue.main.async{
	self.remaining_income.text = "Remaining: \(String(json.remaining))"
	self.tax_amount.text = "Tax Amount: \(String(json.tax))"
	self.state_label.text = "State: \(json.state)"
}
```
- Assets Calculation
```swift
DispatchQueue.main.async {
	self.return_amnt_lbl.text = "$\(String(json.return_per_year)) /Yearly"
}
```
These are the main components of the Swift frontend in relation to the Python(FastAPI) backend.
# App Logo
![enter image description here](https://i.imgur.com/urovqoO.png)
# Screens
## Loading Screen (Splash Screen)
This Screen is mainly used to give the user something to view while the app is loading. This Screen didn't require any coding and was created with simple UI elements such as a label and two ImageViews. 

![enter image description here](https://i.imgur.com/Q2vWenX.png)


## Home Screen (Welcome Screen)

   ![enter image description here](https://i.imgur.com/KZlJfpF.png)
   
The purpose of the main screen is to collect essential user data to send to the API. This screen manages the state that the user resides in as well as their monthly income. This ViewController validates the data that is inputted via a series of logic statements.  The following @IBAction is triggered once the `Calculate Taxes` button is clicked. 
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
This logic handles all user input and makes sure that we are sending the correct type of data to the API to ensure that we get the desired response.
## HUB Screen (Main Menu)
![enter image description here](https://i.imgur.com/gHMzNfv.png)

The Budget Creation screen is the first thing the user sees after inputting his State and Income Data into the previous ViewController. Here the user visits the response that the API sent back; the user can view how much money they have left after allocating the correct amount for taxes and the state they inputted. 
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

## Asset Returns Calculation
![enter image description here](https://i.imgur.com/k1Q7np0.png)

The Asset Returns Calculation screen is a simple screen containing a textfield, a label, and a button. This screen simply takes in the users estimated assets (inputted by the user) and displays a simple chart that gives the user a simple way to view the estimated returns that their assets will yield each year. 

## Budget
![enter image description here](https://i.imgur.com/ZXhlfv9.png)![enter image description here](https://i.imgur.com/KwZstja.png)

The Budget creation tool is a great resource for our users as it allows them to allocate their money after taxes and then see a chart that allows them grasp the magnitude of their spending and how that affects them in certain aspects of their lives. 
The budget creation tool allows the users to create their own budgets which they can utilize to change their spending habits and make better financial decisions.

## Chart Screens
![enter image description here](https://i.imgur.com/heKWZnZ.png)![enter image description here](https://i.imgur.com/AMXcQmJ.png)![enter image description here](https://i.imgur.com/xDQidP9.png)

The Chart view allows the user to have a visual representation of the budget they created. This chart was created using the [Charts Library](https://github.com/danielgindi/Charts) for Swift. This library allows us to create a great visual for the user. This graphic contains all the information they added into the Budget Creation Section of the app and displays it. There is some simple logic involved in creating the chart as we want to avoid any entry that is 0 because if we don't, the graph will appear squished. 
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
The`colorsOfCharts()` function is responsible for creating random colors whenever it is called. This ensures that each Pie Chart element is different, so there is no confusion while reading the chart. 

These Chart Screen are a great way for the User to visualize the data. For example the first screenshot allows the user to view how much taxes they are paying in relation to their income. This chart was created to allow people to visualize how much they are paying and if Tax Evasion is the thing for them (For legal reasons that's a joke). 
 
 The second  screenshot allows the user to see how well their investments are paying off. This chart gives the user an estimate by utilizing the average ROI from the US. This allows the user to comprehend their data a lot better. 

The third screenshot is the one to which the code is referring to.  This chart allows the user to see the data they input into the budget creation tool and allows them to maybe think twice about how they are spending their money. Typically they spend too much on entertainment or miscellaneous expenses. 
# Conclusion
In conclusion, this app has several moving parts that need to work in unison to yield the desired results. This final project was fun to create as I had not worked with SWIFT in over a year. Working with swift has many challenges, but once you become familiar with them, it almost becomes second nature to detect them before they happen. For example, we always have to remember to force unwrap values from variables. This is very important because if we don't, the application will freeze and throw an exception. We also have to remember to add constraints to all of our UI elements because if we fail to do so, we will most likely have several UI elements all over the place. Overall this entire experience was great as I had never used swift to make API requests and get data, format it, and then display it. It was an entirely new experience, and I will experiment with it a lot more because the possibilities of this are endless.
