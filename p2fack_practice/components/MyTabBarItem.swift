//
//  MyTabBarItem.swift
//  p2fack_practice
//
//  Created by 上野隆斗 on 2020/03/01.
//  Copyright © 2020 Fuuya Yamada. All rights reserved.
//

import UIKit

class MyTabBarItem: UITabBarItem {
    //storyboardで設置した時
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setAppearance()
    }

    private func setAppearance() {
        //ライフサイクル内ならselfでVCから参照すれば使わなくてもいける->NCのみ
        //tabBarの画像は30*30px(Retinaだと60*60)
        switch self.tag {
        case 0:
            self.setTabBarItem(title: "", image: UIImage(named: "alerm")!, selectedImage: UIImage(named: "alerm")!)
        case 1:
            self.setTabBarItem(title: "", image: UIImage(named: "mic")!, selectedImage: UIImage(named: "mic")!)
        default:
            break
        }
    }

    func setTabBarItem(title: String, image: UIImage, selectedImage: UIImage) -> Void {
        self.title = title
        self.image = image//.withRenderingMode(.alwaysOriginal)<-PDFの時はこの設定いらない
        self.selectedImage = selectedImage//.withRenderingMode(.alwaysOriginal)<-PDFの時はこの設定いらない
    }
}
