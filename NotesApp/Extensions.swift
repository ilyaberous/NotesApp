//
//  Extensions.swift
//  NotesApp
//
//  Created by Ilya on 20.01.2023.
//

import Foundation
import UIKit

extension UIView {
    func customAnimateForButton() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        })
        { (_) in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
}
