//
//  AlarmViewController.swift
//  p2fack_practice
//
//  Created by 上野隆斗 on 2020/02/29.
//  Copyright © 2020 Fuuya Yamada. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {
    //インスタンスを生成
    let alarm = Alarm()
    @IBOutlet weak var sleepTimePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        //UIDatePickerを.timeモードにする
        sleepTimePicker.datePickerMode = UIDatePicker.Mode.time
        //現在の時間をDatePickerに表示
        sleepTimePicker.setDate(Date(), animated: false)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func alarmBtnWasPressed(_ sender: UIButton) {
        //AlarmにあるselectedWakeUpTimeにユーザーの入力した日付を代入
        alarm.selectedWakeUpTime = sleepTimePicker.date
        //AlarmのrunTimerを呼ぶ
        alarm.runTimer()
performSegue(withIdentifier:"toSecond", sender: nil)
    }
    

    override func viewDidAppear(_ animated: Bool) {
         //AlarmでsleepTimerがnilじゃない場合
        if alarm.sleepTimer != nil{
            //再生されているタイマーを止める
            alarm.stopTimer()
        }
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

