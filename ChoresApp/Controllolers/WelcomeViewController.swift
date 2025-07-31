//
//  WelcomeViewController.swift
//  ChoresApp
//
//  Created by Shivam Nanda on 9/15/22.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "DutyDo!"
        
        if UserDefaults.standard.bool(forKey: "LOGGEDIN")==true{
            
            self.performSegue(withIdentifier: "LandingToMain", sender: self)
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
