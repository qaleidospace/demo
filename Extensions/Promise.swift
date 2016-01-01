import Foundation

import Argo
import PromiseK

extension Promise {
    func wait() {
        var finished = false
        self.flatMap { (value: T) -> Promise<()> in
            finished = true
            return Promise<()>()
        }
        while (!finished){
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 0.1))
        }
    }
}

func >-?<T, U>(lhs: Promise<Decoded<T>>, rhs: T -> Decoded<U>) -> Promise<Decoded<U>> {
    return lhs.map { $0.flatMap(rhs) }
}

func >>-?<T, U>(lhs: Promise<Decoded<T>>, rhs: T -> Promise<Decoded<U>>) -> Promise<Decoded<U>> {
    return lhs.flatMap { decoded in
        switch decoded {
        case let .Success(value):
            return rhs(value)
        case let .Failure(error):
            return pure(.Failure(error))
        }
    }
}
