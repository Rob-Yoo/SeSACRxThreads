//
//  RecentCollectionViewCell.swift
//  SeSACRxThreads
//
//  Created by Jinyoung Yoo on 8/7/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class RecommendCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: RecommendCollectionViewCell.self)
    
    let recentButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .clear
    }
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(recentButton)
        recentButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}
