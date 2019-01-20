//
//  AddCardVC.swift
//  ForPpu
//
//  Created by 배지영 on 20/01/2019.
//  Copyright © 2019 baecheese. All rights reserved.
//

import UIKit

class AddCardVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var carmeraImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!

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
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.backgroundColor = colorManager.getMainBackImage()
        tableView.separatorStyle = .none
        setImageViewTintColor()
        cardName.delegate = self
        barCodeNumber.delegate = self
        barCodeNumber.addTarget(self, action: #selector(AddTableViewController.textFieldDidChange), for: .editingChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        scanBarcodeNumber(number: SharedMemoryContext.get(key: "scanBarCode"))
    }

    func setImageViewTintColor() {
        let backImage = UIImage(named: "before")?.withRenderingMode(.alwaysTemplate)
        backImageView.image = backImage
        backImageView.tintColor = .white
        let carmeraImage = UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate)
        carmeraImageView.image = carmeraImage
        carmeraImageView.tintColor = .white
    }

    @IBAction func onTouchBack(_ sender: UIButton) {
        view.endEditing(true)
        self.dataRepository.set(cardID: self.cardID, cardName: self.cardName.text!, cardNumber: self.barCodeNumber.text!)
//        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onTouchCameraRecognitionToBarcode(_ sender: UIButton) {
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

}

extension AddCardVC: UITableViewDataSource, UITableViewDelegate {

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return Menu().sectionName.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Menu().sectionName[section]
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if 0 != section {
            return 0.1
        }
        return TableFrameSize().sectionHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 1 == section {
            return Menu().cardInfo.count
        }
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if 1 == indexPath.section && 1 == indexPath.row {
            return TableFrameSize().addRowInfoHeghit
        }
        if 2 == indexPath.section {
            return view.frame.height - 230.1
        }
        return TableFrameSize().addRowHeghit
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            leatherImage.image = UIImage(named: "leatherBlack.jpg")
            leatherImage.contentMode = .scaleToFill
            cell.addSubview(leatherImage)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
