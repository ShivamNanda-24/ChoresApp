//
//  HomeViewController.swift
//  ChoresApp
//
//  Created by Shivam Nanda on 8/31/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class HomeViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tasksLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addChoresButton: UIImageView!
    @IBOutlet weak var addMembersButton: UIImageView!
    @IBOutlet weak var noTaskAssigedImage: UIImageView!
    @IBOutlet weak var labelNoMembers: UILabel!
    
    let db = Firestore.firestore()
    
    var members:[HomeMembers] = []
    var chores: [Chores] = []
    var userCode : String = ""
    let today = Date()
    var allMyMembers:[String]=[]
    var addedMember = HomeMembers.self
    var firstNameDetail = ""
    var avatarDetail = " "
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChoresDisplayViewController {

            vc.callback = { item in
                self.noTaskAssigedImage.isHidden = true
                self.chores.insert(item, at: 0)
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                    
                    self.tasksLabel.text = "You have \(self.chores.count) tasks waiting for you"
                    
                    }
                self.navigationController?.popViewController(animated: true)
                
                
            }
        }
        if let vc = segue.destination as? CodeBoardViewController {
            vc.callback = { item in
                self.noTaskAssigedImage.isHidden = true
                self.viewWillAppear(true)
                
                    }
                
            }
        }
    
        
        

    
    @IBAction func onTappedAddMembers(_ sender: Any) {
    
        addMembersButton.alpha = 0.75
        UIView.animate(withDuration: 1.5) {
            self.addMembersButton.transform = CGAffineTransform(rotationAngle: 45)
        }

        
    }
    
    @IBAction func onTappedChoresPlus(_ sender: Any) {
        
        addChoresButton.alpha = 0.75
            UIView.animate(withDuration: 1.5) {
                self.addChoresButton.transform = CGAffineTransform(rotationAngle: 45)
               }
    }
    
    
    func getName(){
        if Auth.auth().currentUser != nil {

            let docRef = db.collection("UserDetails").document(Auth.auth().currentUser!.uid as String)
            docRef.getDocument { (querySnapshot, error) in
                if let e = error{

                    print(e)
                }
                else{
                    if let snapshot = querySnapshot {
                        self.nameLabel.text = "Hello, \(snapshot.get("firstName")!)"

                    }
                }
            }
        }
    }
    
    
    func getAll(){
        let todayFormatted = today.formatted(date: .long , time: .omitted)
        print(todayFormatted)
        if Auth.auth().currentUser != nil {
            
            let docsRef = db.collection("UserDetails").document(Auth.auth().currentUser!.uid as String)
            docsRef.addSnapshotListener { (querySnapshot, error) in
                if let e = error{
                    print(e)
                }
                else{
                    if let snapshot = querySnapshot {
                            self.userCode = snapshot.get("houseCode")! as! String
    
                        self.tasksLabel.text = "You have \(self.chores.count) tasks waiting for you"
                    }


                    let docRef = self.db.collection("Usergroups").document(self.userCode)
            docRef.addSnapshotListener { (querySnapshot, error) in
                if let e = error{
                    print(e)
                }
                else{
                    if let _ = querySnapshot {

                        
                    
                        self.db.collection("Usergroups").document(self.userCode).collection("Members").getDocuments() { (
                            snap, err) in
                            if UserDefaults.standard.bool(forKey: "LOGGEDIN")==true{
                                print("LOCNINSINISCNS")
//                                self.members = []
                            }
                            else{
//                                self.members = []
                                UserDefaults.standard.set(true,forKey: "LOGGEDIN")
                            }
                       
                            for docs in snap!.documents{
                                
                                
                                let memberID = docs.get("IDofMember")! as! String
                         
                                
                                self.db.collection("UserDetails").document(memberID).getDocument { snaps, errs in
                            
                                    if let e = err{
                                        print(e)
                                    }
                                    else{
                                        
                                        self.firstNameDetail = snaps!.get("firstName")! as! String
                                        self.avatarDetail = snaps!.get("avatar")! as! String
                                        
                                        print(self.avatarDetail)
                                    }
                                    self.members.append(HomeMembers(name: self.firstNameDetail, image: UIImage(named: self.avatarDetail)!))
                                    self.collectionView.reloadData()
                                }
                  
                               
                            }
                         

                        }

                        
                        
                        self.db.collection("Usergroups").document(self.userCode).collection("Tasks").getDocuments() { (
                            snap, err) in
                            
                            if ((snap?.isEmpty) == true){
                             
                                self.noTaskAssigedImage.isHidden = false
                            }
                            else{
                                self.chores = []
                                for docs in snap!.documents{
                                    
                                    
                                    let assignedToWho = docs.get("assignedTo")! as! Array<String>
                                    let completedYet  =  docs.get("isCompleted")! as! Bool
                                    let dueWhen  =  docs.get("dueDate")! as! String
                                    let nameOfTask =  docs.get("nameofTask")! as! String
                                    let dueDateArray = docs.get("repeatDatesArray") as! Array<String>
                                    let assignedToImage = docs.get("assignedToImage") as! Array<String>
                                    let chosenArea = docs.get("areaChosen") as! String
                                    let docId = docs.get("docId") as! String
                      
                                    if dueDateArray.contains(todayFormatted){
                 
                                        let indexOf = dueDateArray.firstIndex(of: todayFormatted)!
                                        
                                        let addingChores = Chores(taskName: nameOfTask , dueDate: dueWhen, assignedTo: HomeMembers(name: assignedToWho[indexOf % assignedToWho.count], image: assignedToImage[indexOf % assignedToImage.count].toImage()!), done: completedYet, area: chosenArea, docID: docId)
                                        self.chores.append(addingChores)
                                    }
                                }
                          
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
                                    self.tableView.reloadData()

                                    self.tasksLabel.text = "You have \(self.chores.count) tasks waiting for you"
                                }
                                
                            }
                        }


                            }
                        }

                    }

                }
            }
        }
    }
    
    
    
    override func viewDidLoad(){
        getName()
        getAll()
        
        if self.chores.count == 0{
                self.noTaskAssigedImage.isHidden = false
        }
        else{
            self.noTaskAssigedImage.isHidden = true
            labelNoMembers.isHidden = true
        }

                
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.tableView.reloadData()

            self.tasksLabel.text = "You have \(self.chores.count) tasks waiting for you"
        }
        
        
        self.tableView.allowsMultipleSelectionDuringEditing = false
        self.tabBarController?.navigationItem.hidesBackButton = true
        nameLabel.font = UIFont(name: "Inter-Bold", size: 44)
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ChoresCell", bundle: nil), forCellReuseIdentifier: "ChoresCell")
        collectionView.register(UINib(nibName: "UserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReusableCell")
        
   

   
      
 
        
    


            }

}

