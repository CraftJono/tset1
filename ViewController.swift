//
//  ViewController.swift
//  补点测试
//
//  Created by zeki on 2023/11/1.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 创建 SmoothLineView 实例
        let smoothLineView = PressureFreeLineView()
        smoothLineView.backgroundColor = .white

        // 设置 SmoothLineView 的位置和大小
        smoothLineView.frame = view.bounds

        // 将 SmoothLineView 添加到视图控制器的视图中
        self.view.addSubview(smoothLineView)
    }


}

