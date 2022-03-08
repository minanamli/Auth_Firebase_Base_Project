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
import FirebaseFirestore
import FirebaseDatabase
import FacebookLogin
import FacebookCore
import FacebookShare
import CryptoKit
import SnapKit
import SwiftUI


class logInViewController: UIViewController, LoginButtonDelegate {
   
    @IBOutlet weak var emailLoginText: UITextField!    
    @IBOutlet weak var passwordLoginText: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    //var
    var ref = Database.database().reference()
    
    var buttonTitle = "Mina"

    let myButton : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .gray
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        super.view.addSubview(myButton)
        myButton.setTitle(buttonTitle, for: .normal)
        myButton.backgroundColor = .lightGray
        myButton.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(super.view).inset(UIEdgeInsets(top: 570, left: 120, bottom: 280, right: 120))
        }
            
        myButton.addTarget(self, action: #selector(myButtonClicked), for: .touchUpInside)
        
        //fb login button
        let loginButton = FBLoginButton()
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
    
    @objc func myButtonClicked(myButton: UIButton, sender: Any) {
        self.performSegue(withIdentifier: "deneme", sender: nil)
    }
    
    //MARK: - fb delegate funcs
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if let error = error {
           print(error.localizedDescription)
           return
         }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        Auth.auth().signIn(with: credential) { authResult, error123 in
            if let error123 = error123 {
                print(error123.localizedDescription)
            }
            print(authResult?.user.email)
            self.performSegue(withIdentifier: "deneme", sender: nil)
            let uname = authResult?.user.displayName
            let uemail = authResult?.user.email
            self.uploadData(email: uemail, name: uname)
            print("baasarili")
            
        }

        func setupLoginButton() {
            loginButton.delegate = self
            loginButton.loginTracking = .limited
//            loginButton.nonce = sha256(nonce)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }

    //MARK: - custom login func

    @IBAction func loginButtonClicked(_ sender: Any) {

        if ( emailLoginText.text != "" && passwordLoginText.text != ""){
            Auth.auth().signIn(withEmail: emailLoginText.text!, password: passwordLoginText.text!) { [weak self] authResult, error in
                guard self != nil else { return }}}
    }
    
    //MARK: - google login deleggate func
    
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
                    makeAlert(titleInput: "ERROR!", messageInput: error.localizedDescription)
                }else{
                    print(authResult?.user.email)
                    self.performSegue(withIdentifier: "deneme", sender: nil)
                    let uname = authResult?.user.displayName
                    let uemail = authResult?.user.email
                    uploadData(email: uemail, name: uname)
                }
            }
        }
      }
    
    
    
    //MARK: - Helpers
    func showMessagePrompt(_ message: String) {
          let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
          let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
          alert.addAction(okAction)
          present(alert, animated: false, completion: nil)
        }
   
   
    func showTextInputPrompt(withMessage message: String,completionBlock: @escaping ((Bool, String?) -> Void)) {
          let prompt = UIAlertController(title: nil, message: message, preferredStyle: .alert)
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in completionBlock(false, nil)
          }}
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput , message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default)
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func uploadData(email: String?, name: String?){
        let db = FirebaseFirestore.Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        db.collection("users").document(uid!).setData(["email" : email,
                                                       "name"  : name,
                                                       "count" : 0]){ err in
            if let err = err {
                self.makeAlert(titleInput: "Error!", messageInput: err.localizedDescription)
            }}
        
    }
}
    
