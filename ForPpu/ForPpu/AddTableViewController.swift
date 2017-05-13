//
//  AddTableViewController.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct Menu {
    let name = ["card name", "card number"]
}

/** MainTableViewController */
class AddTableViewCell: UITableViewCell {
    @IBOutlet var info: UITextField!
}

class AddTableViewController: UITableViewController, UITextFieldDelegate {

    let dataRepository = DataRepository.sharedInstance
    var cell = AddTableViewCell()
    let cardID = SharedMemoryContext.getCardID() as! Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func makeNavigationItem()  {
        let saveBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        saveBtn.setTitle("save", for: .normal)
        saveBtn.addTarget(self, action: #selector(AddTableViewController.clickSaveButton), for: .touchUpInside)
        let item = UIBarButtonItem(customView: saveBtn)
        navigationItem.rightBarButtonItem = item
    }
    
    func clickSaveButton() {
        cell.info.endEditing(true)
        dataRepository.set(cardID: cardID, cardName: cardName, cardNumber: cardNumber)
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Menu().name[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    var cardInfo = [String]()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "Add", for: indexPath) as! AddTableViewCell
        cell.info.tag = indexPath.section
        if true == haveInfo() {
            cell.info.text = cardInfo[indexPath.section]
        }
        return cell
    }

    private func haveInfo() -> Bool {
        if nil != dataRepository.get(cardID: cardID) {
            let savedCardInfo = dataRepository.get(cardID: cardID)
            cardInfo.append((savedCardInfo?.0)!)
            cardInfo.append((savedCardInfo?.1)!)
            return true
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if 1 == textField.tag {
            cell.info.keyboardType = .numberPad
        }
    }
    
    var cardName = ""
    var cardNumber = ""
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if 0 == textField.tag {
            cardName = textField.text!
        }
        if 1 == textField.tag {
            cardNumber = textField.text!
        }
    }
}
