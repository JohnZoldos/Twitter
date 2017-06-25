//
//  TweetCell.swift
//  Twitter
//
//  Created by John Zoldos on 6/17/17.
//  Copyright © 2017 John Zoldos. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var twitterHandle: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var numRetweetsLabel: UILabel!
    @IBOutlet weak var numFavoritesLabel: UILabel!
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        
        favoriteButton.setImage(#imageLiteral(resourceName: "favorited"), for: .normal)
        tweet.numFavorites = tweet.numFavorites + 1
        numFavoritesLabel.text = tweet.numFavorites.description
    }
    
    @IBAction func retweetButtonAction(_ sender: UIButton) {
        retweetButton.setImage(#imageLiteral(resourceName: "retweeted"), for: .normal)
        tweet.numRetweets = tweet.numRetweets + 1
        numRetweetsLabel.text = tweet.numRetweets.description
    }

    
    var tweet: Tweet!{
        didSet{
            
            profilePicture.af_setImage(withURL: tweet.imageUrl!)
            tweetText.text = tweet.text
            creationDate.text = self.timeElapsedSinceTweet(tweetDate: (tweet.creationDate!))
            userName.text = tweet.userName!
            twitterHandle.text = (tweet.twitterHandle)!
            
            retweetButton.setImage(#imageLiteral(resourceName: "unretweeted"), for: .normal)
            favoriteButton.setImage(#imageLiteral(resourceName: "unfavorited"), for: .normal)
            numRetweetsLabel.text = tweet.numRetweets.description
            numFavoritesLabel.text = tweet.numFavorites.description
          
        }
    }
    
    func timeElapsedSinceTweet(tweetDate: Date) -> String {
        /*let currentDate = Date()
         let calendar = Calendar.current
         let hour = calendar.component(.hour, from: currentDate)
         let minutes = calendar.component(.minute, from: currentDate)
         
         if(date)*/
        let now = Date()
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.maximumUnitCount = 1   // often, you don't care about seconds if the elapsed time is in months, so you'll set max unit to whatever is appropriate in your case
        
        var string = formatter.string(from: tweetDate, to: now)
        string = string?.replacingOccurrences(of: " minutes", with: "m")
        string = string?.replacingOccurrences(of: " minute", with: "m")
        string = string?.replacingOccurrences(of: " seconds", with: "s")
        string = string?.replacingOccurrences(of: " second", with: "s")
        string = string?.replacingOccurrences(of: " days", with: "d")
        string = string?.replacingOccurrences(of: " day", with: "d")
        string = string?.replacingOccurrences(of: " hours", with: "h")
        string = string?.replacingOccurrences(of: " hour", with: "h")
        return string!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePicture.layer.cornerRadius = 3
        profilePicture.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
