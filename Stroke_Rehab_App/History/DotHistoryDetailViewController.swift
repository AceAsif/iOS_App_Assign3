//
//  DotHistoryDetailViewController.swift
//  Stroke_Rehab_App
//
//  Created by Md Asif Iqbal on 15/5/2022.
//

//also add these lines to the top of your file
import Firebase
import FirebaseFirestoreSwift
//import FirebaseStorage

import UIKit

class DotHistoryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonListCell", for: indexPath)
        
        if let ButtonListCell = cell as? ButtonListTableViewCell
        {
            ButtonListCell.buttonListText?.text = buttonList[indexPath.row]

        }
            
            return cell
    }
    
    @IBOutlet weak var searchImageText: UILabel!
    
    @IBOutlet weak var gameStatus: UILabel!
    
    @IBOutlet weak var correctButPress: UILabel!
    
    @IBOutlet weak var wrongButPress: UILabel!
    
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var repetition: UILabel!
    
    @IBOutlet weak var duration: UILabel!
    
    @IBOutlet weak var totalButPress: UILabel!
    
    @IBOutlet weak var buttonTableView: UITableView!
    
    @IBOutlet weak var dotUserPic: UIImageView!
    
    @IBOutlet weak var spinnerLoading: UIActivityIndicatorView!
    
    var dotData: GameData?
    var dotDataIndex: Int?
    
    var buttonList = [String]()
    
    var dotUserPicURL = "" //This is for the image path
    
    var shareDotData = "" //This is for sharing
    
    
    // get a handle to the defaults system
    let defaultSetting = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //These are the tab controller tab index
        let tabIndex = "HistoryIndex"
        defaultSetting.set(tabIndex, forKey: "TabIndexSelect")
        
        if let displayDotData = dotData
        {
            print("Inside the displayDotData")
            dotUserPicURL = "\(displayDotData.userPicture)" //Extra for getting the picture
            gameStatus.text = displayDotData.gameStatus
            correctButPress.text = "\(displayDotData.correctButtonClick)"
            wrongButPress.text = "\(displayDotData.wrongButtonClick)"
            startTime.text = displayDotData.startTime
            endTime.text = displayDotData.endTime
            repetition.text = displayDotData.repetitionNum
            duration.text = "\(displayDotData.durationOfGame)s"
            totalButPress.text = "\(displayDotData.totalButtonClick)"
            buttonList = displayDotData.buttonList
        }
        
        buttonTableView.delegate = self
        buttonTableView.dataSource = self
        
        //MARK: - For setting the image
        let url = URL(string: dotUserPicURL)
        let defaultURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/kit305-607-73727.appspot.com/o/images%2Fsonic_victory.png?alt=media&token=2ee08646-127e-415e-986e-ede770f2537b")
        
        print("urlString: \(String(describing: url))")
        
        let task = URLSession.shared.dataTask(with: url ?? defaultURL!, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return print("No image found because different device")
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.dotUserPic.image = image
                self.spinnerLoading.stopAnimating() //This is to stop the animation after the image has been loaded.
                self.searchImageText.isHidden = true
            }
        })
        
        task.resume()
        
        //MARK: - For sharing and editing string
        //For sharing
        shareDotData = "Status: \(String(describing: dotData!.gameStatus)), Correct Button Click: \(String(describing: dotData!.correctButtonClick)), Wrong Button Click: \(String(describing:dotData!.wrongButtonClick)), Start Time: \(String(describing:dotData!.startTime)), End Time: \(String(describing:dotData!.endTime)), Repetition Number: \(String(describing:dotData!.repetitionNum)), Duration: \(String(describing:dotData!.durationOfGame))s, Total Button Click: \(String(describing:dotData!.totalButtonClick)), Button List: \(dotData!.buttonList.map({ "\"\($0)\"" }).joined(separator: ", "))" //.map({ "\"\($0)\"" }).joined(separator: ", ")) helps to remove the array bracets ([]) and add quotation for each button and timestamp.
        
        print("shareDotData: \(shareDotData)")
        
        
    }
    
    //MARK: - Sharing details from table
    @IBAction func shareButton(_ sender: UIButton)
    {
        let shareViewController = UIActivityViewController(activityItems: ["\(shareDotData)"], applicationActivities: [])
        
        present(shareViewController, animated: true, completion: nil)
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

class ButtonListTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var buttonListText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

@available(iOS, deprecated: 15.0, message: "Use the built-in API instead")
extension URLSession {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }

            task.resume()
        }
    }
}
