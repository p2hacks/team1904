//
//  voice_ViewController.swift
//  p2fack_practice
//
//  Created by Fuuya Yamada on 2019/02/10.
//  Copyright © 2019 Fuuya Yamada. All rights reserved.
//

import UIKit
import AVFoundation

class voice_ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate{

    @IBOutlet weak var voice: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var reserve = -1
    var Rcount = 0
    let image0:UIImage = UIImage(named:"recordIcon.png")!
    let image1:UIImage = UIImage(named:"stopButtun.png")!
    //userDefaultに保存するデータのkey
    let kRecordedVoices = "RECORDED_VOICES"
    let sections = ["default", "recorded"]
    let defaults = ["あんたは私の何を知る", "好きだったこの場所", "黒い羊 2 ", "僕は嫌だ"]
    
    var count = 0
    var audioPlayer:AVAudioPlayer!
    var audioRecorder: AVAudioRecorder!
    //録音音声保存用のデータクラス
    var recordedVoices = [RecordedVoice]()
    //デフォルトで入れておく音声
    var defautVoices = [RecordedVoice]()

    @IBAction func voice(_ sender: Any) {
        count += 1
        if(count%2 == 0){
            audioRecorder.stop()
            
            tableView.reloadData()
            voice.setImage(image0, for: .normal)
        }else{
            record()
            voice.setImage(image1, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        load()
        getDefaultAudio()
              // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
            // NavigationControllerで表示された時に実行する内容
    }
    //再生する音声をセット
    func setAudioPlayer(audioPath:String){
        let audioUrl = URL(fileURLWithPath: audioPath)
        // auido を再生するプレイヤーを作成する
        var audioError:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
        }
        // エラーが起きたとき
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
    }
    
    //再生終了したときに呼ばれる
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("再生終了")
        audioPlayer.stop()
        count += 1
        voice.setImage(image0, for: .normal)
    }
    //defaultの音声取得
    func getDefaultAudio(){
        for def in defaults{
            guard let path = Bundle.main.path(forResource: def, ofType:"mp3") else {
                print("そのファイルパス間違ってるから")
                return
            }
            print(path)
            defautVoices.append(RecordedVoice(path: path, name: def))
            
        }
    }
    //音声保存
    func record(){
        let session = AVAudioSession.sharedInstance()
        do {
            try AVAudioSessionPatch.setSession(session, category: .playAndRecord, with: [.defaultToSpeaker, .duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        audioRecorder = try! AVAudioRecorder(url: getURL(), settings: settings)
        audioRecorder.delegate = self
        audioRecorder.record()
        
        save()
    }
    
    func getURL() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let now = getNowTime()
        let url = docsDirect.appendingPathComponent("recording" + now + ".m4a")
        print(url.path)
        recordedVoices.append(RecordedVoice(path: url.path, name: "recording" + now + ".m4a"))
        return url
    }
    
    func getNowTime() -> String {
        let now = NSDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        let string = formatter.string(from: now as Date)
        
        return string
    }
    
    // 読み込み処理
    func load() {
        // Dictionary配列を読み込み
        let userDefaults = UserDefaults.standard
        if let loadArray = userDefaults.array(forKey: kRecordedVoices) as? [[String: Any]] {
            // Dictionary配列->ToDo配列に変換
            loadArray.forEach({ item in
                recordedVoices.append(RecordedVoice(dictionary: item))
            })
        }
    }
    
    // 保存処理
    func save() {
        var saveArray = [[String: Any]]()
        
        //VoiceRecorded配列->Dictionary配列に変換
        recordedVoices.forEach ({ item in
            saveArray.append(item.dictionaryFromVoice())
        })
        // Dictionary配列を保存
        let userDefaults = UserDefaults.standard
        userDefaults.set(saveArray, forKey: kRecordedVoices)
        userDefaults.synchronize()
        
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

extension voice_ViewController: UITableViewDataSource, UITableViewDelegate{
    
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
            return defautVoices.count
        case 1:
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
            cell.textLabel!.text = defautVoices[indexPath.row].name
            return cell
        case 1:
            cell.textLabel!.text = recordedVoices[indexPath.row].name
            return cell
        default:
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            setAudioPlayer(audioPath: defautVoices[indexPath.row].path)
            if(reserve == indexPath.row && Rcount == 1){
                audioPlayer.stop()
                Rcount = 0
            }else if(reserve == indexPath.row && Rcount == 0){
                audioPlayer.play()
                Rcount = 1
            }else if(reserve != indexPath.row && Rcount == 0){
                audioPlayer.play()
                Rcount = 1
            }else if(reserve != indexPath.row && Rcount == 1){
                audioPlayer.play()
                Rcount = 1
            }
            reserve = indexPath.row
        case 1:
            setAudioPlayer(audioPath: recordedVoices[indexPath.row].path)
            audioPlayer.play()
        default: break
            
        }
    
    }
    
    //cell削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        recordedVoices.remove(at: index)
        save()
        tableView.reloadData()
    }
}
