//
//  home_ViewController.swift
//  p2fack_practice
//
//  Created by Fuuya Yamada on 2019/02/10.
//  Copyright © 2019 Fuuya Yamada. All rights reserved.
//

import UIKit


class home_ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
     let ktaskdata = "TASK_DATA"

    var task = [TaskData]()
  
    //初期ロード
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        load()
        
        self.tableView.register(UINib(nibName:"TableViewCell",bundle:nil), forCellReuseIdentifier:"TableViewCell")
        
        if UserDefaults.standard.object(forKey: "TaskData") != nil {
            task = UserDefaults.standard.object(forKey: "TaskData") as! [TaskData]
        }
    }
    
    //更新
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
        tableView.reloadData()
    }
    
    //数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    
    //セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        // セルに表示する値を設定する
        let now = Date()
        let date = task[indexPath.row].day
        let days = Calendar.current.dateComponents([.day], from: date, to: now).day!
        let format = "\(days)日前"
        cell.taskTime!.text = format
        cell.taskName!.text = task[indexPath.row].name 
        return cell
    }
    
    //セルの選択
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = "リセットしますか？"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okayAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default,handler: nil)
        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel,handler: nil)
        
        alert.addAction(okayAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion:nil)
    }

    //cell高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    
    //cell削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        task.remove(at: index)
        save()
        tableView.reloadData()
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
    //保存
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
    
}
