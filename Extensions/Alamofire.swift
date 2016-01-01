import Foundation

import Alamofire
import PromiseK

extension Request {
    public func promisedResponse(queue queue: dispatch_queue_t? = nil)
        -> Promise<(NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?)> {
            return Promise { resolve in
                self.response(queue: queue) { resolve(pure($0)) }
            }
    }
    
    public func promisedResponseJSON(options options: NSJSONReadingOptions = .AllowFragments)
        -> Promise<Response<AnyObject, NSError>> {
            return Promise { resolve in
                self.responseJSON(options: options) { resolve(pure($0)) }
            }
    }
}
