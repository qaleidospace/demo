import Foundation
import Argo

private let format: String = "yyyy-MM-dd\'T\'HH:mm:ssZZZZZ"

extension NSDate: Decodable {
    public static func decode(json: JSON) -> Decoded<NSDate> {
        switch json {
        case let .String(s):
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = format
            let date = dateFormatter.dateFromString(s)
            if let date = date {
                return pure(date)
            } else {
                return .typeMismatch("Invalid format.", actual: json)
            }
        default:
            return .typeMismatch("Must be String.", actual: json)
        }
    }
}

extension NSDate: Comparable {
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSinceReferenceDate < rhs.timeIntervalSinceReferenceDate
}
