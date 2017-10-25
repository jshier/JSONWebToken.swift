import Foundation

/// URI Safe base64 encode
//func base64encode(_ input: Data) -> String {
//  let data = input.base64EncodedData()
//  let string = String(data: data, encoding: .utf8)!
//  return string
//    .replacingOccurrences(of: "+", with: "-")
//    .replacingOccurrences(of: "/", with: "_")
//    .replacingOccurrences(of: "=", with: "")
//}
//
///// URI Safe base64 decode
//func base64decode(_ input: String) -> Data? {
//  let rem = input.count % 4
//
//  var ending = ""
//  if rem > 0 {
//    let amount = 4 - rem
//    ending = String(repeating: "=", count: amount)
//  }
//
//  let base64 = input.replacingOccurrences(of: "-", with: "+")
//    .replacingOccurrences(of: "_", with: "/") + ending
//
//  return Data(base64Encoded: base64)
//}

public enum Base64Encoding {
  case base64, base64URL
  
  func encode(_ data: Data) -> String {
    switch self {
    case .base64:
      return data.base64EncodedString()
    case .base64URL:
      return data.base64URLEncodedString()
    }
  }
  
  func decode(_ string: String) -> Data {
    switch self {
    case .base64:
      return Data(base64Encoded: string.data(using: .utf8)!)!
    default:
      return string.transformingBase64URLToBase64Data()
    }
  }
  
  
}

extension Data {
  func base64URLEncodedString() -> String {
    return String(data: base64EncodedData(), encoding: .utf8)!
      .replacingOccurrences(of: "+", with: "-")
      .replacingOccurrences(of: "/", with: "_")
      .replacingOccurrences(of: "=", with: "")
  }
  
  func base64URLEncodedData() -> Data {
    return base64URLEncodedString().data(using: .utf8)!
  }
}

extension String {
  func transformingBase64URLToBase64() -> String {
    let paddingRequired = count % 4
    var ending = ""
    if paddingRequired > 0 {
      let paddingAmount = 4 - paddingRequired
      ending = String(repeating: "=", count: paddingAmount)
    }
    
    return replacingOccurrences(of: "-", with: "+")
      .replacingOccurrences(of: "_", with: "/")
      + ending
  }
  
  func transformingBase64URLToBase64Data() -> Data {
    return Data(base64Encoded: transformingBase64URLToBase64().data(using: .utf8)!)!
  }
}
