//
//  PictureDetailExplorerViewController.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 25/03/23.
//

import Foundation
import UIKit

protocol PictureDetailExplorerViewProtocol: AnyObject {
    func constructViewWith(Model model: PictureOfDayModel)
}

class PictureDetailExplorerViewController: UIViewController, PictureDetailExplorerViewProtocol {
    
    var interactorDelegate: PictureDetailExplorerInteractorProtocol?
    
    var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDefaultProperties()
        self.setupScrollView()
        self.interactorDelegate?.startLoading()
    }
    
    func setDefaultProperties() {
        self.title = "Picture of the day"
        self.view.backgroundColor = UIColor.white
    }
    
    func setupScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    func constructViewWith(Model model: PictureOfDayModel) {
        let contentView = UIView()
        
        var constraints = [NSLayoutConstraint]()
        self.scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        var topAnchor = contentView.topAnchor
        constraints.append(contentsOf: [
            contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
        
        if let imageURL = model.hdurl?.getLocalFileURL(), let image = UIImage(contentsOfFile: imageURL.path) {
            let imageView = UIImageView(image: image)
            imageView.backgroundColor = UIColor.black
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(imageView)
            
            constraints.append(contentsOf: [
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height/2)
            ])
            topAnchor = imageView.bottomAnchor
        }
        
        if let title = model.title {
            let titleText = UILabel()
            titleText.text = title
            titleText.font = UIFont.boldSystemFont(ofSize: 20)
            titleText.numberOfLines = 0

            contentView.addSubview(titleText)
            titleText.translatesAutoresizingMaskIntoConstraints = false
            constraints.append(contentsOf: [
                titleText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                titleText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                titleText.topAnchor.constraint(equalTo: topAnchor, constant: 16)
            ])
            topAnchor = titleText.bottomAnchor
        }
        
        if let explanation = model.explanation {
            let explanationText = UILabel()
            explanationText.text = explanation
            explanationText.font = UIFont.systemFont(ofSize: 14)
            explanationText.numberOfLines = 0
            
            contentView.addSubview(explanationText)
            explanationText.translatesAutoresizingMaskIntoConstraints = false
            constraints.append(contentsOf: [
                explanationText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                explanationText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                explanationText.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                explanationText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}
