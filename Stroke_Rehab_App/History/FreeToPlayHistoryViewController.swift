//
//  FreeToPlayHistoryViewController.swift
//  Stroke_Rehab_App
//
//  Created by Md Asif Iqbal on 16/5/2022.
//

//also add these lines to the top of your file
import Firebase
import FirebaseFirestoreSwift

import UIKit

class FreeToPlayHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var freeTotRecordField: UILabel!
    
    @IBOutlet weak var freeSearchBar: UISearchBar!
    
    @IBOutlet weak var freeTableView: UITableView!
    
    var freeHistories = [FreeGameData]() //This is an empty array created for storing the data from the database.
    
    //These are for searching feature
    var freeDataDuration: [Int] = [] //This is an empty array for searching
    var filteredData: [FreeGameData] = [] //This is an empty array for searching
    
    var filterDataSort: [FreeGameData] = [] //This is for sorting the data using the start time
    
    var shareFreeData = "---Whole Free to Play History---" //This is for sharing
    
    // get a handle to the defaults system
    let defaultSetting = UserDefaults.standard
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //These are the tab controller tab index
        let tabIndex = "HistoryIndex"
        defaultSetting.set(tabIndex, forKey: "TabIndexSelect")
        
        freeTotRecordField.text = "Total records: Loading..."
        
        let db = Firestore.firestore()
        let dotGameCollection = db.collection("iOS_free_to_play_history")
        dotGameCollection.getDocuments() { (result, err) in
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
                        try document.data(as: FreeGameData.self)
                    }
                    print(type(of: FreeGameData.self))
                    print("Reult: \(conversionResult)")
                    switch conversionResult
                    {
                    case .success(let freeGame):
                        //dotGame.dataID = document.documentID
                        print("Dot Game Data: \(freeGame)")
                        print(type(of: freeGame))
                        
                        //NOTE THE ADDITION OF THIS LINE
                        self.freeHistories.append(freeGame)
                        
                        //self.filteredData.append(dotGame)
                        
                    case .failure(let error):
                        // A `FreeGameData` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding game data: \(error)")
                    }
                }
                
                //NOTE THE ADDITION OF THIS LINE
                self.filteredData = self.freeHistories //This is for saving the data from the database into the filtered array for searching.
                
                self.filterDataSort =  self.filteredData.sorted { $1.dataID! < $0.dataID! } //This gives a list
                print("filterDataSort: \(self.filterDataSort)")
                
                self.freeTableView.reloadData()
                self.freeTotRecordField.text = "Total records: \(self.filterDataSort.count)"
            }
        }
        
        freeTableView.delegate = self
        freeTableView.dataSource = self
        
        //For search bar
        freeSearchBar.delegate = self
        freeSearchBar.showsCancelButton = true
        
        print("Inside View filteredData: \(filterDataSort)")
    }
    
    //MARK: - Delete dot data from database
    /**Got help from these sources:
     *Delete data from Cloud Firestore : https://firebase.google.com/docs/firestore/manage-data/delete-data#swift_2
     */
    func deleteFreeData(freeDataDelete: FreeGameData)
    {
        let db = Firestore.firestore()
        let dotGameCollection = db.collection("iOS_free_to_play_history")
        
        dotGameCollection.document(freeDataDelete.dataID!).delete() { err in
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
        //return freeHistories.count
        
        return filterDataSort.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeHistoryTableCell", for: indexPath)
        
        //get the game data for this row
        var freeHistory = freeHistories[indexPath.row]
        
        if !filteredData.isEmpty
        {
            freeHistory = filterDataSort[indexPath.row]
            
        }
        
        //down-cast the cell from UITableViewCell to our cell class MovieUITableViewCell
        //note, this could fail, so we use an if let.
        if let freeCell = cell as? FreeHistoryTableCell
        {
            //populate the cell
            freeCell.freeDurationField.text = "Duration: \(freeHistory.durationOfGame)s"
            freeCell.freeStartTime.text = "Start Time: \(freeHistory.startTime)"
            
            freeCell.freeTotalButClick.text = "Total Button Clicked: \(freeHistory.totalButtonClick)"
            
            freeDataDuration.append(freeHistory.durationOfGame) //This is for storing the duration for searhing
            
            //MARK: - For sharing and editing string
            //Got help from this source: https://docs.swift.org/swift-book/LanguageGuide/StringsAndCharacters.html
            //For sharing
            shareFreeData += "   "
            shareFreeData += "Correct Button Click: \(String(describing: freeHistory.correctButtonClick)), Wrong Button Click: \(String(describing:freeHistory.wrongButtonClick)), Start Time: \(String(describing:freeHistory.startTime)), End Time: \(String(describing:freeHistory.endTime)), Duration: \(String(describing:freeHistory.durationOfGame))s, Total Button Click: \(String(describing:freeHistory.totalButtonClick)), Button List: \(freeHistory.buttonList.map({ "\"\($0)\"" }).joined(separator: ", "))\n"
        }
        
        //print("freeDataDuration: \(freeDataDuration)")
        
        //print("shareFreeData: \(shareFreeData)")
        
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
            
            deleteFreeData(freeDataDelete: filteredData[indexPath.row])  //This is for deleting data from the database
            
            freeHistories.removeAll { item in
                return item.dataID == filterDataSort[indexPath.row].dataID
            }
            
            filterDataSort.remove(at: indexPath.row) //This updates the list of the dot data stored in this list for table view.
            
            tableView.deleteRows(at: [indexPath], with: .fade) //This is for deleting data from the table.
            
            self.freeTotRecordField.text = "Total records: \(self.filterDataSort.count)" //This updates the text that displays the number of data in the database.
            
            tableView.endUpdates()
        }
    }
    
    // MARK: - Moving data to Dot History Detail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        // is this the segue to the details screen? (in more complex apps, there is more than one segue per screen)
        if segue.identifier == "FreeHistoryDetailSeague"
        {
              //down-cast from UIViewController to DetailViewController (this could fail if we didn’t link things up properly)
              guard let detailViewController = segue.destination as? FreeToPlayHistoryDetailedViewController else
              {
                  fatalError("Unexpected destination: \(segue.destination)")
              }

              //down-cast from UITableViewCell to MovieUITableViewCell (this could fail if we didn’t link things up properly)
              guard let selectedDataCell = sender as? FreeHistoryTableCell else
              {
                  fatalError("Unexpected sender: \( String(describing: sender))")
              }

              //get the number of the row that was pressed (this could fail if the cell wasn’t in the table but we know it is)
              guard let indexPath = freeTableView.indexPath(for: selectedDataCell) else
              {
                  fatalError("The selected cell is not being displayed by the table")
              }

              //work out which movie it is using the row number
              let selectedDotData = filterDataSort[indexPath.row]

              //send it to the details screen
              detailViewController.freeData = selectedDotData
              detailViewController.freeDataIndex = indexPath.row
        }
    }
    
    // MARK: - Search bar functiom
    /**Got help from this source:
     * How to add a Search Bar to your Table View | Using UISearchBar | Swift 5 in Xcode 11: https://www.youtube.com/watch?v=iH67DkBx9Jc&t=240s&ab_channel=AjayGandecha
     * Searchable Table View in Swift with Xcode 11 | iOS for Beginners: https://www.youtube.com/watch?v=-UQcifmThag&ab_channel=iOSAcademy
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == ""
        {
            filteredData = freeHistories
            print("Search text is empty")
        }
        else
        {
            for freeGame in freeHistories{
               
                if freeGame.durationOfGame == Int(searchText)
                {
                    filteredData.append(freeGame)
                }
            }
            
        }
        
        self.filterDataSort =  self.filteredData.sorted { $1.dataID! < $0.dataID! } //This gives a sorted list
        
        print("Inside View filteredData: \(filterDataSort.count)")
        self.freeTableView.reloadData()
        self.freeTotRecordField.text = "Total records: \(self.filterDataSort.count)"

    }
    
    //Got help from this source: https://stackoverflow.com/questions/34692277/how-to-exit-from-the-search-on-clicking-on-cancel-button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @IBAction func freeShareAll(_ sender: UIButton)
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

// MARK: - FreeHistoryTableCell
class FreeHistoryTableCell: UITableViewCell {
    
    @IBOutlet weak var freeDurationField: UILabel!
    
    @IBOutlet weak var freeStartTime: UILabel!
    
    @IBOutlet weak var freeTotalButClick: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
