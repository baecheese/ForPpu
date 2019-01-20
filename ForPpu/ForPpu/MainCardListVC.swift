//
//  MainCardListVC.swift
//  ForPpu
//
//  Created by 배지영 on 20/01/2019.
//  Copyright © 2019 baecheese. All rights reserved.
//

import UIKit

class MainCardListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoImageView: UIImageView!

    let colorManager = ColorManager.sharedInstance
    let cardMenu = CardMenu()
    let dataRepository = DataRepository.sharedInstance
    var cardInfo:[[String:String?]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = colorManager.getMainBackImage()
        setImageViewTintColor()
        if false == VersoinManager.sharedInstance.checkUpdate() {
            showUpdateInfo()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    func setImageViewTintColor() {
        let infoImage = UIImage(named: "info")?.withRenderingMode(.alwaysTemplate)
        infoImageView.image = infoImage
        infoImageView.tintColor = .white
    }

    func moveEditPage(section:Int) {
        let cardId = "\(section)"
        SharedMemoryContext.set(key: Key().cardID, setValue: cardId)
        let addPageVC = self.storyboard?.instantiateViewController(withIdentifier: AddCardVC.className) as! AddCardVC
//        self.navigationController?.pushViewController(addPageVC, animated: true)
        present(addPageVC, animated: true, completion: nil)
    }

    @IBAction func onTouchInfoPageButton(sender: UIButton) {
        let infoPage = self.storyboard?.instantiateViewController(withIdentifier: "infoTableViewController") as? InfoTableViewController
        self.navigationController?.pushViewController(infoPage!, animated: true)
    }

    func showUpdateInfo() {
        SharedMemoryContext.set(key: Key().info, setValue: InfoManager.sharedInstance.updateInfo)
        let infoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InfoDetailViewController") as! InfoDetailViewController
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    
}

extension MainCardListVC: UITableViewDataSource, UITableViewDelegate {

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return cardMenu.rainbow.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cardMenu.rainbow[section]
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TableFrameSize().sectionHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
        let cardID = String(section)
        let nowCardInfo = dataRepository.get(cardID: cardID)
        title.text = nowCardInfo?.0
        title.font = UIFont.boldSystemFont(ofSize: 14.0)
        headerImage.addSubview(title)

        if 0 != section {
            headerView.backgroundColor = .white
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableFrameSize().rowHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Card", for: indexPath) as! MainTableViewCell
        let nowCardInfo = dataRepository.get(cardID: String(indexPath.section))
        if nil == nowCardInfo || true == nowCardInfo?.1.isEmpty {
            let cardInfo = NSLocalizedString("NoCardInfo", tableName: "Korean", value: "No information stored for your card.", comment: "카드 없음 설명")
            cell.info.text = cardInfo
            cell.barcodeImage.image = nil
            return cell
        }
        cell.info.text = nowCardInfo?.1
        cell.barcodeImage.image = dataRepository.showBarCodeImage(cardNumber: (nowCardInfo?.1)!)

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveEditPage(section: indexPath.section)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "delete") { action, index in
            self.dataRepository.delete(cardID: String(indexPath.section))
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        delete.backgroundColor = .red

        return [delete]
    }

}
