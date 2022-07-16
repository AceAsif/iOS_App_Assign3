//
//  TapGameCompleteViewController.swift
//  Stroke_Rehab_App
//
//  Created by Md Asif Iqbal on 15/5/2022.
//

import UIKit

class TapGameCompleteViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UILabel!
    
    @IBOutlet weak var gameMode: UILabel!
    
    
    @IBOutlet weak var duration: UILabel!
    
    @IBOutlet weak var buttonTap: UILabel!
    
    @IBOutlet weak var sonicImage: UIImageView!
    
    // get a handle to the defaults system
    let defaultSetting = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //These are the tab controller tab index
        let tabIndex = "GameIndex"
        defaultSetting.set(tabIndex, forKey: "TabIndexSelect")
        
        intialiseText()
    }
    
    // MARK: - Initialise Game Complete Page text
    //These are the things that needs to be initialised and set when the game is started by the user
    func intialiseText(){
        userNameTextField.text = defaultSetting.string(forKey: "UserName") ?? "Sonic" //This sets the username from the main page.
        
        //This is for the game status whether the game is complete or not
        let getGameStatus = defaultSetting.string(forKey: "TapGameStatus")
        print("Game Status: \(String(describing: getGameStatus))")
        
        //This is for the game mode whether the game is goal mode or time mode
        let getGameMode = defaultSetting.string(forKey: "TapGameMode")
        print("Game Mode: \(getGameMode ?? "Goal Mode")")
        
        gameMode.text = defaultSetting.string(forKey: "TapGameMode") ?? "Goal Mode"
        
        //This is for the duration of the game. Like how long it take the user to finish the game.
        let getDuration = defaultSetting.integer(forKey: "TapDuration")
        print("Total Durations: \(getDuration)")
        
        switch getDuration
        {
        case 0:
            print("Duration is 0s")
            let timeSeconds = 0
            duration.text = "\(timeSeconds)s"
        case 59:
            print("Duration is 59s so it made to 60s")
            let timeSeconds = 60
            duration.text = "\(timeSeconds)s"
        default:
            print("Nothing special")
            let timeSeconds = getDuration
            duration.text = "\(timeSeconds)s"
        }
        
        
        //This is for the total number of button pressed by the user in the game
        let getTapButton = defaultSetting.integer(forKey: "TapButtons")
        print("Total button Press: \(getTapButton)")
        
        if getTapButton != 0 {
            buttonTap.text = "\(getTapButton)"
        }
        else{
            buttonTap.text = "0"
        }
        
        // MARK: - Setting the feedback image
        /*Got help from this source:
         *change image programmatically swift: https://developer.apple.com/forums/thread/6301
         */
        switch getGameMode
        {
        case "Time Mode":
            print("Time Mode")
            if (getGameStatus == "Complete" || getTapButton > 100)
            {
                sonicImage.image = UIImage(named: "Sonic_great_job")
            }
            else
            {
                sonicImage.image = UIImage(named: "Sonic_Try Again")
            }
        default:
            print("Goal Mode")
            if getGameStatus == "Complete"
            {
                sonicImage.image = UIImage(named: "Sonic_great_job")
            }
            else
            {
                sonicImage.image = UIImage(named: "Sonic_Try Again")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
