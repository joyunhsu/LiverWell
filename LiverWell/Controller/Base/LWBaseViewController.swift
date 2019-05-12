//
//  LWBaseViewController.swift
//  LiverWell
//
//  Created by Jo Yun Hsu on 2019/5/12.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import SCLAlertView

class LWBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CheckInternet.Connection() {
            getData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CheckInternet.Connection() == false {
            connectionErrorMsg(getData: getData)
        }
    }
    
    func getData() {
//        print("----------------")
//        print("read data")
    }
    
    func connectionErrorMsg(getData: (() -> Void)?) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false // hide default button
        )
        let alert = SCLAlertView(appearance: appearance) // create alert with appearance
        alert.addButton("重試", action: { // create button on alert
            // action on click
            if CheckInternet.Connection() == false {
                self.connectionErrorMsg(getData: nil)
            } else {
                getData?()
            }
        })
        
        alert.showError("沒有網路連線", subTitle: "請重新確認網路連線")
        
    }

}
