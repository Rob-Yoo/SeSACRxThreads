//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by Jinyoung Yoo on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingViewModel {
    struct Input {
        let addButtonTapped: ControlEvent<Void>
        let addProductTitle: ControlProperty<String>
        let tableViewItemSelected: ControlEvent<IndexPath>
        let tableViewModelSelected: ControlEvent<Product>
        let itemDeleted: ControlEvent<IndexPath>
        let completedProduct: PublishRelay<Int>
        let starredProduct: PublishRelay<Int>
    }
    
    struct Output {
        let shoppingList: BehaviorRelay<[Product]>
        let cellSelected: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<Product>.Element)>
        let addButtonTapped: ControlEvent<Void>
    }
    
    private let list = BehaviorRelay(value: [
        Product(title: "그립톡 구매하기", isCompleted: .random(), isStar: .random()),
        Product(title: "사이다 구매", isCompleted: .random(), isStar: .random()),
        Product(title: "아이패드 최저가 알아보기", isCompleted: .random(), isStar: .random()),
        Product(title: "양말", isCompleted: .random(), isStar: .random())
    ])
    
    private let disposeBag = DisposeBag()
    
    func tranform(input: Input) -> Output {
        let newProduct = input.addButtonTapped.withLatestFrom(input.addProductTitle)
        let cellSelected = Observable.zip(input.tableViewItemSelected, input.tableViewModelSelected)
        
        newProduct
            .bind(with: self) { owner, title in
                var list = owner.list.value

                list.append(Product(title: title, isCompleted: false, isStar: false))
                owner.list.accept(list)
            }
            .disposed(by: disposeBag)
        
        input.completedProduct
            .bind(with: self) { owner, row in
                var list = owner.list.value
                
                list[row].isCompleted.toggle()
                owner.list.accept(list)
            }
            .disposed(by: disposeBag)
        
        input.starredProduct
            .bind(with: self) { owner, row in
                var list = owner.list.value
                
                list[row].isStar.toggle()
                owner.list.accept(list)
            }
            .disposed(by: disposeBag)
        
        input.itemDeleted
            .bind(with: self) { owner, indexPath in
                var list = owner.list.value

                list.remove(at: indexPath.row)
                owner.list.accept(list)
            }
            .disposed(by: disposeBag)
        
        return Output(shoppingList: list, cellSelected: cellSelected, addButtonTapped: input.addButtonTapped)
    }
}
