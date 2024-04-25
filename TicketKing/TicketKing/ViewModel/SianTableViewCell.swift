//
//  SianTableViewCell.swift
//  TicketKing
//
//  Created by David Jang on 4/26/24.
//

import UIKit
import SnapKit

class SianTableViewCell: UITableViewCell {
    
    private let container = UIView()
    private var movieInfoCell: MovieInfoCell?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContainerView()
        setupMovieInfoCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContainerView() {
        contentView.addSubview(container)
        container.layer.cornerRadius = 8
        container.clipsToBounds = true
        container.backgroundColor = .white
        container.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
            make.left.equalTo(contentView.snp.left).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
        }
    }
    
    private func setupMovieInfoCell() {
        movieInfoCell = MovieInfoCell(frame: .zero)
        guard let movieInfoCell = movieInfoCell else { return }
        container.addSubview(movieInfoCell)
        movieInfoCell.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with movie: MovieModel) {
        movieInfoCell?.configure(with: movie)
    }
}
