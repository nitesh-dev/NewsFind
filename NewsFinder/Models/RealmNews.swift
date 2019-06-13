//
//  RealmNews.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 07/12/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

@objcMembers class RealmNews: Object {
    enum Property: String {
        case id, author, title, descr, url, urlToImage, publishedAt, newsType
    }
    dynamic var id = UUID().uuidString
    
    dynamic var items = [TrendingNewsModel]()
    
    dynamic var author : String?
    dynamic var title : String?
    dynamic var descr : String?
    dynamic var url : String?
    dynamic var urlToImage : String?
    dynamic var publishedAt : String?
    dynamic var source : Source?
    dynamic var newsType: String = ""
    dynamic var country: String = ""
    //dynamic var items = List<TrendingNewsModel>()
    override static func primaryKey() -> String? {
        return "id"
    }
    convenience init(author: String, title: String, descr: String, url: String, urlToImage: String, publishedAt: String, source: Source, newsType: String, country: String) {
        self.init()
        self.title = title
        self.author = author
        self.descr = descr
        self.url = url
        self.urlToImage = urlToImage
        self.source = source
        self.publishedAt = publishedAt
        self.newsType = newsType
        self.country = country
    }

}
extension RealmNews {
    static func all(in realm: Realm = try! Realm()) -> Results<RealmNews> {
        return realm.objects(RealmNews.self)
            .sorted(byKeyPath: RealmNews.Property.title.rawValue)
    }
    
    
    static func add(items: [TrendingNewsModel], newsType: String ,country: String, in realm: Realm = try! Realm()) {
            for item in items
            {
                let it = RealmNews(value: ["title": item.title as Any, "author": item.author as Any, "descr": item.description as Any, "url": item.url as Any, "urlToImage": item.urlToImage as Any, "source": item.source as Any, "publishedAt": item.publishedAt as Any, "newsType": newsType, "country": country])
                try! realm.write {
                    realm.add(it)
                }
            }
        
    }

}
