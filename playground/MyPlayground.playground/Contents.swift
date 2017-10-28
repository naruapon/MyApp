//: Playground - noun: a place where people can play

import UIKit

//String and Concatination
var str = "Hello, playground"

let label = "The width is "
let width = 94
let widthLabel = label + String(width)

//Show variable in String
let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples."
let fruitSummary = "I have \(apples+oranges) pieces of fruit."


//Array of String
var shoppingList = ["catfish", "water", "tulips", "blue plant"]
shoppingList[1] = "bottle of water"

//Creating Class with attribute 
//new Object from Class

class Resolution{
    var width = 0
    var height = 0
}

let someResolution = Resolution()
someResolution.width = 10    
print(someResolution.width)

//Example of Function

func Hello(){
    print("Hello")
}

Hello()

//Function with Parameter
func greet(name: String, day: String) -> String{
    return "Hello \(name), today is \(day)"
}

greet(name: "Bob", day: "Monday")
