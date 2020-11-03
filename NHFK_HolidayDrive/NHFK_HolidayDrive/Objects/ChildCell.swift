//
//  ChildCell.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 11/2/20.
//

import Foundation
import UIKit

class ChildCell: UITableViewCell{
    
    @IBOutlet weak var childNameAge: UILabel!
    @IBOutlet weak var program: UILabel!
    
    @IBOutlet weak var movie1: UILabel!
    
    @IBOutlet weak var movie2: UILabel!
    
    @IBOutlet weak var item1: UILabel!
    
    @IBOutlet weak var item2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
