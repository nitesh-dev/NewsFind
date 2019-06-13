//
//  DownloadManager.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 07/12/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import Foundation
import Moya
import RealmSwift

class DownloadManager {
    
    let provider = MoyaProvider<TrendingAPI>()
    let sourceProvider = MoyaProvider<SourceAPI>()
    private let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
    var newsType = ""
    var res: [TrendingNewsModel]!
    {
        didSet {flag = true}
    }
    var sourceRes: [SourceModel]!
    {
        didSet {flag = true}
    }
    private var realmItems: Results<RealmNews>?
    private var realmSourceItems: Results<RealmSource>?
    var realmItem = [TrendingNewsModel]()
    var realmSourceItem = [SourceModel]()
    var flag = false

    
    enum DownloadResult {
        case success(Results<RealmNews>?)
        case catchFailure(Error)
        case failure(String)
    }
    enum SourceDownloadResult {
        case success(Results<RealmSource>?)
        case catchFailure(Error)
        case failure(String)
    }
    
    
    func getDataFromAPI(code: String, category: String, query: String, completionHandler: @escaping (DownloadResult) -> ()){
        if (query == "")
        {
            provider.request(.country(ccode: code, ctgry: category)) { result in
                switch result  {
                case .success(let response):
                    do{
                        print(response)
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        let decoder = JSONDecoder()
                        self.res = try filteredResponse.map([TrendingNewsModel].self, atKeyPath: "articles", using: decoder)
                        self.realmItem = self.res
                        RealmNews.add(items: self.realmItem, newsType: category, country: code)
                        NewsPageViewController.isFirstLoad = false
                        self.realmItems = RealmNews.all()
                        completionHandler(.success(self.realmItems))
                    } catch {
                        completionHandler(.catchFailure(error))
                        print("Exception occured, please try again later")
                    }
                case .failure:
                    completionHandler(.failure("Sorry, Please try again"))
                    print("Error occured, please try again later")
                }
            }
        }
        else
        {
            provider.request(.query(qry: query)) { result in
                switch result  {
                case .success(let response):
                    do{
                        print(response)
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        let decoder = JSONDecoder()
                        self.res = try filteredResponse.map([TrendingNewsModel].self, atKeyPath: "articles", using: decoder)
                        self.realmItem = self.res
                        //completionHandler(.success(self.realmItem))
                    } catch {
                        completionHandler(.catchFailure(error))
                        print("Exception occured, please try again later")
                    }
                case .failure:
                    completionHandler(.failure("Sorry, Please try again"))
                    print("Error occured, please try again later")
                }
            }
        }
    }

    func getSourceFromAPI(countryCode: String, language: String, completionHandler: @escaping (SourceDownloadResult) -> ()){
        if (countryCode == "")
        {
            sourceProvider.request(.languageWise(qry: language)) { result in
                switch result  {
                case .success(let response):
                    do{
                        print(response)
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        let decoder = JSONDecoder()
                        self.sourceRes = try filteredResponse.map([SourceModel].self, atKeyPath: "sources", using: decoder)
                        self.realmSourceItem = self.sourceRes
                        RealmSource.add(items: self.realmSourceItem)
                        self.realmSourceItems = RealmSource.all()
                        completionHandler(.success(self.realmSourceItems))
                    } catch {
                        completionHandler(.catchFailure(error))
                        print("Exception occured, please try again later")
                    }
                case .failure:
                    completionHandler(.failure("Sorry, Please try again"))
                    print("Error occured, please try again later")
                }
            }
        }
        else
        {
            sourceProvider.request(.countryWise(ccode: countryCode, language: language)) { result in
                switch result  {
                case .success(let response):
                    do{
                        print(response)
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        let decoder = JSONDecoder()
                        self.sourceRes = try filteredResponse.map([SourceModel].self, atKeyPath: "sources", using: decoder)
                        self.realmSourceItem = self.sourceRes
                        RealmSource.add(items: self.realmSourceItem)
                        self.realmSourceItems = RealmSource.all()
                        completionHandler(.success(self.realmSourceItems))
                    } catch {
                        completionHandler(.catchFailure(error))
                        print("Exception occured, please try again later")
                    }
                case .failure:
                    completionHandler(.failure("Sorry, Please try again"))
                    print("Error occured, please try again later")
                }
            }
        }
}
}

