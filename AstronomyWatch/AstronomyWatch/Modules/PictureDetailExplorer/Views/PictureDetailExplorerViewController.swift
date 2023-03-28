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
    func showErrorPopupWith(Message message: String)
    func showLoader(_ value: Bool)
}

class PictureDetailExplorerViewController: UIViewController, PictureDetailExplorerViewProtocol {
    
    var interactorDelegate: PictureDetailExplorerInteractorProtocol?
    
    var scrollView = UIScrollView()
    var loader = UIActivityIndicatorView(style: .medium)
    var alertController: UIAlertController?
    var titleText: UILabel?
    var explanationText: UILabel?
    var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDefaultProperties()
        self.setupLoader()
        self.setupScrollView()
        self.interactorDelegate?.startLoading()
    }
    
    func setDefaultProperties() {
        self.title = "Picture of the day"
        self.view.backgroundColor = UIColor.white
    }
    
    func setupLoader() {
        self.loader.hidesWhenStopped = true
        self.view.addSubview(loader)
        self.loader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.loader.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loader.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
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
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        self.imageView = nil
        self.titleText = nil
        self.explanationText = nil
        
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
        
        if let imageURL = model.url?.getLocalFileURL(), let image = interactorDelegate?.getImageFor(Path: imageURL.path) {
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
            self.imageView = imageView
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
            self.titleText = titleText
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
            self.explanationText = explanationText
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func showErrorPopupWith(Message message: String) {
        self.alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.alertController?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.navigationController?.present(alertController!, animated: true, completion: nil)
    }
    
    func showLoader(_ value: Bool) {
        self.loader.layer.zPosition = CGFloat.greatestFiniteMagnitude
        if value {
            self.loader.startAnimating()
        } else {
            self.loader.stopAnimating()
        }
    }
}
