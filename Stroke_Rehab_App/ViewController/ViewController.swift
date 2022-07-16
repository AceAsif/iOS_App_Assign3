//
//  ViewController.swift
//  Stroke_Rehab_App
//
//  Created by Md Asif Iqbal on 27/4/2022.
//

import UIKit
//import Firebase
//import FirebaseFirestoreSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    // get a handle to the defaults system
    let defaultSetting = UserDefaults.standard
    
    //This will refresh the page every time the user clicks on it.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.text = defaultSetting.string(forKey: "UserName") ?? "Sonic" //This sets the username from the main page.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //These are the tab controller tab index
        let tabIndex = "GameIndex"
        defaultSetting.set(tabIndex, forKey: "TabIndexSelect")
        
        //Loading the username if the username was saved before.
        nameTextField.text = defaultSetting.string(forKey: "UserName")
    }
    
    //Got help from this source: https://stackoverflow.com/questions/26288124/how-do-i-get-the-return-key-to-perform-the-same-action-as-a-button-press-in-swif
    @IBAction func nameEntered(_ sender: Any)
    {
        let userName = nameTextField.text!
        print("User typed \(nameTextField.text!)") //this is the line of code you should add to your project.
            //the other lines have been auto-generated for you.
        nameTextField.resignFirstResponder()
        
        //Saving the user from the user input by writing defaults.
        defaultSetting.set(userName, forKey: "UserName")
        
        // reading defaults
        let checkUserName = defaultSetting.string(forKey: "UserName")
        
        //showToast(message: "Name saved", font: .systemFont(ofSize: 12.0))
        //Got help for fonts from https://stackoverflow.com/questions/50978284/swift-4-set-custom-font-programmatically
        showToast(message: "Name saved", font: UIFont(name:"Futura",size:20)!)
        // check
        print ("The name: \(checkUserName!) has been saved")
    }
    
    
    

}

/** Got help from these sources:
  * How to create a toast message in Swift?: https://stackoverflow.com/questions/31540375/how-to-create-a-toast-message-in-swift
 *How to create Toast message in swift 4.2 iOS: https://www.youtube.com/watch?v=0M9g_w6MSiM&ab_channel=PushpendraSaini
  *These function is used to create toast messages when clicks on a button or perform a certain task*
 */
extension UIViewController {

    func showToast(message : String, font: UIFont)
    {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.orange.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}


