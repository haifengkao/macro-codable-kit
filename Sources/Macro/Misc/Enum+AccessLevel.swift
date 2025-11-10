//
//  Enum+AccessLevel.swift
//
//
//  Created by Hai Feng Kao on 2025-11-10.
//

import MacroToolkit
import SwiftSyntax

extension Enum {
    /// Whether the enum declaration uses the `public` modifier.
    var isPublic: Bool { _syntax.isPublic }
}
