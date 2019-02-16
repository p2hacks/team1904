//
//  RootViewController.swift
//  p2fack_practice
//
//  Created by 中村　朝陽 on 2019/02/16.
//  Copyright © 2019年 Fuuya Yamada. All rights reserved.

//MARK サイドメニューと初期画面のUIViewControllerを保持する
//MARK サイドメニューを開く
//MARK 画面遷移の際に現在のViewControllerを捨てて新しいものにする

import UIKit

class RootViewController: UIViewController {
    
    var contentViewController:UIViewController!
    var sideMenuViewController:UIViewController!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("RootViewController.init(coder)");
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("RootViewController.init(nibName, bundle)");
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //各viewControllerをロード
        self.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "p2p_ViewController")
        self.sideMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "taskAndAudioViewController")
        
        addChild(self.contentViewController)
        self.view.addSubview(self.contentViewController.view)
        self.contentViewController.didMove(toParent: self)
        
        addChild(self.sideMenuViewController)
        self.view.addSubview(self.sideMenuViewController.view)
        self.sideMenuViewController.didMove(toParent: self)
        
        self.sideMenuViewController.view.isHidden = true
    
        self.view.bringSubviewToFront(self.sideMenuViewController.view)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //サイドメニュー外をタップした際にシドメニューを開く
    @objc func backgroundTapped(sender: UITapGestureRecognizer){
        dismissMenuViewController()
    }
    
    // メニューViewControllerの表示
    func presentMenuViewController(){
        sideMenuViewController.beginAppearanceTransition(true, animated: true)
        self.sideMenuViewController.view.isHidden = false
        //サイドメニューを画面の3/4まで移動する
        self.sideMenuViewController.view.frame = sideMenuViewController.view.frame.offsetBy(dx: -sideMenuViewController.view.frame.size.width, dy: 0)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: UIView.AnimationOptions.curveEaseOut, animations: {
            let bounds = self.sideMenuViewController.view.bounds
            self.sideMenuViewController.view.frame = CGRect(x:-bounds.size.width * 1 / 4, y:0, width:bounds.size.width, height:bounds.size.height)
        }, completion: {_ in
            self.sideMenuViewController.endAppearanceTransition()
        })
    }
    
    // メニューViewControllerの非表示
    func dismissMenuViewController(){
        self.sideMenuViewController.beginAppearanceTransition(false, animated: true)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.sideMenuViewController.view.frame = self.sideMenuViewController.view.frame.offsetBy(dx: -self.sideMenuViewController.view.bounds.size.width * 3 / 4, dy: 0)
        }, completion: {_ in
            self.sideMenuViewController.view.isHidden = true
            self.sideMenuViewController.endAppearanceTransition()
        })
    }
    
    //コンテンツViewControllerにUIViewControllerをセット.
    func set(contentViewController: UIViewController){
        
        // 既存コンテンツの開放
        self.contentViewController.willMove(toParent: nil)
        self.contentViewController.view.removeFromSuperview()
        self.contentViewController.removeFromParent()
        
        // 新コンテンツのセット
        self.contentViewController = contentViewController
        self.view.addSubview(contentViewController.view)
        self.view.bringSubviewToFront(self.sideMenuViewController.view)
        self.addChild(contentViewController)
        
        // 新コンテンツフェードイン
        contentViewController.view.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            contentViewController.view.alpha = 1
        }, completion: { _ in
            contentViewController.didMove(toParent: self)
        })
    }
}

//rootViewControllerを親にもつViewControllerのみがrootViewContorollerのインスタンスを生成できる
extension UIViewController {
    func rootViewController() -> RootViewController? {
        var vc = self.parent
        while(vc != nil){
            guard let viewController = vc else { return nil }
            if viewController is RootViewController {
                return viewController as? RootViewController
            }
            vc = viewController.parent
        }
        return nil
    }
}
