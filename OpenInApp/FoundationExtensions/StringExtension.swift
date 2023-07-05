//
//  StringExtension.swift
//
import Foundation
import UIKit

// MARK: Extension

extension String {
    
    var isTrue: Bool {
        return self.lowercased() == "true"
    }
    
    var url: URL? {
        guard let url = URL(string: self) else {
            return nil
        }
        return url
    }
    
    /// This will convert hex code string to UIColor object
    /// If no color found, this will return clear color
    var hexColorWithAlpha: UIColor {
        let color = UIColor(hexString: self)
        return color ?? .clear
    }

    func getIntValueFromDoubleString() -> Int? {
        let doubleValue: Double = Double(self) ?? 0.0
        let intValue: Int = Int(doubleValue)
        return intValue
    }
    
    func isEqualTo(string: String) -> Bool {
        return self == string
    }
    
    func deletePrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func convertImageToBase64String(img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }

    // retun localised string
    var localisedString: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var masked: String {
        return String(repeating: "*", count: Swift.max(0, count - 5)) + suffix(4)
    }
    
    var emoji: String? {
        let emojiValueWithoutUPlusSymbol = self.replacingOccurrences(of: "U+", with: "")
        let modifiedEmojiHexValue = "0x\(emojiValueWithoutUPlusSymbol)"
        guard let floatValue = Float64(modifiedEmojiHexValue) else {
            return nil
        }
        let emojiUintValue = UInt32(floatValue)
        guard let unicodeScalarValue = UnicodeScalar(emojiUintValue) else {
            return nil
        }
        return String(unicodeScalarValue)
    }
    
    var decodeEmoji: String {
        let data = self.data(using: String.Encoding.utf8)
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr {
            return str as String
        }
        return self
    }

    // message to the server
    var encodeEmoji: String {
        if let encodeStr = NSString(cString: cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue) {
            return encodeStr as String
        }
        return self
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }

    func lines(font: UIFont, width: CGFloat) -> Int {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return Int(boundingBox.height / font.lineHeight)
    }

    func stringByStrippingHTML() -> String {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

    func isEmpty() -> Bool {
        let trimmed = trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        return trimmed.isEmpty
    }

    func boolValue() -> Bool {
        if isEmpty() {
            return false
        }
        switch self {
        case "True", "true", "yes", "1", "Y", "y":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return false
        }
    }

    func integerValue() -> Int {
        if let doubleValue = Double(self) {
            return doubleValue.isInt ? Int(ceil(doubleValue)) : 0
        }
        return 0
    }

    func doubleValue() -> Double {
        if let doubleValue = Double(self) {
            return doubleValue
        }
        return 0.0
    }

    func floatValues() -> Float {
        if let doubleValue = Float(self) {
            let divisor = pow(10.0, Float(2))
            return (doubleValue * divisor).rounded() / divisor
        }
        return 0.0
    }

    func poundValues() -> Float {
        if let doubleValue = Float(self) {
            return doubleValue
        }
        return 0.0
    }
    
    func withDecimalPoints(to decimalPoints: Int) -> String {
        let doubleVal = Double(self) ?? 0
        return String(format: "%.\(decimalPoints)f", doubleVal)
    }

    /// This will return extension from string if it is contains the image's extension.
    public func isImage() -> Bool {
        // Add here your image formats.
        let imageFormats = ["jpg", "jpeg", "png", "gif"]

        if let ext = getExtension() {
            return imageFormats.contains(ext)
        }

        return false
    }

    /// This will return extension from string.
    public func getExtension() -> String? {
        let ext = (self as NSString).pathExtension
        if ext.isEmpty {
            return nil
        }

        return ext
    }

    /// This will boolen if current string is valid URL.
    public func isURL() -> Bool {
        return URL(string: self) != nil
    }

    func rightJustified(width: Int, truncate: Bool = false) -> String {
        guard width > count else {
            return truncate ? String(suffix(width)) : self
        }
        return String(repeating: " ", count: width - count) + self
    }

    func leftJustified(width: Int, truncate: Bool = false) -> String {
        guard width > count else {
            return truncate ? String(prefix(width)) : self
        }
        return self + String(repeating: " ", count: width - count)
    }

    func isNumberOnly() -> Bool {
        if isEmpty {
            return !isEmpty
        }
        let aSet = NSCharacterSet(charactersIn: "0123456789").inverted
        let compSepByCharInSet = components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return self == numberFiltered
    }

    func isStringOnly(spaceAllow: Bool) -> Bool {
        if isEmpty {
            return !isEmpty
        }
        do {
            let space = (spaceAllow == true) ? " " : ""
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z\(space)].*", options: [])
            if regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil {
                return false
            } else {
                return true
            }
        } catch {
            return false
        }
    }

