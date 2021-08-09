//
//  Listcell.swift
//  AssignmentProject
//
//  Created by iOS on 06/08/2021.
//

import UIKit

class Listcell: UITableViewCell {

    @IBOutlet weak var lbTitle:UILabel!
    @IBOutlet weak var lbDate:UILabel!
    @IBOutlet weak var lbBounting:UILabel!
    @IBOutlet weak var lbNotes:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
