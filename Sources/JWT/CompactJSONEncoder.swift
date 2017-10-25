final class CompactJSONEncoder {
  let encoder = JSONEncoder()
  
  func encode<T : Encodable>(_ value: T, using base64Encoding: Base64Encoding) throws -> Data {
    return try encodeString(value, using: base64Encoding).data(using: .ascii) ?? Data()
  }

  func encodeString<T: Encodable>(_ value: T, using base64Encoding: Base64Encoding) throws -> String {
    return base64Encoding.encode(try encoder.encode(value))
  }

  func encodeString(_ value: [String: Any], using base64Encoding: Base64Encoding) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: value) else { return nil }

    return base64Encoding.encode(data)
  }
}
