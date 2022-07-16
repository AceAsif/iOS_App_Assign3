//
//  SettingViewController.swift
//  Stroke_Rehab_App
//
//  Created by Md Asif Iqbal on 27/4/2022.
//

import UIKit


class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    //These are for the text fields and picker view
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var repTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var dotTextField: UITextField!
    
    //These are for the switch buttons
    @IBOutlet weak var randomSwitch: UISwitch!
    @IBOutlet weak var nextSwitch: UISwitch!

    //These are for the custom radio buttons
    @IBOutlet weak var smallBtn: UIButton!
    @IBOutlet weak var mediumBtn: UIButton!
    @IBOutlet weak var largeBtn: UIButton!
    
    // get a handle to the defaults system
    let defaultSetting = UserDefaults.standard

    //These are for the random and indication settings
    var randomSwitchState: Bool = false
    var nextSwitchState: Bool = false
    
    //This is for the button size setting
    var buttonSize: String = "size"
    
    //This array will be used for both the number of repetitions and number of dots since they have the values.
    var repDotNumber = [
        "2",
        "3",
        "4",
        "5"
    ]
    
    /*Got hep from this source:
     *How to Load a Dictionary into a UIPickerView: https://stackoverflow.com/questions/35670825/how-to-load-a-dictionary-into-a-uipickerview
     */
    //This array will be used for the time limit values as tuples
    var timeLimitDict:[(time: Int, details: String)] = [
        (60 , "1 min"),
        (120 , "2 mins"),
        (300 , "5 mins"),
        (600 , "10 mins"),
        (900 , "15 mins")
    ]
    
    var repPickerView = UIPickerView()
    var timeLimitPickerView = UIPickerView()
    var dotPickerView = UIPickerView()
    
    var selectedRow = 0
    //This will refresh the page every time the user clicks on it.
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        nameTextField.text = defaultSetting.string(forKey: "UserName") ?? "Sonic" //This sets the username from the main page.
        
        /**Got help from these sources:
         *Pop Up Picker View Swift Xcode Tutorial - UIPickerView inside Alert Dialog: https://www.youtube.com/watch?v=9Fy0Gc1l3VE&ab_channel=CodeWithCal
         *selectedRow(inComponent:) : https://developer.apple.com/documentation/uikit/uipickerview/1614369-selectedrow
         *UIPickerView Index as Int: https://stackoverflow.com/questions/44641432/uipickerview-index-as-int
         ***These are for setting the selected row for the total number of repetitions when the user returns to this page and clicks the pickerView
         */
        let getPickerRepNumberRow = defaultSetting.integer(forKey: "PickerRepNumberRow")
        print("Total number of Repetitions PickerView row: \(getPickerRepNumberRow)")
        
        if getPickerRepNumberRow != 0 {
            //repTextField.text = String(getPickerRepNumberRow)
            repPickerView.selectRow(getPickerRepNumberRow, inComponent: 0, animated: false)
        }
        else{
            //repTextField.text = repDotNumber[0]
            repPickerView.selectRow(0, inComponent: 0, animated: false)
        }
        
        //This is for the time limit pickerView row of the game
        let getTimeLimitRow = defaultSetting.integer(forKey: "PickerTimeLimitRow")
        print("Time Limit picker row: \(getTimeLimitRow)")
        
        if getTimeLimitRow != 0 {
            timeLimitPickerView.selectRow(getTimeLimitRow, inComponent: 0, animated: false)
        }
        else{
            timeLimitPickerView.selectRow(0, inComponent: 0, animated: false)
        }
        
        //This is for the dot number pickerView row of the game
        let getPickerDotNumberRow = defaultSetting.integer(forKey: "PickerDotNumberRow")
        print("Total number of dots PickerView row: \(getPickerDotNumberRow)")
        
        if getPickerDotNumberRow != 0 {
            //repTextField.text = String(getPickerRepNumberRow)
            dotPickerView.selectRow(getPickerDotNumberRow, inComponent: 0, animated: false)
        }
        else{
            //repTextField.text = repDotNumber[0]
            dotPickerView.selectRow(0, inComponent: 0, animated: false)
        }
        
        //This is for the Randomisation switch
        let getRandomSwitchValue = defaultSetting.bool(forKey: "random")
        if getRandomSwitchValue == true
        {
            randomSwitch.setOn(true, animated: true)
            print("User turned on the randomisation")
        }
        else
        {
            randomSwitch.setOn(false, animated: true)
            print("User turned off the randomisation")
        }
        
        //This is for the Indication switch
        let getIndicateSwitchValue = defaultSetting.bool(forKey: "indicate")
        if getIndicateSwitchValue == true
        {
            nextSwitch.setOn(true, animated: true)
            print("User turned on the indication")
        }
        else
        {
            nextSwitch.setOn(false, animated: true)
            print("User turned off the indication")
        }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setImages() //This is for the radio button images.
        intialiseSettings() //This sets the settings for the user
        
    }
    
    //This function for initialising the settings for the user.
    func intialiseSettings()
    {
        /*Got Help from this source:
         * Multiple pickerview: https://www.youtube.com/watch?v=BTKhVkcezBk&ab_channel=PlanetVeracity
        */
        //These are the placeholder for the text input
        repTextField.placeholder = "Select repetitions"
        timeTextField.placeholder = "Select time limit"
        dotTextField.placeholder = "Select number of dots"
        
        //These are for placing the text in the center of the text input
        repTextField.textAlignment = .center
        timeTextField.textAlignment = .center
        dotTextField.textAlignment = .center
        
        /**
         ***These are selecting the first value of the pickerview
         */
        //This is for the total number of repetitions
        let getRepNum = defaultSetting.integer(forKey: "RepNumber")
        print("Total number of Repetitions: \(getRepNum)")
        
        if getRepNum != 0 {
            repTextField.text = String(getRepNum)
        }
        else{
            repTextField.text = repDotNumber[0]
        }
        
        //This is for the total number of dots
        let getDotNum = defaultSetting.integer(forKey: "DotNumber")
        print("Total number of dots: \(getDotNum)")
        
        if getDotNum != 0 {
            dotTextField.text = String(getDotNum)
        }
        else{
            dotTextField.text = repDotNumber[0]
        }
        
        //This is for the time limit of the game
        let getTimeLimitString = defaultSetting.string(forKey: "TimeLimitString")
        //Got help from this source: https://www.tutorialkart.com/swift-tutorial/how-to-get-the-type-of-variable-in-swift/
        print(type(of: getTimeLimitString)) //This helps to see the type of the variable.
        print("Time Limit: \(String(describing: getTimeLimitString))")
        
        if getTimeLimitString != nil {
            timeTextField.text = getTimeLimitString
        }
        else{
            timeTextField.text = timeLimitDict[0].details
        }
        
        /**
         ***These are setting the input from the pickerview
        */
        repTextField.inputView = repPickerView
        timeTextField.inputView = timeLimitPickerView
        dotTextField.inputView = dotPickerView
        
        /**
         ***These are getting the data for the pickerview
        */
        pickUp(repTextField)
        pickUp(timeTextField)
        pickUp(dotTextField)
        
        /**
         ***Tags for different pickerView since I am using multiple pickerview
        */
        repPickerView.tag = 1
        timeLimitPickerView.tag = 2
        dotPickerView.tag = 3
        
        //This is for the total number of repetitions
        /*let getRepNum = defaultSetting.integer(forKey: "RepNumber")
        print("Total number of Repetitions: \(getRepNum)")
        
        //This is for the total number of dots
        let getDotNum = defaultSetting.integer(forKey: "DotNumber")
        print("Total number of dots: \(getDotNum)")*/
        
        //This is for the button size of the game
        var getButtonSize = defaultSetting.string(forKey: "ButtonSize")
        if getButtonSize != nil {
            print("Button Size: \(getButtonSize ?? "small")")
        }
        else{
            getButtonSize = "small"
        }
        
        
        switch getButtonSize
        {
            
        case "small":
            self.smallBtn.isSelected = true
            self.setImages()
            print("Small size is selected")
            
        case "medium":
            self.mediumBtn.isSelected = true
            self.setImages()
            print("Medium size is selected")
            
        case "large":
            self.largeBtn.isSelected = true
            self.setImages()
            print("Large button is selected")
            
        default:
            print("No button is selected")
        }
        
        //This is for the Randomisation switch
        let getRandomSwitchValue = defaultSetting.bool(forKey: "random")
        if getRandomSwitchValue == true
        {
            randomSwitch.setOn(true, animated: true)
        }
        else
        {
            randomSwitch.setOn(false, animated: true)
        }
        
        //This is for the Indication switch
        let getIndicateSwitchValue = defaultSetting.bool(forKey: "indicate")
        if getIndicateSwitchValue == true
        {
            nextSwitch.setOn(true, animated: true)
        }
        else
        {
            nextSwitch.setOn(false, animated: true)
        }
    }
    
    func setImages()
    {
        /**Got help from this source:
            * Configuring and Displaying Symbol Images in Your UI: https://developer.apple.com/documentation/uikit/uiimage/configuring_and_displaying_symbol_images_in_your_ui/
         */
        // Create a custom symbol image using an asset in an asset catalog in Xcode.
        //These are the radio button images when they are not clicked
        let imageCircleSmall = UIImage(named: "radio_button_unchecked_small.png")
        let imageCircleMedium = UIImage(named: "radio_button_unchecked_medium.png")
        let imageCircleLarge = UIImage(named: "radio_button_unchecked_large.png")
        
        // Create a system symbol image.
        //These are the radio button images when they are  clicked
        //let imageCircleFill = UIImage(systemName: "circle.circle.fill")
        let imageCircleFillSmall = UIImage(named: "radio_button_checked_small.png")
        let imageCircleFillMedium = UIImage(named: "radio_button_checked_medium.png")
        let imageCircleFillLarge = UIImage(named: "radio_button_checked_large.png")
        
        //This is for setting the border of the radio buttons.
        /*smallBtn.layer.borderColor = UIColor.white.cgColor
        smallBtn.layer.borderWidth = 1.5
        
        mediumBtn.layer.borderColor = UIColor.white.cgColor
        mediumBtn.layer.borderWidth = 1.5
        
        largeBtn.layer.borderColor = UIColor.white.cgColor
        largeBtn.layer.borderWidth = 1.5*/

        // Do any additional setup after loading the view.
        smallBtn.setImage(imageCircleSmall, for:.normal)
        mediumBtn.setImage(imageCircleMedium, for:.normal)
        largeBtn.setImage(imageCircleLarge, for:.normal)
        
        smallBtn.setImage(imageCircleFillSmall, for:.selected)
        mediumBtn.setImage(imageCircleFillMedium, for:.selected)
        largeBtn.setImage(imageCircleFillLarge, for:.selected)
    }
    
    /*Got help from this source: https://iosdevcenters.blogspot.com/2017/05/uipickerview-example-with-uitoolbar-in.html
     *These function helps to dismiss the PickerView using a toolbar
     */
    func pickUp(_ textField : UITextField){

        /**
         ***UIPickerView
         */
        switch textField
        {
        case repTextField:
            //This is for the repetition picker view
            self.repPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
            self.repPickerView.delegate = self
            self.repPickerView.dataSource = self
            self.repPickerView.backgroundColor = UIColor.white
            textField.inputView = self.repPickerView
            
        case timeTextField:
            //This is for the time limit picker view
            self.timeLimitPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
            self.timeLimitPickerView.delegate = self
            self.timeLimitPickerView.dataSource = self
            self.timeLimitPickerView.backgroundColor = UIColor.white
            textField.inputView = self.timeLimitPickerView
            
        case dotTextField:
            //This is for the dot number picker view
            self.dotPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
            self.dotPickerView.delegate = self
            self.dotPickerView.dataSource = self
            self.dotPickerView.backgroundColor = UIColor.white
            textField.inputView = self.dotPickerView
            
        default:
            print("No text field has been pressed")
        }

        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()

        // Adding Button ToolBar
        //let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(SettingViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(SettingViewController.cancelClick))
        //toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.setItems([cancelButton, spaceButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar

    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch pickerView.tag {
        case 1:
            //This is for the rep number pickerview
            return repDotNumber.count
        case 2:
            //This is for the time limit pickerview
            return timeLimitDict.count
        case 3:
            //This is for the dot number pickerview
            return repDotNumber.count
        default:
            return 1
        }
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        switch pickerView.tag {
        case 1:
            //This is for the rep number pickerview
            return repDotNumber[row]
        case 2:
            //This is for the time limit pickerview
            return timeLimitDict[row].details
        case 3:
            //This is for the dot number pickerview
            return repDotNumber[row]
        default:
            return "Data not found!!"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        //historyTextField.text = historyData[row]
        //historyTextField.resignFirstResponder()
        
        switch pickerView.tag
        {
        case 1:
            //Got help for userdefault for pickerView from https://stackoverflow.com/questions/30647379/save-uipickerview-selection-to-nsuserdefaults-swift
            //This is for the rep number pickerview
            let repNumRow = row  //This is for the picker row number only and not the row value
            let repNum = repDotNumber[row] //This is for the picker row value only  and not the row number
            repTextField.text = repNum //Sets the value in the text field
            repTextField.resignFirstResponder() //Dismiss the picker view when the user selects something
            
            print("This is the value of pickerview for repetition \(repNum)")
            defaultSetting.set(repNum, forKey: "RepNumber") //This saves the picker row value only and not the row number
            
            print("This is the row number of pickerview for repetition: \(repNumRow)")
            defaultSetting.set(repNumRow, forKey: "PickerRepNumberRow") //This saves the picker row number only and not the row value
            
            showToast(message: "Settings Saved", font: UIFont(name:"Futura",size:20)!) //This creates a message to tell the user that the user input has been saved.
            
        case 2:
            //This is for the time limit pickerview
            let timeLimitRow = row //This is for the picker row number only and not the row value
            let timeLimit = timeLimitDict[row].time //This stores the integer value of the time
            let stringTimeLimit = timeLimitDict[row].details //This stores the string value of the time
            timeTextField.text = stringTimeLimit //Sets the value in the text field
            timeTextField.resignFirstResponder() //Dismiss the picker view when the user selects something but not the first option or default option
            
            print("Setting page time limit: \(stringTimeLimit)")
            defaultSetting.set(stringTimeLimit, forKey: "TimeLimitString") //This stores the integer value of the time for the setting page only.
            
            print("Game page time limit: \(timeLimit)")
            defaultSetting.set(timeLimit, forKey: "TimeLimit") //This stores the integer value of the time for the game pages
            
            print("Row number of pickerview for time limit: \(timeLimitRow)")
            defaultSetting.set(timeLimitRow, forKey: "PickerTimeLimitRow") //This saves the picker row number only and not the row value
            
            showToast(message: "Settings Saved", font: UIFont(name:"Futura",size:20)!)
            
        case 3:
            //This is for the dot number pickerview
            let dotNumRow = row //This is for the picker row number only and not the row value
            let dotNum = repDotNumber[row] //This is for the picker row value only  and not the row number
            dotTextField.text = dotNum //Sets the value in the text field
            dotTextField.resignFirstResponder() //Dismiss the picker view when the user selects something but not the first option or default option
             
            print("Value of pickerview for dot number: \(dotNum)")
            defaultSetting.set(dotNum, forKey: "DotNumber") //This saves the picker row value only and not the row number
            
            
            print("Row number of pickerview for dot number: \(dotNumRow)")
            defaultSetting.set(dotNumRow, forKey: "PickerDotNumberRow") //This saves the picker row number only and not the row value
            
            showToast(message: "Settings Saved", font: UIFont(name:"Futura",size:20)!)
            
        default:
            return
        }
    }
    
    // MARK: - TextFiled Delegate

    private func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(repTextField)
        self.pickUp(timeTextField)
        self.pickUp(dotTextField)
    }
    
    // MARK: - Button
    /*@objc func doneClick() {
        repTextField.resignFirstResponder()
        timeTextField.resignFirstResponder()
        dotTextField.resignFirstResponder()
      }*/
    @objc func cancelClick() {
        repTextField.resignFirstResponder()
        timeTextField.resignFirstResponder()
        dotTextField.resignFirstResponder()
      }
    
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
        
        // check
        print ("The name: \(checkUserName!) has been saved")
        
        showToast(message: "Name Saved", font: UIFont(name:"Futura",size:20)!)
    }
    
    /**Got help from this source: https://www.youtube.com/watch?v=sKkcGCzfIsg&ab_channel=SWIFTHubLearning
     *This function is for turning the randomisation of the game on and off
     */
    @IBAction func randomOnOff(_ sender: UISwitch)
    {
        if sender.isOn
        {
            randomSwitchState = true
            defaultSetting.set(randomSwitchState, forKey: "random") //This is for the dot game page only
            print("User turned on the randomisation")
            //showToast(message: "On", font: UIFont(name:"Futura",size:20)!)
            
            showToast(message: "Settings Saved", font: UIFont(name:"Futura",size:20)!)
        }
        else
        {
            randomSwitchState = false
            defaultSetting.set(randomSwitchState, forKey: "random")
            print("User turned off the randomisation")
            //showToast(message: "Off", font: UIFont(name:"Futura",size:20)!)
            
            showToast(message: "Settings Saved", font: UIFont(name:"Futura",size:20)!)
        }
    }
    
    @IBAction func nextOnOff(_ sender: UISwitch)
    {
        if sender.isOn
        {
            nextSwitchState = true
            defaultSetting.set(nextSwitchState, forKey: "indicate") //This is for the dot game page only
            print("User turned on the next button indication")
            //showToast(message: "On", font: UIFont(name:"Futura",size:20)!)
            
            showToast(message: "Settings Saved", font: UIFont(name:"Futura",size:20)!)
        }
        else
        {
            nextSwitchState = false
            defaultSetting.set(nextSwitchState, forKey: "indicate")
            print("User turned off the next button indication")
            //showToast(message: "Off", font: UIFont(name:"Futura",size:20)!)
            
            showToast(message: "Settings Saved", font: UIFont(name:"Futura",size:20)!)
        }
    }
    
    
    
    @IBAction func smallBtnAction(_ sender: UIButton)
    {
        //print(String(describing: smallBtn.state))
        if sender.isSelected{
            //smallBtn.setImage(imageCircle, for:.selected)
            //sender.isSelected = false
        } else{
            buttonSize = "small"
            
            smallBtn.isSelected = true
            mediumBtn.isSelected = false
            largeBtn.isSelected = false
            setImages()
            
            defaultSetting.set(buttonSize, forKey: "ButtonSize") //This saves button size to the userdefaults.
            
            showToast(message: "Settings Saved", font: UIFont(name:"Futura",size:20)!)
        }
        print(String(describing: smallBtn.state))
    }
    
    @IBAction func mediumBtnAction(_ sender: UIButton)
    {
        if sender.isSelected{
            //sender.isSelected = false
            //mediumBtn.setImage(imageCircle, for:.normal)
        } else{
            buttonSize = "medium"
            
            smallBtn.isSelected = false
            mediumBtn.isSelected = true
            largeBtn.isSelected = false
            setImages()
            
            defaultSetting.set(buttonSize, forKey: "ButtonSize") //This saves button size to the userdefaults.
            
            showToast(message: "Settings Saved", font: UIFont(name:"Futura",size:20)!)
        }
        print(String(describing: smallBtn.state))
    }
    
    @IBAction func largeBtnPressed(_ sender: UIButton)
    {
        //print(String(describing: smallBtn.state))
        /*sender.isSelected = true
        //largeBtn.setImage(imageCircleFill, for:.selected)
        print("Selected")*/
        
        if sender.isSelected{
            //sender.isSelected = false
            //mediumBtn.setImage(imageCircle, for:.normal)
        } else{
            buttonSize = "large"
            
            smallBtn.isSelected = false
            mediumBtn.isSelected = false
            largeBtn.isSelected = true
            setImages()
            
            defaultSetting.set(buttonSize, forKey: "ButtonSize") //This saves button size to the userdefaults.
            
            showToast(message: "Settings Saved", font: UIFont(name:"Futura",size:20)!)
        }
        print(String(describing: smallBtn.state))
        
    }
    
    //This is for the user actions
    /*@IBAction func saveButton(_ sender: UIButton)
    {
        // reading defaults
        /*let checkUserName = defaultSetting.string(forKey: "UserName")
        
        // check
        print ("The name: \(checkUserName!) has been saved")*/
        
        /**Got help from these sources:
         *Pop Up Picker View Swift Xcode Tutorial - UIPickerView inside Alert Dialog: https://www.youtube.com/watch?v=9Fy0Gc1l3VE&ab_channel=CodeWithCal
         *selectedRow(inComponent:) : https://developer.apple.com/documentation/uikit/uipickerview/1614369-selectedrow
         *UIPickerView Index as Int: https://stackoverflow.com/questions/44641432/uipickerview-index-as-int
         ***These are for setting the selected row for the total number of repetitions when the user returns to this page and clicks the pickerView
         */
        let getPickerRepNumberRow = defaultSetting.integer(forKey: "PickerRepNumberRow")
        print("Total number of Repetitions PickerView row: \(getPickerRepNumberRow)")
        
        if getPickerRepNumberRow != 0 {
            //repTextField.text = String(getPickerRepNumberRow)
            repPickerView.selectRow(getPickerRepNumberRow, inComponent: 0, animated: false)
        }
        else{
            //repTextField.text = repDotNumber[0]
            repPickerView.selectRow(0, inComponent: 0, animated: false)
        }
        
        //This is for the total number of repetitions
        let getRepNum = defaultSetting.integer(forKey: "RepNumber")
        print("Total number of Repetitions: \(getRepNum)")
        
        //This is for the total number of dots
        let getDotNum = defaultSetting.integer(forKey: "DotNumber")
        print("Total number of dots: \(getDotNum)")
        
        //This is for the time limit of the game
        let getTimeLimit = defaultSetting.integer(forKey: "TimeLimit")
        print("Time Limit: \(getTimeLimit)")
        
        //This is for the button size of the game
        let getButtonSize = defaultSetting.string(forKey: "ButtonSize")
        print("Button Size: \(getButtonSize!)")
        
        //This is for the Randomisation switch
        /*let getRandomSwitchValue = defaultSetting.bool(forKey: "random")
        if getRandomSwitchValue == true
        {
            randomSwitch.setOn(true, animated: true)
            print("User turned on the randomisation")
        }
        else
        {
            randomSwitch.setOn(false, animated: true)
            print("User turned off the randomisation")
        }
        
        //This is for the Indication switch
        let getIndicateSwitchValue = defaultSetting.bool(forKey: "indicate")
        if getIndicateSwitchValue == true
        {
            nextSwitch.setOn(true, animated: true)
            print("User turned on the indication")
        }
        else
        {
            nextSwitch.setOn(false, animated: true)
            print("User turned off the indication")
        }*/
        
        showToast(message: "Settings Saved", font: UIFont(name:"Futura",size:20)!)
    }*/
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

