//
//  MacroToolkit+Helpers.swift
//
//
//  Created by Mikhail Maslo on 23.09.23.
//

import MacroToolkit

extension Enum {
    var rawInheritedTypes: [String]? {
        _syntax.inheritanceClause?.inheritedTypes.map(\.type.trimmedDescription)
    }
}

extension Struct {
    var rawInheritedTypes: [String]? {
        _syntax.inheritanceClause?.inheritedTypes.map(\.type.trimmedDescription)
    }
}

extension Variable {
    var isStatic: Bool {
        _syntax.modifiers.contains(where: { modifier in
            if case .keyword(.static) = modifier.name.tokenKind {
                return true
            } else {
                return false
            }
        })
    }
}

extension Type {
    var isOptional: Bool {
        switch self {
        case .optional:
            return true
        default:
            return false
        }
    }
}
