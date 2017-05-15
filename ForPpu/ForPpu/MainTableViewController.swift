//
//  MainTableViewController.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct CardMenu {
    let list = ["First", "Second", "Third"]
    let rainbow = ["red", "orange", "yellow", "green", "blue", "indigo", "violet"]
}

/** MainTableViewController */
class MainTableViewCell: UITableViewCell {
//    @IBOutlet var name: UILabel!
    @IBOutlet var info: UILabel!
    @IBOutlet var barcodeImage: UIImageView!
}

class MainTableViewController: UITableViewController {

    let colorManager = ColorManager.sharedInstance
    let cardMenu = CardMenu()
    let dataRepository = DataRepository.sharedInstance
    var cardInfo:[[String:String?]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return cardMenu.rainbow.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cardMenu.rainbow[section]
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40.0))
        headerView.backgroundColor = colorManager.getRainbow(section: section)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Card", for: indexPath) as! MainTableViewCell
        let nowCardInfo = dataRepository.get(cardID: indexPath.section)
        if nil == nowCardInfo {
//            cell.name.text = "card"
            cell.info.text = "입력된 정보가 없습니다"
            return cell
        }
        cell.info.text = nowCardInfo?.1
        cell.barcodeImage.image = dataRepository.getBarCodeImage(cardNumber: (nowCardInfo?.1)!)
        cell.barcodeImage.contentMode = .scaleAspectFit
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveEditPage(section: indexPath.section)
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let add = UITableViewRowAction(style: .default, title: "edit") { action, index in
            self.moveEditPage(section: indexPath.section)
        }
        add.backgroundColor = .gray
        
        let delete = UITableViewRowAction(style: .default, title: "delete") { action, index in
            print("delete")
        }
        delete.backgroundColor = .red
        
        return [delete, add]
    }
    
    func moveEditPage(section:Int) {
        SharedMemoryContext.setCardID(setValue: section)
        let addPage = self.storyboard?.instantiateViewController(withIdentifier: "AddTableViewController") as! AddTableViewController
        self.navigationController?.pushViewController(addPage, animated: true)
    }
    
    func setNavigationColor() {
        navigationController?.navigationBar.barTintColor = colorManager.UIColorFromRGB(rgbValue: 0x26140C)
    }
    
}
