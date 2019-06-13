//
//  RSSParser.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 06/12/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import Foundation

class RSSParser: NSObject, XMLParserDelegate {
    var xmlParser: XMLParser!
    var currentElement = ""
    var foundCharacters = ""
    var currentData = [String: String]()
    var parsedData = [[String: String]]()
    var isHeader = true
    
    func startParsingWithContentsOfURL(url: URL, with completion: (Bool) -> ())
    {
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        if let flag = parser?.parse()
        {
            parsedData.append(currentData)
            completion(flag)
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if currentElement == "item" || currentElement == "entry"
        {
            if isHeader == false
            {
                parsedData.append(currentData)
            }
            isHeader = false
        }
        if isHeader == false
        {
            if currentElement == "media:thumbnail" || currentElement == "media:content"
            {
                foundCharacters += attributeDict["url"]!
            }
        }
    }
    
//    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        if isHeader == false
//        {
//            if (currentElement == "title" || currentElement == "link" ||currentElement == "description" || currentElement == "content" || currentElement == "pubDate" || currentElement == "author" || currentElement == "dc:creator" || currentElement == "content:encoded")
//            {
//                foundCharacters += string
//                //foundCharacters = foundCharacters.deleteHTML(tags: ["a", "p", "div", "img"])
//                foundCharacters = foundCharacters.
//            }
//        }
//    }
    
}
