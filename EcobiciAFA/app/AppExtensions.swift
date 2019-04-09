//
//  AppExtensions.swift
//  EcobiciAFA
//
//  Created by Alberto Farías on 4/5/19.
//  Copyright © 2019 Alberto Farías. All rights reserved.
//

import Foundation
import UIKit


enum AppColors:String {
    case dark = "#3C1B32"
    case accent = "#7A145D"
    case base = "#16DDC1"
    case warning = "#EF1C90"
    case success = "#4EA6E9"
    case info = "#D5E519"
    case mainFont = "#1B3C38"
    case mainFontReverse = "#FFFFFF"
    case fbBtnColor = "#3B5999"
    case bkgdLight = "#D5F9F4"
}

enum AlertType {
    case error
    case success
    case warning
    case info
}


// MARK: String extensions


//Formatea un string como fecha
extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
}

//Formatea un string como fecha
extension String {
    func toDateTime(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: -6)
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
}


extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}




extension UIViewController{
    
    func showAlertMessage(message:String , alertType: AlertType) {
        let defaultAlertTimer = 2
        showAlertMessageWithTimer(message: message, alertType: alertType, timer: defaultAlertTimer)
    }
    
    func showAlertMessageWithTimer(message:String , alertType: AlertType, timer: Int) {
        
        var bgColor = AppColors.info.rawValue
        
        switch alertType {
        case .error:
            bgColor =  AppColors.warning.rawValue
        case .success:
            bgColor = AppColors.success.rawValue
        case .warning:
            bgColor = AppColors.dark.rawValue
        default:
            bgColor = AppColors.info.rawValue
        }
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let alertBoxHeight:CGFloat = 260
        
        
        
        var myNewView:UIView!;
        DispatchQueue.main.async(execute: {()->Void in
            myNewView=UIView(frame: CGRect(x: 0, y: screenSize.maxY, width: screenWidth, height: alertBoxHeight))
            // Change UIView background colour
            myNewView.backgroundColor = UIColor(hex: bgColor, alpha: 0.95);
            myNewView.layer.opacity = 0
            
            let label = UILabel()
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.text = message
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            myNewView.addSubview(label)
            
            label.anchor(top: myNewView.topAnchor, paddingTop: 0, right: nil, paddingRight: 0, bottom: myNewView.bottomAnchor, paddingBottom: 0, left: nil, paddingLeft: 0, height: nil, width: myNewView.bounds.width - 32, centerX: myNewView.centerXAnchor, centerY: myNewView.centerYAnchor)
            
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                myNewView.layer.opacity = 1
                myNewView.frame.origin.y = myNewView.frame.origin.y - alertBoxHeight
            }, completion: nil)
            
            // Add UIView as a Subview
            self.view.addSubview(myNewView)
        });
        
        
        DispatchQueue.main.asyncAfter(deadline: timer.seconds.fromNow) { // change 2 to desired number of seconds
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                myNewView.layer.opacity = 0
                myNewView.frame.origin.y = myNewView.frame.origin.y + alertBoxHeight
            }, completion: { (true) in
                myNewView.removeFromSuperview();
            })
        }
    }
    
    
    func showLoadingScreen(vc: UIViewController, msg: String){
        
        let overlay: UIView = {
            let view = UIView()
            view.tag = 101010;
            view.backgroundColor = UIColor(hex: AppColors.bkgdLight.rawValue, alpha: 0.9)
            return view
        }()
        
        let loadingContainer: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.clipsToBounds = true
            view.layer.cornerRadius = 3
            return view
        }()
        let loader: UIActivityIndicatorView = {
            let activityIndicator = UIActivityIndicatorView(style: .gray)
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = false
            activityIndicator.color = UIColor(hex: AppColors.dark.rawValue)
            return activityIndicator
        }()
        
        let textLbl: UILabel = {
            let lbl = UILabel()
            lbl.text = msg
            lbl.textAlignment = .center
            lbl.tintColor = UIColor(hex: AppColors.mainFont.rawValue)
            lbl.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            return lbl
        }()
        
        DispatchQueue.main.async {
            vc.view.addSubview(overlay)
            if #available(iOS 11.0, *) {
                overlay.anchor(top: vc.view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, right: vc.view.rightAnchor, paddingRight: 0, bottom: vc.view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0, left: vc.view.leftAnchor, paddingLeft: 0, height: nil, width: nil, centerX: nil, centerY: nil)
            } else {
                // Fallback on earlier versions
            }
            overlay.addSubview(loadingContainer)
            loadingContainer.anchor(top: nil, paddingTop: 0, right: nil, paddingRight: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, height: 64, width: 256, centerX: overlay.centerXAnchor, centerY: overlay.centerYAnchor)
            loadingContainer.addSubview(loader)
            loader.center = CGPoint(x: 32, y: 32)
            loadingContainer.addSubview(textLbl)
            textLbl.anchor(top: loadingContainer.topAnchor, paddingTop: 8, right: loadingContainer.rightAnchor, paddingRight: 16, bottom: loadingContainer.bottomAnchor, paddingBottom: 8, left: loadingContainer.leftAnchor, paddingLeft: 48, height: nil, width: nil, centerX: nil, centerY: nil)
        }
        
    }
    
    func removeLoadingScreen(){
        DispatchQueue.main.async(execute: {()->Void in
            guard let myView = self.view.viewWithTag(101010) else { return }
            myView.removeFromSuperview()
        })
    }
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}



