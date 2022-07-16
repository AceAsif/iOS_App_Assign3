//
//  FreeToPlayCompleteViewController.swift
//  Stroke_Rehab_App
//
//  Created by Md Asif Iqbal on 12/5/2022.
//

//These are for the database
import Firebase
import FirebaseFirestoreSwift

import UIKit

class FreeToPlayCompleteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userNameTextField: UILabel!
    
    @IBOutlet weak var duration: UILabel!
    
    @IBOutlet weak var buttonPress: UILabel!
    
    @IBOutlet weak var freeImageView: UIImageView!
    
    var freeUserImageURL =  URL(string: "https://www.google.com/") //returns a valid URL
    
    // get a handle to the defaults system
    let defaultSetting = UserDefaults.standard
    
    //This is for gallery
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //These are the tab controller tab index
        let tabIndex = "GameIndex"
        defaultSetting.set(tabIndex, forKey: "TabIndexSelect")
        
        initialiseTextCom()
        
        //These are the image picker from the gallery
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
    }
    
    //This function set up the text for the user to see when he comes to the game complete page.
    func initialiseTextCom()
    {
        userNameTextField.text = defaultSetting.string(forKey: "UserName") ?? "Sonic" //This sets the username from both the main page and setting page.
        
        //This is for the duration of the game. Like how long it take the user to finish the game.
        let getDuration = defaultSetting.integer(forKey: "FreeDurationSecond")
        print("Total Durations: \(getDuration)")
        
        if getDuration != 0 {
            let timeSeconds = getDuration
            duration.text = "\(timeSeconds)s"
        }
        else{
            let timeSeconds = 0
            duration.text = "\(timeSeconds)s"
        }
        
        //This is for the total number of button pressed by the user in the game
        let getButtonPress = defaultSetting.integer(forKey: "FreeButtonPress")
        print("Total button Press: \(getButtonPress)")
        
        if getButtonPress != 0 {
            buttonPress.text = "\(getButtonPress)"
        }
        else{
            buttonPress.text = "0"
        }
    }
    
    
    //MARK: - Use gallery to select image
    /*Got help from this source:
     *https://www.youtube.com/watch?v=TAF6cPZxmmI&ab_channel=iOSAcademy
     *https://stackoverflow.com/questions/66031481/saving-a-reference-to-an-image-in-camera-roll-to-recall-later-in-app
     *https://mlog.club/article/5674295
     */
    func imagePickerController(_ picker: UIImagePickerController,                       didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        //This is for getting the database ID for updating it.
        let getFreeDatabaseID = defaultSetting.string(forKey: "freeDatabseID")
        
        print("getFreeDatabaseID!: \(getFreeDatabaseID!)")
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            freeImageView.image = image
            dismiss(animated: true, completion: nil)
            
            if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
                let freeImgName = imgUrl.lastPathComponent
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true).first
                let localPath = documentDirectory?.appending(freeImgName)
                
                let imageData = image.pngData()! as NSData
                imageData.write(toFile: localPath!, atomically: true)
                
                freeUserImageURL = URL.init(fileURLWithPath: localPath!)
                print("freeUserImageURL: \(freeUserImageURL!)")
                
                let urlString = freeUserImageURL!.absoluteString
                print("Download URL: \(urlString)")
                
                //This is for updating the dot game database with the user picture.
                //These are for the database
                let db = Firestore.firestore()
                print("\nINITIALIZED FIRESTORE APP \(db.app.name)\n")
                //This will create a collection if the collection does not exist already.
                let gameCollection = db.collection("iOS_free_to_play_history")
                
                gameCollection.document(getFreeDatabaseID!).updateData(["userPicture": urlString] as [String : Any]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func freeGalleryTap(_ sender: UIButton)
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            print("Galley available")
        }
        else
        {
            print("No galley available")
        }
        present(imagePicker, animated: true, completion: nil)
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
