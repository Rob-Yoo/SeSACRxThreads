//
//  ShoppingViewController.swift
//  SeSACRxThreads
//
//  Created by Jinyoung Yoo on 8/3/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

struct Product {
    let title: String
    var isCompleted: Bool
    var isStar: Bool
}

final class ShoppingViewController: UIViewController {
    
    private var list = BehaviorRelay(value: [
        Product(title: "그립톡 구매하기", isCompleted: .random(), isStar: .random()),
        Product(title: "사이다 구매", isCompleted: .random(), isStar: .random()),
        Product(title: "아이패드 최저가 알아보기", isCompleted: .random(), isStar: .random()),
        Product(title: "양말", isCompleted: .random(), isStar: .random())
    ])
    private let disposeBag = DisposeBag()
    
    private let addView = AddView()
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.rowHeight = 70
        $0.showsVerticalScrollIndicator = false
        $0.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.reuseIdentifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    private func configureHierarchy() {
        self.view.addSubview(addView)
        self.view.addSubview(tableView)
    }
    
    private func configureLayout() {
        addView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(70)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func bind() {
        list
            .bind(to: tableView.rx.items(cellIdentifier: ProductTableViewCell.reuseIdentifier, cellType: ProductTableViewCell.self)) { row, element, cell in
                cell.configureCell(product: element)
                
                cell.completeButton.rx.tap
                    .bind(with: self) { owner, _ in
                        var list = owner.list.value
                        
                        list[row].isCompleted.toggle()
                        owner.list.accept(list)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.starButton.rx.tap
                    .bind(with: self) { owner, _ in
                        var list = owner.list.value

                        list[row].isStar.toggle()
                        owner.list.accept(list)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.modelSelected(Product.self), tableView.rx.itemSelected)
            .bind(with: self) { owner, value in
                let nextVC = ProductViewController(product: value.0)
                
                owner.navigationController?.pushViewController(nextVC, animated: true)
                owner.tableView.deselectRow(at: value.1, animated: true)
            }
            .disposed(by: disposeBag)
        
        addView.addButton.rx.tap
            .withLatestFrom(addView.addTextField.rx.text.orEmpty)
            .bind(with: self) { owner, text in
                var list = owner.list.value
                
                list.append(Product(title: text, isCompleted: false, isStar: false))
                owner.list.accept(list)
            }
            .disposed(by: disposeBag)
    }
}

final class AddView: UIView {
    
    let addTextField = UITextField().then {
        $0.backgroundColor = .clear
        $0.borderStyle = .none
        $0.placeholder = " 무엇을 구매하실 건가요?"
    }
    
    let addButton = UIButton().then {
        $0.backgroundColor = .black
        $0.setTitle("추가", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGray5
        self.layer.cornerRadius = 15
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        self.addSubview(addTextField)
        self.addSubview(addButton)
    }
    
    private func configureLayout() {
        addTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(15)
            make.leading.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        addButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.leading.equalTo(addTextField.snp.trailing).offset(15)
        }
    }
}

final class ProductTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ProductTableViewCell.self)
    var disposeBag = DisposeBag()
    
    let completeButton = UIButton().then {
        $0.tintColor = .black
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 15)
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    let starButton = UIButton().then {
        $0.tintColor = .black
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .systemGray5
        self.contentView.layer.cornerRadius = 15
        self.contentView.clipsToBounds = true
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        self.contentView.addSubview(completeButton)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(starButton)
    }
    
    private func configureLayout() {
        completeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.verticalEdges.equalToSuperview().inset(10)
            make.width.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(completeButton.snp.trailing).offset(20)
            make.verticalEdges.equalToSuperview().inset(10)
            make.width.equalToSuperview().multipliedBy(0.65)
        }
        
        starButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().offset(-15)
            make.leading.equalTo(titleLabel.snp.trailing).offset(15)
        }
    }
    
    func configureCell(product: Product) {
        let completeImage = product.isCompleted ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
        let starImage = product.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
        self.completeButton.setImage(completeImage, for: .normal)
        self.titleLabel.text = product.title
        self.starButton.setImage(starImage, for: .normal)
    }
}
