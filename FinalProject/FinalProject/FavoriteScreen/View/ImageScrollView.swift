//
//  ImageScrollView.swift
//  FinalProject
//
//  Created by Антон Сафронов on 27.07.2021.
//

import UIKit

protocol ImageScrollViewDelegate: AnyObject {
    func hideInterface()
}

class ImageScrollView: UIScrollView {

    weak var hideDelegate: ImageScrollViewDelegate?
    
    private var imageView = UIImageView()

    private lazy var doubleTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        return tap
    }()
    
    private lazy var singleTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapped))
        tap.numberOfTapsRequired = 1
        tap.require(toFail: doubleTap)
        return tap
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
//        self.hideDelegate = hideDelegate
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    init(frame: CGRect, hideDelegate: ImageScrollViewDelegate) {
        super.init(frame: frame)
        self.hideDelegate = hideDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getImage() -> UIImage {
        guard let image = imageView.image else { return UIImage() }
        return image
    }
    
    func set(image: UIImage) {
        imageView.removeFromSuperview()
        imageView = UIImageView(image: image)
        self.addSubview(imageView)
        
        configurateFor(imageSize: image.size)
    }
    
    private func configurateFor(imageSize: CGSize) {
        self.contentSize = imageSize
        
        setCurrentMaxandMinZoomScale()
        self.zoomScale = self.minimumZoomScale
        
        self.imageView.addGestureRecognizer(self.doubleTap)
        self.imageView.addGestureRecognizer(self.singleTap)
        self.imageView.isUserInteractionEnabled = true
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.centerImage()
    }
    
    private func setCurrentMaxandMinZoomScale() {
        let boundsSize = self.bounds.size
        let imageSize = imageView.bounds.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale = min(xScale, yScale)
        
        var maxScale: CGFloat = 2.0
        
        if minScale < 0.3 {
            maxScale = 0.9
        }
        if minScale >= 0.3 && minScale < 1.5 {
            maxScale = 1.4
        }
        if minScale >= 1.5 {
            maxScale = max(3.0, minScale)
        }
        
        self.minimumZoomScale = minScale
        self.maximumZoomScale = maxScale
    }
    
    private func centerImage() {
        let boundsSize = self.bounds.size
        var frameToCenter = imageView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        imageView.frame = frameToCenter
    }
    
    
    @objc private func doubleTapped(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        self.zoom(point: location, animated: true)
    }
    
    @objc private func singleTapped(sender: UITapGestureRecognizer) {
        hideDelegate?.hideInterface()
    }
    
    private func zoom(point: CGPoint, animated: Bool) {
        let currectScale = self.zoomScale
        let minScale = self.minimumZoomScale
        let maxScale = self.maximumZoomScale
        
        if (minScale == maxScale && minScale > 1) {
            return
        }
        
        let toScale = maxScale
        let finalScale = (currectScale == minScale) ? toScale : minScale
        let zoomRect = self.zoomRect(scale: finalScale, center: point)
        self.zoom(to: zoomRect, animated: animated)
    }
    
    private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds
        
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        return self.centerImage()
    }
}

extension ImageScrollView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
             shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
       
       if gestureRecognizer == self.singleTap &&
              otherGestureRecognizer == self.doubleTap {
          return true
       }
       return false
    }
    
}
