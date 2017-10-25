import Foundation

/*** Encode a set of claims
 - parameter claims: The set of claims
 - parameter algorithm: The algorithm to sign the payload with
 - returns: The JSON web token as a String
 */
public func encode(claims: ClaimSet, algorithm: Algorithm, headers: [String: String]? = nil, using base64Encoding: Base64Encoding) -> String {
  let encoder = CompactJSONEncoder()

  var headers = headers ?? [:]
  if !headers.keys.contains("typ") {
    headers["typ"] = "JWT"
  }
  headers["alg"] = algorithm.description

  let header = try! encoder.encodeString(headers, using: base64Encoding)
  let payload = encoder.encodeString(claims.claims, using: base64Encoding)!
  let signingInput = "\(header).\(payload)"
  let signature = algorithm.sign(signingInput, using: base64Encoding)
  return "\(signingInput).\(signature)"
}

/*** Encode a dictionary of claims
 - parameter claims: The dictionary of claims
 - parameter algorithm: The algorithm to sign the payload with
 - returns: The JSON web token as a String
 */
public func encode(claims: [String: Any], algorithm: Algorithm, headers: [String: String]? = nil, using base64Encoding: Base64Encoding) -> String {
  return encode(claims: ClaimSet(claims: claims), algorithm: algorithm, headers: headers, using: base64Encoding)
}

/// Encode a set of claims using the builder pattern
public func encode(_ algorithm: Algorithm, using base64Encoding: Base64Encoding, closure: ((ClaimSetBuilder) -> Void)) -> String {
  let builder = ClaimSetBuilder()
  closure(builder)
  return encode(claims: builder.claims, algorithm: algorithm, using: base64Encoding)
}
