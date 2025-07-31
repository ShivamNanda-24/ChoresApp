//
//  SelectMembersViewController.swift
//  ChoresApp
//
//  Created by Shivam Nanda on 10/12/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SelectMembersViewController: UIViewController {

    @IBOutlet weak var myTable: UITableView!


    
    var cricket = [HomeMembers]()
    var items = [HomeMembers]()
    var callback: ((Array<HomeMembers>) -> ())?
    let db = Firestore.firestore()
    var userCode : String = ""
    var firstname :String = ""
    var avatar : String = ""
    
    
    
    @IBAction func membersAddedClicked(_ sender: Any) {
        items.removeAll()
        if let selectedRows = myTable.indexPathsForSelectedRows
        {
            for indexpath in selectedRows{
                items.append(cricket[indexpath.row])
            }
        }
        
        callback?(items)
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            let docsRef = db.collection("UserDetails").document(Auth.auth().currentUser!.uid as String)
            docsRef.getDocument { (querySnapshot, error) in
                if let e = error{
                    print(e)
                }
                else{
                    if let snapshot = querySnapshot {
                        self.userCode = snapshot.get("houseCode") as! String
                        
                    }
                    
                    
                    
                    self.db.collection("Usergroups").document(self.userCode).collection("Members").getDocuments() { (
                        snap, err) in
                        for docs in snap!.documents{
                                
                                
                                let memberID = docs.get("IDofMember")! as! String
                         
                                
                                self.db.collection("UserDetails").document(memberID).getDocument { snaps, errs in
                            
                                    if let e = err{
                                        print(e)
                                    }
                                    else{
                                        
                                        self.firstname = snaps!.get("firstName")! as! String
                                        self.avatar = snaps!.get("avatar")! as! String
                                        
                                    
                                    }
                                    self.cricket.append(HomeMembers(name: self.firstname, image: UIImage(named: self.avatar)!))
                                    print(self.cricket.count)
                                    self.myTable.reloadData()
                                }
               
                        }
                        
                    }
//                    let docRef = self.db.collection("Usergroups").document(self.userCode)
//                    docRef.getDocument { (querySnapshot, error) in
//                        if let e = error{
//                            print(e)
//                        }
//                        else{
//                            if let snapshot = querySnapshot {
//                                let membersList = snapshot.get("Members") as! Array<String>
//                                self.cricket = membersList
//
//
//                                DispatchQueue.main.async {
//                                    self.myTable.reloadData()
//
//
//
//
//                                    }
//                            }
//
//                        }
//
//                    }
                    
                }
                
            }
        }
        // Do any additional setup after loading the view.
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
extension SelectMembersViewController: UITableViewDelegate, UITableViewDataSource{
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section:Int) -> String?
    {
        
      return "Select member(s)"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

        let headerView = UIView()
        headerView.addSubview(myLabel)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return cricket.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 40
        }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let resize = self.resizeImage(image: cricket[indexPath.row].image, targetSize: CGSizeMake(65.0, 65.0))
        
        cell.textLabel?.text = cricket[indexPath.row].name
        cell.imageView?.image = resize
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 30
        cell.clipsToBounds = true

        
        
        
        
        
    
        
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size:20)

  

        
        
        return cell
    
    }
    
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = myTable.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.blue
        selectedCell.textLabel?.textColor = UIColor.white
        
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = myTable.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.clear
        selectedCell.textLabel?.textColor = UIColor.black
       }
    
    
}
