import Foundation

extension GraphQLCodegen {
    /// Generates struct that is applicable to input object.
    static func generateInputObject(_ name: String, for type: GraphQL.InputObjectType) -> String {
        [ "struct \(name): Codable {"
        , type.inputFields
            .map(generateInputField)
            .joined(separator: "\n")
        , "}"
        ]
        .joined(separator: "\n")
    }
    
    // MARK: - Private helpers
    
    /// Generates a single fileld.
    private static func generateInputField(_ field: GraphQL.InputValue) -> String {
        [ generateDescription(for: field)
        , "let \(field.name): \(generatePropertyType(for: field.type))"
        ]
        .compactMap { $0 }
        .map { "    \($0)" }
        .joined(separator: "\n")
    }
    
    private static func generateDescription(for field: GraphQL.InputValue) -> String? {
        field.description.map { "/// \($0)" }
    }
    
    private static func generatePropertyType(for ref: GraphQL.InputTypeRef) -> String {
        generatePropertyType(for: ref.inverted)
    }
    
    private static func generatePropertyType(for ref: GraphQL.InvertedInputTypeRef) -> String {
        switch ref {
        case .named(let named):
            switch named {
            case .scalar(let scalar):
                // TODO:
                return scalar
            case .enum(let enm):
                return enm
            case .inputObject(let inputObject):
                return inputObject.pascalCase
            }
        case .list(let subref):
            return "[\(generatePropertyType(for: subref))]"
        case .nullable(let subref):
            return "\(generatePropertyType(for: subref))?"
        }
    }
    
}
