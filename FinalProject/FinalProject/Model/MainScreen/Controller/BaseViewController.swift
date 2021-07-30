//
//  BaseViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 30.07.2021.
//

import UIKit

class BaseViewController: UIViewController {
    
    private let spinnerVC = SpinnerViewController()
    
    var isLoading = false {
        didSet {
            guard oldValue != isLoading else { return }
            showSpinner(isShown: isLoading)
        }
    }
    
    func showSpinner(isShown: Bool) -> Bool {
        if isShown {
            addChild(spinnerVC)
            spinnerVC.view.frame = view.frame
            view.addSubview(spinnerVC.view)
            spinnerVC.didMove(toParent: self)
            return true
        } else {
            spinnerVC.willMove(toParent: nil)
            spinnerVC.view.removeFromSuperview()
            spinnerVC.removeFromParent()
            return false
        }
    }
    
     func showAlert(for error: NetworkServiceError) {
        let alert = UIAlertController(title: "Что-то пошло не так",
                                      message: message(for: error),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func message(for error: NetworkServiceError) -> String {
        switch error {
        case .network:
            return "Запрос упал"
        case .decodable:
            return "Не смогли распарсить"
        case .buildingURL:
            return "Ошибка в сборке url"
        case .unknown:
            return "Что-то неизвестное"
        }
    }
}
