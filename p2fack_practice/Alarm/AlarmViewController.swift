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
    let voice = voice_ViewController()
    
        @IBOutlet weak var sleepTimePicker: UIDatePicker!

    @IBOutlet weak var startBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetting()
        //UIDatePickerを.timeモードにする
        sleepTimePicker.datePickerMode = UIDatePicker.Mode.time
        //現在の時間をDatePickerに表示
        sleepTimePicker.setDate(Date(), animated: false)
        // Do any additional setup after loading the view.
    }
    
    func buttonSetting() {
        startBtn.backgroundColor = MyColor.mainOrange
        startBtn.layer.cornerRadius = 25.0
        startBtn.layer.shadowOffset = CGSize(width: 3, height: 3 )
        startBtn.layer.shadowOpacity = 0.5
        startBtn.layer.shadowRadius = 10
        startBtn.layer.shadowColor = UIColor.gray.cgColor
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

