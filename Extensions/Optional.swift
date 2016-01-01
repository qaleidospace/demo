import Argo

extension Optional {
    func flatMap<U>(transform: Wrapped -> Decoded<U>) -> Decoded<U> {
        switch self {
        case .None:
            return .customError("nil")
        case let .Some(x):
            return transform(x)
            
        }
    }
    
    func decoded(message: String = "nil") -> Decoded<Wrapped> {
        switch self {
        case .None:
            return .customError(message)
        case let .Some(x):
            return .Success(x)
        }
    }
}