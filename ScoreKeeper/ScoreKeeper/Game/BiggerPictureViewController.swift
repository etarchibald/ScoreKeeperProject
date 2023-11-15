//
//  BiggerPictureViewController.swift
//  ScoreKeeper
//
//  Created by Ethan Archibald on 11/15/23.
//

import UIKit

class BiggerPictureViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    static var picture = GamePicture(picture: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "newestGame")!)
        
        imageView.backgroundColor = .black
        
        imageView.layer.borderWidth = 10
        imageView.layer.borderColor = UIColor.black.cgColor
        
        mainScrollView.delegate = self
        
        let path = getDocumentsDirectory().appendingPathExtension(BiggerPictureViewController.picture.picture)
        imageView.image = UIImage(contentsOfFile: path.path)
        
        print(BiggerPictureViewController.picture)
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func updateZoomFor(size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let scale = min(widthScale, heightScale)
        mainScrollView.minimumZoomScale = scale
        mainScrollView.zoomScale = scale
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateZoomFor(size: view.bounds.size)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}
