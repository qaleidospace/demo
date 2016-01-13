import Foundation

import Alamofire
import Argo
import PromiseK

func downloadItems(page page: Int, perPage: Int) -> Promise<Decoded<[Item]>> {
    let request: Request = Alamofire.request(.GET, "https://qiita.com/api/v2/items",
        parameters: ["page": page, "per_page": perPage])
    return request.promisedResponseJSON().map { response in
        response.result.flatMap { decode($0) }
    }
}

// let request: Request = Alamofire.request(.GET, "https://qiita.com/api/v2/items",
//     parameters: ["page": 1, "per_page": 100])
// let items: Promise<Decoded<[Item]>> = request.promisedResponseJSON().map { response in
//     response.result.flatMap { decode($0) }
// }
// 

// let items: Promise<Decoded<[Item]>> = (1...3).reduce(pure(pure([]))) { items, page in
//     items >>-? { items in
//         downloadItems(page: page, perPage: 100) >-? { pageItems in
//             items + pageItems
//         }
//     }
// }


let items: Promise<Decoded<[Item]>> = (1...3).reduce(pure(pure([]))) { items, page in
    items >>-? { items in
        let wait: Promise<()> = Promise { resolve in
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3.6 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                resolve(Promise())
            }
        }
        
        let pageItems: Promise<Decoded<[Item]>> = downloadItems(page: page, perPage: 100) >-? { pageItems in
            items + pageItems
        }

        return wait.flatMap { _ in pageItems }
    }
}

items.map { items in
    switch items {
    case let .Success(items):
        items.filter { $0.createdAt > NSDate(timeIntervalSinceNow: -86400) } // 24時間以内の投稿に絞る
            .map { ($0, $0.score) } // スコアの計算は重いので、一度計算した値を使いまわせるようにタプルに格納
            .sort { $0.1 > $1.1 }[0..<100] // ソートして上位100個の要素に絞る
            .enumerate() // 順位を表示するためにインデックスとペアにする
            .forEach { print("\($0 + 1): \($1.0.title) (\($1.1) pt)") } // 順位、タイトル、スコアを表示
    case let .Failure(error):
        print(error) // Qiita APIおよびデコードでエラーだった場合はエラーを表示
    }
}.wait()
