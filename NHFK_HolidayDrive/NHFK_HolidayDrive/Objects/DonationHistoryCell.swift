//
//  DonationHistoryCell.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 11/18/20.
//

import Foundation
import UIKit

class DonationHistoryCell: UITableViewCell{
    
    @IBOutlet var donationName: UILabel!
    @IBOutlet var donationAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
