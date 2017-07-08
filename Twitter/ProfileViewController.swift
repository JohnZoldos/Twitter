//
//  ProfileViewController.swift
//  Twitter
//
//  Created by John Zoldos on 7/5/17.
//  Copyright © 2017 John Zoldos. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var screenname: String?
    var tweets: [Tweet]!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    @IBOutlet weak var bannerView: UIImageView!
    /*@IBOutlet weak var tweetCellProfilePictureView: UIButton!
    @IBOutlet weak var tweetCellUsernameLabel: UILabel!
    @IBOutlet weak var tweetCellHandleLabel: UILabel!
    @IBOutlet weak var tweetCellTweetAgeLabel: UILabel!*/
    
    
    @IBAction func backButton(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true)
    }
    
    @IBAction func composeTweetButton(_ sender: UIButton) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    
        
        
        usernameLabel.layer.shadowRadius = 10
        profilePictureView.layer.cornerRadius = 5
        profilePictureView.clipsToBounds = true
        var user: OtherUser?
        TwitterClient.sharedInstance?.getUserInfo(screenName: (screenname?.replacingOccurrences(of: "@", with: ""))!, success: { (dict: NSDictionary) in
            user = OtherUser(dictionary: dict)
            self.usernameLabel.text = user?.name!
            self.profilePictureView?.af_setImage(withURL: user?.profileUrlBigger as! URL)
            let handle = "@" + (user?.screenName)!
            self.handleLabel.text = handle
            self.bannerView?.af_setImage(withURL: user?.bannerUrl as! URL)
            self.usernameLabel.layer.shadowRadius = 10
            self.addBlurEffect(view: (self.bannerView)!)
            self.numTweetsLabel.text = user?.numTweets?.description
            self.numFollowersLabel.text = user?.numFollowers?.description
            self.numFollowingLabel.text = user?.numFollowing?.description
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
        TwitterClient.sharedInstance?.userTimeline(screenName: self.screenname!, count: 20, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets![indexPath.row]
        //cell.profileButton.tag = indexPath.row
        return cell
        
    }
    
    func addBlurEffect(view: UIImageView)
    {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        blurEffectView.alpha = 0.7
        view.addSubview(blurEffectView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
