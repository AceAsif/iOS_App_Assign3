//
//  FreeToPlayViewController.swift
//  Stroke_Rehab_App
//
//  Created by Md Asif Iqbal on 12/5/2022.
//

//These are for the database
import Firebase
import FirebaseFirestoreSwift

import UIKit
// MARK: - Need to edit this file.
// MARK: - Change the user default key since it conflicts with the dot game Goal mode.
class FreeToPlayViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UILabel!
    
    //Connecting the buttons with the storyboard.
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    
    //This is for the progress bar
    @IBOutlet weak var progreesBar: UIProgressView!
    var progressCount: Float = 0.0
    
    //These is for the repetition number
    var repNum = 0 //This stores the repetition number from the setting page.
    var repCount = 1 //This keeps track of the repetition of the game
    var count = 0 //This is for knowing when it is time to move to new repetition
    //This is for the number of dots
    var dotNum = 0

    //These for tracking the buttons
    var buttonCount:Int = 0  //This count is for both the correct and incorrect button presses.
    var correctBut:Int  = 0
    var wrongBut:Int = 0
    var button1Clicked: Bool = false
    var button2Clicked: Bool = false
    var button3Clicked: Bool = false
    var button4Clicked: Bool = false
    var button5Clicked: Bool = false
        
    //These are for saying that the button presses were done.
    var button1Done: Bool = false
    var button2Done: Bool = false
    var button3Done: Bool = false
    var button4Done: Bool = false
    var button5Done: Bool = false
    
    var listButtons: [String] = [] //This is an empty array to contain list of button press done by the user in the game. It will include both the correct and incorrect button presses.
    
    //This is for randomisation of the button
    var randomisationBut: Bool = false
        
    //These is for next button indication
    var indication: Bool = false
    var indicateCount = 0
    
    //These are for tracking the start time and end time
    var startTime = "12:00 am" //This is the start time of the game
    var endTime = "5:00 am" //This is the end time of the game
    var diffStart: Date? = nil
    var differ: Int = 0  //This saves the difference the start time and the end of the game.
        
    var quitGame:Bool = false //This is to tell the prohgrammer that the user wants to finish the game.
    var gameOver = "Incomplete" //This is for saying that the user completed the game or not
        
    // get a handle to the defaults system
    let defaultSetting = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intialiseGame()
        print("Total Buttons clicked: \(buttonCount)")
    }
    
    //These are the things that needs to be initialised and set when the game is started by the user
    func intialiseGame(){
        
        //These are the tab controller tab index
        let tabIndex = "GameIndex"
        defaultSetting.set(tabIndex, forKey: "TabIndexSelect")
        
        userNameTextField.text = defaultSetting.string(forKey: "UserName") ?? "Sonic" //This sets the username from the main page.

        //This is for the total number of repetitions
        let getRepNum = defaultSetting.integer(forKey: "RepNumber")
        //repetition.text = "Repetitions: 1/\(getRepNum)"
        print("Total number of Repetitions: \(getRepNum)")
        
        if getRepNum != 0 {
            repNum = getRepNum
        }
        else{
            repNum = 1
        }
        
        //This is for the total number of dots
        let getDotNum = defaultSetting.integer(forKey: "DotNumber")
        //print("Total number of dots: \(getDotNum)")
        
        if getDotNum != 0 {
            dotNum = getDotNum
            print("Total number of dots: \(dotNum)")
        }
        else{
            dotNum = 2
            print("Total number of dots: \(dotNum)")
        }
        
        switch dotNum
        {
        case 3:
            button1.isHidden = false
            button2.isHidden = false
            button3.isHidden = false
            button4.isHidden = true
            button5.isHidden = true
            print("Total number of dots: \(dotNum)")
            
        case 4:
            button1.isHidden = false
            button2.isHidden = false
            button3.isHidden = false
            button4.isHidden = false
            button5.isHidden = true
            print("Total number of dots: \(dotNum)")
           
        case 5:
            button1.isHidden = false
            button2.isHidden = false
            button3.isHidden = false
            button4.isHidden = false
            button5.isHidden = false
            print("Total number of dots: \(dotNum)")
            
        default:
            button1.isHidden = false
            button2.isHidden = false
            button3.isHidden = true
            button4.isHidden = true
            button5.isHidden = true
            print("Total number of dots: \(dotNum)")
        }

        //This is for the randomisation of the buttons
        let getRandomSwitchValue = defaultSetting.bool(forKey: "random")
        print("The randomisation: \(getRandomSwitchValue)")
        
        randomisationBut = getRandomSwitchValue
        if randomisationBut == true
        {
            randomButPos() //Call randomButPos() to place the buttons in random positions.
        }
        
        //This is for the Indication of the buttons
        let getIndicateSwitchValue = defaultSetting.bool(forKey: "indicate")
        print("The indication: \(getIndicateSwitchValue)")
        indication = getIndicateSwitchValue //This is for knowing if the user enabled the option for indication or not
        
        if indication == true
        {
            indicateCount = 1
            indicationBut()
            
            print("Indication is on")
        }
        else
        {
            print("Indication is off")
        }
        
        //This is for the progress bar
        progreesBar.progress = progressCount
        
        //These are for the buttons
        makeDotButton()
        
        //Got help from this source: https://www.advancedswift.com/local-utc-date-format-swift/
        //These are for the Start time of the game
        let localDateFormatter = DateFormatter()
        localDateFormatter.dateStyle = .medium
        localDateFormatter.timeStyle = .medium

        // Printing a Date
        let date = Date()
        //print(localDateFormatter.string(from: date))
        startTime = localDateFormatter.string(from: date) //This is the start time of the game
        diffStart = Date()
        print("The start time: \(startTime)")
        
    }
    
    //This is for changing the button Size using the setting from the Setting Page
    func butSize()
    {
        let getButtonSize = defaultSetting.string(forKey: "ButtonSize") ?? "Small"
        print("Button Size: \(getButtonSize)")
        
        switch getButtonSize
        {
        case "medium":
            print("Inside medium")
            //45 for small, 70 for medium, 90 for large
            button1.frame.size = CGSize(width: 70, height: 70)
            button2.frame.size = CGSize(width: 70, height: 70)
            button3.frame.size = CGSize(width: 70, height: 70)
            button4.frame.size = CGSize(width: 70, height: 70)
            button5.frame.size = CGSize(width: 70, height: 70)
            
        case "large":
            print("Inside large")
            //45 for small, 70 for medium, 90 for large
            button1.frame.size = CGSize(width: 90, height: 90)
            button2.frame.size = CGSize(width: 90, height: 90)
            button3.frame.size = CGSize(width: 90, height: 90)
            button4.frame.size = CGSize(width: 90, height: 90)
            button5.frame.size = CGSize(width: 90, height: 90)
            
        default:
            print("Inside default i.e small")
            //45 for small, 70 for medium, 90 for large
            button1.frame.size = CGSize(width: 45, height: 45)
            button2.frame.size = CGSize(width: 45, height: 45)
            button3.frame.size = CGSize(width: 45, height: 45)
            button4.frame.size = CGSize(width: 45, height: 45)
            button5.frame.size = CGSize(width: 45, height: 45)
        }
        
    }
    
    func makeDotButton()
    {
        /*Got help from this source for circle buttons:
         * https://www.youtube.com/watch?v=dB14lZjW7ZU&ab_channel=AjayGandecha
         * https://nitishrajput912.medium.com/uibutton-programmatically-in-swift-8e64ea9573c2
         *These are for changing the button shapes to circle to make them look like dot
        */
        //These are for the button size
        //45 for small, 70 for medium, 90 for large
        
        butSize() //This calls the function that changes the button size
        
        button1.layer.cornerRadius = button1.frame.width / 2
        button1.layer.masksToBounds = true
        //Setting border of UIButton
        button1.layer.borderColor = UIColor.black.cgColor
        button1.layer.borderWidth = 1.5
        
        button2.layer.cornerRadius = button2.frame.width / 2
        button2.layer.masksToBounds = true
        //Setting border of UIButton
        button2.layer.borderColor = UIColor.black.cgColor
        button2.layer.borderWidth = 1.5
        
        button3.layer.cornerRadius = button3.frame.width / 2
        button3.layer.masksToBounds = true
        //Setting border of UIButton
        button3.layer.borderColor = UIColor.black.cgColor
        button3.layer.borderWidth = 1.5
    
        button4.layer.cornerRadius = button4.frame.width / 2
        button4.layer.masksToBounds = true
        //Setting border of UIButton
        button4.layer.borderColor = UIColor.black.cgColor
        button4.layer.borderWidth = 1.5
        
        button5.layer.cornerRadius = button5.frame.width / 2
        button5.layer.masksToBounds = true
        //Setting border of UIButton
        button5.layer.borderColor = UIColor.black.cgColor
        button5.layer.borderWidth = 1.5
    }
    
    //This function is for indicating the next button for the user to press
    func indicationBut()
    {
        switch indicateCount
        {
        case 1:
            button1.backgroundColor = UIColor.red
        case 2:
            button2.backgroundColor = UIColor.red
        case 3:
            button3.backgroundColor = UIColor.red
        case 4:
            button4.backgroundColor = UIColor.red
        case 5:
            button5.backgroundColor = UIColor.red
        default:
            print("Indication is off")
        }
    }
    
    //This function saves the duration and button press of the game
    func saveTimeButton()
    {
        defaultSetting.set(differ, forKey: "FreeDurationSecond")
        defaultSetting.set(buttonCount, forKey: "FreeButtonPress")
    }
    
    //This function updates the repetition number and checks if the user reached the final repetition or not to call the gameComplete function.
    func updateRep()
    {
        print("Total count: \(count)")
        //if dotNum == buttonCount
        if dotNum == count
        {
            repCount += 1
            print("The repetition number in updateRep: \(repCount)")
            gameComplete()
        }
    }
    
    //gameComplete() is used for sending the user to DotGameComplete page or if the user didn't finish the game then start a new repetition
    func gameComplete()
    {
        print("Quit status: \(quitGame)")
        if (quitGame == true)
        {
            //let start = DispatchTime.now() // <<<<<< Start time
            print("complete Total Buttons clicked: \(buttonCount)")
            
            //These are for the End time of the game
            let localDateFormatter = DateFormatter()
            localDateFormatter.dateStyle = .medium
            localDateFormatter.timeStyle = .medium

            // Printing a Date
            let dateEnd = Date()
            endTime = localDateFormatter.string(from: dateEnd) //This is the start time of the game
            /**Got help from this source:
             *Calculating the difference in hours between two dates in Swift: https://www.donnywals.com/calculating-the-difference-in-hours-between-two-dates-in-swift/
             * Calculating the difference between two dates in Swift: https://stackoverflow.com/questions/50950092/calculating-the-difference-between-two-dates-in-swift
            */
            differ = Calendar.current.dateComponents([.second], from: diffStart!, to: dateEnd).second!

            
            
            print("The end time: \(endTime)")
            print("The duration is \(differ)")
            print(type(of: differ)) //This shows the type of that specific variable whether it is a string or integer or something else.
            
            saveTimeButton() //Saves the duration and button press of the game
            
            storeToDatabase() //This saves to the database.
            
            //Measure elapsed time in Swift: https://stackoverflow.com/questions/24755558/measure-elapsed-time-in-swift
            //let end = DispatchTime.now()   // <<<<<<   end time
            
            //let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
            //let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests

            //print("Time taken to run the game complete function: \(timeInterval) seconds")
            
            self.performSegue(withIdentifier: "FreeToPlayCompSegue", sender: self)
        }
        else
        {
            print("Time to reset the game for new repetition")
            resetGame()
        }
        
    }
    
    //This is for resetting the game for new repetition or next repetition
    func resetGame()
    {
        //buttonCount = 0
        count = 0 //This is for knowing when it is time to move to new repetition
        indicateCount = 1

        button1.backgroundColor =  UIColor.systemCyan
        button2.backgroundColor =  UIColor.systemCyan
        button3.backgroundColor =  UIColor.systemCyan
        button4.backgroundColor =  UIColor.systemCyan
        button5.backgroundColor =  UIColor.systemCyan
        
        //This is for tracking the user if they have pressed the wrong button or not
        button1Clicked = false
        button2Clicked = false
        button3Clicked = false
        button4Clicked = false
        button5Clicked = false
        
        //This is for saying that the button presses are not done in the next/new repetition.
        button1Done = false
        button2Done = false
        button3Done = false
        button4Done = false
        button5Done = false
        
        //This is for the progress bar.
        progressCount = 0
        progreesBar.setProgress(1, animated: false)
        
        print("Check for the indication option")
        if indication == true{
            indicationBut()
        }
        
        print("Check for the randomisation option")
        if randomisationBut == true
        {
            print("In reset Randomisation: \(randomisationBut)")
            randomButPos() //Call randomButPos() to place the buttons in random positions.
        }
        
        print("Button count: \(buttonCount)")
    }
    
    /**Got help from this source: https://developer.apple.com/documentation/uikit/uiprogressview/1619844-progress
     **/
    //This function is only called when there are only 3 dots. This is a special case. Since 3 dots make the progressCount = 0.3 which does not add up to 1 so it makes the progress bar not complete. This function will make the progress bar complete for the 3 dots.
    func but3progressBarComp()
    {
        print("3 dots so but3progressBarComp function has been called")
        
        if progressCount > Float(0.8) && dotNum == 3
        {
            print("Progress Value: \(progressCount)")
            progreesBar.setProgress(1, animated: false) //This makes the progress bar full. Since the max value of the progress bar is 1.
            print("Progress Bar is full now")
        }
        else
        {
            print("Inside the else statement of the progressCount for Button3")
            progreesBar.setProgress(progressCount, animated: false)
        }
    }
    
    //This function is for the progress bar to increase every time the user presses the buttons.
    func progressBarValue()
    {
        switch dotNum
        {
        case 3:
            print("Inside the special case of 0.3")
            progressCount += Float(1)/Float(3)
            print("Progress Value: \(progressCount)")
            print("Dot Num for progress: \(dotNum)")
        case 4:
            progressCount += 0.25
            print("Progress Value: \(progressCount)")
            print("Dot Num for progress: \(dotNum)")
        case 5:
            progressCount += 0.2
            print("Progress Value: \(progressCount)")
            print("Dot Num for progress: \(dotNum)")
        default:
            progressCount += 0.5
            print("Progress Value: \(progressCount)")
            print("Dot Num for progress: \(dotNum)")
        }
    }
    
    /*Got help from this source:
     *CGPoint: https://developer.apple.com/documentation/coregraphics/cgpoint
    */
    func randomButPos()
    {
        let randomNumAnimation = Int.random(in: 0..<5)
        switch randomNumAnimation
        {
        case 2:
            print("randomNumAnimation: \(randomNumAnimation)")
            //This is for moving the buttons
            UIView.animate(withDuration: 0.5, animations: {
            () in
                //These are notes for coordinates for placing the buttons
                //(0,0) is bad and y:800 makes the buttons touch the progress bar.
                //so for y, 350 is the save distance for buttons against the text and 750 is the save distance against the progress bar.
                //y:700 is better for the large buttons and maybe y: 400 is better for large buttons as well.
                //x : 350 is the save distance for the buttons against the right screen of the phone.
                //x : 50 is the save distance for the buttons against the left screen of the phone.
                let xPos = Int.random(in: 170..<300) //This is for the x coordinate.
                print("x-coord: \(xPos)")
                let yPos = Int.random(in: 350..<390) //This is for the y coordinate.
                print("y-coord: \(yPos)")
                
                self.button1.center = CGPoint(x: xPos, y: yPos) //This is for moving the button position.
                
                let xPos2 = Int.random(in: 50..<120) //This is for the x coordinate.
                print("x-coord2: \(xPos2)")
                let yPos2 = Int.random(in: 411..<440) //This is for the y coordinate.
                print("y-coord2: \(yPos2)")
                self.button2.center = CGPoint(x: xPos2, y: yPos2)
                
                let xPos3 = Int.random(in: 170..<300) //This is for the x coordinate.
                print("x-coord3: \(xPos3)")
                let yPos3 = Int.random(in: 461..<490) //This is for the y coordinate.
                print("y-coord3: \(yPos3)")
                self.button3.center = CGPoint(x: xPos3, y: yPos3)
                
                let xPos4 = Int.random(in: 50..<120) //This is for the x coordinate.
                print("x-coord4: \(xPos4)")
                let yPos4 = Int.random(in: 511..<540) //This is for the y coordinate.
                print("y-coord4: \(yPos4)")
                self.button4.center = CGPoint(x: xPos4, y: yPos4)
                
                let xPos5 = Int.random(in: 170..<300) //This is for the x coordinate.
                print("x-coord5: \(xPos5)")
                let yPos5 = Int.random(in: 561..<590) //This is for the y coordinate.
                print("y-coord5: \(yPos5)")
                self.button5.center = CGPoint(x: xPos5, y: yPos5)
            
            })
            
        case 3:
            print("randomNumAnimation: \(randomNumAnimation)")
            //This is for moving the buttons
            UIView.animate(withDuration: 0.5, animations: {
            () in
                //These are notes for coordinates for placing the buttons
                //(0,0) is bad and y:800 makes the buttons touch the progress bar.
                //so for y, 350 is the save distance for buttons against the text and 750 is the save distance against the progress bar.
                //y:700 is better for the large buttons and maybe y: 400 is better for large buttons as well.
                //x : 350 is the save distance for the buttons against the right screen of the phone.
                //x : 50 is the save distance for the buttons against the left screen of the phone.
                let xPos = Int.random(in: 50..<120) //This is for the x coordinate.
                print("x-coord: \(xPos)")
                let yPos = Int.random(in: 350..<400) //This is for the y coordinate.
                print("y-coord: \(yPos)")
                
                self.button1.center = CGPoint(x: xPos, y: yPos) //This is for moving the button position.
                
                let xPos2 = Int.random(in: 170..<300) //This is for the x coordinate.
                print("x-coord2: \(xPos2)")
                let yPos2 = Int.random(in: 411..<450) //This is for the y coordinate.
                print("y-coord2: \(yPos2)")
                self.button2.center = CGPoint(x: xPos2, y: yPos2)
                
                let xPos3 = Int.random(in: 50..<120) //This is for the x coordinate.
                print("x-coord3: \(xPos3)")
                let yPos3 = Int.random(in: 461..<500) //This is for the y coordinate.
                print("y-coord3: \(yPos3)")
                self.button3.center = CGPoint(x: xPos3, y: yPos3)
                
                let xPos4 = Int.random(in: 170..<300) //This is for the x coordinate.
                print("x-coord4: \(xPos4)")
                let yPos4 = Int.random(in: 511..<550) //This is for the y coordinate.
                print("y-coord4: \(yPos4)")
                self.button4.center = CGPoint(x: xPos4, y: yPos4)
                
                let xPos5 = Int.random(in: 50..<120) //This is for the x coordinate.
                print("x-coord5: \(xPos5)")
                let yPos5 = Int.random(in: 561..<600) //This is for the y coordinate.
                print("y-coord5: \(yPos5)")
                self.button5.center = CGPoint(x: xPos5, y: yPos5)
            
            })
            
        case 4:
            print("randomNumAnimation: \(randomNumAnimation)")
            //This is for moving the buttons
            UIView.animate(withDuration: 0.5, animations: {
            () in
                //These are notes for coordinates for placing the buttons
                //(0,0) is bad and y:800 makes the buttons touch the progress bar.
                //so for y, 350 is the save distance for buttons against the text and 750 is the save distance against the progress bar.
                //y:700 is better for the large buttons and maybe y: 400 is better for large buttons as well.
                //x : 350 is the save distance for the buttons against the right screen of the phone.
                //x : 50 is the save distance for the buttons against the left screen of the phone.
                let xPos = Int.random(in: 170..<300) //This is for the x coordinate.
                print("x-coord: \(xPos)")
                let yPos = Int.random(in: 360..<400) //This is for the y coordinate.
                print("y-coord: \(yPos)")
                
                self.button1.center = CGPoint(x: xPos, y: yPos) //This is for moving the button position.
                
                let xPos2 = Int.random(in: 50..<120) //This is for the x coordinate.
                print("x-coord2: \(xPos2)")
                let yPos2 = Int.random(in: 421..<470) //This is for the y coordinate.
                print("y-coord2: \(yPos2)")
                self.button2.center = CGPoint(x: xPos2, y: yPos2)
                
                let xPos3 = Int.random(in: 170..<300) //This is for the x coordinate.
                print("x-coord3: \(xPos3)")
                let yPos3 = Int.random(in: 471..<490) //This is for the y coordinate.
                print("y-coord3: \(yPos3)")
                self.button3.center = CGPoint(x: xPos3, y: yPos3)
                
                let xPos4 = Int.random(in: 50..<120) //This is for the x coordinate.
                print("x-coord4: \(xPos4)")
                let yPos4 = Int.random(in: 521..<560) //This is for the y coordinate.
                print("y-coord4: \(yPos4)")
                self.button4.center = CGPoint(x: xPos4, y: yPos4)
                
                let xPos5 = Int.random(in: 170..<300) //This is for the x coordinate.
                print("x-coord5: \(xPos5)")
                let yPos5 = Int.random(in: 571..<590) //This is for the y coordinate.
                print("y-coord5: \(yPos5)")
                self.button5.center = CGPoint(x: xPos5, y: yPos5)
            
            })
            
        case 5:
            print("randomNumAnimation: \(randomNumAnimation)")
            //This is for moving the buttons
            UIView.animate(withDuration: 0.5, animations: {
            () in
                //These are notes for coordinates for placing the buttons
                //(0,0) is bad and y:800 makes the buttons touch the progress bar.
                //so for y, 350 is the save distance for buttons against the text and 750 is the save distance against the progress bar.
                //y:700 is better for the large buttons and maybe y: 400 is better for large buttons as well.
                //x : 350 is the save distance for the buttons against the right screen of the phone.
                //x : 50 is the save distance for the buttons against the left screen of the phone.
                let xPos = Int.random(in: 50..<120) //This is for the x coordinate.
                print("x-coord: \(xPos)")
                let yPos = Int.random(in: 350..<400) //This is for the y coordinate.
                print("y-coord: \(yPos)")
                
                self.button1.center = CGPoint(x: xPos, y: yPos) //This is for moving the button position.
                
                let xPos2 = Int.random(in: 170..<300) //This is for the x coordinate.
                print("x-coord2: \(xPos2)")
                let yPos2 = Int.random(in: 411..<450) //This is for the y coordinate.
                print("y-coord2: \(yPos2)")
                self.button2.center = CGPoint(x: xPos2, y: yPos2)
                
                let xPos3 = Int.random(in: 50..<120) //This is for the x coordinate.
                print("x-coord3: \(xPos3)")
                let yPos3 = Int.random(in: 461..<500) //This is for the y coordinate.
                print("y-coord3: \(yPos3)")
                self.button3.center = CGPoint(x: xPos3, y: yPos3)
                
                let xPos4 = Int.random(in: 170..<300) //This is for the x coordinate.
                print("x-coord4: \(xPos4)")
                let yPos4 = Int.random(in: 511..<550) //This is for the y coordinate.
                print("y-coord4: \(yPos4)")
                self.button4.center = CGPoint(x: xPos4, y: yPos4)
                
                let xPos5 = Int.random(in: 50..<120) //This is for the x coordinate.
                print("x-coord5: \(xPos5)")
                let yPos5 = Int.random(in: 561..<600) //This is for the y coordinate.
                print("y-coord5: \(yPos5)")
                self.button5.center = CGPoint(x: xPos5, y: yPos5)
            
            })
            
        default:
            print("randomNumAnimation (default): \(randomNumAnimation)")
            //This is for moving the buttons
            UIView.animate(withDuration: 0.5, animations: {
            () in
                //These are notes for coordinates for placing the buttons
                //(0,0) is bad and y:800 makes the buttons touch the progress bar.
                //so for y, 350 is the save distance for buttons against the text and 750 is the save distance against the progress bar.
                //y:700 is better for the large buttons and maybe y: 400 is better for large buttons as well.
                //x : 350 is the save distance for the buttons against the right screen of the phone.
                //x : 50 is the save distance for the buttons against the left screen of the phone.
                let xPos = Int.random(in: 50..<120) //This is for the x coordinate.
                print("x-coord: \(xPos)")
                let yPos = Int.random(in: 350..<400) //This is for the y coordinate.
                print("y-coord: \(yPos)")
                
                self.button1.center = CGPoint(x: xPos, y: yPos) //This is for moving the button position.
                
                let xPos2 = Int.random(in: 170..<300) //This is for the x coordinate.
                print("x-coord2: \(xPos2)")
                let yPos2 = Int.random(in: 411..<450) //This is for the y coordinate.
                print("y-coord2: \(yPos2)")
                self.button2.center = CGPoint(x: xPos2, y: yPos2)
                
                let xPos3 = Int.random(in: 50..<120) //This is for the x coordinate.
                print("x-coord3: \(xPos3)")
                let yPos3 = Int.random(in: 461..<500) //This is for the y coordinate.
                print("y-coord3: \(yPos3)")
                self.button3.center = CGPoint(x: xPos3, y: yPos3)
                
                let xPos4 = Int.random(in: 170..<300) //This is for the x coordinate.
                print("x-coord4: \(xPos4)")
                let yPos4 = Int.random(in: 511..<550) //This is for the y coordinate.
                print("y-coord4: \(yPos4)")
                self.button4.center = CGPoint(x: xPos4, y: yPos4)
                
                let xPos5 = Int.random(in: 50..<120) //This is for the x coordinate.
                print("x-coord5: \(xPos5)")
                let yPos5 = Int.random(in: 561..<600) //This is for the y coordinate.
                print("y-coord5: \(yPos5)")
                self.button5.center = CGPoint(x: xPos5, y: yPos5)
            
            })
        }
        
    }
    
    @IBAction func button1Tap(_ sender: UIButton)
    {
        if (button1Done == true)
        {
            print("Button 1 pressed done and can't be pressed")
            
            let now = Date()
            let dtFormatter = DateFormatter()
            dtFormatter.dateFormat = "ss.SSS"
            let wrongClickTime1 = dtFormatter.string(from: now)
            print("[incorrect] Button1 -> \(wrongClickTime1) s")
            listButtons.append("[incorrect] Button1 -> \(wrongClickTime1) s") //This is for saving the button press time in the button list
            
            buttonCount += 1 //Both Correct and incorrect buttons press
            wrongBut += 1 //Only wrong button presses

            print("Wrong button is pressed")
            showToast(message: "Wrong Button", font: UIFont(name:"Futura",size:23)!)
        }
        else
        {
            button1Clicked = true
            sender.backgroundColor =  UIColor.green //This shows that the button has been pressed.
            button1Done = true //This tells the program that the user has clicked the button already.
            
            /**Got help from this source:
             *How To Format Date Time In Swift: https://www.datetimeformatter.com/how-to-format-date-time-in-swift/
             *Date & Time: https://iharishsuthar.github.io/posts/swift-date/
            */
            
            let now = Date()
            let dtFormatter = DateFormatter()
            dtFormatter.dateFormat = "ss.SSS"
            let clickTime1 = dtFormatter.string(from: now)
            print("Button1 -> \(clickTime1) s")
            listButtons.append("Button1 -> \(clickTime1) s") //This is for saving the button press time in the button list
            
            buttonCount += 1 //Both Correct and incorrect buttons press
            correctBut += 1 //Only for the correct button press
            
            count += 1 //This is for knowing when it is time to move to new repetition
            indicateCount += 1
            progressBarValue()
            progreesBar.setProgress(progressCount, animated: false)
            
            print("Indication count: \(indicateCount)")
            print("Button 1 was clicked")
            
            if indication == true{
                indicationBut()
            }
        }
    }
    
    @IBAction func button2Tap(_ sender: UIButton)
    {
        if(button1Clicked == false || button2Done == true)
        {
            print("Button 2 pressed done and can't be pressed")
            let now = Date()
            let dtFormatter = DateFormatter()
            dtFormatter.dateFormat = "ss.SSS"
            let wrongClickTime2 = dtFormatter.string(from: now)
            print("[Incorrect] Button2 -> \(wrongClickTime2) s")
            listButtons.append("[Incorrect] Button2 -> \(wrongClickTime2) s") //This is for saving the button press time in the button list
            
            buttonCount += 1 //Both Correct and incorrect buttons press
            wrongBut += 1 //Only wrong button presses
            print("Wrong button is pressed")
            showToast(message: "Wrong Button", font: UIFont(name:"Futura",size:23)!)
        }
        else
        {
            button2Clicked = true
            sender.backgroundColor =  UIColor.green //This shows that the button has been pressed.
            button2Done = true //This tells the program that the user has clicked the button already.
            
            let now = Date()
            let dtFormatter = DateFormatter()
            dtFormatter.dateFormat = "ss.SSS"
            let clickTime2 = dtFormatter.string(from: now)
            print("Button2 -> \(clickTime2) s")
            listButtons.append("Button2 -> \(clickTime2) s") //This is for saving the button press time in the button list
            
            buttonCount += 1 //Both Correct and incorrect buttons press
            correctBut += 1 //Only for the correct button press
            
            count += 1 //This is for knowing when it is time to move to new repetition
            indicateCount += 1
            progressBarValue()
            progreesBar.setProgress(progressCount, animated: false)
            
            
            print("Indication count: \(indicateCount)")
            print("Button 2 was clicked")
            
            if indication == true{
                indicationBut()
            }
            
            updateRep() //Check if it is time to move to the new repetition.
        }
    }
    
    @IBAction func button3Tap(_ sender: UIButton)
    {
        if(button2Clicked == false || button3Done == true)
        {
            print("Button 3 pressed done and can't be pressed")
            
            let now = Date()
            let dtFormatter = DateFormatter()
            dtFormatter.dateFormat = "ss.SSS"
            let wrongClickTime3 = dtFormatter.string(from: now)
            print("[incorrect] Button3 -> \(wrongClickTime3) s")
            listButtons.append("[incorrect] Button3 -> \(wrongClickTime3) s") //This is for saving the button press time in the button list
            
            buttonCount += 1 //Both Correct and incorrect buttons press
            wrongBut += 1 //Only wrong button presses

            print("Wrong button is pressed")
            showToast(message: "Wrong Button", font: UIFont(name:"Futura",size:23)!)
        }
        else
        {
            button3Clicked = true
            sender.backgroundColor =  UIColor.green //This shows that the button has been pressed.
            button3Done = true //This tells the program that the user has clicked the button already.
            
            let now = Date()
            let dtFormatter = DateFormatter()
            dtFormatter.dateFormat = "ss.SSS"
            let clickTime3 = dtFormatter.string(from: now)
            print("Button3 -> \(clickTime3) s")
            listButtons.append("Button3 -> \(clickTime3) s") //This is for saving the button press time in the button list
            
            buttonCount += 1 //Both Correct and incorrect buttons press
            correctBut += 1 //Only for the correct button press
            
            count += 1
            indicateCount += 1
            progressBarValue()
            print("In button 3 Progress Value: \(progressCount)")
            but3progressBarComp() //This calls the special function for completing the progress bar.
            
            
            print("Button 3 was clicked")
            print("The number of button count is \(buttonCount)")
            
            if indication == true{
                indicationBut()
            }
            
            updateRep()
        }
    }
    
    @IBAction func button4Tap(_ sender: UIButton)
    {
        if(button3Clicked == false || button4Done == true)
        {
            print("Button 4 pressed done and can't be pressed")
            let now = Date()
            let dtFormatter = DateFormatter()
            dtFormatter.dateFormat = "ss.SSS"
            let wrongClickTime4 = dtFormatter.string(from: now)
            print("[incorrect] Button4 -> \(wrongClickTime4) s")
            listButtons.append("[incorrect] Button4 -> \(wrongClickTime4) s") //This is for saving the button press time in the button list
            
            buttonCount += 1 //Both Correct and incorrect buttons press
            wrongBut += 1 //Only wrong button presses

            print("Wrong button is pressed")
            showToast(message: "Wrong Button", font: UIFont(name:"Futura",size:23)!)
        }
        else
        {
            button4Clicked = true
            sender.backgroundColor =  UIColor.green
            button4Done = true //This tells the program that the user has clicked the button already.
            
            let now = Date()
            let dtFormatter = DateFormatter()
            dtFormatter.dateFormat = "ss.SSS"
            let clickTime4 = dtFormatter.string(from: now)
            print("Button4 -> \(clickTime4) s")
            listButtons.append("Button4 -> \(clickTime4) s") //This is for saving the button press time in the button list
            
            buttonCount += 1 //Both Correct and incorrect buttons press
            correctBut += 1 //Only for the correct button press
            
            count += 1
            indicateCount += 1
            //progressCount += 0.3
            progressBarValue()
            progreesBar.setProgress(progressCount, animated: false)
            
            print("Button 4 was clicked")
            print("The number of button count is \(buttonCount)")
            
            if indication == true{
                indicationBut()
            }
            
            updateRep()
        }
    }
    
    @IBAction func button5Tap(_ sender: UIButton)
    {
        if(button4Clicked == false || button5Done == true)
        {
            print("Button 5 pressed done and can't be pressed")
            let now = Date()
            let dtFormatter = DateFormatter()
            dtFormatter.dateFormat = "ss.SSS"
            let wrongClickTime5 = dtFormatter.string(from: now)
            print("[incorrect] Button5 -> \(wrongClickTime5) s")
            listButtons.append("[incorrect] Button5 -> \(wrongClickTime5) s") //This is for saving the button press time in the button list
            
            buttonCount += 1 //Both Correct and incorrect buttons press
            wrongBut += 1 //Only wrong button presses

            print("Wrong button is pressed")
            showToast(message: "Wrong Button", font: UIFont(name:"Futura",size:23)!)
        }
        else
        {
            button5Clicked = true
            sender.backgroundColor =  UIColor.green
            button5Done = true //This tells the program that the user has clicked the button already.
            
            let now = Date()
            let dtFormatter = DateFormatter()
            dtFormatter.dateFormat = "ss.SSS"
            let clickTime5 = dtFormatter.string(from: now)
            print("Button5 -> \(clickTime5) s")
            listButtons.append("Button5 -> \(clickTime5) s") //This is for saving the button press time in the button list
            
            buttonCount += 1 //Both Correct and incorrect buttons press
            correctBut += 1 //Only for the correct button press
            
            count += 1
            indicateCount += 1
            progressBarValue()
            progreesBar.setProgress(progressCount, animated: false)
            
            print("Button 5 was clicked")
            print("The number of button count is \(buttonCount)")
            
            if indication == true{
                indicationBut()
            }
            
            updateRep()
        }
    }
    
    
    @IBAction func quitBut(_ sender: UIButton)
    {
        /*Got help from these source:
         * https://www.appsdeveloperblog.com/how-to-show-an-alert-in-swift/
         * https://blog.kulman.sk/changing-uialertaction-text-color/
        */
        // Create Alert
        let dialogMessage = UIAlertController(title: "Alert", message: "Are you sure you want to quit this game?", preferredStyle: .alert)
        // Create Yes button with action handler
        let yes = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) -> Void in
            print("Yes button tapped")
            //User has finished the game by clicking "Yes" button.
            self.quitGame = true
            print("Quit Status: \(self.quitGame)")

            self.gameComplete() //If the user clicks the "yes" then the game is complete so this function is called
            
        })
        // Create No button with action handlder
        let no = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
            print("No button tapped")
           
        }
        //Add Yes and No button to an Alert object
        dialogMessage.addAction(yes)
        dialogMessage.addAction(no)
        // Present alert message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    //This is for storing data into the database from the game
    func storeToDatabase()
    {
        /**Got help from this source:
         *How To Format Date Time In Swift: https://www.datetimeformatter.com/how-to-format-date-time-in-swift/
         *Date & Time: https://iharishsuthar.github.io/posts/swift-date/
         */
        
        let now = Date()
        
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "MMddyyyyHHmmss"
        
        let freeDatabaseID = dtFormatter.string(from: now)
        print("freeDatabaseID: \(freeDatabaseID)")
        
        defaultSetting.set(freeDatabaseID, forKey: "freeDatabseID") //This is for saving the DatabaseID to the userDefaults.
        
        //These are for the database
        let db = Firestore.firestore()
        print("\nINITIALIZED FIRESTORE APP \(db.app.name)\n")
        
        //This will create a collection if the collection does not exist already.
        let gameCollection = db.collection("iOS_free_to_play_history")
        
        //These are the things that are being saved in the Firebase.
        let attempt =
        ["id": freeDatabaseID,
         "startTime": startTime,
         "endTime": endTime,
         "durationOfGame": differ,
         "totalButtonClick": buttonCount,
         "correctButtonClick": correctBut,
         "wrongButtonClick": wrongBut,
         "buttonList": listButtons,
         "userPicture": ""
        ] as [String : Any]
        
        
        gameCollection.document(freeDatabaseID).setData(attempt)
        { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
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
