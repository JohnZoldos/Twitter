//
//  TwitterClient.swift
//  Twitter
//
//  Created by John Zoldos on 6/9/17.
//  Copyright © 2017 John Zoldos. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient (baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "8EaDOO4VxdpKw1LQbb2usWOU4", consumerSecret: "aUmGRf4LQxi6eeupDmlnxXoSNtwEgolp99UxUbppHHHEb26wUE")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [ NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func userTimeline(screenName: String, count: Int, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/user_timeline.json?screen_name=\(screenName)&count=\(count.description)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [ NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

    
    func currentAccount(success: @escaping (User) -> (),failure: @escaping (Error) -> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "myTwitterApp://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = URL(string:
                "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
            UIApplication.shared.open(url)
        }) { (error: Error!) -> Void in
            print(error.localizedDescription)
            self.loginFailure?(error)
        }
    }
    
    func logOut() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: Notification.Name(rawValue: User.userDidLogoutNotification) as NSNotification.Name, object: nil)
    }
    
    func handleOpenUrl(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
                self.currentAccount(success: { (user: User) in
                    User.currentUser = user
                    self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
        }) { (error: Error!) -> Void in
            print("error")
            self.loginFailure?(error)
        }
    }
    
    func isFavorited(id: String, success: @escaping (Bool) -> (), failure: @escaping (Error) -> ()){
        let url = "1.1/statuses/show.json?id=\(id)"
        var favorited = true
        get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as! NSDictionary
            favorited = dictionary["favorited"] as! Bool
            success(favorited)
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure(error)
        }
    }
    
    func isRetweeted(id: String, success: @escaping (Bool) -> (), failure: @escaping (Error) -> ()){
        let url = "1.1/statuses/show.json?id=\(id)"
        var retweeted = true
        get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as! NSDictionary
            retweeted = dictionary["retweeted"] as! Bool
            success(retweeted)
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure(error)
        }
    }
    
    func favoriteTweet(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        let url = "1.1/favorites/create.json?id=\(id)"
        post(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure(error)
        }
    }
    
    func unfavoriteTweet(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        let url = "1.1/favorites/destroy.json?id=\(id)"
        post(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure(error)
        }
    }
    
    func retweetTweet(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        let url = "1.1/statuses/retweet/\(id).json"
        post(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure(error)
        }
    }
    
    func replyToTweet(id: String, text: String, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        let stringUrl = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let url = "1.1/statuses/update.json?status=\(String(describing: stringUrl))&in_reply_to_status_id=\(id)"
        post(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure(error)
        }
    }
    
    func getUserInfo(screenName: String, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()){
        let url = "1.1/users/show.json?screen_name=\(screenName)"
        get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as! NSDictionary
            success(dictionary)
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure(error)
        }
    }
    
    
    
    
}
