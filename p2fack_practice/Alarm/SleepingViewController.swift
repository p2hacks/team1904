//
//  SleepingViewController.swift
//  p2fack_practice
//
//  Created by 上野隆斗 on 2020/03/01.
//  Copyright © 2020 Fuuya Yamada. All rights reserved.
//

import UIKit

class SleepingViewController: UIViewController {
    //インスタンスを生成
    var currentTime = CurrentTime()


    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
    currentTime.delegate = self
    }

    @IBAction func closeBtnWasPressed(_ sender: UIButton) {
          performSegue(withIdentifier:"dismiss", sender: nil)
    }
    func updateTime(_ time:String) {
timeLabel.text = time
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
