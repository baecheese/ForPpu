//
//  AddTableViewController.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct Menu {
    let sectionName = ["empty space", "card Info", "leather"]
    let cardInfo = ["card name", "barcode image", "barcode number"]
}

struct Message {
    let setCardName = "Write your card name."
    let setCardNumber = "Write barcode number with no spaces."
}

/** MainTableViewController */
class AddTableViewCell: UITableViewCell {
    @IBOutlet var infoLabel: UIView!
}

class AddTableViewController: UITableViewController, UITextFieldDelegate {

    let colorManager = ColorManager.sharedInstance
    let dataRepository = DataRepository.sharedInstance
    var cell = AddTableViewCell()
    let cardID = SharedMemoryContext.getCardID() as! Int
    var cardName = UITextField()
    var barCodeNumber = UITextField()
    var cardInfo = [String]()
    var barCodeImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = colorManager.getMainColor()
        tableView.separatorStyle = .none
        makeNavigationItem()
        cardName.delegate = self
        barCodeNumber.delegate = self
        barCodeNumber.addTarget(self, action: #selector(AddTableViewController.textFieldDidChange), for: .editingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func makeNavigationItem()  {
        let saveBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        saveBtn.setTitle("save", for: .normal)
        saveBtn.setTitleColor(colorManager.getTint(), for: .normal)
        saveBtn.addTarget(self, action: #selector(AddTableViewController.clickSaveButton), for: .touchUpInside)
        let item = UIBarButtonItem(customView: saveBtn)
        navigationItem.rightBarButtonItem = item
    }
    
    func clickSaveButton() {
        self.cell.endEditing(true)
        showAlert(message: "Do you want to save?", haveCancel: true, doneHandler: { (UIAlertAction) in
            if true == (self.isEmpty()) {
                self.showAlert(message: "Fill in the blanks without omission!", haveCancel: false, doneHandler: nil, cancelHandler: nil)
                return;
            }
            self.dataRepository.set(cardID: self.cardID, cardName: self.cardName.text!, cardNumber: self.barCodeNumber.text!)
            self.navigationController?.popViewController(animated: true)
        }, cancelHandler: nil)
    }
    
    func isEmpty() -> Bool {
        if true == cardName.text?.isEmpty || true == barCodeNumber.text?.isEmpty {
            return true
        }
        return false
    }
    
    func showAlert(message:String, haveCancel:Bool, doneHandler:((UIAlertAction) -> Swift.Void)?, cancelHandler:((UIAlertAction) -> Swift.Void)?)
    {
        let alertController = UIAlertController(title: "Notice", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default,handler: doneHandler))
        if haveCancel {
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: cancelHandler))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Menu().sectionName.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Menu().sectionName[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if 0 != section {
            return 0.1
        }
        return TableFrameSize().sectionHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30.0))
        if 0 == section {
            let headerImage = UIImageView(frame: headerView.bounds)
            headerImage.image = UIImage(named: "headerImage.png")
            headerImage.contentMode = .scaleToFill
            headerImage.clipsToBounds = true
            headerImage.image = headerImage.image!.withRenderingMode(.alwaysTemplate)
            headerImage.tintColor = .white
            
            headerView.addSubview(headerImage)
            let margenX:CGFloat = 15.0
            let margenY:CGFloat = headerImage.frame.height/2 - TableFrameSize().sectionLabelHeight/2
            let title = UILabel(frame: CGRect(x: margenX, y: margenY, width: tableView.frame.width - margenX*2, height: TableFrameSize().sectionLabelHeight))
            headerImage.addSubview(title)
        }
        if 0 != section {
            headerView.backgroundColor = .white
        }
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 1 == section {
            return Menu().cardInfo.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if 1 == indexPath.section && 1 == indexPath.row {
            return TableFrameSize().addRowInfoHeghit
        }
        if 2 == indexPath.section {
            return view.frame.height - 230.1
        }
        return TableFrameSize().addRowHeghit
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "Add", for: indexPath) as! AddTableViewCell
        cell.selectionStyle = .none
        setCellDetailInfo(cell: cell, indexPath: indexPath)
        if true == haveInfo() {
            if 1 == indexPath.section && 1 == indexPath.row {
                let barcodeNumber = dataRepository.get(cardID: cardID)?.1
                barCodeImage.image = dataRepository.showBarCodeImage(cardNumber: barcodeNumber!)
            }
            else {
                setCardInfo(section: indexPath.section)
            }
        }
        return cell
    }
    
    private func setCellDetailInfo(cell:AddTableViewCell, indexPath:IndexPath) {
        let cellWidth = self.cell.frame.width
        let textFieldwidth = cellWidth * 0.8
        let margen = (cellWidth - textFieldwidth) * 0.5
        let commonFrame = CGRect(x: margen, y: 0, width: textFieldwidth, height: self.cell.infoLabel.frame.height)
        
        if 0 == indexPath.section {
            cell.backgroundColor = colorManager.getRainbow(section: cardID)
        }
        if 1 == indexPath.section && 0 == indexPath.row {
            cardName.frame = commonFrame
            cardName.font = UIFont.boldSystemFont(ofSize: 23.0)
            let attributes = [
                NSForegroundColorAttributeName: UIColor.lightGray,
                NSFontAttributeName : UIFont.systemFont(ofSize: 15.0)
            ]
            cardName.attributedPlaceholder = NSAttributedString(string: Message().setCardName, attributes:attributes)
            cardName.textAlignment = .center
            cell.infoLabel.addSubview(cardName)
        }
        if 1 == indexPath.section && 1 == indexPath.row {
            barCodeImage = UIImageView(frame: commonFrame)
            barCodeImage.image = UIImage(named: "emptyImage.png")
            cell.addSubview(barCodeImage)
        }
        if 1 == indexPath.section && 2 == indexPath.row {
            barCodeNumber.frame = commonFrame
            barCodeNumber.textAlignment = .center
            barCodeNumber.font = UIFont.systemFont(ofSize: 18.0)
            let attributes = [
                NSForegroundColorAttributeName: UIColor.lightGray,
                NSFontAttributeName : UIFont.systemFont(ofSize: 12.0)
            ]
            barCodeNumber.attributedPlaceholder = NSAttributedString(string: Message().setCardNumber, attributes:attributes)
            barCodeNumber.keyboardType = .numberPad
            cell.infoLabel.addSubview(barCodeNumber)
        }
        if 2 == indexPath.section {
            let leatherImage = UIImageView(frame: cell.bounds)
            leatherImage.image = UIImage(named: "leatherBlack.jpg")
            leatherImage.contentMode = .topRight
            cell.addSubview(leatherImage)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // barcode image
        if 1 == indexPath.section && 1 == indexPath.row {
            
        }
        // leather
        if indexPath.section == 2 {
            cardName.endEditing(true)
            barCodeNumber.endEditing(true)
        }
    }
    
    func textFieldDidChange() {
        barCodeImage.image = dataRepository.showBarCodeImage(cardNumber: barCodeNumber.text!)
        if true == barCodeNumber.text?.isEmpty {
            barCodeImage.image = UIImage(named: "emptyImage.png")
        }
    }
    
    private func setCardInfo(section:Int) {
        if 0 == section {
            cardName.text = cardInfo[0]
        }
        if 1 == section {
            barCodeNumber.text = cardInfo[1]
        }
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
}
