//
//  MovieCardCollectionViewCell.swift
//  TicketKing
//
//  Created by David Jang on 4/24/24.
//

import UIKit

class MovieCardCollectionViewCell: UICollectionViewCell {
    
    private var movieCardCell: MovieCardCell?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMovieCardCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMovieCardCell() {
        movieCardCell = MovieCardCell(frame: .zero)
        guard let movieCardCell = movieCardCell else { return }
        contentView.addSubview(movieCardCell)
        movieCardCell.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with movie: MovieModel, mode: MovieCardCell.ViewMode) {
        movieCardCell?.configure(with: movie, mode: mode)
    }
}
