//
//  SettingsViewController.swift
//  ShopingList
//
//  Created by David Kababyan on 02/04/2017.
//  Copyright © 2017 David Kababyan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var signOutButtonOutlet: UIButton!
    
    let currencyArray = ["€", "$", "£", "¥", "₽", "HKD", "CHF", "Kč", "kr", "﷼", "₪", "₩", "Ls", "₨", "﷼"]
    let currencyStringArray = ["EUR, €", "USD, $", "GBP, £", "CNY, ¥", "RUB, ₽", "HKD", "CHF", "CZK, Kč", "DKK, kr", "IRR, ﷼", "ILS, ₪", "KRW, ₩", "Lat, Ls", "Rupee, ₨", "QAR, ﷼"]

    var currencyPicker: UIPickerView!
    var currencyString = ""
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signOutButtonOutlet.layer.cornerRadius = 8
        signOutButtonOutlet.layer.borderWidth = 1
        signOutButtonOutlet.layer.borderColor = #colorLiteral(red: 0.1987636381, green: 0.7771705055, blue: 1, alpha: 1).cgColor


        currencyPicker = UIPickerView()
        currencyPicker.delegate = self
        currencyTextField.inputView = currencyPicker
        
        currencyTextField.delegate = self
        
    }
    
    
    //MARK: IBActions
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        
        self.view.endEditing(true)
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        
        cleanupFirebaseObservers()
        
        FUser.logOutCurrentUser { (success) in
            
            if success {
                
                let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcomeView")
                
                self.present(login, animated: true, completion: nil)
            }
        }

    }


    //MARK: PickerView dataSource functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        if pickerView == currencyPicker {
            
            return currencyStringArray.count
        } else {
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == currencyPicker {
            
            return currencyStringArray[row]
            
        }  else {
            return ""
        }
        
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == currencyPicker {
            
            currencyTextField.text = currencyArray[row]
        }
        
        saveSettings()
        updateUI()
    }
    
    //MARK: Save Settings
    
    func saveSettings() {
        
        userDefaults.set(currencyTextField.text!, forKey: kCURRENCY)
        userDefaults.synchronize()

    }



    //MARK: TextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == currencyTextField {
            if currencyString == "" {

                currencyString = currencyArray[0]
            }
            currencyTextField.text = currencyString
        }
    }
    
    //MARK: UpdateUI

    func updateUI() {
        
        currencyTextField.text = userDefaults.object(forKey: kCURRENCY) as? String
        currencyString = currencyTextField.text!
    }
    


}
