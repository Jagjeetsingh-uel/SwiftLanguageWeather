//
//  UITableViewExtension + Helper.swift
//  SwiftWeather
//
//  Created by Jagjeetsingh Labana on 18/11/2024.
//  Copyright © 2024 Jake Lin. All rights reserved.
//

import Foundation
import UIKit    
extension UITableView {
    
    public enum EffectEnum {
        case roll
        case LeftAndRight
        case slideLeftToRight
        case slideRightToLeft
    }
    
    public func reloadData(effect: EffectEnum , minimumAnimation : Bool = false) {
        self.reloadData()
        
        switch effect {
        case .roll:
            roll(minimumAnimation)
            break
        case .LeftAndRight:
            leftAndRightMove()
            break
        case .slideLeftToRight:
            slideLeftToRight()
            break
        case .slideRightToLeft:
            slideRightToLeft()
            break
        }
        
    }
    
    private func roll(_ minimumAnimation : Bool = false) {
        let cells = self.visibleCells
        
        let tableViewHeight = self.bounds.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: minimumAnimation ? 0.5 : 2, delay: minimumAnimation ? 0.035 : Double(delayCounter) * 0.035, usingSpringWithDamping: minimumAnimation ? 0.85 : 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    private func leftAndRightMove() {
        let cells = self.visibleCells
        
        let tableViewWidth = self.bounds.width
        
        var alternateFlag = false
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: alternateFlag ? tableViewWidth : tableViewWidth * -1, y: 0)
            alternateFlag = !alternateFlag
        }
        
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: 2, delay: Double(delayCounter) * 0.035, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    private func slideRightToLeft() {
        let cells = self.visibleCells
        let tableViewWidth = self.bounds.width
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: tableViewWidth, y: 0)
        }
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 2, delay: Double(delayCounter) * 0.035, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    private func slideLeftToRight() {
        let cells = self.visibleCells
        let tableViewWidth = self.bounds.width
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: tableViewWidth * -1, y: 0)
        }
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 2, delay: Double(delayCounter) * 0.035, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}
extension UITableViewCell {
    func doSlideFromLeftAnimation(tableViewWidth : CGFloat, delay : TimeInterval = 0.035,withDuration : TimeInterval = 1.5){
        self.transform = CGAffineTransform(translationX: tableViewWidth * -1, y: 0)
        UIView.animate(withDuration: withDuration, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    func doSlideFromRightAnimation(tableViewWidth : CGFloat, delay : TimeInterval = 0.035,withDuration : TimeInterval = 1.5){
        self.transform = CGAffineTransform(translationX: tableViewWidth, y: 0)
        UIView.animate(withDuration: withDuration, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    func doFadeAnimation(with indexPath : IndexPath, withDelay : Double = 0.05){
        self.alpha = 0
        UIView.animate(withDuration: 0.7, delay: withDelay * Double(indexPath.row), animations: {
            self.alpha = 1
        })
    }
    func doCustomSpringAnimation(with indexPath : IndexPath, withDuration : TimeInterval = 0.7, delay : TimeInterval = 0.03,usingSpringWithDamping : CGFloat = 0.5, initialSpringVelocity : CGFloat = 0.1){
        self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        UIView.animate(
            withDuration: withDuration,
            delay: delay * Double(indexPath.row),
                    usingSpringWithDamping: usingSpringWithDamping,
                    initialSpringVelocity: initialSpringVelocity,
                    options: [.curveEaseInOut],
                    animations: {
                        self.transform = CGAffineTransform(translationX: 0, y: 0)
                })
    }
}
