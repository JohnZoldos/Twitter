//
//  Tweet.swift
//  Twitter
//
//  Created by John Zoldos on 6/9/17.
//  Copyright © 2017 John Zoldos. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var creationDate: Date?
    var numRetweets: Int = 0
    var numFavorites: Int = 0
    var userName: String?
    var twitterHandle: String?
    var imageUrl: URL?
    var id: String?
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        numRetweets = dictionary["retweet_count"] as! Int
        numFavorites = dictionary["favorite_count"] as! Int
        
        let user = dictionary["user"] as! NSDictionary
        userName = user["name"] as? String
        twitterHandle = "@\(user["screen_name"]!)"
        var imageUrlString = user["profile_image_url"] as? String
        imageUrlString = imageUrlString?.replacingOccurrences(of: "http://", with: "https://")
        if imageUrlString != nil {
            imageUrl = URL(string: imageUrlString!)!
        } else {
            imageUrl = nil
        }
        
        
        let timeStampString = dictionary["created_at"] as? NSString
        
        
        if let timeStampString = timeStampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            creationDate = formatter.date(from: timeStampString as String)
        }
        
        id = dictionary["id_str"] as? String
    }
    
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        
        return tweets
    }
}
