//
//  UIViewExtentions.swift
//  Weather (BitCot)
//
//  Created by Ranjith on 08/04/23.
//

import Foundation
import UIKit
extension UIView{
    func dropShadow(color: UIColor = .darkGray , opacity: Float = 0.5, offSet: CGSize = CGSize(width: -1, height: 1), radius: CGFloat = 3, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

      }
    func dropShadowToView(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        //layer.cornerRadius = 5
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    func roundCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    func addBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }

    @IBInspectable var cornerRadius : CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
}

extension Date{
    func toString(format : String) -> String{
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension UIViewController{
    func dateFormatting(GivenFormat: String, requiredFormat: String,SeperatingString: String?,date:String) -> String{
        var convDate = ""
        if SeperatingString != nil{
            convDate = date.components(separatedBy: SeperatingString!).first ?? ""
        }else{
            convDate = date
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = GivenFormat
        guard let date = dateFormatter.date(from: convDate) else{return "-"}
        dateFormatter.dateFormat = requiredFormat
        let resultString = dateFormatter.string(from: date )
        return resultString
    }
    
        func weatherdateformat(timestamps: Int) -> String {
    let timestamp = timestamps // replace with your timestamp
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, dd MMM"
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    let dateString = dateFormatter.string(from: date)
    print(dateString) // output: "Sunday, 02 Oct"
    return dateString
}
    func getImage(forKey key: String) -> UIImage {

        switch key {
        case "clear sky":
            return UIImage(named: "sun")!
        case "few clouds":
            return UIImage(named: "partlycloudyday")!
        case "scattered clouds":
            return UIImage(named: "plaincloud")!
        case "overcast clouds":
            return UIImage(named: "partlyrain")!
        case "light rain":
            return UIImage(named: "heavyrain")!
        case "smoke":
            return UIImage(named: "smoke")!
        default:
            return UIImage(named: "partlycloudyday")!
        }
    }
//case brokenClouds = "broken clouds"
//case clearSky = "clear sky"
//case fewClouds = "few clouds"
//case overcastClouds = "overcast clouds"
//case scatteredClouds = "scattered clouds"
//case smoke = "smoke"


func weatherdateformatatt(timestamps: Int) -> NSAttributedString {
    let timestamp = timestamps // replace with your timestamp
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, dd MMM"
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    let dateString = dateFormatter.string(from: date)
    
    let attributedDateString = NSMutableAttributedString(string: dateString)
    attributedDateString.addAttribute(.foregroundColor, value: UIColor.lightText, range: NSRange(location: dateString.count - 6, length: 6))
    
    return attributedDateString
}

    func dateformatforhour(timestamps: Int) -> NSAttributedString {
        let timestamp = timestamps // replace with your timestamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let timeString = dateFormatter.string(from: date)
        
        let attributedTimeString = NSMutableAttributedString(string: timeString)
        attributedTimeString.addAttribute(.foregroundColor, value: UIColor.lightText, range: NSRange(location: timeString.count, length: 0))
        
        return attributedTimeString
    }



}
extension String {
    var bold: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
    }
    
    func withDegreeSymbol() -> String {
        return self + "\u{00B0}"
    }
}

extension Double {
    func kelvinToCelsius() -> Int {
        let celsius = self - 273.15
        return Int(celsius.rounded())
    }
}




