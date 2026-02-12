import Foundation

// MARK: - Symbol

struct Symbol {
    let name: String
    let value: Double
    let description: String
}

// MARK: - Energy Types

enum EnergyType: String {
    case relativistic
    case kinetic
    case thermal
    case electromagnetic
    
    static let allCases: [EnergyType] = [
        .relativistic,
        .kinetic,
        .thermal,
        .electromagnetic
    ]
}

// MARK: - Energy Node

struct EnergyNode {
    let type: EnergyType
    var baseSymbols: [Symbol]
    var unitySymbols: [Symbol]
    
    init(type: EnergyType, baseSymbols: [Symbol]) {
        self.type = type
        self.baseSymbols = baseSymbols
        self.unitySymbols = []
    }
    
    mutating func addUnitySymbol(_ symbol: Symbol) {
        unitySymbols.append(symbol)
    }
    
    func formulaString() -> String {
        let unityPart = unitySymbols.map { $0.name }.joined(separator: " * ")
        let basePart = baseSymbols.map { $0.name }.joined(separator: " * ")
        
        if unityPart.isEmpty {
            return "E = \(basePart)"
        } else {
            return "E = \(unityPart) * \(basePart)"
        }
    }
    
    func describeSymbols() {
        print("Base Symbols:")
        for s in baseSymbols {
            print("- \(s.name): \(s.description)")
        }
        
        if !unitySymbols.isEmpty {
            print("Unity Symbols:")
            for s in unitySymbols {
                print("- \(s.name): \(s.description)")
            }
        }
    }
}

// MARK: - Ontology

class EnergyOntology {
    var nodes: [EnergyType: EnergyNode] = [:]
    
    init() {
        nodes[.relativistic] = EnergyNode(
            type: .relativistic,
            baseSymbols: [
                Symbol(name: "lne", value: 1.0, description: "Natural logarithmic base"),
                Symbol(name: "gamma", value: 1.0, description: "Lorentz factor"),
                Symbol(name: "mcmod2", value: 0.0, description: "Mass-energy equivalence")
            ]
        )
        
        nodes[.kinetic] = EnergyNode(
            type: .kinetic,
            baseSymbols: [
                Symbol(name: "0.5", value: 0.5, description: "Half constant"),
                Symbol(name: "m", value: 0.0, description: "Mass"),
                Symbol(name: "v**2", value: 0.0, description: "Velocity squared")
            ]
        )
        
        nodes[.thermal] = EnergyNode(
            type: .thermal,
            baseSymbols: [
                Symbol(name: "k", value: 0.0, description: "Boltzmann constant"),
                Symbol(name: "T", value: 0.0, description: "Temperature")
            ]
        )
        
        nodes[.electromagnetic] = EnergyNode(
            type: .electromagnetic,
            baseSymbols: [
                Symbol(name: "h", value: 0.0, description: "Planck constant"),
                Symbol(name: "f", value: 0.0, description: "Frequency")
            ]
        )
    }
}

// MARK: - Explorer

func startExplorer() {
    let ontology = EnergyOntology()
    var running = true
    
    print("=== Energy Lexicon Explorer ===")
    
    while running {
        print("\nAvailable Energy Types:")
        for (index, type) in EnergyType.allCases.enumerated() {
            print("\(index + 1). \(type.rawValue)")
        }
        print("0. Exit")
        
        print("\nSelect energy type:")
        guard let input = readLine(),
              let choice = Int(input),
              choice >= 0,
              choice <= EnergyType.allCases.count else {
            print("Invalid input.")
            continue
        }
        
        if choice == 0 {
            running = false
            print("Exiting explorer.")
            break
        }
        
        let selectedType = EnergyType.allCases[choice - 1]
        
        guard var node = ontology.nodes[selectedType] else {
            continue
        }
        
        print("\n--- \(selectedType.rawValue.uppercased()) ---")
        print(node.formulaString())
        node.describeSymbols()
        
        print("\nAdd unity symbol? (y/n)")
        if let response = readLine(), response.lowercased() == "y" {
            print("Enter unity symbol name:")
            if let name = readLine() {
                let symbol = Symbol(
                    name: name,
                    value: 1.0,
                    description: "User-defined unity dimension"
                )
                node.addUnitySymbol(symbol)
                print("Updated Formula:")
                print(node.formulaString())
            }
        }
    }
}

// Run it
startExplorer()
