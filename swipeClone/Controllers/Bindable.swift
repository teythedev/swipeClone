//
//  Bindable.swift
//  swipeClone
//
//  Created by tugay emre yücedağ on 29.03.2023.
//

import Foundation

final class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping(T?) -> ()) {
        self.observer = observer
    }
}
