//
//  ChooseAvatarViewController.swift
//  ChoresApp
//
//  Created by Shivam Nanda on 11/6/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
class ChooseAvatarViewController: UIViewController {


  
    
  

    @IBOutlet weak var image1: UIButton!
    @IBOutlet weak var image2: UIButton!
    @IBOutlet weak var image3: UIButton!
    
    @IBOutlet weak var image4: UIButton!
    
    @IBOutlet weak var image5: UIButton!
    @IBOutlet weak var image6: UIButton!
    @IBOutlet weak var image7: UIButton!
    
    @IBOutlet weak var image8: UIButton!
    @IBOutlet weak var image9: UIButton!
    var firstname:String = ""
    var houseCode:String = ""
    
    
    var didPress: Bool = false
    var avatars  = ["941","942","943"]
    var selected : Array<Any> =  []
    let db = Firestore.firestore()
    
    
  
    
    override func viewDidLoad() {
        
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(UINib(nibName: "AvatarCollectionViewCell", bundle: nil),

        // Do any additional setup after loading the view.
        
    }
    
    func circleBackground(didPress:Bool,buttonPressed:UIButton,imageName:String){
       print("alerted")
        let allImage = [image1,image2,image3,image4,image5,image6,image7,image8, image9]
        
        
        if didPress == true{
            
            selected.append(imageName)

                                
            buttonPressed.layer.borderWidth = 6
            buttonPressed.layer.cornerRadius = 50
            
   
            buttonPressed.layer.borderColor = CGColor(red: 0.03, green: 0.32, blue: 0.89, alpha: 1)
        }
        else{
            selected.remove(at: 0)
            for i in allImage{
        
                i?.layer.borderWidth = 0
                i?.layer.cornerRadius = 0
                i?.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
                }
        }

        
    }
    
    @IBAction func pressed_9(_ sender: Any) {
        didPress = !didPress
        circleBackground(didPress: didPress, buttonPressed: image9,imageName:"949")
    }
    @IBAction func pressed_8(_ sender: Any) {
        didPress = !didPress
        circleBackground(didPress: didPress, buttonPressed: image8,imageName:"948")
    }
    
    @IBAction func pressed_7(_ sender: Any) {
        didPress = !didPress
        circleBackground(didPress: didPress, buttonPressed: image7,imageName:"947")
    }
    
    @IBAction func pressed_6(_ sender: Any) {
        didPress = !didPress
        circleBackground(didPress: didPress, buttonPressed: image6,imageName:"946")
    }
    
    @IBAction func pressed_5(_ sender: Any) {
        didPress = !didPress
        circleBackground(didPress: didPress, buttonPressed: image5,imageName:"945")
    }
    
    
    @IBAction func pressed_4(_ sender: Any) {
        didPress = !didPress
        circleBackground(didPress: didPress, buttonPressed: image4,imageName:"944")
    }
    
    @IBAction func pressed_3(_ sender: Any) {
        didPress = !didPress
        circleBackground(didPress: didPress, buttonPressed: image3,imageName:"943")
    }
    
    @IBAction func pressed_2(_ sender: Any) {

        didPress = !didPress
        circleBackground(didPress: didPress, buttonPressed: image2,imageName:"942")
    }
    
    
    @IBAction func pressed_1(_ sender: Any) {

        didPress = !didPress
        circleBackground(didPress: didPress, buttonPressed: image1,imageName:"941")
    }
    
    @IBAction func proceedLetsGo(_ sender: Any) {
        
        if didPress == true{
            
            self.db.collection("UserDetails").document(Auth.auth().currentUser!.uid as String).updateData(
                ["avatar" : selected[0] as! String]
                
            )
            self.db.collection("UserDetails").document(Auth.auth().currentUser!.uid as String).getDocument { snap, err in
                if let e = err{

                    print(e)
                }
                else{
                    if let snapshot = snap {
                        self.firstname = snapshot.get("firstName")! as! String
                        self.houseCode = snapshot.get("houseCode")! as! String

                    }
                }
            }
            
            
            
            
    
            self.performSegue(withIdentifier: "AvatarToMain", sender: self )
        }
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


