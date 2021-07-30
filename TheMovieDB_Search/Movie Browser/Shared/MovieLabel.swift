//
//  MovieLabel.swift
//  Movie Browser
//
//  Created by Khatib Mahad H. on 7/19/21.
//
import UIKit

final class MovieLabel: UILabel {
    public init(style: UIFont.TextStyle, alignment: NSTextAlignment = .left) {
        super.init(frame: .zero)
        self.numberOfLines = 0
        self.textAlignment = alignment
        self.lineBreakMode = .byWordWrapping
        self.font = .preferredFont(forTextStyle: style)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
