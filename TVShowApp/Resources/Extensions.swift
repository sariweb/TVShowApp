//
//  Extensions.swift
//  TVShowApp
//
//  Created by Sergei on 28.08.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
