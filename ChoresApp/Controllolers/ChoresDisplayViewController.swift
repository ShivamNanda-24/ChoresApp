//
//  ChoresDisplayViewController.swift
//  ChoresApp
//
//  Created by Shivam Nanda on 9/29/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class ChoresDisplayViewController: UIViewController {
    
    @IBOutlet weak var choresUIView: UIView!
    var callback: ((Chores) -> ())?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // error checking is always a good idea
        //  this properly unwraps the destination controller and confirms it's
        //  an instance of NewItemViewController
        if let vc = segue.destination as? AssignPageViewController {
            // callback is a property we added to NewItemViewController
            //  we declared it to return a String

            vc.callback = { item in
                
                self.navigationController?.popViewController(animated: true)
                self.callback?(item)
    
                
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.dismiss(animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
        {
            let touch = touches.first
            if touch?.view != self.choresUIView
            { self.dismiss(animated: true, completion: nil) }
        }
}
    

