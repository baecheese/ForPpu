//
//  InfoTableViewController.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 6. 5..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

/** MainTableViewController */
class InfoTableViewCell: UITableViewCell {
    @IBOutlet var infoMenu: UILabel!
    @IBOutlet var backImage: UIImageView!
}

class InfoTableViewController: UITableViewController {

    let infoManager = InfoManager.sharedInstance
    let colorManager = ColorManager.sharedInstance
    
    private let lastCellLeather = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = colorManager.getMainBackImage()
        self.tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoManager.getInfoMenu().count + 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let menuHeight:CGFloat = 70.0
        if lastCellLeather == indexPath.row {
            return view.frame.height - menuHeight*2
        }
        return menuHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Info", for: indexPath) as! InfoTableViewCell
        cell.selectionStyle = .none
        if lastCellLeather == indexPath.row {
            setLastCell(cell: cell)
        }
        else {
            setInfoCard(cell: cell, row: indexPath.row)
        }
        
        return cell
    }
    
    func setInfoCard(cell:InfoTableViewCell, row:Int) {
        cell.infoMenu.text = infoManager.getInfoMenu()[row]
        cell.backImage.image = cell.backImage.image?.withRenderingMode(.alwaysTemplate)
        cell.backImage.tintColor = colorManager.getInfoColor(menu: row)
        if row == infoManager.fullScreenMode {
            cell.backgroundColor = colorManager.getInfoColor(menu: infoManager.saveAndDelete)
        }
    }
    
    func setLastCell(cell:InfoTableViewCell) {
        cell.backImage.image = UIImage(named: "leatherBlack.jpg")
        cell.backImage.contentMode = .scaleToFill
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if 2 != indexPath.row {
            SharedMemoryContext.set(key: Key().info, setValue: indexPath.row)
            let infoDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "InfoDetailViewController") as? InfoDetailViewController
            self.navigationController?.pushViewController(infoDetailVC!, animated: true)
        }
    }
}
