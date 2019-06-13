//
//  Extensions.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 04/09/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

public extension UIImageView {
    
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                        else
                        {
                            self.image = placeHolder
                        }
                    }
                }
            }).resume()
        }
    }
}
public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
                switch identifier {
                case "iPod5,1":                                 return "iPod Touch 5"
                case "iPod7,1":                                 return "iPod Touch 6"
                case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
                case "iPhone4,1":                               return "iPhone 4s"
                case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
                case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
                case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
                case "iPhone7,2":                               return "iPhone 6"
                case "iPhone7,1":                               return "iPhone 6 Plus"
                case "iPhone8,1":                               return "iPhone 6s"
                case "iPhone8,2":                               return "iPhone 6s Plus"
                case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
                case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
                case "iPhone8,4":                               return "iPhone SE"
                case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
                case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
                case "iPhone10,3", "iPhone10,6":                return "iPhone X"
                case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
                case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
                case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
                case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
                case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
                case "iPad6,11", "iPad6,12":                    return "iPad 5"
                case "iPad7,5", "iPad7,6":                      return "iPad 6"
                case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
                case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
                case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
                case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
                case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
                case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
                case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
                case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
                case "AppleTV5,3":                              return "Apple TV"
                case "AppleTV6,2":                              return "Apple TV 4K"
                case "AudioAccessory1,1":                       return "HomePod"
                case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
                default:                                        return identifier
                }
            #elseif os(tvOS)
                switch identifier {
                case "AppleTV5,3": return "Apple TV 4"
                case "AppleTV6,2": return "Apple TV 4K"
                case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
                default: return identifier
                }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}
public extension DateFormatter{
    func convertDate(_ string: String) -> String
    {
        let dateComponent = string.components(separatedBy: "T")
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateComponent[0])!
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date)
        //print("EXACT_DATE : \(dateString)")
        
        return dateString
    }
}

public extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
    func removeCharacters(from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
public extension UILabel {
    func setSizeFont (sizeFont: CGFloat) {
        self.font =  UIFont(name: "Montserrat-SemiBold", size: sizeFont)!
        self.sizeToFit()
    }
}
struct ShortCodeGenerator {
    
    private static let base62chars = [Character]("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".characters)
    private static let maxBase : UInt32 = 62
    
    static func getCode(withBase base: UInt32 = maxBase, length: Int) -> String {
        var code = ""
        for _ in 0..<length {
            let random = Int(arc4random_uniform(min(base, maxBase)))
            code.append(base62chars[random])
        }
        return code
    }
}
extension UIView {
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

