//
//  AllOf.swift
//
//
//  Created by Mikhail Maslo on 26.09.23.
//

/**
 A macro that provides conformance to `Decodable` and `Encodable` for types that implement all of the specified macros, following the OpenAPI `allOf` specification for composition.

 If a type already conforms to `Decodable` or `Encodable`, the corresponding conformance will not be generated.

 - Note: This macro is attached to an extension.

 - Requires: `Macro` module.

 - SeeAlso: `AllOfCodableMacro`

 - Important: If a type already conforms to `Encodable`, no `Encodable` conformance will be generated by this macro.
 - Important: If a type already conforms to `Decodable`, no `Decodable` conformance will be generated.
 */
@attached(extension, conformances: Decodable, Encodable, names: named(CodingKeys), named(init(from:)), named(encode(to:)))
public macro AllOfCodable() = #externalMacro(module: "Macro", type: "AllOfCodableMacro")

/**
 A macro that provides conformance to `Decodable` for types that implement all of the specified macros, following the OpenAPI `allOf` specification for composition.

 If a type already conforms to `Decodable`, `Decodable` conformance will not be generated.

 - Note: This macro is attached to an extension.

 - Requires: `Macro` module.

 - SeeAlso: `AllOfDecodableMacro`

 - Important: If a type already conforms to `Decodable`, no `Decodable` conformance will be generated by this macro.
 */
@attached(extension, conformances: Decodable, names: named(CodingKeys), named(init(from:)))
public macro AllOfDecodable() = #externalMacro(module: "Macro", type: "AllOfDecodableMacro")

/**
 A macro that provides conformance to `Encodable` for types that implement all of the specified macros, following the OpenAPI `allOf` specification for composition.

 If a type already conforms to `Encodable`, `Encodable` conformance will not be generated.

 - Note: This macro is attached to an extension.

 - Requires: `Macro` module.

 - SeeAlso: `AllOfEncodableMacro`

 - Important: If a type already conforms to `Encodable`, no `Encodable` conformance will be generated by this macro.
 */
@attached(extension, conformances: Encodable, names: named(CodingKeys), named(encode(to:)))
public macro AllOfEncodable() = #externalMacro(module: "Macro", type: "AllOfEncodableMacro")
