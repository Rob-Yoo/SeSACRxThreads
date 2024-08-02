//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = UILabel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    func bind() {
        let validation = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 8 }.share(replay: 1)
        
        validation.bind(to: descriptionLabel.rx.isHidden, nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        validation
            .map { $0 ? Color.black : UIColor.lightGray }
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.leading.equalToSuperview().offset(20)
        }
        descriptionLabel.text = "8자리 이상 입력해주세요"
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
