//
//  Tweet.swift
//  Twitter
//
//  Created by John Zoldos on 6/9/17.
//  Copyright © 2017 John Zoldos. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: NSString?
    var creationDate: Date?
    var numRetweets: Int = 0
    var numFavorites: Int = 0
    var userImage: 
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? NSString
        
        numRetweets = dictionary["retweet_count"] as! Int
        numFavorites = (dictionary["favourites_count"] as? Int) ?? 0
        
        //TO DO: make sure numFavorites is being grabbed from the API correctly
        
        let timeStampString = dictionary["created_at"] as? NSString
        
        
        if let timeStampString = timeStampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            creationDate = formatter.date(from: timeStampString as String)
        }
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
