
import UIKit

extension String {
    
    public func substring(from string: String) -> String? {
        guard let range = self.range(of: string) else { return nil }
        return String(self[range.upperBound...])
    }
    
    public func substring(to string: String) -> String? {
        guard let range = self.range(of: string) else { return nil }
        return String(self[..<range.lowerBound])
    }
    
    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        } else {
            return self
        }
    }
}
