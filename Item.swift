import Foundation

import Argo
import Curry
import Runes

struct Item {
    let id: String
    let title: String
    let url: String
    let userPermanentId: Int
    let tags: [String]
    let createdAt: NSDate
}

extension Item: Decodable {
    static func decode(json: JSON) -> Decoded<Item> {
        let tagJsons: Decoded<[JSON]> = json <|| "tags"
        let tags: Decoded<[String]> = tagJsons
            .flatMap { tagJsons in sequence(tagJsons.map { $0 <| "name" }) }

        return curry(Item.init)
            <^> json <| "id"
            <*> json <| "title"
            <*> json <| "url"
            <*> json <| ["user", "permanent_id"]
            <*> tags
            <*> json <| "created_at"
    }
}

extension Item {
    var score: Double {
        // Dummy implementation
        return Double(abs(title.hashValue) % 1000) / 10.0
    }
}