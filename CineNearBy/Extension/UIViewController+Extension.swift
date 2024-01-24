//
//  UIViewController+Extension.swift
//  CineNearBy
//
//  Created by hwijinjeong on 1/24/24.
//

import UIKit

extension UIViewController {
    func showActionSheet(completionHandler: @escaping (String) -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let megaBoxAction = UIAlertAction(title: "메가박스", style: .default) { _ in
            completionHandler("메가박스")
        }
        
        let lotteCinemaAction = UIAlertAction(title: "롯데시네마", style: .default) { _ in
            completionHandler("롯데시네마")
        }
            
        let cgvAction = UIAlertAction(title: "CGV", style: .default) { _ in
            completionHandler("CGV")
        }
        
        let allCineAction = UIAlertAction(title: "전체보기", style: .default) { _ in
            completionHandler("전체보기")
        }
            
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
        alert.addAction(megaBoxAction)
        alert.addAction(lotteCinemaAction)
        alert.addAction(cgvAction)
        alert.addAction(allCineAction)
        alert.addAction(cancelAction)
            
        self.present(alert, animated: true, completion: nil)
    }
}
