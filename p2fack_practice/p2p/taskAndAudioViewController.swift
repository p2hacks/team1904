//
//  taskAndAudioViewController.swift
//  p2fack_practice
//
//  Created by 中村　朝陽 on 2019/02/16.
//  Copyright © 2019年 Fuuya Yamada. All rights reserved.
//

import UIKit

class taskAndAudioViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var recordedVoices = [RecordedVoice]()
    var taskList = [String]()
    
    let kRecordedVoices = "RECORDED_VOICES"
    let kTaskList = "TaskList"
    let sections = ["task", "recorded"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVoice()
        // Do any additional setup after loading the view.
    }
    
    // 読み込み処理
    func loadVoice() {
        // Dictionary配列を読み込み
        let userDefaults = UserDefaults.standard
        if let loadArray = userDefaults.array(forKey: kRecordedVoices) as? [[String: Any]] {
            // Dictionary配列->ToDo配列に変換
            loadArray.forEach({ item in
                recordedVoices.append(RecordedVoice(dictionary: item))
            })
        }
    }
    
    func loadTask(){
        let userDefaults = UserDefaults.standard
        taskList = userDefaults.array(forKey: kTaskList) as! [String]
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

extension taskAndAudioViewController: UITableViewDelegate, UITableViewDataSource{
    //セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    //セクションのヘッダーの内容
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return taskList.count
        case 1:
            print("\(recordedVoices.count)")
            return recordedVoices.count
        default:
            return 0
        }
    }
    
    //セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel!.text = taskList[indexPath.row]
            return cell
        case 1:
            cell.textLabel!.text = recordedVoices[indexPath.row].name
            return cell
        default:
            return cell
        }
        
    }
    
    //セルタップ時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nav = self.navigationController
        // 一つ前のViewControllerを取得する
        let p2pViewController = nav?.viewControllers[(nav?.viewControllers.count)!-2] as! p2p_ViewController
        switch indexPath.section{
        case 0:
            p2pViewController.sendString(str: taskList[indexPath.row])
        case 1:
            p2pViewController.recordedVoice = recordedVoices[indexPath.row]
            p2pViewController.isAudio = true
            // popする
            _ = navigationController?.popViewController(animated: true)

            print("case 1")
            //storyBoard.sendAudio(audioData: recordedVoices[indexPath.row])
        default:
            break
        }
    }
}
