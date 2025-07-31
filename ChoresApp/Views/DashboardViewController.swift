//
//  DashboardViewController.swift
//  ChoresApp
//
//  Created by Shivam Nanda on 1/3/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        

//        let nav = navigationController?

      
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "onBoarding") as! WelcomeViewController
        let nav1 = UINavigationController()
        let mainView = WelcomeViewController(nibName: nil, bundle: nil) //ViewController = Name of your controller
        nav1.viewControllers = [mainView]
        UIApplication.shared.windows.first?.rootViewController = nav1
        
        UIApplication.shared.windows.first?.makeKeyAndVisible()
//        do {
//          try Auth.auth().signOut()
//
//
//        } catch let signOutError as NSError {
//          print("Error signing out: %@", signOutError)
//        }
        
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
