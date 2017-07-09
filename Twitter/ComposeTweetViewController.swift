//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by John Zoldos on 7/3/17.
//  Copyright © 2017 John Zoldos. All rights reserved.
//

import UIKit
import AlamofireImage

class ComposeTweetViewController: UIViewController, UITextViewDelegate{
    
    var tweetID: String?
    var twitterHandleReplyingTo: String?
    
    @IBOutlet weak var characterCount: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var twitterHandle: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    
    
    
    
    @IBAction func tweetButtonAction(_ sender: UIButton) {
        var text: String?
        if(twitterHandleReplyingTo != nil){
            text = twitterHandleReplyingTo! + " " + textView.text
            TwitterClient.sharedInstance?.replyToTweet(id: tweetID!, text: text!, success: {
                self.view.endEditing(true)
                self.dismiss(animated: true)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })

        } else {
            text = textView.text
            TwitterClient.sharedInstance?.composeTweet(text: text!, success: {
                self.view.endEditing(true)
                self.dismiss(animated: true)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
        
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        dismiss(animated: true)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self as UITextViewDelegate
        textView.becomeFirstResponder()
        profilePicture.af_setImage(withURL: User.currentUser?.profileUrl as! URL)
        twitterHandle.text = ("@\(String(describing: User.currentUser?.screenName as! String))")
        username.text = User.currentUser?.name
    }

    func textViewDidChange(_ textView: UITextView) {
        let length = textView.text.characters.count
        let charRemaining = 140 - length
        characterCount.text = charRemaining.description
        if(charRemaining < 0) {
            tweetButton.alpha = 0.4
            tweetButton.isEnabled = false
        } else {
            tweetButton.alpha = 1.0
            tweetButton.isEnabled = true
        }
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
