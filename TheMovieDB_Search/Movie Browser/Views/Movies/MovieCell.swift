//
//  MovieCell.swift
//  Movie Browser
//
//  Created by Khatib Mahad H. on 7/19/21.
//

import UIKit

final class MovieCell: UITableViewCell {

    var movie: Movie? {
        didSet {
            self.titleLabel.text = movie?.title
            self.overviewLabel.text = movie?.overview
            
            guard let posterImagePath:String = movie?.posterPath else {
                return
            }
            self.posterImageView.loadThumbnail(urlSting: MovieAPI.imageDBBaseUrl + posterImagePath)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 90),
            imageView.heightAnchor.constraint(equalToConstant: 160)
        ])
        return imageView
    }()
    let titleLabel = MovieLabel(style: .headline)
    let overviewLabel = MovieLabel(style: .caption1)
    
    private lazy var titleOverviewStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, overviewLabel, UIView()])
        stackView.axis = .vertical
        stackView.spacing = 12.0
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [posterImageView, titleOverviewStackView])
        stackView.spacing = 12.0
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func commonInit() {
        backgroundColor = .white
        safelyAddSubview(stackView)
        stackView.marginToSuperviewSafeArea(top: 12, bottom: 12, leading: 16, trailing: 16)
    }
}
