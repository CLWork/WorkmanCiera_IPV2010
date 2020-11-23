//
//  donateAmountVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 11/4/20.
//

import Foundation
import UIKit
import PassKit

class DonateAmountVC: UIViewController, PKPaymentAuthorizationControllerDelegate{
    
    @IBOutlet weak var donateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var donateAmountLabel: UILabel!
    @IBOutlet weak var donateSlider: UISlider!
    @IBOutlet weak var itemOne: UILabel!
    @IBOutlet weak var itemTwo: UILabel!
    @IBOutlet weak var itemThree: UILabel!
    @IBOutlet weak var itemFour: UILabel!
    
    
    var selectedChild: Child?
    var donateTitle = "Donate"
    var donateToTitle = "Donate To"
    var donationAmnt = 5
    
    let applePayBttn = PKPaymentButton(paymentButtonType: .donate, paymentButtonStyle: .black)
    let setUpBttn = PKPaymentButton(paymentButtonType: .setUp, paymentButtonStyle: .black)
    private var paymentRequest: PKPaymentRequest = {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.org.newhopeforkids.holidayDrive"
        request.supportedNetworks = [.visa, .masterCard]
        request.supportedCountries = ["US"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        return request
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        requestSetUp()
        
    }
    
    
    //Set custom font, labels as needed
    func setUp(){
        donateLabel.font = UIFont(name: "DancingScript-SemiBold", size: 45)
        
        donateAmountLabel.text = "$" + donationAmnt.description
        
        
        if(selectedChild != nil){
            let name = selectedChild!.getName() + ", " + selectedChild!.getAge().description
            donateLabel.text = donateToTitle
            nameLabel.text = name
            let interests = selectedChild!.getInterests()
            
            switch interests.count{
            case 1:
                itemOne.text = interests[0]
                itemTwo.text = ""
                itemThree.text = ""
                itemFour.text = ""
            case 2:
                itemOne.text = interests[0]
                itemTwo.text = interests[1]
                itemThree.text = ""
                itemFour.text = ""
            case 3:
                itemOne.text = interests[0]
                itemTwo.text = interests[1]
                itemThree.text = interests[2]
                itemFour.text = ""
            case 4:
                itemOne.text = interests[0]
                itemTwo.text = interests[1]
                itemThree.text = interests[2]
                itemFour.text = interests[3]
            default:
                itemOne.text = ""
                itemTwo.text = ""
                itemThree.text = ""
                itemFour.text = ""
                return
            }
            
        } else{
            donateLabel.text = donateTitle
            nameLabel.text = ""
        }
    }
    
    //sets up donate button
    func requestSetUp(){
        
        if PKPaymentAuthorizationController.canMakePayments(){
            
            if PKPaymentAuthorizationController.canMakePayments(usingNetworks: paymentRequest.supportedNetworks){
            applePayBttn.frame = CGRect(x: view.frame.width / 2 - 125, y: view.frame.height - 300, width: 250, height: 40)
            applePayBttn.bounds = CGRect(x: view.frame.width / 2 - 125, y: view.frame.height - 300, width: 250, height: 40)
            applePayBttn.clipsToBounds = true
            applePayBttn.addTarget(self, action: #selector(applePayTapped), for: .touchUpInside)
            view.addSubview(applePayBttn)
            } else {
                setUpBttn.frame = CGRect(x: view.frame.width / 2 - 90, y: view.frame.height - 300, width: 250, height: 40)
                setUpBttn.bounds = CGRect(x: view.frame.width / 2 - 90, y: view.frame.height - 300, width: 250, height: 40)
                setUpBttn.clipsToBounds = true
                setUpBttn.addTarget(self, action: #selector(openWalletSetUp), for: .touchUpInside)
                view.addSubview(applePayBttn)
            }
        }
    }
    
    //presents payment window
    @objc
    func applePayTapped(){
        
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Donation", amount: NSDecimalNumber(value: donationAmnt))]
        
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        self.present(applePayController!, animated: true, completion: nil)
    }
    
    @objc
    func openWalletSetUp(){
        let library = PKPassLibrary()
        library.openPaymentSetup()
    }
    
    //Update labels as slider changes - increments of $5
    @IBAction func sliderChanged(_ sender: UISlider) {
        donationAmnt = Int(sender.value) * 5
        donateAmountLabel.text = "$\(donationAmnt.description)"
        
    }
    
    //dismiss controller
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //tell the user their donation was successful. 
    func alertUser(){
        
        let alert = UIAlertController(title: "Thank You!", message: "We have recieved your donation of $\(donationAmnt)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Great!", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController!, didAuthorizePayment payment: PKPayment!, completion: ((PKPaymentAuthorizationStatus) -> Void)!) {
        completion(PKPaymentAuthorizationStatus.success)
        
        guard selectedChild != nil else{
            return
        }
        let currentT = selectedChild!.getTotal()
        let newT = currentT + donationAmnt
        selectedChild!.setTotal(t: newT)
        
      }
    
    
}
