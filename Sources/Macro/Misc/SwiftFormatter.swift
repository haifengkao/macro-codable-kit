//
//  SwiftFormat.swift
//
//
//  Created by Mikhail Maslo on 23.09.23.
//

extension String {
    /// A copy of the string formatted with basic Swift formatting rules.
    var swiftFormatted: Self {
        get throws {
            let lines = self.components(separatedBy: .newlines)
            var formattedLines: [String] = []
            var currentIndentLevel = 0
            var isInEnum = false
            var isInSwitch = false
            var inSwitchCase = false
            
            for line in lines {
                let trimmedLine = line.trimmingCharacters(in: .whitespaces)
                
                // Skip empty lines
                guard !trimmedLine.isEmpty else {
                    formattedLines.append("")
                    continue
                }
                
                // Track contexts
                if trimmedLine.hasPrefix("enum ") {
                    isInEnum = true
                } else if trimmedLine.hasPrefix("switch ") {
                    isInSwitch = true
                }
                
                // Special handling for cases
                let isEnumCase = isInEnum && trimmedLine.hasPrefix("case ")
                let isSwitchCase = isInSwitch && trimmedLine.hasPrefix("case ")
                
                // Adjust indent level before switch cases
                if isSwitchCase {
                    currentIndentLevel -= 1
                    inSwitchCase = true
                } else if inSwitchCase && !trimmedLine.hasPrefix("case ") {
                    currentIndentLevel += 1
                    inSwitchCase = false
                }
                
                // Decrease indent for closing braces
                if trimmedLine.hasPrefix("}") {
                    if isInSwitch {
                        isInSwitch = false
                    }
                    if isInEnum {
                        isInEnum = false
                    }
                    currentIndentLevel = max(0, currentIndentLevel - 1)
                } else if trimmedLine.hasPrefix(")") {
                    currentIndentLevel = max(0, currentIndentLevel - 1)
                }
                
                // Add indentation
                let indentation = String(repeating: "    ", count: max(0, currentIndentLevel))
                formattedLines.append(indentation + trimmedLine)
                
                // Increase indent after opening braces
                if trimmedLine.hasSuffix("{") {
                    currentIndentLevel += 1
                }
                
                // Handle single-line if statements, function calls, etc.
                if trimmedLine.hasSuffix(")") && !trimmedLine.hasSuffix("})") {
                    // Don't increase indent
                } else if trimmedLine.hasSuffix("{)") || trimmedLine.hasSuffix("})") {
                    currentIndentLevel += 1
                }
            }
            
            return formattedLines.joined(separator: "\n")
        }
    }
}

private extension String {
    func indent(level: Int) -> String {
        let indentation = String(repeating: "    ", count: level)
        return indentation + self
    }
}
