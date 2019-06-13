//
//  HashtagComposer.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 24/01/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import Foundation

class HashtagComposer {
    
    let quote = "Here's to the crazy ones. The misfits. The rebels. The troublemakers. The round pegs in the square holes. The ones who see things differently. They're not fond of rules. And they have no respect for the status quo. You can quote them, disagree with them, glorify or vilify them. About the only thing you can't do is ignore them. Because they change things. They push the human race forward. And while some may see them as the crazy ones, we see genius. Because the people who are crazy enough to think they can change the world, are the ones who do. - Steve Jobs (Founder of Apple Inc.)"
    
    let tagger = NSLinguisticTagger(tagSchemes: [.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
    let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
    
    
    func determineLanguage(for text: String) {
        tagger.string = text
        let language = tagger.dominantLanguage
        print("The language is \(language!)")
    }
    
    //determineLanguage(for: quote)
    
    
    func tokenizeText(for text: String) {
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { tag, tokenRange, stop in
            let word = (text as NSString).substring(with: tokenRange)
            print(word)
        }
    }
    //tokenizeText(for: quote)
    
    
    func lemmatization(for text: String) {
        tagger.string = text
        let range = NSRange(location:0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { tag, tokenRange, stop in
            if let lemma = tag?.rawValue {
                print(lemma)
            }
        }
    }
    //lemmatization(for: quote)
    
    func namedEntityRecognition(for text: String) -> [String] {
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
        var tagArray = [String]()
        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, stop in
            if let tag = tag, tags.contains(tag) {
                let name = (text as NSString).substring(with: tokenRange)
                tagArray.append(name)
                print(name)
            }
        }
        //let countArray = createTags(for: tagArray)
        return tagArray
    }
    
    func iterateThroughTitlesForTags(for stringArray: [String]) -> [String]
    {
        let countArray = stringArray.flatMap { namedEntityRecognition(for: $0)}
        let tagArray = createTags(for: countArray)
        return tagArray
    }
    
    func createTags(for stringArray: [String]) -> [String] {
        let counts = stringArray.reduce(into: [:]) { counts, word in counts[word, default: 0] += 1 }
        let sortedDict = counts.sorted{ $0.value > $1.value }
        let slicedDict = Array(sortedDict.filter({$0.key.count < 20}).map({$0.key}).prefix(through: 2))
        let mutatedTagDict = slicedDict.map({ (word) -> String in
            var word = word
            word.insert("#", at: word.startIndex)
            return word.replacingOccurrences(of: " ", with: "")})
        
        return mutatedTagDict
    }
    
    
    
    func partsOfSpeech(for text: String) {
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
            if let tag = tag {
                let word = (text as NSString).substring(with: tokenRange)
                print("\(word): \(tag.rawValue)")
            }
        }
    }
    //partsOfSpeech(for: quote)
    //namedEntityRecognition(for: quote)
    
}
