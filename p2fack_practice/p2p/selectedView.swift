            //
//  selectedView.swift
//  p2fack_practice
//
//  Created by 中村　朝陽 on 2019/02/17.
//  Copyright © 2019年 Fuuya Yamada. All rights reserved.
//

import UIKit

class selectedView: UIView {
    
    let kRecordedVoices = "RECORDED_VOICES"

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var album: UIImageView!
    @IBOutlet weak var descri: UILabel!
    
    var recordedVoices = [RecordedVoice]()

    @IBAction func cancel(_ sender: Any) {
        
    }
    @IBAction func saveData(_ sender: Any) {
        save()
    }
    
    init(frame: CGRect, recordedVoice: RecordedVoice) {
        super.init(frame: frame)
        loadNib()
        
        title.text = recordedVoice.name
        descri.text = ""
        load()
        recordedVoices.append(recordedVoice)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    func loadNib() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
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
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
