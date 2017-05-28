//
//  MainTableViewController.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct CardMenu {
    let rainbow = ["red", "orange", "yellow", "green", "blue", "indigo", "violet"]
}

struct TableFrameSize {
    let sectionHeight:CGFloat = 30.0
    let rowHeight:CGFloat = 80.0
    let sectionLabelHeight:CGFloat = 15.0
    let addRowHeghit:CGFloat = 49.0
    let addRowInfoHeghit:CGFloat = 35.0
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
        tableView.backgroundColor = colorManager.getMainColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationColor()
        tableView.reloadData()
        showFullScreenBarcode()
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
        return TableFrameSize().sectionHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40.0))
        let headerImage = UIImageView(frame: headerView.bounds)
        headerImage.image = UIImage(named: "headerImage.png")
        headerImage.contentMode = .scaleToFill
        headerImage.clipsToBounds = true
        headerImage.image = headerImage.image!.withRenderingMode(.alwaysTemplate)
        headerImage.tintColor = colorManager.getRainbow(section: section)
        headerView.addSubview(headerImage)
        let margenX:CGFloat = 15.0
        let margenY:CGFloat = headerImage.frame.height/2 - TableFrameSize().sectionLabelHeight/2
        let title = UILabel(frame: CGRect(x: margenX, y: margenY, width: tableView.frame.width - margenX*2, height: TableFrameSize().sectionLabelHeight))
        let nowCardInfo = dataRepository.get(cardID: section)
        title.text = nowCardInfo?.0
        title.font = UIFont.boldSystemFont(ofSize: 14.0)
        headerImage.addSubview(title)
        
        if 0 != section {
            headerView.backgroundColor = .white
        }
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableFrameSize().rowHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Card", for: indexPath) as! MainTableViewCell
        let nowCardInfo = dataRepository.get(cardID: indexPath.section)
        if nil == nowCardInfo {
            let cardInfo = NSLocalizedString("NoCardInfo", tableName: "Korean", value: "No information stored for your card.", comment: "카드 없음 설명")
            cell.info.text = cardInfo
            cell.barcodeImage.image = nil
            return cell
        }
        cell.info.text = nowCardInfo?.1
        cell.barcodeImage.image = dataRepository.showBarCodeImage(cardNumber: (nowCardInfo?.1)!)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveEditPage(section: indexPath.section)
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "delete") { action, index in
            self.dataRepository.delete(cardID: indexPath.section)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        delete.backgroundColor = .red
        
        return [delete]
    }
    
    func moveEditPage(section:Int) {
        SharedMemoryContext.set(key: Key().cardID, setValue: section)
        let addPage = self.storyboard?.instantiateViewController(withIdentifier: "AddTableViewController") as! AddTableViewController
        self.navigationController?.pushViewController(addPage, animated: true)
    }
    
    func setNavigationColor() {
        navigationController?.navigationBar.barTintColor = colorManager.getMainColor()
        navigationController?.navigationBar.tintColor = colorManager.getTint()
    }
    
    func showFullScreenBarcode() {
        if nil != dataRepository.getSelectWidgetInfo() {
            let fullScreenBarcodeImageVC = self.storyboard?.instantiateViewController(withIdentifier: "FullScreenImageViewController") as! FullScreenImageViewController
            fullScreenBarcodeImageVC.modalPresentationStyle = .overCurrentContext
            present(fullScreenBarcodeImageVC, animated: true, completion: nil)
        }
    }
    
}
