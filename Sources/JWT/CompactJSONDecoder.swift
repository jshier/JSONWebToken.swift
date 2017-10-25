import Foundation

final class CompactJSONDecoder {
  let decoder = JSONDecoder()
  
  func decode<T>(_ type: T.Type, from data: Data, using base64Encoding: Base64Encoding) throws -> T where T : Decodable {
    guard let string = String(data: data, encoding: .ascii) else {
      throw InvalidToken.decodeError("data should contain only ASCII characters")
    }

    return try decode(type, from: string, using: base64Encoding)
  }

  func decode<T>(_ type: T.Type, from string: String, using base64Encoding: Base64Encoding) throws -> T where T : Decodable {
//    guard let decoded = base64decode(string) else {
//      throw InvalidToken.decodeError("data should be a valid base64 string")
//    }

    return try decoder.decode(type, from: base64Encoding.decode(string))
  }

  func decode(from string: String, using base64Encoding: Base64Encoding) throws -> Payload {
//    guard let decoded = base64decode(string) else {
//      throw InvalidToken.decodeError("Payload is not correctly encoded as base64")
//    }

    let object = try JSONSerialization.jsonObject(with: base64Encoding.decode(string))
    guard let payload = object as? Payload else {
      throw InvalidToken.decodeError("Invalid payload")
    }

    return payload
  }
}
