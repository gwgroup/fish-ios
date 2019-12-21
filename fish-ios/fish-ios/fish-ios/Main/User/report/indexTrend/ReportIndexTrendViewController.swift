//
//  ReportIndexTrendViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/20.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

public struct ReportDetailItem {
    public var item1: String?
    public var item2: String?
    
    public init(item1: String, item2: String) {
        self.item1 = item1
        self.item2 = item2
    }
}

class ReportIndexTrendViewController:  FishPreViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var monthLabelView:UILabel!
    
    
    var titleItemView:HorizontalTitleItemView = HorizontalTitleItemView.titleItemView()
    var popMenu:SwiftPopMenu!
    var sceneList:[PondSceneModel] = [];
    
    var client: FishMainApi = FishMainApi()
    
    var userInfoModel:UserInfoModel?
    
    var selectedMonthCode:String = ""
    
    var monthInitList:[PickViewItem] = []
    
    var detailItems:[ReportDetailItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "指标趋势"
        
        titleItemView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: titleItemView)
        
        titleItemView.isHidden = true
        
        
        self.tableView.register(UINib.init(nibName: "ReportIndexTrendTableViewCell", bundle: nil), forCellReuseIdentifier: ReportIndexTrendTableViewCellReuseID)
        
        self.tableView.tableFooterView = UIView.init()
        
        // Do any additional setup after loading the view.
        
        var formatterDates:[PickViewItem] = []
        for i in 0..<12 {
            
            let preMonth = Calendar.current.date(byAdding: .month, value: -i, to: Date())
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM"
            let dateStr = dateFormatter.string(from: preMonth!)
            
            dateFormatter.dateFormat = "yyyy年MM月"
            let chinaDateStr = dateFormatter.string(from: preMonth!)
            
            formatterDates.append(PickViewItem.init(code: dateStr, name: chinaDateStr))
            
            if i == 0 {
                self.selectedMonthCode = dateStr
                self.monthLabelView.text = chinaDateStr
            }
            
        }
        
        //近一年
        self.monthInitList = formatterDates.reversed()
        
        
        self.detailItems = [ReportDetailItem.init(item1: "日期", item2: "时长"),
                            ReportDetailItem.init(item1: "2019-08-10", item2: "2013"),
                            ReportDetailItem.init(item1: "2019-08-10", item2: "2014")]
        
        
        // 获取鱼塘列表
        self.loadAllScene()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func loadData() -> Void {
        
        
        self.client.userInfo(callBack:  { (data, error) in
            
            self.tableView?.mj_header?.endRefreshing()
            
            if let err = Parse.parseResponse(data, error) {
                self.view.makeHint(err.showMessage)
                return
            }
            if let d = data?.data {
                self.userInfoModel = d
                self.tableView.reloadData()
                //                self.alertList = d
                //                self.tableView.reloadData()
            } else {
                self.view.makeHint("数据获取失败，请稍后再试")
            }
            
        })
        
        //        self.client.getAllTrigger(params: ["device_mac":self.selectedSceneModel?.deviceMac ?? "-"], callBack: { (data, error) in
        //
        //            self.tableView?.mj_header?.endRefreshing()
        //
        //            if let err = Parse.parseResponse(data, error) {
        //                self.view.makeHint(err.showMessage)
        //                return
        //            }
        //            if let d = data?.data, !d.isEmpty {
        //                self.alertList = d
        //                self.tableView.reloadData()
        //            } else {
        //                self.view.makeHint("数据获取失败，请稍后再试")
        //            }
        //        })
        
    }
    
    
    @IBAction func monthButtonTouchUpInSide(_ sender: Any)  {
        
        self.showSingleCustomPickerView(selectVal: self.selectedMonthCode, list: self.monthInitList, callback: { (item) in
            
            self.selectedMonthCode = item.code!
            self.monthLabelView.text = item.name
            
        })
    }
    
    
    
    func showSingleCustomPickerView(selectVal:String?, list:[PickViewItem], callback:@escaping (PickViewItem) ->()) {
        
        let pickerVC = SingleCustomPickerViewController()
        pickerVC.modalTransitionStyle = .coverVertical
        pickerVC.modalPresentationStyle = .overFullScreen
        
        pickerVC.reset(val: selectVal, list: list)
        
        pickerVC.confirmCallBack = { (val :PickViewItem) in
            //确定按钮回调
            callback(val)
            //            print(val.name)
        }
        
        self.present(pickerVC, animated: true, completion: nil)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = ReportLineChartView.chartView()
        
//        headerView.showData(model: self.userInfoModel)
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 238
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: ReportIndexTrendTableViewCellReuseID)
        
        
        guard let eCell = cell as? ReportIndexTrendTableViewCell else {
            return cell
        }
        eCell.selectionStyle = .none
        eCell.showData(model: self.detailItems[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
//        if let type =  self.tableItemData[index]["type"] {
//
//            if type == "report" {
//                print("report")
//
//                let report = UserReportViewController()
//                self.navigationController?.pushViewController(report, animated: true)
//
//            }
//            if type == "phone" {
//                print("phone")
//            }
//        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: Net Request
    
    func loadAllScene() {
        
        self.client.getAllScene() { (data, error) in
            
            if let err = Parse.parseResponse(data, error) {
                self.view.makeHint(err.showMessage)
                return
            }
            
            if let d = data?.data, !d.isEmpty {
                self.sceneList = d
                if (self.sceneList.count > 0) {
                    self.titleItemView.isHidden = false
                    self.titleItemView.reloadSelectedPond(model: self.sceneList[0])
                    
                    //TODO: 触发数据刷新
                    
                }
            } else {
                self.view.makeHint("数据获取失败，请稍后再试")
            }
        }
    }
    
    
    func showMenuBtnClick(view:UIView) {
        
        let point = view.convert(CGPoint(x: 0, y: 0), to: FishKeyWindow())
        //数据源（icon可不填）
        
        var popData:[String]  = []
        for scene in self.sceneList {
            popData.append(scene.sceneName ?? "-")
        }
        
        //设置Parameter（可不写）
        popMenu = SwiftPopMenu(frame:  CGRect(x: SCREEN_WIDTH - 105, y: point.y + 40, width: 100, height: 126))
        popMenu.popTextColor = UIColor.colorWithHexString("#FFFFFF")!
        popMenu.popMenuBgColor = UIColor.colorWithHexString("#1F1F1F")!
        popMenu.popData = popData
        
        //click
        
        popMenu.didSelectMenuBlock = { [weak self](index:Int)->Void in
            print("block select \(index)")
            self?.popMenu.dismiss()
            self?.popMenu = nil
            
            if let model = self?.sceneList[index] {
                self?.titleItemView.isHidden = false
                self?.titleItemView.reloadSelectedPond(model: model)
                
                 //TODO: 触发数据刷新
            }
            
            
        }
        
        //show
        popMenu.show()
    }
    
    
}



//开启右滑返回手势:
extension ReportIndexTrendViewController:HorizontalTitleItemViewDelegate {
    
    func showMore() {
        self.showMenuBtnClick(view: self.titleItemView)
    }
    
}

