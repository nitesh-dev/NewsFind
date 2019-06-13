
import Foundation
import RealmSwift

@objcMembers class TrendingNewsModel: Codable, RealmCollectionValue {
    dynamic var author : String?
    dynamic var title : String?
    dynamic var description : String?
    dynamic var url : String?
    dynamic var urlToImage : String?
    dynamic var publishedAt : String?
    dynamic var source : Source?
    
    enum CodingKeys: String, CodingKey {
        
        case author = "author"
        case title = "title"
        case description = "description"
        case url = "url"
        case urlToImage = "urlToImage"
        case publishedAt = "publishedAt"
        case source = "source"
    }
}
@objcMembers class Source : Object, Codable {
    dynamic var id : String?
    dynamic var name : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}




