//
//  TabButtonView.swift
//  EasyTaipei
//
//  Created by howard hsien on 2016/7/7.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit


class TabButtonView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    class func viewFromNib(frame : CGRect? = nil) -> TabButtonView{
        let view = loadFromNibNamed("TabButtonView") as? TabButtonView
        if let frame = frame{
            view?.frame = frame
        }
        return view!
    }
    
    func setImage(image: UIImage){
        imageView.image = image
        imageView.tintColor = UIColor.esyOffWhiteColor()
    }
    
    func setLabelText(text: String){
        label.text = text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userInteractionEnabled = false
    }
    
    
//    //MARK: test for overriding init
//    override init (frame : CGRect) {
//        super.init(frame : frame)
//    }
//    
//    convenience init () {
//        self.init(frame:CGRect.zero)
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("This class does not support NSCoding")
//    }
    
 



}
