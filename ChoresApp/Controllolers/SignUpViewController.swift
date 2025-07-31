//
//  SignUpViewController.swift
//  ChoresApp
//
//  Created by Shivam Nanda on 9/15/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var houseCode: UITextField!
    let homeViewController = HomeViewController()
    
    let db = Firestore.firestore()
    var callback: ((HomeMembers) -> ())?
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//       if (segue.identifier == "SignUpToAvatar") {
//          let secondView = segue.destination as! UITabBarController
//           let navView = secondView.viewControllers![0] as! UINavigationController
//           let finalView = navView.viewControllers[0] as! HomeViewController
//
//          let object = sender as! HomeMembers
//           finalView.members.append(object)
//
//
//       }
//    }
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if UserDefaults.standard.bool(forKey: "LOGGEDIN")==true{
            self.performSegue(withIdentifier: "LogInToMain", sender: self)
            
        }
        textField.resignFirstResponder()
        return true
        
    }
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        let userGroupDocRef = self.db.collection("Usergroups")
        let userDetailsDocRef = self.db.collection("UserDetails")
        
        
        
        
        
        
        
        if let email = emailAddress.text , let password = passwordField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e)
                }else{
                    var houseSixDigitCode = self.houseCode.text
                    if self.houseCode.text == ""{
                        houseSixDigitCode = self.generateHouseCode()
                    }
                    
                    
                    
                    self.db.collection("UserDetails").document(Auth.auth().currentUser!.uid as String).setData([
                        "firstName" : self.firstName.text!,
                        "lastName" : self.lastName.text!,
                        "email" : self.emailAddress.text!,
                        "houseCode" : houseSixDigitCode!
                        
                    ])

                    
                    
                    self.checkHouseCode(houseCode: houseSixDigitCode!)
                    
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() ) {
                        
                        
//                        let member: HomeMembers = HomeMembers(name: self.firstName.text!, image: UIImage(named: "First")!)
                        self.performSegue(withIdentifier: "SignUpToAvatar", sender: self )
//                        self.callback?(HomeMembers(name: self.firstName.text!, image: UIImage(named: "First")!))
                        
                        
                    }
                    
                    
                    
                    
                    
                }
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstName.delegate = self
        self.lastName.delegate = self
        self.emailAddress.delegate = self
        self.passwordField.delegate = self
        self.houseCode.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap) // Add gesture recognizer to background view
        
        
    }
    
    @objc func handleTap() {
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        emailAddress.resignFirstResponder()
        passwordField.resignFirstResponder()
        houseCode.resignFirstResponder()
        // dismiss keyoard
    }
    
    func checkHouseCode(houseCode:String){
        
        
        let task = Tasks(nameofTask : "", assignedTo: [], dueDate: "", isCompleted: false,listOfRepeatDates: [],repeatEveryTime: ""  ,repeatEveryNumber: 0, startDate: "")
        
        
        let userGroups = db.collection("Usergroups").document(houseCode)
        userGroups.setData([firstName.text! : Auth.auth().currentUser!.uid as String])
        
        userGroups.collection("Members").getDocuments { snapshot, error in
            if ((snapshot?.isEmpty) == true){
                userGroups.collection("Members").document().setData([
                    
                    "IDofMember" : Auth.auth().currentUser!.uid as String,
                ])
                
            }
            else{
                userGroups.collection("Members").addDocument(data:[
                    
                    "IDofMember" : Auth.auth().currentUser!.uid as String,
                    
                ])
                
            }
        }
        
//        userGroups.collection("Tasks").getDocuments { snapshot, error in
//                
//                
//                userGroups.collection("Tasks").addDocument(data: [:])
//
//                        
//                        
//                        
//                    }
           }
            
  
            
          

                
                



    
    
            
            
    


        
        
        
    
    
    
    func generateHouseCode()->String{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map{ _ in letters.randomElement()! })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


public struct Tasks: Codable {


    let nameofTask: String
    let assignedTo: Array<String>?
    let dueDate: String?
    let isCompleted: Bool?
    let listOfRepeatDates : Array<String>
    let repeatEveryTime : String
    let repeatEveryNumber : Int
    let startDate:String

    enum CodingKeys: String, CodingKey {

        case nameofTask
        case assignedTo
        case dueDate
        case isCompleted
        case listOfRepeatDates
        case repeatEveryTime
        case repeatEveryNumber
        case startDate
        
    }

}
