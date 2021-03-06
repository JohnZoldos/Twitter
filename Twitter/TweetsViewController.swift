//
//  TweetsViewController.swift
//  Twitter
//
//  Created by John Zoldos on 6/9/17.
//  Copyright © 2017 John Zoldos. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "profile"), style: .done, target: self, action: #selector(TweetsViewController.profileButtonAction))
        rightBarButton.tag = -552
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
       // profileButton.tag = -552
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func profileButtonAction(){
        performSegue(withIdentifier: "ProfileViewSegue", sender: nil)
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
        cell.profileButton.tag = indexPath.row
        
        return cell

    }
    
    @IBAction func onLogOutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logOut()
    }

    
    
    
    // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Fly if you want to.")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let cell = sender as? UITableViewCell {
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets![indexPath!.row]
        
            let detailsViewController = segue.destination as! DetailsViewController
            detailsViewController.tweet = tweet
        } else if let button = sender as? UIButton{
            
                let indexPath = IndexPath(row: button.tag, section: 0)
                let cell = tableView.cellForRow(at: indexPath) as! TweetCell
                let profileViewController = segue.destination as! ProfileViewController
                profileViewController.screenname = cell.tweet.twitterHandle!
            
        } else {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.screenname = User._currentUser?.screenName
        }


    }
 
    
    

}
