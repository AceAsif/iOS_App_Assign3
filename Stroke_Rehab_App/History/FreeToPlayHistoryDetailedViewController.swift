//
//  FreeToPlayHistoryDetailedViewController.swift
//  Stroke_Rehab_App
//
//  Created by Md Asif Iqbal on 17/5/2022.
//

//also add these lines to the top of your file
import Firebase
import FirebaseFirestoreSwift

import UIKit

class FreeToPlayHistoryDetailedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return freebuttonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeButtonListCell", for: indexPath)
        
        if let FreeButtonListCell = cell as? FreeButtonListTableViewCell
        {
            FreeButtonListCell.freeButtonListText?.text = freebuttonList[indexPath.row]

        }
            
            return cell
    }
    

    @IBOutlet weak var freeSearchImageText: UILabel!
    
    @IBOutlet weak var freeCorrectButPress: UILabel!
    
    @IBOutlet weak var freeWrongButPress: UILabel!
    
    @IBOutlet weak var freeStartTime: UILabel!
    
    @IBOutlet weak var freeEndTime: UILabel!
    
    @IBOutlet weak var freeDuration: UILabel!
    
    @IBOutlet weak var freeTotalButPress: UILabel!
    
    @IBOutlet weak var freeButtonTableView: UITableView!
    
    @IBOutlet weak var freeUserPic: UIImageView!
    
    @IBOutlet weak var freeSpinnerLoad: UIActivityIndicatorView!
    
    
    var freeData: FreeGameData?
    var freeDataIndex: Int?
    
    var freebuttonList = [String]()
    
    var freeUserPicURL = "" //This is for the image path
    
    //For sharing
    var shareFreeData = ""
    
    // get a handle to the defaults system
    let defaultSetting = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //These are the tab controller tab index
        let tabIndex = "HistoryIndex"
        defaultSetting.set(tabIndex, forKey: "TabIndexSelect")
        
        if let displayFreeData = freeData
        {
            print("Inside the displayFreeData")
            freeUserPicURL = "\(displayFreeData.userPicture)" //Extra for getting the picture
            freeCorrectButPress.text = "\(displayFreeData.correctButtonClick)"
            freeWrongButPress.text = "\(displayFreeData.wrongButtonClick)"
            freeStartTime.text = displayFreeData.startTime
            freeEndTime.text = displayFreeData.endTime
            freeDuration.text = "\(displayFreeData.durationOfGame) s"
            freeTotalButPress.text = "\(displayFreeData.totalButtonClick)"
            freebuttonList = displayFreeData.buttonList
        }
        
        freeButtonTableView.delegate = self
        freeButtonTableView.dataSource = self
        
        //MARK: - For setting the image
        let url = URL(string: freeUserPicURL)
        let defaultURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/kit305-607-73727.appspot.com/o/images%2Fsonic_run2.png?alt=media&token=1c65d77e-8585-4894-b6a5-2d61681250fe")
        
        print("urlString: \(String(describing: url))")
        
        let task = URLSession.shared.dataTask(with: url ?? defaultURL!, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return print("No image found because different device")
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.freeUserPic.image = image
                self.freeSpinnerLoad.stopAnimating() //This is to stop the animation after the image has been loaded.
                self.freeSearchImageText.isHidden = true
            }
        })
        
        task.resume()
        
        //MARK: - Attempt to remove character from string
        //For sharing
        
        shareFreeData = "Correct Button Click: \(String(describing: freeData!.correctButtonClick)), Wrong Button Click: \(String(describing:freeData!.wrongButtonClick)), Start Time: \(String(describing:freeData!.startTime)), End Time: \(String(describing:freeData!.endTime)), Duration: \(String(describing:freeData!.durationOfGame))s, Total Button Click: \(String(describing:freeData!.totalButtonClick)), Button List: \(freeData!.buttonList.map({ "\"\($0)\"" }).joined(separator: ", "))" //.map({ "\"\($0)\"" }).joined(separator: ", ")) helps to remove the array bracets ([]) and add quotation for each button and timestamp.
        
        print("shareFreeData: \(shareFreeData)")
    }
    
    @IBAction func freeShareButton(_ sender: UIButton)
    {
        let shareViewController = UIActivityViewController(activityItems: ["\(shareFreeData)"], applicationActivities: [])
        
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

class FreeButtonListTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var freeButtonListText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
