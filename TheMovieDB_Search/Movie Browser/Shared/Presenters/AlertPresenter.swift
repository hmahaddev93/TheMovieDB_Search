//
//  AlertPresenter.swift
//  Movie Browser
//
//  Created by Khatib Mahad H. on 7/26/21.
//
import UIKit

protocol AlertPresenter_Proto {
    func present(from: UIViewController, title: String, message: String, dismissButtonTitle: String)
}

class AlertPresenter: AlertPresenter_Proto {
    func present(from: UIViewController, title: String, message: String, dismissButtonTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: dismissButtonTitle, style: .default, handler: nil)
        alertController.addAction(alertAction)
        from.present(alertController, animated: true, completion: nil)
    }
}
