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
                let preprocessedLine = line.trimmingCharacters(in: .whitespaces)

                
                // Track contexts
                if preprocessedLine.hasPrefix("enum ") {
                    isInEnum = true
                } else if preprocessedLine.hasPrefix("switch ") {
                    isInSwitch = true
                }
                
                // Special handling for cases
                
                let isSwitchCase = isInSwitch && preprocessedLine.hasPrefix("case ")
                
                // Adjust indent level before switch cases
                if isSwitchCase {
                    currentIndentLevel -= 1
                    inSwitchCase = true
                } else if inSwitchCase && !preprocessedLine.hasPrefix("case ") {
                    currentIndentLevel += 1
                    inSwitchCase = false
                }
                
                // Decrease indent for closing braces
                if preprocessedLine.hasPrefix("}") {
                    if isInSwitch {
                        isInSwitch = false
                    }
                    if isInEnum {
                        isInEnum = false
                    }
                    currentIndentLevel = max(0, currentIndentLevel - 1)
                } else if preprocessedLine.hasPrefix(")") {
                    currentIndentLevel = max(0, currentIndentLevel - 1)
                }
                
                // Add indentation
                let indentation = String(repeating: "    ", count: max(0, currentIndentLevel))
                
                if preprocessedLine.isEmpty, currentIndentLevel > 0 {
                    // ignore empty lines with indent
                } else {
                    
                    if preprocessedLine.contains("CustomCodingDecoding.decode(") {
                        formattedLines.append(formatCustomCodingCall(preprocessedLine, indentLevel: currentIndentLevel-1))
                    } else if preprocessedLine.contains("throw DecodingError.dataCorrupted") {
                        formattedLines.append(formatCustomCodingCall(preprocessedLine, indentLevel: currentIndentLevel-2))
                    } else if preprocessedLine.contains("CustomCodingDecoding.safeDecoding") {
                        formattedLines.append(formatCustomCodingCall(preprocessedLine, indentLevel: currentIndentLevel-2))
                    } else if preprocessedLine.contains("try CustomCodingEncoding.encode("), line.count >= 116 {
                        formattedLines.append(formatCustomCodingCall(preprocessedLine, indentLevel: currentIndentLevel-2))
                    } else {
                        formattedLines.append(indentation + preprocessedLine)
                    }
                }
                
                // Increase indent after opening braces
                if preprocessedLine.hasSuffix("{") {
                    currentIndentLevel += 1
                }
                
                // Handle single-line if statements, function calls, etc.
                if preprocessedLine.hasSuffix(")") && !preprocessedLine.hasSuffix("})") {
                    // Don't increase indent
                } else if preprocessedLine.hasSuffix("{)") || preprocessedLine.hasSuffix("})") {
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
    
   
    func formatCustomCodingCall(_ line: String, indentLevel: Int) -> String {
        // Extract components
        guard let openParenIndex = line.firstIndex(of: "("),
              let closeParenIndex = line.lastIndex(of: ")") else {
            return line
        }
        
        let prefix = String(line[..<openParenIndex])
        let argumentsString = String(line[line.index(after: openParenIndex)..<closeParenIndex])
        
        // Parse arguments respecting nested parentheses
        var arguments: [String] = []
        var currentArg = ""
        var parenCount = 0
        
        for char in argumentsString {
            switch char {
            case "(" where parenCount >= 0:
                parenCount += 1
                currentArg.append(char)
            case ")" where parenCount > 0:
                parenCount -= 1
                currentArg.append(char)
            case "," where parenCount == 0:
                arguments.append(currentArg.trimmingCharacters(in: .whitespaces))
                currentArg = ""
            default:
                currentArg.append(char)
            }
        }
        
        if !currentArg.isEmpty {
            arguments.append(currentArg.trimmingCharacters(in: .whitespaces))
        }

        // Format the call
        return """
        \(prefix)(
        \(arguments.map {$0.indent(level: indentLevel)}.joined(separator: ",\n"))
        )
        """
    }
}
