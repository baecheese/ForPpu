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
}

/** MainTableViewController */
class MainTableViewCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var info: UILabel!
}

class MainTableViewController: UITableViewController {

    let cardMenu = CardMenu()
    let dataRepository = DataRepository.sharedInstance
    var cardInfo:[[String:String?]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults(suiteName: GroupKeys().suiteName)
        print("\(defaults?.value(forKey: "test"))")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return cardMenu.list.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cardMenu.list[section]
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Card", for: indexPath) as! MainTableViewCell
        let nowCardInfo = dataRepository.get(cardID: indexPath.section)
        if nil == nowCardInfo {
            cell.name.text = "card"
            cell.info.text = "입력된 정보가 없습니다"
            return cell
        }
        cell.name.text = nowCardInfo?.0
        cell.info.text = nowCardInfo?.1
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
    
    
    
}
