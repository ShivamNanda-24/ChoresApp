//
//  CodeBoardViewController.swift
//  ChoresApp
//
//  Created by Shivam Nanda on 9/28/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore



class CodeBoardViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var houseCode: UILabel!
    @IBOutlet weak var newHouseCode: UITextField!
    let db = Firestore.firestore()
    var callback: ((HomeMembers) -> ())?
    var firstName = ""
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        //textField code

        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newHouseCode.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        if Auth.auth().currentUser != nil {
            let docRef = db.collection("UserDetails").document(Auth.auth().currentUser!.uid as String)
            docRef.getDocument { (querySnapshot, error) in
                if let e = error{
                    print(e)
                }
                else{
                    if let snapshot = querySnapshot {
                        self.houseCode.text = snapshot.get("houseCode") as? String
                       
                    }
                }
            }
        }
        

        // Do any additional setup after loading the view.
    }
    @objc func handleTap() {
        newHouseCode.resignFirstResponder()

        // dismiss keyoard
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        // Get the code
        let houseCodeAdded = newHouseCode.text!
        
        // get the  code database
        if Auth.auth().currentUser != nil {
            let docRefUserDetails = db.collection("UserDetails").document(Auth.auth().currentUser!.uid as String)
            docRefUserDetails.addSnapshotListener { (querySnapshot, error) in
                if let e = error{
                    print(e)
                }
                else{
                    if let snapshot = querySnapshot {
                        let oldHouseCode = snapshot.get("houseCode") as! String
                        self.firstName = snapshot.get("firstName") as! String
                        docRefUserDetails.updateData(["houseCode": houseCodeAdded])    // set house code as new code
                        let docRef = self.db.collection("Usergroups").document(houseCodeAdded)
                        docRef.addSnapshotListener { (querySnapshot, error) in
                            if let e = error{
                                print(e)
                            }
                            else{

                                // add as member
                                
                                let membersList = snapshot.get("Members")
                                docRef.updateData([
                                    "Members": FieldValue.arrayUnion([self.firstName])
                                ])


                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.callback?(HomeMembers(name: self.firstName, image: UIImage(named: "First")!))

                        
                            }
                   


                }
            }
        }
        
        
        
        
        
     
        
        // Dispatch asyn new for all 3
        
        
        
    
            self.dismiss(animated: true)
        
        
        
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
