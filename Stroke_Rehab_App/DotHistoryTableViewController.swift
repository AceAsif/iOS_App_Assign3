//
//  DotHistoryTableViewController.swift
//  Stroke_Rehab_App
//
//  Created by Md Asif Iqbal on 11/5/2022.
//

import UIKit
//also add these lines to the top of your file
import Firebase
import FirebaseFirestoreSwift

class DotHistoryTableViewController: UITableViewController {
    
    var dotHistories = [GameData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let db = Firestore.firestore()
        let dotGameCollection = db.collection("iOS_dot_game_history")
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
                      
                  case .failure(let error):
                      // A `Movie` value could not be initialized from the DocumentSnapshot.
                      print("Error decoding game data: \(error)")
                  }
              }
              
              //NOTE THE ADDITION OF THIS LINE
              self.tableView.reloadData()
          }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dotHistories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DotHistoryTableViewCell", for: indexPath)

        //get the movie for this row
        let dotGameHistory = dotHistories[indexPath.row]

        //down-cast the cell from UITableViewCell to our cell class MovieUITableViewCell
        //note, this could fail, so we use an if let.
        if let dotGameCell = cell as? DotHistoryTableViewCell
        {
            dotGameCell.duration.font = UIFont.boldSystemFont(ofSize: 16.0) //This makes the text bold
            //populate the cell
            //dotGameCell.duration.text = String(dotGameHistory.durationOfGame)
            dotGameCell.duration.text = "\(dotGameHistory.durationOfGame) s"
             //movieCell.subTitleLabel.text = String(movie.year)
        }

        return  cell
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        // is this the segue to the details screen? (in more complex apps, there is more than one segue per screen)
        if segue.identifier == "ShowMovieDetailSegue"
        {
              //down-cast from UIViewController to DetailViewController (this could fail if we didn’t link things up properly)
              guard let detailViewController = segue.destination as? DetailViewController else
              {
                  fatalError("Unexpected destination: \(segue.destination)")
              }

              //down-cast from UITableViewCell to MovieUITableViewCell (this could fail if we didn’t link things up properly)
              guard let selectedMovieCell = sender as? MovieUITableViewCell else
              {
                  fatalError("Unexpected sender: \( String(describing: sender))")
              }

              //get the number of the row that was pressed (this could fail if the cell wasn’t in the table but we know it is)
              guard let indexPath = tableView.indexPath(for: selectedMovieCell) else
              {
                  fatalError("The selected cell is not being displayed by the table")
              }

              //work out which movie it is using the row number
              let selectedMovie = movies[indexPath.row]

              //send it to the details screen
              detailViewController.movie = selectedMovie
              detailViewController.movieIndex = indexPath.row
        }
    }
    
    @IBAction func unwindToMovieList(sender: UIStoryboardSegue)
    {
        //we could reload from db, but lets just trust the local movie object
            if let detailScreen = sender.source as? DetailViewController
            {
                movies[detailScreen.movieIndex!] = detailScreen.movie!
                tableView.reloadData()
            }
    }

    @IBAction func unwindToMovieListWithCancel(sender: UIStoryboardSegue)
    {
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
