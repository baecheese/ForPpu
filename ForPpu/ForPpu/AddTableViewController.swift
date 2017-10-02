//
//  AddTableViewController.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit
import AVFoundation

struct Menu {
    let sectionName = ["empty space", "card Info", "leather"]
    let cardInfo = ["card name", "barcode image", "barcode number"]
}

struct Message {
    let setCardName = NSLocalizedString("SetCardName", tableName: "Korean", value: "Write your card name.", comment: "카드 이름 쓰라는 설명")
    let setCardNumber = NSLocalizedString("SetCardNumber", tableName: "Korean", value: "Write barcode number with no spaces.", comment: "바코드 번호 쓰라는 설명")
    let save = NSLocalizedString("Save", tableName: "Korean", value: "Do you want to save changes?", comment: "저장하겠냐는 알럿 메세지")
    let noBlanks = NSLocalizedString("NoBlanks", tableName: "Korean", value: "Fill in the blanks without omission!", comment: "빈칸 없이 채우라는 알럿 메세지")
}

/** MainTableViewController */
class AddTableViewCell: UITableViewCell {
    @IBOutlet var infoLabel: UIView!
}

class AddTableViewController: UITableViewController, UITextFieldDelegate {

    let colorManager = ColorManager.sharedInstance
    let dataRepository = DataRepository.sharedInstance
    var cell = AddTableViewCell()
    let cardID = SharedMemoryContext.get(key: Key().cardID) as! String
    var cardName = UITextField()
    var barCodeNumber = UITextField()
    var cardInfo = [String]()
    var barCodeImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = colorManager.getMainBackImage()
        tableView.separatorStyle = .none
        makeNavigationItem()
        cardName.delegate = self
        barCodeNumber.delegate = self
        barCodeNumber.addTarget(self, action: #selector(AddTableViewController.textFieldDidChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scanBarcodeNumber(number: SharedMemoryContext.get(key: "scanBarCode"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func makeNavigationItem()  {
        
        let cameraBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        cameraBtn.setImage(UIImage(named: "camera.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cameraBtn.tintColor = colorManager.getTint()
        cameraBtn.addTarget(self, action: #selector(AddTableViewController.clickCamera), for: .touchUpInside)
        let cameraItem = UIBarButtonItem(customView: cameraBtn)
        navigationItem.rightBarButtonItem = cameraItem
        
        let saveBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        saveBtn.setImage(UIImage(named: "before.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        saveBtn.tintColor = colorManager.getTint()
        saveBtn.addTarget(self, action: #selector(AddTableViewController.clickSaveButton), for: .touchUpInside)
        let saveAndBackitem = UIBarButtonItem(customView: saveBtn)
        navigationItem.leftBarButtonItem = saveAndBackitem
    }
    
    @objc func clickSaveButton() {
        self.cell.endEditing(true)
        self.dataRepository.set(cardID: self.cardID, cardName: self.cardName.text!, cardNumber: self.barCodeNumber.text!)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func clickCamera() {
        let barcodeReaderVC = BarcodeReaderViewController()
        self.navigationController?.pushViewController(barcodeReaderVC, animated: true)
    }
    
    func scanBarcodeNumber(number:Any?) {
        let scanNumber = number as? String
        if nil != scanNumber && true != scanNumber?.isEmpty {
            barCodeNumber.text = scanNumber
            SharedMemoryContext.set(key:Key().scanBarCode, setValue: "")
        }
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
            let barcodeNumber = dataRepository.get(cardID: cardID)?.1
            if 1 == indexPath.section && 1 == indexPath.row && false == barcodeNumber?.isEmpty {
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
            let id = Int(cardID)
            cell.backgroundColor = colorManager.getRainbow(section: id!)
        }
        if 1 == indexPath.section && 0 == indexPath.row {
            cardName.frame = commonFrame
            cardName.font = UIFont.boldSystemFont(ofSize: 23.0)
            let attributes = [
                NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15.0)
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
                NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12.0)
            ]
            barCodeNumber.attributedPlaceholder = NSAttributedString(string: Message().setCardNumber, attributes:attributes)
            barCodeNumber.keyboardType = .numberPad
            cell.infoLabel.addSubview(barCodeNumber)
        }
        if 2 == indexPath.section {
            let leatherImage = UIImageView(frame: cell.bounds)
            leatherImage.image = UIImage(named: "leatherBlack_1000.jpg")
            leatherImage.contentMode = .scaleAspectFit
            cell.addSubview(leatherImage)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // barcode image (fullscreen)
        if 1 == indexPath.section && 1 == indexPath.row {
//            SharedMemoryContext.set(key: Key().barcodeNumber, setValue: barCodeNumber.text as Any)
//            let barcodeFullScreen = self.storyboard?.instantiateViewController(withIdentifier: "FullScreenImageViewController") as! FullScreenImageViewController
//            self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
//            self.modalPresentationStyle = .currentContext
//            self.present(barcodeFullScreen, animated: true, completion: nil)
        }
        // leather
        if indexPath.section == 2 {
            cardName.endEditing(true)
            barCodeNumber.endEditing(true)
        }
    }
    
    @objc func textFieldDidChange() {
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
