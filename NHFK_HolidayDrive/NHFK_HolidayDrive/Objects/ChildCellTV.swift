//
//  ChildCellTV.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 12/3/20.
//

import UIKit

class ChildCellTV: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var program: UILabel!
    @IBOutlet weak var item1: UILabel!
    @IBOutlet weak var item2: UILabel!
    @IBOutlet weak var item3: UILabel!
    @IBOutlet weak var item4: UILabel!
    let dancingFont = UIFont(name: "DancingScript-SemiBold", size: 30)
    let writtenFont = UIFont(name: "Pleasewritemeasong", size: 20)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        name.font = dancingFont
        item1.font = writtenFont
        item2.font = writtenFont
        item3.font = writtenFont
        item4.font = writtenFont
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
