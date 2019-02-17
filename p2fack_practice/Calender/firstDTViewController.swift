//
//  firstDTViewController.swift
//  p2fack_practice
//
//  Created by 佐々木真矢 on 2019/02/17.
//  Copyright © 2019 Fuuya Yamada. All rights reserved.
//

import UIKit

class firstDTViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var TtoC: UIButton!
    

   
    @IBOutlet weak var tableView: UITableView!
    
    var received = taskDate()
    
    let TODO = ["選択をする", "布団を洗う"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return TODO.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "afterTableViewCell", for: indexPath) as! afterTableViewCell
        // セルに表示する値を設定する
        cell.aftertaskName =
        return cell    }
    

    @IBOutlet weak var TView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "afterTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "afterTableViewCell")
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
