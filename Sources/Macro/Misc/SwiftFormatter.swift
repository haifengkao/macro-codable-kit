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
            
            for line in lines {
                let trimmedLine = line.trimmingCharacters(in: .whitespaces)
                
                // Skip empty lines
                guard !trimmedLine.isEmpty else {
                    formattedLines.append("")
                    continue
                }
                
                // Decrease indent for closing braces/parentheses
                if trimmedLine.hasPrefix("}") || trimmedLine.hasPrefix(")") {
                    currentIndentLevel = max(0, currentIndentLevel - 1)
                }
                
                // Add indentation
                let indentation = String(repeating: "    ", count: currentIndentLevel)
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
