//
//  UIView + Extension.swift
//  SwiftWeather
//
//  Created by Jagjeetsingh Labana on 18/11/2024.
//  Copyright © 2024 Jake Lin. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
extension UIView {
    func fixInView(_ container: UIView) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        
        NSLayoutConstraint(
            item: self, attribute: .leading, relatedBy: .equal,
            toItem: container, attribute: .leading, multiplier: 1.0, constant: 0)
        .isActive = true
        
        NSLayoutConstraint(
            item: self, attribute: .trailing, relatedBy: .equal,
            toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0)
        .isActive = true
        
        NSLayoutConstraint(
            item: self, attribute: .top, relatedBy: .equal,
            toItem: container, attribute: .top, multiplier: 1.0, constant: 0)
        .isActive = true
        
        NSLayoutConstraint(
            item: self, attribute: .bottom, relatedBy: .equal,
            toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0)
        .isActive = true
    }
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {

        var borders = [UIView]()

        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }


        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }

        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }

        return borders
    }
    func showBorder(_ color: UIColor, _ cornerRadius: CGFloat, _ borderWidth: CGFloat = 1) {
        DispatchQueue.main.async {
            self.clipsToBounds = true
            self.layer.borderColor = color.cgColor
            self.layer.cornerRadius = cornerRadius
            self.layer.borderWidth = borderWidth
        }
    }
    
    func showShadow(color: UIColor, alpha: Float, radius: CGFloat, offSet: CGSize = .zero, showBezierPath: Bool = true ) {
        DispatchQueue.main.async {
            
            self.backgroundColor = .white
            self.clipsToBounds = false
            self.layer.shadowColor = color.cgColor
            if showBezierPath {
                self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            }
            self.layer.shadowRadius = radius
            self.layer.shadowOffset = offSet
            self.layer.shadowOpacity = alpha
        }
    }
    
    func showShadow() {
        self.showShadow(color: .lightGray, alpha: 1, radius: 5)
    }
    
    func circularView(_ borderWidth: CGFloat = 0) {
        DispatchQueue.main.async {
            var height = self.frame.height
            if height < self.frame.width {
                height = self.frame.width
            }
            self.layer.cornerRadius = CGFloat(Int(height) / 2)
            self.layer.borderWidth = borderWidth
            self.clipsToBounds = true
        }
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
  
    
    func addGradientWithColor(color: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.clear.cgColor, color.cgColor]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
   
    func shakeView(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
        
    }
}
extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
    func showOkAlert(_ title: String = "", _ message: String, completion: (() -> ())? = nil) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            completion?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showOkAlert(_ message: String, completion: (() -> ())? = nil) -> Void {
        showOkAlert("", message, completion: completion)
    }
    
    
    func showToast(message: String) {
        let controller = tabBarController ?? self
        
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25
        toastContainer.clipsToBounds  =  true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])
        
        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)
        controller.view.addConstraints([c1, c2, c3])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    func postMenu(finished:@escaping (Bool) -> Void) -> UIMenu {
        
        // Here we specify the "destructive" attribute to show that it’s destructive in nature
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            print("Click Delete")
            finished(true)
        }
        //        finished(false)
        // Create and return a UIMenu with all of the actions as children
        return UIMenu(title: "", children: [delete])
    }
    
    
    func commentMenu(finished:@escaping (Bool) -> Void) -> UIMenu {
        
        // Here we specify the "destructive" attribute to show that it’s destructive in nature
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            print("Click Delete")
            finished(true)
        }
        //        finished(false)
        // Create and return a UIMenu with all of the actions as children
        return UIMenu(title: "", children: [delete])
    }
    
    func viewPostMenu(finished:@escaping (Bool) -> Void) -> UIMenu {
        
        // Here we specify the "destructive" attribute to show that it’s destructive in nature
        let viewPost = UIAction(title: "View Post", image: UIImage(systemName: "")) { action in
            print("Click Delete")
            finished(true)
        }
        //        finished(false)
        // Create and return a UIMenu with all of the actions as children
        return UIMenu(title: "", children: [viewPost])
    }
    
    
}
