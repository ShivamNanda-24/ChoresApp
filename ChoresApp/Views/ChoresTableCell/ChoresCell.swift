//
//  ChoresCell.swift
//  ChoresApp
//
//  Created by Shivam Nanda on 9/2/22.
//

import UIKit

class ChoresCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var choreTask: UILabel!
    

    @IBOutlet weak var dateandTimeView: UIView!

    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var assignedImage: UIImageView!
    @IBOutlet weak var assignedToLabel: UILabel!
    var click = false
    
    @IBOutlet weak var chosenArea: UILabel!
    @IBOutlet weak var dateAndTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        dateandTimeView.layer.cornerRadius = 10
        dateandTimeView.layer.borderWidth = 0.5
        
    }

    @IBAction func onClick(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            checkBox.image = UIImage(systemName: "checkmark.circle")
        }
        else{
            sender.isSelected = true
            checkBox.image = UIImage(systemName: "circle")
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
