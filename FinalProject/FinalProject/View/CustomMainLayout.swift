//
//  CustomLayout.swift
//  FinalProject
//
//  Created by Антон Сафронов on 08.07.2021.
//

import UIKit

final class CustomMainLayout: UICollectionViewLayout {
    private let section = 0
    private let lineSpacing: CGFloat = 0
//    MARK: Задаём размер элемента из вне (убрать 31)
//    var itemSize: CGSize = .zero {
//        didSet {
//            invalidateLayout()
//        }
//    }
    
    var cache = CustomePhotoLayoutCache.zero
    
    override var collectionViewContentSize: CGSize {
        return cache.contentSize
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        let numberOfItems = collectionView.numberOfItems(inSection: section)
//        MARK: Привязал высоту к ширине
        let sizeOfRect = collectionView.bounds.width
        cache = CustomePhotoLayoutCache(itemSize: .init(width: sizeOfRect, height: sizeOfRect), lineSpacing: lineSpacing, collectionWidth: collectionView.bounds.width)
        cache.recalculateDefaulFrames(numberOFItems: numberOfItems)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let indexes = cache.visibleRows(in: rect)
        let cells = indexes.map { (row) -> UICollectionViewLayoutAttributes? in
            let path = IndexPath(row: row, section: section)
            let attributes = layoutAttributesForItem(at: path)
            return attributes
        }.compactMap { $0 }
        return cells
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = cache.defaultCellFrame(atRow: indexPath.row)
        return attributes
    }

    
}
// MARK: Cache, куда-то пихнуть надо
class CustomePhotoLayoutCache {
    
    private let itemSize: CGSize
    private let lineSpacing: CGFloat
    private let collectionWidth: CGFloat
    private var defaultFrames = [CGRect]()

    var contentSize: CGSize {
        return CGSize(width: collectionWidth, height: defaultFrames.last?.maxY ?? 0)
    }
    
    static var zero: CustomePhotoLayoutCache {
        return CustomePhotoLayoutCache(itemSize: .zero, lineSpacing: 0, collectionWidth: 0)
    }
    
    init(itemSize: CGSize, lineSpacing: CGFloat,collectionWidth: CGFloat) {
        self.itemSize = itemSize
        self.collectionWidth = collectionWidth
        self.lineSpacing = lineSpacing
    }
//    MARK: Считаем
    func recalculateDefaulFrames(numberOFItems: Int) {
        defaultFrames = (0..<numberOFItems).map {
            defaultCellFrame(atRow: $0)
        }
    }
    
    func defaultCellFrame(atRow row: Int) -> CGRect {
//        let y = itemSize.height * CGFloat(row)
//        let defaultFrame = CGRect(x: 0, y: y, width: collectionWidth, height: itemSize.height)
        let y = (itemSize.height + lineSpacing) * CGFloat(row)
        let defaultFrame = CGRect(x: 0,
                                  y: y,
                                  width: collectionWidth,
                                  height: itemSize.height)
        return defaultFrame
    }
    

    func visibleRows(in frame: CGRect) -> [Int] {
        return defaultFrames
            .enumerated()   //index to frame relation
            .filter { $0.element.intersects(frame) }    //filter by frame
            .map { $0.offset }  //return indexes
    }
    
    
}

