///
//  addHomeViewController.swift
//  p2fack_practice
//
//  Created by Fuuya Yamada on 2019/02/12.
//  Copyright © 2019 Fuuya Yamada. All rights reserved.
//

import UIKit


class addHomeViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var voice: UITextField!
    
    var pickerView: UIPickerView = UIPickerView()
    var DPicker = DatePickerKeyboard()
    var task = [TaskData]()
    var home = home_ViewController()
    
    //userDefaultに保存するデータのkey
    let ktaskdata = "TASK_DATA"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.placeholder = "やったこと"
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField2.placeholder = "いつやった？"
        textField2.leftViewMode = .always
        textField2.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        voice.placeholder = "通知するボイス"
        voice.leftViewMode = .always
        voice.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        // Do any additional setup after loading the view.
        load()
    }
    
    
    @IBAction func picChoice(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = self
            // ビューに表示
            self.present(pickerView, animated: true)
        }
    }
    
    //Done
    @IBAction func addTask(_ sender: UIBarButtonItem) {
         //let nav = self.navigationController
        // 一つ前のViewControllerを取得する
       //
       // let homeViewController = nav?.viewControllers[(nav?.viewControllers.count)!-2] as! home_ViewController
        
        
        // 値を渡す
        let date = DateUtils.dateFromString(string: textField2.text!, format: "yyyy年MM月dd日")
        task = [TaskData]()
        task.append(TaskData(day: date, name: textField.text!))
        textField.text = ""
        save()
        // popする
        navigationController?.popViewController(animated: true)
    }
    
  //reload
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // 読み込み処理
    func load() {
        // Dictionary配列を読み込み
        let userDefaults = UserDefaults.standard
        if let loadArray = userDefaults.array(forKey: ktaskdata) as? [[String: Any]] {
            // Dictionary配列->ToDo配列に変換
            loadArray.forEach({ item in
                task.append(TaskData(dictionary: item))
            })
        }
    }
    
    // 保存処理
    func save() {
        var saveArray = [[String: Any]]()
        
        //VoiceRecorded配列->Dictionary配列に変換
        task.forEach ({ item in
            saveArray.append(item.dictionaryFromTask())
        })
        // Dictionary配列を保存
        let userDefaults = UserDefaults.standard
        userDefaults.set(saveArray, forKey: ktaskdata)
        userDefaults.synchronize()
    }

    //keyboard close
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