extension UIColor {
    convenience init(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    convenience init(hex: String, alpha:Float) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    static func rgb(r: CGFloat,g: CGFloat, b: CGFloat) -> UIColor {
        
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
        
    }
    
    static let dark = { return UIColor(hex: AppColors.dark.rawValue) }()
    static let accent = { return UIColor(hex: AppColors.accent.rawValue) }()
    static let base = { return UIColor(hex: AppColors.base.rawValue) }()
    static let mainFont = { return UIColor(hex: AppColors.mainFont.rawValue) }()
    static let mainFontReverse = { return UIColor(hex: AppColors.mainFontReverse.rawValue) }()
    static let light = { return UIColor(hex: AppColors.bkgdLight.rawValue) }()
    static let success = { return UIColor(hex: AppColors.success.rawValue) }()
    static let info = { return UIColor(hex: AppColors.info.rawValue) }()
    
}



extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, paddingTop: CGFloat,
                right: NSLayoutXAxisAnchor?, paddingRight: CGFloat,
                bottom: NSLayoutYAxisAnchor?, paddingBottom: CGFloat,
                left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat,
                height: CGFloat?,
                width: CGFloat?,
                centerX: NSLayoutXAxisAnchor?,
                centerY: NSLayoutYAxisAnchor?
        ) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: paddingRight * -1).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom * -1).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
}


extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else if secondsAgo < year {
            quotient = secondsAgo / month
            unit = "month"
        } else {
            quotient = secondsAgo / year
            unit = "year"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
    
    func timeAgoDisplayShortHand() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "s"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "m"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "h"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "d"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "w"
        } else if secondsAgo < year {
            quotient = secondsAgo / month
            unit = "m"
        } else {
            quotient = secondsAgo / year
            unit = "y"
        }
        
        return "\(quotient)\(unit)"
        
    }
}


public extension Int {
    
    public var seconds: DispatchTimeInterval {
        return DispatchTimeInterval.seconds(self)
    }
    
    public var second: DispatchTimeInterval {
        return seconds
    }
    
    public var milliseconds: DispatchTimeInterval {
        return DispatchTimeInterval.milliseconds(self)
    }
    
    public var millisecond: DispatchTimeInterval {
        return milliseconds
    }
    
}

public extension DispatchTimeInterval {
    public var fromNow: DispatchTime {
        return DispatchTime.now() + self
    }
}


    



//imagen a un textfield
@IBDesignable
class DesignableUITextField2Gom: UITextField {
    
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0{
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}


