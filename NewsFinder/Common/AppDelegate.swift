//
//  AppDelegate.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 06/08/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import DropDown
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var realmItems: Results<RealmNews>?
    private var realmSources: Results<RealmSource>?
    let dmg = DownloadManager()
    var window: UIWindow?
    private let concurrentQueue = DispatchQueue(label: "cQueue", qos: .userInitiated, attributes: .concurrent)
    let newsTypes:[String] = ["general","business","technology","entertainment","sports","science","health"]
    var code = Locale.current.regionCode?.lowercased()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        
        self.window!.rootViewController = viewController
        self.window!.makeKeyAndVisible()
        DropDown.startListeningToKeyboard()
        
        realmItems = RealmNews.all()
        realmSources = RealmSource.all()
        if(realmItems?.isEmpty)!
        {
            if code == ""
            { code = "us" }
            performAsyncTaskInConcurrentQueue()
        }
        if(realmSources?.isEmpty)!
        {
            concurrentQueue.async {
                self.downloadAllNewsSources()
            }
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        return true
    }
    func downloadAllNewsSources(){
        let lang = Locale.current.languageCode
        
        self.dmg.getSourceFromAPI(countryCode: self.code!, language: lang!, completionHandler: {
            result in
            switch result {
            case .success(let retrievedData):
                self.realmSources = retrievedData
            case .failure(let error): print(error)
            case .catchFailure : print("Please try again")
            }
        })
    }
    
    func performAsyncTaskInConcurrentQueue() {
        var task:DispatchWorkItem?
        
        task = DispatchWorkItem {
            for type in self.newsTypes {
                
                self.dmg.getDataFromAPI(code: self.code!, category: type, query: "",completionHandler:{ result in
                    switch result {
                    case .success(let retrievedData):
                        self.realmItems = retrievedData
                    case .failure(let error): print(error)
                    case .catchFailure : print("Please try again")
                    }
                })
                
                if (task?.isCancelled)! {
                    break
                }
            }
            task = nil
        }
        
        concurrentQueue.async {
            task?.perform()
        }
        concurrentQueue.asyncAfter(deadline: .now() + .seconds(2), execute: {
            task?.cancel()
        })
        
        task?.notify(queue: concurrentQueue) {
            print("\n############")
            print("###### Work Item Completed")
        }
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if Auth.auth().currentUser != nil
        {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(withIdentifier: "tabMain")
            self.window?.rootViewController?.present(newVC, animated: true, completion: nil)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    override init() {
        FirebaseApp.configure()
    }
    
    
}

