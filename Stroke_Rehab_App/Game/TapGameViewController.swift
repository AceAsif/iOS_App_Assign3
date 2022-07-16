//
//  TapGameViewController.swift
//  Stroke_Rehab_App
//
//  Created by Md Asif Iqbal on 14/5/2022.
//

import UIKit

//MARK: - Remove the start time and End time

class TapGameViewController: UIViewController {

    // MARK: - IBOutet
    @IBOutlet weak var userNameTextField: UILabel!
    
    @IBOutlet weak var redDotBut: UIButton!
    
    @IBOutlet weak var blinkSlider: UISlider!
    
    @IBOutlet weak var timeSwtich: UISwitch!
    
    @IBOutlet weak var tapCounterText: UILabel!
    
    @IBOutlet weak var sonicPic: UIImageView!
    
    @IBOutlet weak var timerText: UILabel!
    
    @IBOutlet weak var timerIcon: UIImageView!
    
    @IBOutlet weak var feedbackText: UILabel!
    
    @IBOutlet weak var guideText: UILabel!
    
    @IBOutlet weak var gameNameText: UILabel!
    
    
    // MARK: - Variables
    //These are variable for tracking the tap.
    var count = 0
    var totalCount = 10
    var tapCount = 1 //tapCount was created because count starts from 0 but we want to count from 1. Therefore, tapCount stores the count value with plus (+) 1.
    var startGame = false
    
    var durationSpeed: Float = 0
    //For start Button
    var startClicked = false
    var blinkRateSlideable = true
    
    //These are for the clock
    var timer = Timer()
    var timeLimit = 60   //This is for the time limit of the tap game. It is always 1 min for the game so the value is set to 60 seconds.
    var clockRunning: Bool = false
    
    //These are for tracking the start time and end time
    var startTime = " " //This is the start time of the game
    var endTime = " " //This is the end time of the game
    var diffStart: Date? = nil
    var differ: Int = 0  //This saves the difference the start time and the end of the game.
    
    //These are for the time Mode switch
    var timeModeSwitchState: Bool = false
    
    //Game Mode of the game. By default the game is set to Goal Mode instead of Time Mode
    var gameMode = "Goal Mode"
    //For game is complete or not
    var gameStatus = "Incomplete"
    
   
    
    // get a handle to the defaults system
    let defaultSetting = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //These are the tab controller tab index
        let tabIndex = "GameIndex"
        defaultSetting.set(tabIndex, forKey: "TabIndexSelect")
        
