//: Playground - noun: a place where people can play


import UIKit
import PlaygroundSupport

let view: UIView = UIView(frame : CGRect(x:0, y:0, width:375, height:667))
let coloredSquare: UIView = UIView(frame : CGRect(x:20,y:100,width:50,height:50))
coloredSquare.backgroundColor = .blue

coloredSquare.alpha = 0.5
coloredSquare.tag = 100
coloredSquare.isUserInteractionEnabled = true

view.backgroundColor = .white
view.addSubview(coloredSquare)


UIView.animate(withDuration: 1.0, delay: 0.0, options:[.repeat, .autoreverse, .curveEaseInOut], animations:{
    coloredSquare.backgroundColor = .red
    coloredSquare.frame = CGRect(x:350-50, y:100, width:50, height:50)
}, completion: nil)


let lbl = UILabel(frame: CGRect(x:150, y:400, width:100, height:50))
lbl.text = "Animate"
view.addSubview(lbl)


// uncomment to play
//PlaygroundPage.current.liveView = view
