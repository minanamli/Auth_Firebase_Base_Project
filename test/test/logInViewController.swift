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



class logInViewController: UIViewController{
    
    @IBOutlet weak var emailLoginText: UITextField!    
    @IBOutlet weak var passwordLoginText: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var signInButton: GIDSignInButton!
    //TODO: add validate google login responcer status
    
    override func viewDidLoad() {
        super.viewDidLoad()
      }
    
    func showMessagePrompt(_ message: String) {
       let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
       let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
       alert.addAction(okAction)
       present(alert, animated: false, completion: nil)
     }

     
     func showTextInputPrompt(withMessage message: String,
                              completionBlock: @escaping ((Bool, String?) -> Void)) {
       let prompt = UIAlertController(title: nil, message: message, preferredStyle: .alert)
       let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
         completionBlock(false, nil)
       }
}
    
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        if ( emailLoginText.text != "" && passwordLoginText.text != ""){
            Auth.auth().signIn(withEmail: emailLoginText.text!, password: passwordLoginText.text!) { [weak self] authResult, error in
                guard self != nil else { return }}}
    }
    
    @IBAction func signInWithGoogle(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else{
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

            if error != nil {
            // ...
            return
          }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)
    
            Auth.auth().signIn(with: credential) { authResult, error in
                
                if let error = error {
                  let authError = error as NSError
                  if authError.code == AuthErrorCode.secondFactorRequired.rawValue {
                 
                    let resolver = authError
                      .userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                    var displayNameString = ""
                    for tmpFactorInfo in resolver.hints {
                      displayNameString += tmpFactorInfo.displayName ?? ""
                      displayNameString += " "}
            
                      self.showTextInputPrompt(
                      withMessage: "Select factor to sign in\n\(displayNameString)",
                      completionBlock: { userPressedOK, displayName in
                        var selectedHint: PhoneMultiFactorInfo?
                        for tmpFactorInfo in resolver.hints {
                          if displayName == tmpFactorInfo.displayName {
                            selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
                          }
                        }
                        PhoneAuthProvider.provider()
                          .verifyPhoneNumber(with: selectedHint!, uiDelegate: nil,
                                             multiFactorSession: resolver
                                               .session) { verificationID, error in
                            if error != nil {
                              print(
                                "Multi factor start sign in failed. Error: \(error.debugDescription)"
                              )
                            } else {
                              self.showTextInputPrompt(
                                withMessage: "Verification code for \(selectedHint?.displayName ?? "")",
                                completionBlock: { userPressedOK, verificationCode in
                                  let credential: PhoneAuthCredential? = PhoneAuthProvider.provider()
                                    .credential(withVerificationID: verificationID!,
                                                verificationCode: verificationCode!)
                                  let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator
                                    .assertion(with: credential!)
                                  resolver.resolveSignIn(with: assertion!) { authResult, error in
                                    if error != nil {
                                      print(
                                        "Multi factor finanlize sign in failed. Error: \(error.debugDescription)"
                                      )
                                    } else {
                                      self.navigationController?.popViewController(animated: true)
                                    }}})}}})
                  } else {
                    self.showMessagePrompt(error.localizedDescription)
                    return
                  }
                    return
                    
                }}}
    }
    
    
    @IBAction func signInAppleAc(_ sender: Any) {
    }
    
    
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput , message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default)
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)}

}
