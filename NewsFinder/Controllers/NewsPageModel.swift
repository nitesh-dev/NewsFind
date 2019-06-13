//
//  NewsPageModel.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 12/01/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import Foundation
import Moya
import RealmSwift

class NewsPageModel {
    
    var realmItems: Results<RealmNews>?
    var filteredItemsByNewsType: Results<RealmNews>?
    var realmItem = [TrendingNewsModel]()
    let realm = try! Realm()
    
    func readyData(newsType: String) -> Results<RealmNews>?
    {
        realmItems = RealmNews.all()
        let code = Locale.current.regionCode?.lowercased()
        let resultPredicate = NSPredicate(format: "newsType = %@ AND country = %@", newsType.lowercased(), code!)
        filteredItemsByNewsType = realm.objects(RealmNews.self).filter(resultPredicate).sorted(byKeyPath: "publishedAt", ascending: false).distinct(by: ["title"])
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        return filteredItemsByNewsType
    }
}