extension HomeViewController : UICollectionViewDataSource,UICollectionViewDelegate{
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell", for: indexPath) as! UserCollectionViewCell

//        self.labelNoMembers.isHidden = true
        cell.label.text = members[indexPath.row].name
        cell.avatar.image = members[indexPath.row].image
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        return chores.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.noTaskAssigedImage.isHidden = true
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoresCell", for: indexPath) as! ChoresCell
        
        cell.choreTask.text = chores[indexPath.row].taskName
        cell.dateAndTime.text = chores[indexPath.row].dueDate
        cell.assignedToLabel.text = chores[indexPath.row].assignedTo.name
        cell.assignedImage.image = chores[indexPath.row].assignedTo.image
        cell.chosenArea.text = chores[indexPath.row].area

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let todayFormatted = today.formatted(date: .long , time: .omitted)
        let done  = UIContextualAction(style: .normal, title: "Done", handler: { (action, view, completionHandler) in
            
            let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
            selectedCell.contentView.backgroundColor = UIColor(red: 0, green: 0.8, blue: 0, alpha: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                let taskDone = self.chores.remove(at: indexPath.row)
                if self.chores.count == 0{
                
                        self.noTaskAssigedImage.isHidden = false
                }
                else{
                    self.noTaskAssigedImage.isHidden = true
                }
                
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                
                
                self.db.collection("Usergroups").document(self.userCode).collection("Tasks").document(taskDone.docID).updateData([ "repeatDatesArray" : FieldValue.arrayRemove([todayFormatted])])
                    { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                selectedCell.contentView.backgroundColor = .clear
                self.tasksLabel.text = "You have \(self.chores.count) tasks waiting for you"
                
                self.tableView.reloadData()
            }
                                
                            
           
            completionHandler(true)
            
        })
       

        
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [done])
        return swipeConfig
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete  = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completionHandler) in
                let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        
            selectedCell.contentView.backgroundColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                let taskremoved = self.chores.remove(at: indexPath.row)
                if self.chores.count == 0{
                
                        self.noTaskAssigedImage.isHidden = false
                }
                else{
                    self.noTaskAssigedImage.isHidden = true
                }
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
     
                self.db.collection("Usergroups").document(self.userCode).collection("Tasks").document(taskremoved.docID).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                selectedCell.contentView.backgroundColor = .clear
                self.tasksLabel.text = "You have \(self.chores.count) tasks waiting for you"
                
                self.tableView.reloadData()
            }
            completionHandler(true)
    
        })
        let swipeConfig = UISwipeActionsConfiguration(actions: [delete])
        return swipeConfig
    }
    
}




