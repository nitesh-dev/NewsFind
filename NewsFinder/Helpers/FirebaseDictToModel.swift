//
//  FirebaseDictToModel.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 13/10/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import Foundation

class FirebaseDictToModel: NSObject {
    let title: String?
    let desc : String?
    let date: String?
    let imgURL: String?
    let url : String?
    let source: String?
    init(title: String, desc: String, date: String, imgURL: String, url: String, source: String) {
        self.title = title
        self.desc = desc
        self.date = date
        self.imgURL = imgURL
        self.url = url
        self.source = source
    }
}

