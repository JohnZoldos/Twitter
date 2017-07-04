//
//  DetailsViewController.swift
//  Twitter
//
//  Created by John Zoldos on 7/2/17.
//  Copyright © 2017 John Zoldos. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var twitterHandle: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var numRetweets: UILabel!
    @IBOutlet weak var numFavorites: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    
    @IBAction func retweetButtonAction(_ sender: UIButton) {
        TwitterClient.sharedInstance?.isRetweeted(id: tweet.id!, success: { (retweetedCurrently: Bool) in
            if(retweetedCurrently){
                self.retweetButton.setImage(#imageLiteral(resourceName: "unretweeted"), for: .normal)
                self.tweet.numRetweets = self.tweet.numRetweets - 1
                self.numRetweets.text = self.tweet.numRetweets.description
                
            } else {
                TwitterClient.sharedInstance?.retweetTweet(id: self.tweet.id!, success: {
                    self.retweetButton.setImage(#imageLiteral(resourceName: "retweeted"), for: .normal)
                    self.tweet.numRetweets = self.tweet.numRetweets + 1
                    self.numRetweets.text = self.tweet.numRetweets.description
                }, failure: { (error: Error) in
                    print(error.localizedDescription)
                })
                
            }
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        TwitterClient.sharedInstance?.isFavorited(id: tweet.id!, success: { (favoritedCurrently: Bool) in
            if(favoritedCurrently){
                TwitterClient.sharedInstance?.unfavoriteTweet(id: self.tweet.id!, success: {
                    self.favoriteButton.setImage(#imageLiteral(resourceName: "unfavorited"), for: .normal)
                    self.tweet.numFavorites = self.tweet.numFavorites - 1
                    self.numFavorites.text = self.tweet.numFavorites.description
                }, failure: { (error: Error) in
                    print(error.localizedDescription)
                })
                
            } else {
                TwitterClient.sharedInstance?.favoriteTweet(id: self.tweet.id!, success: {
                    self.favoriteButton.setImage(#imageLiteral(resourceName: "favorited"), for: .normal)
                    self.tweet.numFavorites = self.tweet.numFavorites + 1
                    self.numFavorites.text = self.tweet.numFavorites.description
                }, failure: { (error: Error) in
                    print(error.localizedDescription)
                })
            }
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        setFavoriteImage()
        setRetweetImage()
        
        
        profilePicture.af_setImage(withURL: tweet.imageUrl!)
        profilePicture.layer.cornerRadius = 3
        profilePicture.clipsToBounds = true

        tweetText.text = tweet.text
        //timestamp.text = tweet.creationDate?.description
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy hh:mm a"
        timestamp.text = dateFormatterPrint.string(from: tweet.creationDate!)
        userName.text = tweet.userName!
        twitterHandle.text = (tweet.twitterHandle)!
        numRetweets.text = tweet.numRetweets.description
        numFavorites.text = tweet.numFavorites.description
        
        /*retweetButton.setImage(#imageLiteral(resourceName: "unretweeted"), for: .normal)
        favoriteButton.setImage(#imageLiteral(resourceName: "unfavorited"), for: .normal)
        numRetweetsLabel.text = tweet.numRetweets.description
        numFavoritesLabel.text = tweet.numFavorites.description*/

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setFavoriteImage(){
        TwitterClient.sharedInstance?.isFavorited(id: tweet.id!, success: { (favoritedCurrently: Bool) in
            if(favoritedCurrently){
                self.favoriteButton.setImage(#imageLiteral(resourceName: "favorited"), for: .normal)
                
            } else {
                self.favoriteButton.setImage(#imageLiteral(resourceName: "unfavorited"), for: .normal)
            }
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })

    }
    
    func setRetweetImage(){
        TwitterClient.sharedInstance?.isRetweeted(id: tweet.id!, success: { (retweetedCurrently: Bool) in
            if(retweetedCurrently){
                self.retweetButton.setImage(#imageLiteral(resourceName: "retweeted"), for: .normal)
                
            } else {
                self.retweetButton.setImage(#imageLiteral(resourceName: "unretweeted"), for: .normal)
            }
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ComposeTweetViewController
        destination.tweetID = tweet.id
        destination.twitterHandleReplyingTo = tweet.twitterHandle
        // Pass the selected object to the new view controller.
    }
    

}
