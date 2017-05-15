//
//  AddTableViewController.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct Menu {
    let name = ["card name", "barcode number", "barcode image"]
}

/** MainTableViewController */
class AddTableViewCell: UITableViewCell {
    @IBOutlet var infoLabel: UIView!
}

class AddTableViewController: UITableViewController, UITextFieldDelegate {

    let dataRepository = DataRepository.sharedInstance
    var cell = AddTableViewCell()
    let cardID = SharedMemoryContext.getCardID() as! Int
    var cardName = UITextField()
    var barCodeNumber = UITextField()
    var cardInfo = [String]()
    var barCodeImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        saveBtn.setTitleColor(.blue, for: .normal)
        saveBtn.addTarget(self, action: #selector(AddTableViewController.clickSaveButton), for: .touchUpInside)
        let item = UIBarButtonItem(customView: saveBtn)
        navigationItem.rightBarButtonItem = item
    }
    
    func clickSaveButton() {
        self.cell.endEditing(true)
        showAlert(message: "저장하시겠습니까?", haveCancel: true, doneHandler: { (UIAlertAction) in
            if true == (self.isEmpty()) {
                self.showAlert(message: "빈칸없이 작성해주세요!", haveCancel: false, doneHandler: nil, cancelHandler: nil)
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
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Menu().name[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "Add", for: indexPath) as! AddTableViewCell
        cell.selectionStyle = .none
        setCellDetailInfo(cell: cell, indexPath: indexPath)
        if true == haveInfo() {
            if 2 == indexPath.section {
//                barCodeImage.image = dataRepository.getBardCodeImage(cardID: cardID)
                let barcodeNumber = dataRepository.get(cardID: cardID)?.1
                barCodeImage.image = showBarCode(cardNumber: barcodeNumber!)
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
        
        if 0 == indexPath.section {
            cardName.frame = CGRect(x: margen, y: 0, width: textFieldwidth, height: self.cell.infoLabel.frame.height)
            cardName.font = UIFont.systemFont(ofSize: 13.0)
            cardName.placeholder = "사용할 카드의 이름을 적어주세요."
            cell.infoLabel.addSubview(cardName)
        }
        if 1 == indexPath.section {
            barCodeNumber.frame = CGRect(x: margen, y: 0, width: textFieldwidth, height: self.cell.infoLabel.frame.height)
            barCodeNumber.font = UIFont.systemFont(ofSize: 13.0)
            barCodeNumber.placeholder = "띄어쓰기 없이 바코드 번호를 적어주세요."
            barCodeNumber.keyboardType = .numberPad
            cell.infoLabel.addSubview(barCodeNumber)
        }
        if 2 == indexPath.section {
            barCodeImage = UIImageView(frame: cell.bounds)
            barCodeImage.image = UIImage(named: "emptyImage.png")
            print(cell.bounds)
            //                barCodeImage.image = dataRepository.getBardCodeImage(cardID: cardID)
            cell.addSubview(barCodeImage)
        }
        
    }
    
    func textFieldDidChange() {
        barCodeImage.image = dataRepository.getBarCodeImage(cardNumber: barCodeNumber.text!)
    }
    
    private func setCardInfo(section:Int) {
        if 0 == section {
            cardName.text = cardInfo[0]
        }
        if 1 == section {
            barCodeNumber.text = cardInfo[1]
        }
    }
    
    private func showBarCode(cardNumber:String) -> UIImage? {
        if cardNumber.characters.count < 1 {
            return nil
        }
        let asciiEncodedValue = cardNumber.data(using: .ascii)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(asciiEncodedValue, forKey: "inputMessage")
        return UIImage(ciImage: (filter?.outputImage)!)
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
