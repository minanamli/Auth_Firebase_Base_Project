//
//  userViewController.swift
//  test
//
//  Created by Mina Namlı on 24.02.2022.
//

import UIKit
import FacebookLogin
import FBSDKCoreKit
import FacebookCore
import FirebaseAuth
import Firebase
import FacebookLogin


class userViewController: UIViewController, LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        self.performSegue(withIdentifier: "deneme12", sender: nil)
         
    }
    

    @IBOutlet weak var helloLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let token = AccessToken.current,
               !token.isExpired {
            let loginButton = FBLoginButton()
            loginButton.delegate = self
            loginButton.center = view.center
            view.addSubview(loginButton)
           }
    }
    

    
}
