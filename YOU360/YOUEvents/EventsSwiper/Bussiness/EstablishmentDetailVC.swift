//
//  EstablishmentDetailVC.swift
//  YOUEstablishments
//
//  Created by Ihar Karunny on 6/3/24.
//

import UIKit

final class EstablishmentDetailVC: UIViewController {
    private let viewModel: EstablishmentDetailViewModel
    
    init(model: EstablishmentDetailViewModel) {
        self.viewModel = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
