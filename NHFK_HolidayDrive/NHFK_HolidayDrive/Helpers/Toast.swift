//
//  Toast.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/25/20.
//

import Foundation
import UIKit

extension UIViewController {

func showToast(message : String) {

    let toast = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
    toast.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toast.textColor = UIColor.white
    toast.font =  UIFont.systemFont(ofSize: 12.0)
    toast.textAlignment = .center;
    toast.text = message
    toast.numberOfLines = 0
    toast.alpha = 1.0
    toast.layer.cornerRadius = 10;
    toast.clipsToBounds  =  true
    UIApplication.shared.windows.first?.addSubview(toast)
    UIView.animate(withDuration: 5.0, delay: 0.3, options: .curveEaseOut, animations: {
         toast.alpha = 0.0
    }, completion: {(isCompleted) in
        toast.removeFromSuperview()
    })
} }