    func isStrongPassword() -> Bool {
        var lowerCaseLetter = false
        var upperCaseLetter = false
        var digit = false
        var specialCharacter = false

        if count >= 8 {
            for char in unicodeScalars {
                if !lowerCaseLetter {
                    lowerCaseLetter = CharacterSet.lowercaseLetters.contains(char)
                }
                if !upperCaseLetter {
                    upperCaseLetter = CharacterSet.uppercaseLetters.contains(char)
                }
                if !digit {
                    digit = CharacterSet.decimalDigits.contains(char)
                }
                if !specialCharacter {
                    specialCharacter = CharacterSet.punctuationCharacters.contains(char)
                }
            }
            if specialCharacter || (digit && lowerCaseLetter && upperCaseLetter) {
                return true
            } else {
                return false
            }
        }
        return false
    }

    func date(format: String, timeZone: TimeZone = .current) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        let date = dateFormatter.date(from: self)
        return date
    }

    func convertDateString(currentFormat: String, currentTimeZone: TimeZone = .current, extepectedFormat: String, expectedTimeZone: TimeZone = .current) -> String {
        return date(format: currentFormat, timeZone: currentTimeZone)?.dateString(format: extepectedFormat, timeZone: expectedTimeZone) ?? self
    }

    func currentTimeFromUTC(currentFormat: String, extepectedFormat: String) -> String {
        return convertDateString(currentFormat: currentFormat, currentTimeZone: TimeZone(abbreviation: "UTC") ?? .current, extepectedFormat: extepectedFormat) // expected default
    }

    func getAttributedTextWithLineOfHeight(height: CGFloat, alignment: NSTextAlignment) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = height
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }

    func findDateDiff(secondTime: String, format: String) -> (hours: Int, min: Int, second: Int) {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = format

        guard let time1 = date(format: format),
              let time2 = secondTime.date(format: format) else { return (0, 0, 0) }

        // You can directly use from here if you have two dates

        let interval = time2.timeIntervalSince(time1)
        let hour = interval / 3600
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let intervalInt = Int(interval)
        return (Int(hour), Int(minute), intervalInt)
    }

    func isValidDecimal() -> Bool {
        let regex1 = "^\\d+(\\.\\d{1,2})?$"
        let test1 = NSPredicate(format: "SELF MATCHES %@", regex1)
        return test1.evaluate(with: self)
    }

    var jsonObject: Any? {
        let invalidJson = "Not a valid JSON"
        do {
            guard let data = data(using: .utf8) else { return Data() }
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return jsonObject
        } catch {
            return invalidJson
        }
    }

    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }

    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue,
        ], documentAttributes: nil).string

        return decoded ?? self
    }
    
    var htmlAttributedString: NSAttributedString? {
        let htmlText = String(
            format: "<span style=\"font-family: 'Graphik'\">%@</span>",
            self
        )
        let data = Data(htmlText.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            return attributedString.trimmedAttributedString()
        }
        return nil
    }
    
    func convertToDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }

    func boundingRectSize(_ font: UIFont, constraintSize: CGSize) -> CGSize {
          let string = NSString(string: self)
          return string.boundingRect(
              with: constraintSize,
              options: NSStringDrawingOptions.usesLineFragmentOrigin,
              attributes: [NSAttributedString.Key.font: font],
              context: nil
          ).size
      }
      
      func boundingRectSize(
          constraintSize: CGSize,
          attributes: [NSAttributedString.Key : Any]?) -> CGSize {
          let string = NSString(string: self)
          return string.boundingRect(
              with: constraintSize,
              options: NSStringDrawingOptions.usesLineFragmentOrigin,
              attributes: attributes,
              context: nil
          ).size
      }

    func convertToDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        return nil
    }
    
    func localised(comment: String? = "") -> String {
        return NSLocalizedString(self, comment: comment ?? "" )
    }
    
    func getAttributedString(
        fontName: String,
        color: UIColor,
        textAlignment: String = "center",
        lineSpacing: CGFloat,
        fontSize: CGFloat
    ) -> NSAttributedString? {
        let modifiedFont = String(format: "<span style=\"font-family: '\(fontName)'; font-size: \(fontSize); text-align: \(textAlignment) \">%@</span>", self)
        
        guard let modifiedFont = modifiedFont.data(
            using: .unicode, allowLossyConversion: true
        ),
              let attrStr = try? NSMutableAttributedString(
                data: modifiedFont,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
              )
        else { return nil }
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = lineSpacing // Whatever line spacing you want in points
        
        if textAlignment == "left" {
            paragraphStyle.alignment = .left
        } else if textAlignment == "center" {
            paragraphStyle.alignment = .center
        } else if textAlignment == "right" {
            paragraphStyle.alignment = .right
        }
        
        // *** Apply attribute to string ***
        attrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrStr.length))
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, attrStr.length))
        
        return attrStr
    }
    
    func attributedStringWithImageAppended(image: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self + " ")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: image)
        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
        let imageString = NSAttributedString(attachment: imageAttachment)
        attributedString.append(imageString)
        return attributedString
    }
    
    func urlEncoded() -> String? {
        addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)?
            .replacingOccurrences(of: "&", with: "%26")
    }
}

