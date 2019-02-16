//
//  Daytask_ViewController.swift
//  p2fack_practice
//
//  Created by 佐々木真矢 on 2019/02/17.
//  Copyright © 2019 Fuuya Yamada. All rights reserved.
//

import UIKit

class Daytask_ViewController: UIViewController {

  
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var CtoT: UIButton!
   
    @IBAction func CtoT(_ sender: Any) {
        let storyboard: UIStoryboard = self.storyboard!
        let second = storyboard.instantiateViewController(withIdentifier: "seni1")
        self.present(second, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
