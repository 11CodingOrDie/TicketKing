//
//  MovieInfoCollectionViewCell.swift
//  TicketKing
//
//  Created by David Jang on 4/24/24.
//

import UIKit

class MovieInfoCollectionViewCell: UICollectionViewCell {
    
    private var movieInfoCell: MovieInfoCell?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMovieInfoCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMovieInfoCell() {
        
        movieInfoCell = MovieInfoCell(frame: .zero, mode: .compact)
        guard let movieInfoCell = movieInfoCell else { return }
        contentView.addSubview(movieInfoCell)
        movieInfoCell.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with movie: MovieModel) {
        movieInfoCell?.configure(with: movie)
    }
}