//MARK: - Date related
extension String {
    /// Returns date in `5th Jul 2022` format
    func getDDMMMYYYYWithSuffixFormatDate() -> String {
        let dateFormatter = DateFormatter()
        // set locale to reliable US_POSIX
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.dateFormat = date.dateFormatWithSuffix()
        let myStringTime = dateFormatter.string(from: date)
        return myStringTime
    }
    
    /// Returns date in `Jul 5th 2022` format
    func getMMMDDYYYYWithSuffixFormatDate() -> String {
        let dateFormatter = DateFormatter()
        // set locale to reliable US_POSIX
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "MMM d'\(date.daySuffix())' yyyy"
        let myStringTime = dateFormatter.string(from: date)
        return myStringTime
    }
    
    /// Returns date in `01-07-2022` format
    func getDDMMYYYYDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let convertedDate = dateFormatter.date(from: self) else {
            return nil
        }
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.string(from: convertedDate)
        return date
    }
}

// MARK: - URL Extension
extension String {
    
    enum URLError: Error {
        case strToURLFailed
        case hostUnavailable
    }
    
    func getDomain() throws -> String {
        guard let url = URL(string: self) else {
            throw URLError.strToURLFailed
        }
        guard let domain = url.host else {
            throw URLError.hostUnavailable
        }
        return domain
    }
    
    func getHostAndURL() throws -> (host: String, url: URL) {
        guard let url = URL(string: self) else {
            throw URLError.strToURLFailed
        }
        guard let host = url.host else {
            throw URLError.hostUnavailable
        }
        return (host, url)
    }
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    
    func replaceFirst(of pattern:String, with replacement:String) -> String {
        if let range = self.range(of: pattern) {
            return self.replacingCharacters(in: range, with: replacement)
        } else {
            return self
        }
    }
}

extension NSAttributedString {
    
    func trimmedAttributedString() -> NSAttributedString {
        let nonNewlines = CharacterSet.whitespacesAndNewlines.inverted
        // 1
        let startRange = string.rangeOfCharacter(from: nonNewlines)
        // 2
        let endRange = string.rangeOfCharacter(from: nonNewlines, options: .backwards)
        guard let startLocation = startRange?.lowerBound, let endLocation = endRange?.lowerBound else {
            return self
        }
        // 3
        let range = NSRange(startLocation...endLocation, in: string)
        return attributedSubstring(from: range)
    }
    
}
