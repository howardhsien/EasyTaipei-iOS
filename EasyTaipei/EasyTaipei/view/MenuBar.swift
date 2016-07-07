//
//  MenuBar.swift
//
//
//  Created by Howard Hsien on 6/6/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit


protocol MenuBarDelegate :class{
    //delegate to the tabBarController to switch pages
    func switchPages(index: Int)
}

protocol CellDelegate {
    //delegate to the menuBar to setSelectedPages
    func selectIndex(index: Int)

}
struct Icon {
    let title: String
    var image: UIImage {
        didSet{
            image = image.imageWithRenderingMode(.AlwaysTemplate)
        }
    }
    
    init(title:String, image:UIImage){
        self.title = title
        self.image = image
        self.setImage(image)
    }
    
    mutating func setImage(newValue: UIImage){
        self.image = newValue
    }
}


class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,CellDelegate {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.esyDuskBlueColor()
        cv.dataSource = self
        cv.delegate = self
        cv.clipsToBounds = false
        return cv
    }()
    var delegate:MenuBarDelegate?
    let cellId = "cellId"
    var iconArray: [Icon] = [
        Icon(title:"MRT", image: UIImage(named: "MRT")!),
        Icon(title:"YouBike", image: UIImage(named: "bike")!),
        Icon(title:"Toilet", image: UIImage(named: "toilet")!)
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.registerClass(MenuCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges()
        
        //setup first selected tab
        let selectedIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        collectionView.selectItemAtIndexPath(selectedIndexPath, animated: false, scrollPosition: .None)
    }
    
    //MARK: CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! MenuCell

        cell.cellDelegate = self

        cell.setButtonTag(indexPath.item)
        cell.setTabButtonView(iconArray[indexPath.item].title, image: iconArray[indexPath.item].image)

        cell.clipsToBounds = false
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(frame.width / 3, frame.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.switchPages(indexPath.item)
    }
    
    //MARK: cellDelegate : selectIndex
    func selectIndex(index: Int) {
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        //this triggers the cell.selected = true
        collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        //this triggers the collection view didSelect method
        collectionView.delegate?.collectionView!(collectionView, didSelectItemAtIndexPath: indexPath)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}









