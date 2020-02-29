//
//  MyTabBarController.swift
//  p2fack_practice
//
//  Created by 上野隆斗 on 2020/02/29.
//  Copyright © 2020 Fuuya Yamada. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // アイコンの色
        UITabBar.appearance().tintColor = UIColor(red: 239/255, green: 176/255, blue: 84/255, alpha: 1.0) // yellow

        // 背景色
        UITabBar.appearance().barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0) // grey black
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
