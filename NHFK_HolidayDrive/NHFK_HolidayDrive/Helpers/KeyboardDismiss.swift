//
//  KeyboardDismiss.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 11/22/20.
//

import Foundation
import UIKit
extension UIViewController{
    
    func hideKeyboard(){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}

