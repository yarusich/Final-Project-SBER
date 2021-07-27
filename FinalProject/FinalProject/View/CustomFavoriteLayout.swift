//
//  CustomFavoriteLayout.swift
//  FinalProject
//
//  Created by Антон Сафронов on 26.07.2021.
//


import UIKit

protocol CustomFavoriteLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, sizeForViewAtIndexPath indexPath: IndexPath) -> Int
    
    func numberOfColumnsInCollectionView(collectionView:UICollectionView) -> Int
}

final class CustomFavoriteLayout: UICollectionViewLayout {
    weak var delegate: CustomFavoriteLayoutDelegate?
    fileprivate var cellPadding: CGFloat = 1

     fileprivate var cache = [UICollectionViewLayoutAttributes]()

     fileprivate var contentHeight: CGFloat = 0
     private var columsHeights : [CGFloat] = []
     private var avaiableSpaces : [(Int,CGFloat)] = []

     fileprivate var contentWidth: CGFloat {
         guard let collectionView = collectionView else {
             return 0
         }
         let insets = collectionView.contentInset
         return collectionView.bounds.width - (insets.left + insets.right)
     }

     var columnsQuantity : Int{
         get{
             if(self.delegate != nil)
             {
                 return (self.delegate?.numberOfColumnsInCollectionView(collectionView: self.collectionView!))!
             }
             return 0
         }
     }

     private func shortestColumnIndex() -> Int{
         var retVal : Int = 0
         var shortestValue = MAXFLOAT

         var i = 0
         for columnHeight in columsHeights {
             if(Float(columnHeight) < shortestValue)
             {
                 shortestValue = Float(columnHeight)
                 retVal = i
             }
             i += 1
         }
         return retVal
     }

     private func largestColumnIndex() -> Int{
         var retVal : Int = 0
         var largestValue : Float = 0.0

         var i = 0
         for columnHeight in columsHeights {
             if(Float(columnHeight) > largestValue)
             {
                 largestValue = Float(columnHeight)
                 retVal = i
             }
             i += 1
         }
         return retVal
     }

     private func canUseBigColumnOnIndex(columnIndex:Int,size:Int) ->Bool
     {
         if(columnIndex < self.columnsQuantity - (size-1))
         {
             let firstColumnHeight = columsHeights[columnIndex]
             for i in columnIndex..<columnIndex + size{
                 if(firstColumnHeight != columsHeights[i]) {
                     return false
                 }
             }
             return true
         }

         return false
     }

     override var collectionViewContentSize: CGSize {
         return CGSize(width: contentWidth, height: contentHeight)
     }

     override func prepare() {
         guard cache.isEmpty == true, let collectionView = collectionView else {
             return
         }

         self.columsHeights = []
         for _ in 0 ..< self.columnsQuantity {
             self.columsHeights.append(0)
         }

         for item in 0 ..< collectionView.numberOfItems(inSection: 0) {

             let indexPath = IndexPath(item: item, section: 0)

             let viewSize: Int = delegate.collectionView(collectionView, sizeForViewAtIndexPath: indexPath)
             let blockWidth = (contentWidth/CGFloat(columnsQuantity))
             let width = blockWidth * CGFloat(viewSize)
             let height = width

             var columIndex = self.shortestColumnIndex()
             var xOffset = (contentWidth/CGFloat(columnsQuantity)) * CGFloat(columIndex)
             var yOffset = self.columsHeights[columIndex]

             if (viewSize > 1){ //Big Cell
                 if(!self.canUseBigColumnOnIndex(columnIndex: columIndex,size: viewSize)){
                     //  Set column height
                     for i in columIndex..<columIndex + viewSize{
                         if(i < columnsQuantity){
                             self.avaiableSpaces.append((i,yOffset))
                             self.columsHeights[i] += blockWidth
                         }
                     }
                     //  Set column height
                     yOffset = columsHeights[largestColumnIndex()]
                     xOffset = 0
                     columIndex = 0
                 }

                 for i in columIndex..<columIndex + viewSize{
                     if(i < columnsQuantity){
                         //current height
                         let currValue = self.columsHeights[i]
                         //new column height with the update
                         let newValue = yOffset + height
                         //space that will remaing in blank, this must be 0 if its ok
                         let remainder = (newValue - currValue) - CGFloat(viewSize) * blockWidth
                         if(remainder > 0) {
                             //number of spaces to fill
                             let spacesTofillInColumn = Int(remainder/blockWidth)
                             //we need to add those spaces as avaiableSpaces
                             for j in 0..<spacesTofillInColumn {
                                 self.avaiableSpaces.append((i,currValue + (CGFloat(j)*blockWidth)))
                             }
                         }
                         self.columsHeights[i] = yOffset + height
                     }
                 }
             } else {
                 //if there is not avaiable space
                 if (self.avaiableSpaces.count == 0)
                 {
                     self.columsHeights[columIndex] += height
                 } else{//if there is some avaiable space
                     yOffset = self.avaiableSpaces.first!.1
                     xOffset = CGFloat(self.avaiableSpaces.first!.0) * width
                     self.avaiableSpaces.remove(at: 0)
                 }
             }

             let frame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
             let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

             let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
             attributes.frame = insetFrame
             cache.append(attributes)

             contentHeight = max(contentHeight, frame.maxY)
         }
     }

     func getNextCellSize(currentCell: Int, collectionView: UICollectionView) -> Int {
         var nextViewSize = 0
         if currentCell < (collectionView.numberOfItems(inSection: 0) - 1) {
             nextViewSize = delegate.collectionView(collectionView, sizeForViewAtIndexPath: IndexPath(item: currentCell + 1, section: 0))
         }
         return nextViewSize
     }

     override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

         var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

         // Loop through the cache and look for items in the rect
         for attributes in cache {
             if attributes.frame.intersects(rect) {
                 visibleLayoutAttributes.append(attributes)
             }
         }
         return visibleLayoutAttributes
     }

     override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
         return cache[indexPath.item]
     }
}



