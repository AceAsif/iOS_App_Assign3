//
//  TabBarController.swift
//  Stroke_Rehab_App
//
//  Created by Md Asif Iqbal on 16/5/2022.
//

import UIKit

class TabBarController: UITabBarController {

    
    // get a handle to the defaults system
    let defaultSetting = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*Got help from this source:
        *Setting default tab in UITabBar in swift: https://stackoverflow.com/questions/30039717/setting-default-tab-in-uitabbar-in-swift
         */
        let getSelectedIndex = defaultSetting.string(forKey: "TabIndexSelect")
        
        switch getSelectedIndex
        {
        case "HistoryIndex":
            //This is for going to the History tab
            self.selectedIndex = 1
            print("tabIndexSelect: \(String(describing: getSelectedIndex))")
        case "GameIndex":
            //This is for going to the Game tab by default
            self.selectedIndex = 0
            print("tabIndexSelect: \(String(describing: getSelectedIndex))")
        default:
            //This is for going to the Game tab by default
            self.selectedIndex = 0
            print("tabIndexSelect: \(String(describing: getSelectedIndex))")
            
        }
        //self.selectedIndex = 1
        
        //MARK: - Removing tab index userDefault
        /**Got help from these source:
         *An effective way to clear entire Userdefaults in Swift: https://ohmyswift.com/blog/2020/05/19/an-effective-way-to-clear-entire-userdefaults-in-swift/
         *Swift 5: Detect if a user exits your iOS App: https://ericgustin.medium.com/swift-5-detect-if-a-user-exits-your-ios-app-7351db54a279
         */
        UserDefaults.standard.removeObject(forKey: "TabIndexSelect") //This removes the userDefault for the tab index selection
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
