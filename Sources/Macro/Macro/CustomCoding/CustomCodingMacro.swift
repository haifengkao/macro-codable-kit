//
//  CustomCodingMacro.swift
//
//
//  Created by Mikhail Maslo on 01.10.23.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct CustomCodingMacro {}

extension CustomCodingMacro: PeerMacro {
    public static func expansion(
        of _: AttributeSyntax,
        providingPeersOf _: some DeclSyntaxProtocol,
        in _: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        []
    }
}
