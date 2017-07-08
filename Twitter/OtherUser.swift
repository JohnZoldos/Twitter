//
//  User.swift
//  Twitter
//
//  Created by John Zoldos on 6/9/17.
//  Copyright © 2017 John Zoldos. All rights reserved.
//

import UIKit
import AlamofireImage

class OtherUser: NSObject {
    
    var name: String?
    var screenName: String?
    var profileUrl: NSURL?
    var tagline: NSString?
    var profileImage: UIImageView?
    var profileUrlBigger: NSURL?
    var bannerUrl: NSURL?
    var numTweets: Int?
    var numFollowers: Int?
    var numFollowing: Int?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary){
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        let bannerUrlString = dictionary["profile_banner_url"] as? String
        bannerUrl = NSURL(string: bannerUrlString!)
        let profileUrlString = dictionary["profile_image_url_https"] as? NSString
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString as String)
            profileUrlBigger = NSURL(string: profileUrlString.replacingOccurrences(of: "normal", with: "bigger"))
        }
        numTweets = dictionary["statuses_count"] as? Int
        numFollowers = dictionary["followers_count"] as? Int
        numFollowing = dictionary["friends_count"] as? Int
        tagline = dictionary["description"] as? NSString
        self.dictionary = dictionary
        
    }
    
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
     
     TwitterClient.sharedInstance?.getUserInfo(screenName: screenName!, success: { (info: NSDictionary) in
     var bannerImageURLString = info["profile_banner_url"]
     if bannerImageURLString == nil {
     bannerImageURLString = info["profile_background_image_url_https"]
     }
     bannerImageURL = NSURL(string: bannerImageURLString as! String)
     }, failure: { (error: Error) in
     print(error.localizedDescription)
     })

    }
    */

