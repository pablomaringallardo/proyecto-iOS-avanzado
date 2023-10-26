//
//  DetailViewController.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 26/10/23.
//

import UIKit
import MapKit
import Kingfisher

protocol DetailViewControllerDelegate {
    var viewState: ((DetailViewState) -> Void)? { get set }
    
    func onViewAppear()
}

enum DetailViewState {
    case update(hero: Hero?, locations: [HeroLocation])
}

class DetailViewController: UIViewController {
    
//    MARK: - Outlets -
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabelDetail: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mapViewDetail: MKMapView!
    
    
    
    var viewModel: DetailViewControllerDelegate?
    
//    MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObserver()
        viewModel?.onViewAppear()
    }
    
    private func initViews() {
        
    }
    
    private func setObserver() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .update(let hero, let locations):
                    self?.updateViews(hero: hero, heroLocations: locations)
                }
            }
        }
    }
    
    private func updateViews(hero: Hero?, heroLocations: [HeroLocation]) {
        imageView.kf.setImage(with: URL(string: hero?.photo ?? ""))
        nameLabelDetail.text = hero?.name
        textView.text = hero?.description
    }
}
