//
//  MenuCell.swift
//  EasyTaipei
//
//  Created by howard hsien on 2016/7/7.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

class MenuCell: BaseCell {
    
 
    let tabButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.esyDuskBlueColor()
        return button
    }()
    
    let tabButtonView = TabButtonView.viewFromNib()

    var cellDelegate:CellDelegate?
    
    
    override var highlighted: Bool {
        didSet {
            tabButton.backgroundColor = highlighted ? UIColor.esyBluegreenColor() : UIColor.esyDuskBlueColor()
        }
    }
    
    override var selected: Bool {
        didSet {
            tabButton.backgroundColor = selected ? UIColor.esyBluegreenColor() : UIColor.esyDuskBlueColor()
        }
    }
    
    // setting button tag makes collectionView easier to dothing to cell
    // for cell has no property like indexPath
    func setButtonTag(tag: Int){
        tabButton.tag = tag
    }
    // delegate to collectionview to set selected index
    func setSelected() {
        cellDelegate?.selectIndex(tabButton.tag)
    }
    
    func setTabButtonView(text:String,image:UIImage?) {
        tabButtonView.setLabelText(text)
        if let image = image{
            tabButtonView.setImage(image)
        }
    }
    
    
    override func setupViews() {
        super.setupViews()
        clipsToBounds = false
        
        addSubview(tabButton)
        
        let widthConstraint = NSLayoutConstraint(item: tabButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 78)
        self.addConstraint(widthConstraint)
        let heightConstraint = NSLayoutConstraint(item: tabButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 78)
        tabButton.addConstraint(widthConstraint)
        tabButton.addConstraint(heightConstraint)
        tabButton.layer.cornerRadius = 78/2
        tabButton.autoConstrainAttribute( .Bottom, toAttribute: .Bottom, ofView: self)
        tabButton.autoAlignAxisToSuperviewAxis(.Vertical)
        
        tabButton.addTarget(self, action: #selector(setSelected), forControlEvents: .TouchUpInside)
        
        tabButton.addSubview(tabButtonView)
        tabButtonView.autoPinEdgesToSuperviewEdges()
        
        
    }
    
}
