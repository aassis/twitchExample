//
//  MoyaProvider+Decoder.swift
//  Practice
//
//  Created by André Assis on 13/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import Foundation
import Moya
import Gloss
import Result
import Moya_Gloss
import RxSwift

extension MoyaProvider {
    
    func requestArray<T:Gloss.JSONDecodable>(_ target:Target, type:T.Type) -> Observable<[T]> {
        return Observable.create({ o in
            let task = self.request(target, callbackQueue:nil, progress:nil) { result in
                switch result {
                case .success(let response):
                    do {
                        let model = try response.mapArray(T.self)
                        o.onNext(model)
                        o.onCompleted()
                    } catch {
                        o.onError(NSError.init(domain: "PracticeApp", code: 400, userInfo: [NSLocalizedDescriptionKey : "Couldn't parse returned data"]))
                        o.onCompleted()
                    }
                    break;
                case .failure(let error):
                    o.onError(error)
                    o.onCompleted()
                    break;
                }
            }
            return Disposables.create { task.cancel() }
        })
    }
    
    func request<T:Gloss.JSONDecodable>(_ target:Target, type:T.Type) -> Observable<T> {
        return Observable.create({ o in
            let task = self.request(target, callbackQueue:nil, progress:nil) { result in
                switch result {
                case .success(let response):
                    do {
                        let model = try response.mapObject(T.self)
                        o.onNext(model)
                        o.onCompleted()
                    } catch {
                        do {
                            let model = try response.mapObject(ErrorModel.self)
                            o.onError(NSError.init(domain: "PracticeApp", code: model.status, userInfo: [NSLocalizedDescriptionKey : model.message]))
                            o.onCompleted()
                        } catch {
                            o.onError(NSError.init(domain: "PracticeApp", code: -1, userInfo: [NSLocalizedDescriptionKey : "Couldn't parse returned data"]))
                            o.onCompleted()
                        }
                    }
                    break;
                case .failure(let error):
                    o.onError(error)
                    o.onCompleted()
                    break;
                }
            }
            return Disposables.create { task.cancel() }
        })
    }
    
}
