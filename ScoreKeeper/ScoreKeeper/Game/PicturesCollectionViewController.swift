//
//  PicturesCollectionViewController.swift
//  ScoreKeeper
//
//  Created by Ethan Archibald on 11/14/23.
//

import UIKit

protocol AddPictures {
    func addPictures(pictures: [GamePicture])
}

class PicturesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    var pictures = [GamePicture]()
    
    var delegate: AddPictures?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundView = UIImageView(image: UIImage(named: "newestGame"))
        
//        trashButton.isEnabled = false
        
        collectionView.reloadData()
    }
    
    init?(pictures: [GamePicture], coder: NSCoder) {
        self.pictures = pictures
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.addPictures(pictures: pictures)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picture", for: indexPath) as? PicturesCollectionViewCell else { fatalError("Unable to dequeue PicturesCell")}
        
        let picture = pictures[indexPath.row]
        
        let path = getDocumentsDirectory().appendingPathExtension(picture.picture)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if trashButton.isSelected {
            BiggerPictureViewController.picture = pictures[indexPath.row]
            let questionController = UIAlertController(title: "Delete Picture?", message: nil, preferredStyle: .alert)
            questionController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
                self.pictures.remove(at: indexPath.item)
                self.collectionView.deleteItems(at: [indexPath])
                self.collectionView.reloadData()
                self.navigationController?.popViewController(animated: true)
            }))
            questionController.addAction(UIAlertAction(title: "Cancel", style: .default))
            
            present(questionController, animated: true)
        } else {
            BiggerPictureViewController.picture = pictures[indexPath.row]
        }
    }
    
    @IBAction func trashButtonTapped(_ sender: UIBarButtonItem) {
        trashButton.isSelected.toggle()
    }
    
    @IBAction func addPicture(_ sender: UIBarButtonItem) {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source:", message: nil, preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = collectionView
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                imageController.sourceType = .camera
                self.present(imageController, animated: true)
            }
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
            imageController.sourceType = .photoLibrary
            self.present(imageController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
}

extension PicturesCollectionViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathExtension(imageName)
        
        if let jpegData = selectedImage.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let picture = GamePicture(picture: imageName)
        
        pictures.append(picture)
        
        collectionView.reloadData()
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
