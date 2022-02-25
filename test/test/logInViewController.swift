//
//  logInViewController.swift
//  test
//
//  Created by Mina Namlı on 18.02.2022.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseAuth
import Firebase
import FacebookCore
import FacebookLogin
import FacebookShare
import CryptoKit


class logInViewController: UIViewController {
    
    @IBOutlet weak var emailLoginText: UITextField!    
    @IBOutlet weak var passwordLoginText: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var signInButton: GIDSignInButton!
    //TODO: add validate google login responcer status
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        if ( emailLoginText.text != "" && passwordLoginText.text != ""){
            Auth.auth().signIn(withEmail: emailLoginText.text!, password: passwordLoginText.text!) { [weak self] authResult, error in
                guard self != nil else { return }}}
    }
    
    @IBAction func signInWithGoogle(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else{ return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            if error != nil {
                makeAlert(titleInput: "ERROR!", messageInput: error!.localizedDescription)
            }else{
                
            }

            guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                
                if let error = error {
                    self.makeAlert(titleInput: "ERROR!", messageInput: error.localizedDescription)
                }else{
                    print(authResult?.user.email)
/*                    let storyboard: UIStoryboard = UIStoryboard(name: "another", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "userViewController") as! userViewController
                    self.show(vc, sender: self)*/
                }
            }
        }
      }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput , message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default)
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
}

//    func showMessagePrompt(_ message: String) {
//       let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//       let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//       alert.addAction(okAction)
//       present(alert, animated: false, completion: nil)
//     }
//
//
//     func showTextInputPrompt(withMessage message: String,completionBlock: @escaping ((Bool, String?) -> Void)) {
//       let prompt = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//       let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in completionBlock(false, nil)
//       }
//}
