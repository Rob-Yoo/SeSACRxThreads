//
//  ProductViewController.swift
//  SeSACRxThreads
//
//  Created by Jinyoung Yoo on 8/4/24.
//

import UIKit
import SnapKit
import Then

final class ProductViewController: UIViewController {
    
    private let product: Product
    
    private let completeLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 15)
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 15)
    }
    
    private let starLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 15)
    }
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(completeLabel)
        self.view.addSubview(titleLabel)
        self.view.addSubview(starLabel)
        
        completeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(completeLabel.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(20)
        }
        
        starLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(20)
        }
        
        completeLabel.text = product.isCompleted ? "완료" : "미완료"
        titleLabel.text = product.title
        starLabel.text = product.isStar ? "별표" : "별표 X"
    }
}
