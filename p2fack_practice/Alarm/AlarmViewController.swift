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
    var voice = voice_ViewController()
    
        @IBOutlet weak var sleepTimePicker: UIDatePicker!
    @IBOutlet weak var musicPicker: UIPickerView!
    @IBOutlet weak var startBtn: UIButton!
        let defaults = ["あんたは私の何を知る", "好きだったこの場所", "黒い羊 2 ", "僕は嫌だ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.voice = voice_ViewController()
        buttonSetting()
        //UIDatePickerを.timeモードにする
        sleepTimePicker.datePickerMode = UIDatePicker.Mode.time
        //現在の時間をDatePickerに表示
        sleepTimePicker.setDate(Date(), animated: false)
       musicPicker.delegate = self
        musicPicker.dataSource = self
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
}
    extension AlarmViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
       // ドラムロールの列数
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       // ドラムロールの行数
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  voice.sections.count
       }
       
   // ドラムロールの各タイトル
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return defaults[row]
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

