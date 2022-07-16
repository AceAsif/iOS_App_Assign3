//
//  HistoryViewController.swift
//  Stroke_Rehab_App
//
//  Created by Md Asif Iqbal on 28/4/2022.
//

//also add these lines to the top of your file
import Firebase
import FirebaseFirestoreSwift

import UIKit
// MARK: - Need to edit this file
    
class DotHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var historyTableView: UITableView!
  
    //This is for the search bar
    @IBOutlet weak var searchBar: UISearchBar!
    
    //This is for showing the total number of data in the database.
    @IBOutlet weak var totRecordField: UILabel!
    
    var dotHistories = [GameData]() //This is an empty array created for storing the data from the database.
    
    //These are for searching feature
    var dotDataDuration: [Int] = [] //This is an empty array for searching
    var filteredData: [GameData] = [] //This is an empty array for searching
    
    var filterDataSort: [GameData] = [] //This is for sorting the data using the start time
    
    var shareDotData = "---Whole Dot Game History---" //This is for sharing
    
    // get a handle to the defaults system
    let defaultSetting = UserDefaults.standard
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //These are the tab controller tab index
        let tabIndex = "HistoryIndex"
        defaultSetting.set(tabIndex, forKey: "TabIndexSelect")
        
        totRecordField.text = "Total records: Loading..."
        
        let db = Firestore.firestore()
        let dotGameCollection = db.collection("iOS_dot_game_history")
        dotGameCollection.getDocuments() { [self] (result, err) in
            //check for server error
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                //loop through the results
                for document in result!.documents
                {
                    print(document)
                    //attempt to convert to Movie object
                    let conversionResult = Result
                    {
                        try document.data(as: GameData.self)
                    }
                    print(type(of: GameData.self))
                    print("Reult: \(conversionResult)")
                    switch conversionResult
                    {
                    case .success(let dotGame):
                        //dotGame.dataID = document.documentID
                        print("Dot Game Data: \(dotGame)")
                        print(type(of: dotGame))
                        
                        //NOTE THE ADDITION OF THIS LINE
                        self.dotHistories.append(dotGame)
                        
                        //self.filteredData.append(dotGame)
                        
                    case .failure(let error):
                        // A `Movie` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding game data: \(error)")
                    }
                }
                
                //NOTE THE ADDITION OF THIS LINE
                //var dotHistorySort =  self.dotHistories.sort{$0.startTime < $1.startTime}
                //print("dotHistorySort: \(dotHistorySort)")
                
                self.filteredData = self.dotHistories //This is for saving the data from the database into the filtered array for searching.
                
                self.filterDataSort =  self.filteredData.sorted { $1.dataID! < $0.dataID! } //This gives a list
                print("filterDataSort: \(self.filterDataSort)")
                self.historyTableView.reloadData()
                self.totRecordField.text = "Total records: \(self.filterDataSort.count)"
                
            }
        }
        
        // Do any additional setup after loading the view.
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        //For search bar
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        //searchBar.placeholder = "Search by Duration value"
        
        print("Inside View filteredData: \(filterDataSort)")
    }
    
    //MARK: - Delete dot data from database
    /**Got help from these sources:
     *Delete data from Cloud Firestore : https://firebase.google.com/docs/firestore/manage-data/delete-data#swift_2
     
     */
    func deleteDotData(dotDataDelete: GameData)
    {
        let db = Firestore.firestore()
        let dotGameCollection = db.collection("iOS_dot_game_history")
        
        dotGameCollection.document(dotDataDelete.dataID!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    // MARK: - Table view data source
    //Got help from this source: https://www.ralfebert.com/ios-examples/uikit/uitableviewcontroller/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return dotHistories.count
        return filterDataSort.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryShortCell", for: indexPath)
        
        //get the game data for this row
        var dotGameHistory = dotHistories[indexPath.row]
        
        if !filteredData.isEmpty
        {
             dotGameHistory = filterDataSort[indexPath.row]
            
        }
        
        //down-cast the cell from UITableViewCell to our cell class MovieUITableViewCell
        //note, this could fail, so we use an if let.
        if let dotGameCell = cell as? HistoryTableCell
        {
            //populate the cell
            dotGameCell.durationField.text = "Duration: \(dotGameHistory.durationOfGame)s"
            dotGameCell.startTimeField.text = "Start Time: \(dotGameHistory.startTime)"
            dotGameCell.repField.text = "Repetitions: \(dotGameHistory.repetitionNum)"
        
            //MARK: - For sharing and editing string
            //Got help from this source: https://docs.swift.org/swift-book/LanguageGuide/StringsAndCharacters.html
            //For sharing
            shareDotData += "   "
            shareDotData += "Status: \(String(describing: dotGameHistory.gameStatus)), Correct Button Click: \(String(describing: dotGameHistory.correctButtonClick)), Wrong Button Click: \(String(describing:dotGameHistory.wrongButtonClick)), Start Time: \(String(describing:dotGameHistory.startTime)), End Time: \(String(describing:dotGameHistory.endTime)), Repetition Number: \(String(describing:dotGameHistory.repetitionNum)), Duration: \(String(describing:dotGameHistory.durationOfGame))s, Total Button Click: \(String(describing:dotGameHistory.totalButtonClick)), Button List: \(dotGameHistory.buttonList.map({ "\"\($0)\"" }).joined(separator: ", "))\n"
            
            
            
            dotDataDuration.append(dotGameHistory.durationOfGame) //This is for storing the duration for searhing
            
        }
        //print("dotDataDuration: \(dotDataDuration)")
        
        //print("shareDotData: \(shareDotData)")
        
        return  cell
    }
    
    //MARK: - Deleting data from table view
    /**Got help from this source:
     *How To Delete Cells in UITableView - Swift Tutorial (2020 for Beginners): https://www.youtube.com/watch?v=F6dgdJCFS1Q&ab_channel=iOSAcademy
     */
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            tableView.beginUpdates()
    
            deleteDotData(dotDataDelete: filteredData[indexPath.row]) //This is for deleting data from the database
            
            dotHistories.removeAll { item in
                return item.dataID == filterDataSort[indexPath.row].dataID
            }
            
            filterDataSort.remove(at: indexPath.row) //This updates the list of the dot data stored in this list for table view.
            
            tableView.deleteRows(at: [indexPath], with: .fade) //This is for deleting data from the table.
            
            self.totRecordField.text = "Total records: \(self.filterDataSort.count)" //This updates the text that displays the number of data in the database.
            
            tableView.endUpdates()
        }
    }

    
    // MARK: - Moving data to Dot History Detail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        // is this the segue to the details screen? (in more complex apps, there is more than one segue per screen)
        if segue.identifier == "DotHistoryDetailSeague"
        {
              //down-cast from UIViewController to DetailViewController (this could fail if we didn’t link things up properly)
              guard let detailViewController = segue.destination as? DotHistoryDetailViewController else
              {
                  fatalError("Unexpected destination: \(segue.destination)")
              }

              //down-cast from UITableViewCell to MovieUITableViewCell (this could fail if we didn’t link things up properly)
              guard let selectedDataCell = sender as? HistoryTableCell else
              {
                  fatalError("Unexpected sender: \( String(describing: sender))")
              }

              //get the number of the row that was pressed (this could fail if the cell wasn’t in the table but we know it is)
              guard let indexPath = historyTableView.indexPath(for: selectedDataCell) else
              {
                  fatalError("The selected cell is not being displayed by the table")
              }

              //work out which game data it is using the row number
              let selectedDotData = filterDataSort[indexPath.row]

              //send it to the details screen
              detailViewController.dotData = selectedDotData
              detailViewController.dotDataIndex = indexPath.row
        }
    }
    
    // MARK: - Search bar functiom
    /**Got help from this source:
     * How to add a Search Bar to your Table View | Using UISearchBar | Swift 5 in Xcode 11: https://www.youtube.com/watch?v=iH67DkBx9Jc&t=240s&ab_channel=AjayGandecha
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == ""
        {
            filteredData = dotHistories
        }
        else
        {
            for dotGame in dotHistories{
               
                if dotGame.durationOfGame == Int(searchText)
                {
                    filteredData.append(dotGame)
                }
            }
            
        }
        
        self.filterDataSort =  self.filteredData.sorted { $1.dataID! < $0.dataID! } //This gives a list
        
        print("Inside View filterDataSort: \(filterDataSort.count)")
        self.historyTableView.reloadData()
        self.totRecordField.text = "Total records: \(self.filterDataSort.count)"

    }
    
    //Got help from this source: https://stackoverflow.com/questions/34692277/how-to-exit-from-the-search-on-clicking-on-cancel-button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @IBAction func dotShareAll(_ sender: UIButton)
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

// MARK: - HistoryTableCell

class HistoryTableCell: UITableViewCell {
    
    @IBOutlet weak var durationField: UILabel!
    @IBOutlet weak var startTimeField: UILabel!
    @IBOutlet weak var repField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
