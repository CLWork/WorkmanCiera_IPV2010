//
//  SponsorDonateVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 11/4/20.
//

import Foundation
import UIKit
import PassKit

class DonatePageVC: UIViewController, PKPaymentAuthorizationControllerDelegate{
    
    @IBOutlet weak var donateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var amt25Bttn: UIButton!
    @IBOutlet weak var amt100Bttn: UIButton!
    @IBOutlet weak var amt500Bttn: UIButton!
    
    var donateAmount = 5
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
    
    //set font
    func setUp(){
        donateLabel.font = UIFont(name: "DancingScript-SemiBold", size: 50)
        amountLabel.text = "$\(donateAmount.description)"
        amt25Bttn.setTitleColor(.systemBlue, for: .selected)
        amt100Bttn.setTitleColor(.systemBlue, for: .selected)
        amt500Bttn.setTitleColor(.systemBlue, for: .selected)
        
    }
    
    //sets up donate button
    func requestSetUp(){
        
        if PKPaymentAuthorizationController.canMakePayments(){
            
            if PKPaymentAuthorizationController.canMakePayments(usingNetworks: paymentRequest.supportedNetworks){
            applePayBttn.frame = CGRect(x: view.frame.width / 2 - 125, y: view.frame.height - 200, width: 250, height: 40)
            applePayBttn.bounds = CGRect(x: view.frame.width / 2 - 125, y: view.frame.height - 200, width: 250, height: 40)
            applePayBttn.clipsToBounds = true
            applePayBttn.addTarget(self, action: #selector(applePayTapped), for: .touchUpInside)
            view.addSubview(applePayBttn)
            } else {
                setUpBttn.frame = CGRect(x: view.frame.width / 2 - 90, y: view.frame.height - 200, width: 250, height: 40)
                setUpBttn.bounds = CGRect(x: view.frame.width / 2 - 90, y: view.frame.height - 200, width: 250, height: 40)
                setUpBttn.clipsToBounds = true
                setUpBttn.addTarget(self, action: #selector(openWalletSetUp), for: .touchUpInside)
                view.addSubview(setUpBttn)
            }
        }
        
        //ALERNATIVE METHOD OF DONATION
    }
    
    //presents payment window
    @objc
    func applePayTapped(){
        
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Donation", amount: NSDecimalNumber(value: donateAmount))]
        
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        self.present(applePayController!, animated: true, completion: nil)
    }
    
    @objc
    func openWalletSetUp(){
        let library = PKPassLibrary()
        library.openPaymentSetup()
    }
    
    //dismiss controller
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donateBttnPressed(_ sender: UIButton) {
        amt25Bttn.tintColor = .darkGray
        amt100Bttn.tintColor = .darkGray
        amt500Bttn.tintColor = .darkGray
        
        switch sender.tag{
        case 0:
            amt25Bttn.isSelected = true
            amt100Bttn.isSelected = false
            amt500Bttn.isSelected = false
            amt25Bttn.tintColor = .systemBlue
            donateAmount = 25
            
        case 1:
            amt25Bttn.isSelected = false
            amt100Bttn.isSelected = true
            amt500Bttn.isSelected = false
            amt25Bttn.tintColor = .systemBlue
            donateAmount = 100
        case 2:
            amt25Bttn.isSelected = false
            amt100Bttn.isSelected = false
            amt500Bttn.isSelected = true
            amt500Bttn.tintColor = .systemBlue
            donateAmount = 500
        default:
            return
        }
        
        amountLabel.text = "$\(donateAmount.description)"
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        
        donateAmount = Int(slider.value) * 5
        amountLabel.text = "$\(donateAmount.description)"
        
    }
    //tell the user their donation was successful.
    func alertUser(amount: String){
        
        let alert = UIAlertController(title: "Thank You!", message: "We have recieved your donation of $\(amount)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Great!", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        //let paymentToken = payment.token
        
        self.dismiss(animated: true, completion: nil)
       
    }
    
}
