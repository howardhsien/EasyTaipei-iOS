//
//  HitTest.swift
//  EasyTaipei
//
//  Created by howard hsien on 2016/7/6.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

extension UITabBar{
    //for button out of bound of cell

    override public func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if(!self.clipsToBounds && !self.hidden && self.alpha > 0.0){
            let subviews = self.subviews.reverse()
            for member in subviews {
                let subPoint = member.convertPoint(point, fromView: self)
                if let result:UIView = member.hitTest(subPoint, withEvent:event) {
                    return result;
                }
            }
        }
        return nil
    }
    
}

extension UICollectionView{
    //for button out of bound of cell
    override public func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if(!self.clipsToBounds && !self.hidden && self.alpha > 0.0){
            let subviews = self.subviews.reverse()
            for member in subviews {
                let subPoint = member.convertPoint(point, fromView: self)
                if let result:UIView = member.hitTest(subPoint, withEvent:event) {
                    return result;
                }
            }
        }
        return nil
    }
}

extension MenuBar{
    //for button out of bound of cell
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if(!self.clipsToBounds && !self.hidden && self.alpha > 0.0){
            let subviews = self.subviews.reverse()
            for member in subviews {
                let subPoint = member.convertPoint(point, fromView: self)
                if let result:UIView = member.hitTest(subPoint, withEvent:event) {
                    return result;
                }
            }
        }
        return nil
    }
    
}


extension MenuCell{
    //for button out of bound of cell
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if(!self.clipsToBounds && !self.hidden && self.alpha > 0.0){
            let subviews = self.subviews.reverse()
            for member in subviews {
                let subPoint = member.convertPoint(point, fromView: self)
                if let result:UIView = member.hitTest(subPoint, withEvent:event) {
                    return result;
                }
            }
        }
        return nil
    }

}