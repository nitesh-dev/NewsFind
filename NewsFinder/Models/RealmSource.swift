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

@objcMembers class RealmSource: Object {
    enum Property: String {
        case id, name, descr, url, category, language, country
    }
    dynamic var id = UUID().uuidString
    
    dynamic var items = [SourceModel]()
    
    dynamic var ids : String?
    dynamic var name : String?
    dynamic var descr : String?
    dynamic var url : String?
    dynamic var category : String?
    dynamic var language : String?
    dynamic var country: String = ""
    //dynamic var items = List<TrendingNewsModel>()
    override static func primaryKey() -> String? {
        return "id"
    }
    convenience init(ids: String, name: String, descr: String, url: String, category: String, language: String, country: String) {
        self.init()
        self.ids = ids
        self.name = name
        self.descr = descr
        self.url = url
        self.category = category
        self.language = language
        self.country = country
    }
}
extension RealmSource {
    static func all(in realm: Realm = try! Realm()) -> Results<RealmSource> {
        return realm.objects(RealmSource.self)
            .sorted(byKeyPath: RealmSource.Property.name.rawValue)
    }
    
    static func add(items: [SourceModel], in realm: Realm = try! Realm()) {
        for item in items
        {
            let it = RealmSource(value: ["ids": item.id as Any, "name": item.name as Any, "descr": item.description as Any, "url": item.url as Any, "category": item.category as Any, "language": item.language as Any, "country": item.country as Any])
            try! realm.write {
                realm.add(it)
            }
        }
    }
}

