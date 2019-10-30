//
//  PondViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/15.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit
import Pageboy
import Tabman

class PondViewController:  TabmanViewController, PageboyViewControllerDataSource {
    
    lazy var viewControllers: [PondContentViewController] = {
        var viewControllers = [PondContentViewController]()
        for i in 0 ..< 5 {
            let vc = PondContentViewController();
//            let view = UIView()
//            view.frame = CGRect(x: 0, y: 0, width: 100, height: 50);
//            view.backgroundColor = UIColor.darkText
//            vc.view.addSubview(view)
////            vc.automaticallyAdjustsScrollViewInsets = true
//            vc.view.backgroundColor = i % 2 == 0 ? UIColor.red : UIColor.yellow
            viewControllers.append(vc)
        }
        return viewControllers
    }()
    
    
    // modify TabmanScrollingButtonBar
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.dataSource = self
        self.automaticallyAdjustsChildScrollViewInsets = true
        // configure the bar
        self.bar.items = [Item(title: "Page 1"),
                          Item(title: "Page 2"), Item(title: "Page 2"), Item(title: "Page 2"), Item(title: "Page 2"), Item(title: "Page 2"),  Item(title: "Page 2")]
        
        self.bar.style = .scrollingButtonBar
        self.bar.location = .top
        
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in

            // customise appearance here
//            appearance.text.
//            appearance.text.color = UIColor.red
            appearance.style.background = .solid(color: UIColor.white)
//            appearance.indicator.isProgressive = true
        })
        
        self.embedBar(in: (self.navigationController?.navigationBar)!)
//        self.embeddingView =
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
