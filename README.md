# Tax Calculator
## OVERVIEW

The TAX CALCULATOR APP is composed of a SWIFT frontend and a Python(FastAPI) backend. The Front end is quite simple as all that is really going on is a simple request to the backend that returns a JSON object that contains the following, 
```json 
{
"remaining": 0.00,  
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

## Budget Screen
![enter image description here](https://i.imgur.com/9QpWuRK.png)![enter image description here](https://i.imgur.com/Udo7aPh.png)
