import ArgumentParser
import Parsing

/// A style of code indentation.
enum IndentationStyle: Equatable {
  /// Use one tab for each indent.
  case tabs
  /// Use a specific number of spaces for each indent.
  case spaces(Int)
  
  /// The string representation of a single indent.
  var string: String {
    switch self {
      case .tabs:
        return "\t"
      case .spaces(let count):
        return String(repeating: " ", count: count)
    }
  }
}

extension IndentationStyle: ExpressibleByArgument {
  var defaultValueDescription: String {
    switch self {
      case .tabs:
        return "tabs"
      case let .spaces(count):
        return "spaces=\(count)"
    }
  }
  
  init?(argument: String) {
    let parser = Parse {
      OneOf {
        Parse {
          "tabs"
        }.map {
          IndentationStyle.tabs
        }
        
        Parse {
          "spaces="
          Int.parser()
        }.map { count in
          IndentationStyle.spaces(count)
        }
      }
    }
    
    guard let style = try? parser.parse(argument) else {
      return nil
    }
    
    self = style
  }
}