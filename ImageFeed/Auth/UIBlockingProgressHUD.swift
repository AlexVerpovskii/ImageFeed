//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Александр Верповский on 21.06.2024.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    
}
