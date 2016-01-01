import Alamofire
import Argo

extension Result {
    func flatMap<U>(transform: Value -> Decoded<U>) -> Decoded<U> {
        switch self {
        case let .Success(value):
            return transform(value)
        case let .Failure(error):
            return .customError("\(error)")
            
        }
    }
}