        intialiseGame()
        makeDotButton()
        
    }
    
    // MARK: - Initialise Game func
    //These are the things that needs to be initialised and set when the game is started by the user
    func intialiseGame(){
        userNameTextField.text = defaultSetting.string(forKey: "UserName") ?? "Sonic" //This sets the username from the main page.
        
        blinkSlider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
        
        makeDotButton() //This makes the button into dot
        
        Blink() //This makes the blink animation.
    }
    
    // MARK: - Make Dot buttons
    func makeDotButton()
    {
        /*Got help from this source for circle buttons:
         * https://www.youtube.com/watch?v=dB14lZjW7ZU&ab_channel=AjayGandecha
         * https://nitishrajput912.medium.com/uibutton-programmatically-in-swift-8e64ea9573c2
         *These are for changing the button shapes to circle to make them look like dot
        */
        
        redDotBut.layer.cornerRadius = redDotBut.frame.width / 2
        redDotBut.layer.masksToBounds = true
    }
    
    // MARK: - Timer
    /*Got help from this source: https://www.youtube.com/watch?v=svq6_11_0ts&ab_channel=ShaunHalverson
     *This function is for timer of the game.
    */
    @objc func timerClass(){
        timeLimit -= 1 //For decreasing the time of the clock
        
        let time = secondsToMinutesSeconds(seconds: timeLimit) //Converting the time from seconds into minutes and seconds
        timerText.text = makeTimeString(minutes: time.0, seconds: time.1)
        
        if(timeLimit == 0){
            timer.invalidate()
            timerText.text = "Time: 00:00 min(s)"
            
            gameStatus = "Complete"
            //These are for the End time of the game
            let localDateFormatter = DateFormatter()
            localDateFormatter.dateStyle = .medium
            localDateFormatter.timeStyle = .medium

            // Printing a Date
            let dateEnd = Date()
            self.endTime = localDateFormatter.string(from: dateEnd) //This is the start time of the game
            /**Got help from this source:
             *Calculating the difference in hours between two dates in Swift: https://www.donnywals.com/calculating-the-difference-in-hours-between-two-dates-in-swift/
             * Calculating the difference between two dates in Swift: https://stackoverflow.com/questions/50950092/calculating-the-difference-between-two-dates-in-swift
            */
            self.differ = Calendar.current.dateComponents([.second], from: self.diffStart!, to: dateEnd).second!
            
            
            print("The end time: \(self.endTime)")
            print("The duration is \(self.differ)")
            print(type(of: self.differ)) //This shows the type of that specific variable whether it is a string or integer or something else.
            //saveTimeButton() //Saves the duration and button press of the game
            saveGameStatus() // This saves details to show in the game complete page.
            
            self.performSegue(withIdentifier: "TapGameCompleteSegue", sender: self) //This sends the user to the game complete page.
        }
    }
    
    //This stops the clock
    func pauseClock()
    {
        timer.invalidate()
    }
    
    //This starts the clock
    func startClock()
    {
        let time = secondsToMinutesSeconds(seconds: timeLimit)
        timerText.text = makeTimeString(minutes: time.0, seconds: time.1)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(DotGameViewController.timerClass), userInfo: nil, repeats: true)
    }
    
    /** Got help from this source: https://www.youtube.com/watch?v=3TbdoVhgQmE&t=11s&ab_channel=CodeWithCal
      *These functions are used for  clock of the game.
      **secondsToMinutesSeconds is for conversion of the seconds into  minutes and seconds
      ****makeTimeString is for making the the time into a format of String to display in the game.
     */
    func secondsToMinutesSeconds(seconds: Int) -> (Int, Int)
    {
        return ( ((timeLimit % 3600) / 60), (((timeLimit % 3600) % 60 % 3600) % 60) )
    }
    
    func makeTimeString(minutes: Int, seconds: Int) -> String
    {
        var timeString = "Time: "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        timeString += " min"
        
        return timeString
    }
    
    // MARK: - Feedback for Time Mode
    /**Got help from this source:
     *Switch case with range: https://stackoverflow.com/questions/52665744/switch-case-with-range
     */
    func feedBackForUser()
    {
        print("feedBackForUser count: \(count)")
        switch count
        {
        case 50..<100:
            feedbackText.isHidden = false
            feedbackText.text = "try harder"
        case 100..<150:
            feedbackText.isHidden = false
            feedbackText.text = "Not bad"
        case 150..<200:
            feedbackText.isHidden = false
            feedbackText.text = "Good effort"
        case 200..<250:
            feedbackText.isHidden = false
            feedbackText.text = "Awesome"
        case 250..<300:
            feedbackText.isHidden = false
            feedbackText.text = "Great"
        case 300..<350:
            feedbackText.isHidden = false
            feedbackText.text = "Best"
        case 350..<400:
            feedbackText.isHidden = false
            feedbackText.text = "Excellent"
        case 400..<500:
            feedbackText.isHidden = false
            feedbackText.text = "OMG!!"
        case 500..<600:
            feedbackText.isHidden = false
            feedbackText.text = "Superb"
        case 600..<999:
            feedbackText.isHidden = false
            feedbackText.text = "Super Saiyan"
        case 999..<1001:
            feedbackText.isHidden = false
            feedbackText.text = "Insane Speed"
        default:
            feedbackText.isHidden = true
        }
    }
    
    // MARK: - Reset the Game
    func resetGame()
    {
        //The game is not started
        startGame = false
        //Start is not clicked so it startClicked becomes false
        startClicked = false
        //Stop the animation
        stopBlink()
        //Stop the clock
        pauseClock()
        //Reset the clock to 60 seconds
        timeLimit = 60
        //Make the timer text back to 1 min
        let time = secondsToMinutesSeconds(seconds: timeLimit)
        timerText.text = makeTimeString(minutes: time.0, seconds: time.1)
        //Make the button count back to 0
        count = 0
        //Make the tapCount back to 0
        tapCount = 0
        //Update the text for the tap feedback
        tapCounterText.text = "Number of Taps: \(count) out of \(totalCount)"
        //Hide the feedback text which only for display when it is Time Mode
        feedbackText.isHidden = true
        //Notify the user to press the start button again.
        showToast(message: "Press Start", font: UIFont(name:"Futura",size:20)!)
        print("Game Start: \(startGame)")
    }
    
    // MARK: - Red Dot
    @IBAction func redButton(_ sender: UIButton)
    {
        switch gameMode
        {
        case "Time Mode":
            //This is for the Time Mode
            print("Game Mode: \(gameMode)")
            
            print("Game Start: \(startGame)")
            
            if (startGame == false)
            {
                showToast(message: "Press Start", font: UIFont(name:"Futura",size:20)!)
            }
            else
            {
                count += 1
                tapCounterText.text = "Number of Taps: \(count)"
                print("Count: \(count)")
                feedBackForUser() //Give feedback to the user for doing certain number of taps.
            }
            
        default:
            //This is for the Goal Mode
            print("Game Mode: \(gameMode)")
            
            print("Game Start: \(startGame)")
            
            blinkRateSlideable = true //Make the slider not clickable for the user.
            
            if (tapCount == (totalCount + 1) )
            {
                print("Inside if Count: \(count)")
                gameStatus = "Complete" //The game is complete since the user finished the 10 taps.
                stopBlink()
                tapCounterText.text = "Number of Taps: 10 out of \(totalCount)"
                
                //These are for the End time of the game
                let localDateFormatter = DateFormatter()
                localDateFormatter.dateStyle = .medium
                localDateFormatter.timeStyle = .medium
                
                // Printing a Date
                let dateEnd = Date()
                self.endTime = localDateFormatter.string(from: dateEnd) //This is the start time of the game
                
                self.differ = Calendar.current.dateComponents([.second], from: self.diffStart!, to: dateEnd).second!
                
                print("The end time: \(self.endTime)")
                print("The duration is \(self.differ)")
                print(type(of: self.differ)) //This shows the type of that specific variable whether it is a string or integer or something else.
                
                saveGameStatus() //Save data for Game Complete
                self.performSegue(withIdentifier: "TapGameCompleteSegue", sender: self)
            }
            else if (startGame == false)
            {
                showToast(message: "Press Start", font: UIFont(name:"Futura",size:20)!)
            }
            else
            {
                count += 1
                tapCount += 1
                tapCounterText.text = "Number of Taps: \(count) out of \(totalCount)"
                print("Count: \(count)")
                print("Total tap: \(totalCount)")
                print("Tap count: \(tapCount)")
            }
        }
    }
    
    // MARK: - Slider
    @IBAction func blinkSlider(_ sender: UISlider)
    {
        if blinkRateSlideable == false
        {
            print("Time mode")
            durationSpeed = 0
            showToast(message: "Only fast", font: UIFont(name:"Futura",size:20)!)

        }
        else {
            print("Not time mode")
            
            let value = sender.value
            switch value
            {
            case 0:
                print("Slide slow value: \(value)")
                blinkSlider.setThumbImage(UIImage(systemName: "hare.fill"), for: .normal)
            case 1:
                print("Slide slow value: \(value)")
                blinkSlider.setThumbImage(UIImage(systemName: "tortoise.fill"), for: .normal)
            default:
                print("Slide default value: \(value)")
                blinkSlider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
            }
            
            durationSpeed = value
            resetGame()
        }
        
    }
    
    // MARK: - Time Mode Switch
    @IBAction func timeSwitch(_ sender: UISwitch)
    {
        if sender.isOn
        {
            resetGame()
            timeModeSwitchState = true
            print("User turned on the time mode")
            
            gameMode = "Time Mode"
            print("Game Mode: \(gameMode)")

            timerText.isHidden = false
            timerIcon.isHidden = false
            
            //This is for setting the slider to fast mode and disabling it.
            /**Got help from these sources:
            *setThumbImage(_:for:) : https://developer.apple.com/documentation/uikit/uislider/1621336-setthumbimage
             *UISlider thumb image is hidden on sliding:  https://stackoverflow.com/questions/32963035/uislider-thumb-image-is-hidden-on-sliding
             */
            blinkSlider.value = 0
            durationSpeed = 0
            blinkRateSlideable = false //Make the slider not clickable for the user.
            blinkSlider.setThumbImage(UIImage(systemName: "hare.fill"), for: .normal)
            
            gameNameText.text = "Tap the Red Dot but Gotta Go Fast!"
            guideText.text = "Within 1 minute, tap the red dot as many times as possible. To initiate time mode, click the Start button. For Time Mode, the blink rate will be set to Fast and slider is disabled."
            tapCounterText.text = "Number of Taps: \(count)"
            
            showToast(message: "Time Mode", font: UIFont(name:"Futura",size:20)!)
        }
        else
        {
            resetGame()
            timeModeSwitchState = false
            print("User turned off the time Mode")
            gameMode = "Goal Mode"
            print("Game Mode: \(gameMode)")
            
            timerText.isHidden = true
            timerIcon.isHidden = true
            
            //This is for enabling the slider and allowing to the user to change the blink rate again.
            blinkRateSlideable = true //Make the slider not clickable for the user.
            blinkSlider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
            
            gameNameText.text = "Tap the Red Dot"
            guideText.text = "Tap the red dot 10 times with the same frequency at which Sonic blinks. Press the Start button to start the game."
            tapCounterText.text = "Number of Taps: \(count) out of \(totalCount)"
            
            showToast(message: "Goal Mode", font: UIFont(name:"Futura",size:20)!)
        }
    }
    
    
    // MARK: - Start Button
    @IBAction func startButton(_ sender: UIButton)
    {
        if(startClicked == true)
        {
            showToast(message: "Already Started", font: UIFont(name:"Futura",size:20)!)
        }
        else
        {
            startGame = true
            startClicked = true
            
            tapCount = 2
            Blink()
            startClock()
            print("Clock started")
            
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
        
    }
    
    // MARK: - Quit Button
    @IBAction func quitButton(_ sender: Any)
    {
        pauseClock() //Stop the clock
        stopBlink() // Stop the animation
        /*Got help from these source:
         * https://www.appsdeveloperblog.com/how-to-show-an-alert-in-swift/
         * https://blog.kulman.sk/changing-uialertaction-text-color/
        */
        // Create Alert
        let dialogMessage = UIAlertController(title: "Alert", message: "Are you sure you want to quit this game?", preferredStyle: .alert)
        // Create Yes button with action handler
        let yes = UIAlertAction(title: "Yes", style: .destructive, handler: { [self] (action) -> Void in
            print("Yes button tapped")
            /** Got help from this source: https://www.youtube.com/watch?v=btL9D2n41Hc&ab_channel=MohamedShehab
              * This is for going to the dot game page.
             */
            //These are for the End time of the game
            let localDateFormatter = DateFormatter()
            localDateFormatter.dateStyle = .medium
            localDateFormatter.timeStyle = .medium

            /**Got help from this source:
             *Calculating the difference in hours between two dates in Swift: https://www.donnywals.com/calculating-the-difference-in-hours-between-two-dates-in-swift/
             * Calculating the difference between two dates in Swift: https://stackoverflow.com/questions/50950092/calculating-the-difference-between-two-dates-in-swift
            */
            print("Quit start Game: \(startTime)")
            if startGame == true
            {
                // Printing a Date
                let dateEnd = Date()
                self.endTime = localDateFormatter.string(from: dateEnd) //This is the start time of the game
                
                self.differ = Calendar.current.dateComponents([.second], from: self.diffStart!, to: dateEnd).second!
                
                print("The end time: \(self.endTime)")
                print("The duration is \(self.differ)")
                print(type(of: self.differ)) //This shows the type of that specific variable whether it is a string or integer or something else.
            }
            
            self.saveGameStatus() //Saves everything if the user presses the quit instead of playing the game
            
            self.performSegue(withIdentifier: "TapGameCompleteSegue", sender: self) //This sends the user to the game complete page.
        })
        // Create No button with action handlder
        let no = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
            print("No button tapped")
            self.startClock() //Start the clock again if the user press "no" for quit
            self.Blink() //Start the animation again if the user press "no" for quit
        }
        //Add Yes and No button to an Alert object
        dialogMessage.addAction(yes)
        dialogMessage.addAction(no)
        // Present alert message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    
    // MARK: - Blink Animation
    /**Got help from these sources:
       *Blinking effect on UILabel: https://stackoverflow.com/questions/6224468/blinking-effect-on-uilabel
     *INFINITY in Swift Lang: https://stackoverflow.com/questions/24028450/infinity-in-swift-lang
     */
    func Blink()
    {
        
        let animation = CABasicAnimation(keyPath: "opacity")
            animation.isRemovedOnCompletion = false
        //For opacity, default fromValue is 1
            animation.fromValue           = 2
            animation.toValue             = 0
        //For speed, default duration = 0.8 so 1 is slow, 0.5 is medium and 0.2 is fast.
            animation.duration            = CFTimeInterval(durationSpeed)
            animation.autoreverses        = true
            //animation.repeatCount         = 3
            animation.repeatCount         = Float(Double.infinity)
            animation.beginTime           = CACurrentMediaTime() + 0.5
       
        print("Duration of animate: \(animation.duration)")
       
        if (startGame == true)
        {
            sonicPic.layer.add(animation, forKey: nil)
        }
    }
    
    
    /**Got help from this source:
     * How to blink an object continously till the app gets killed: https://stackoverflow.com/questions/32733117/how-to-blink-an-object-continuously-till-the-app-gets-killed
     *“Blinking effect on UILabel” Code Answer: https://www.codegrepper.com/code-examples/swift/Blinking+effect+on+UILabel
     */
    func stopBlink()
    {
        sonicPic.layer.removeAllAnimations()
        sonicPic.alpha = 1
    }
    
    // MARK: - Save data for Game Complete
    func saveGameStatus()
    {
        //For game status is complete or incomplete
        defaultSetting.set(gameStatus, forKey: "TapGameStatus")
        print("game status: \(gameStatus)")
        //For the game mode
        defaultSetting.set(gameMode, forKey: "TapGameMode")
        print("game mode: \(gameMode)")
        //For the start time
        defaultSetting.set(startTime, forKey: "TapStartTime")
        print("start time: \(startTime)")
        //For the end time
        defaultSetting.set(endTime, forKey: "TapEndTime")
        print("end time: \(endTime)")
        
        //For the button pressed
        if (startGame == true && gameMode == "Goal Mode" && gameStatus == "Complete")
        {
            count += 1
            print("Final Count: \(count)")
            defaultSetting.set(count, forKey: "TapButtons")
        }
        else
        {
            print("Final Count: \(count)")
            defaultSetting.set(count, forKey: "TapButtons")
        }
        
        //For the duration of the game
        defaultSetting.set(differ, forKey: "TapDuration")
        print("duration: \(differ)")
        
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

