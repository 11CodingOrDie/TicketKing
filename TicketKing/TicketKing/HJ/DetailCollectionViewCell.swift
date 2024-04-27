//
//  DetailCollectionViewCell.swift
//  TicketKing
//
//  Created by David Jang on 4/26/24.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    private var personInfoCell: PersonInfoCell?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // setupPersonInfoCell()이 삭제되었습니다. 초기화는 configure에서 수행합니다.
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with movie: MovieModel, viewMode: PersonInfoCell.ViewMode) {
        if personInfoCell == nil {
            // movieId와 viewMode를 사용하여 여기서 PersonInfoCell을 초기화합니다.
            personInfoCell = PersonInfoCell(frame: bounds, movieId: movie.id, viewMode: viewMode)
            guard let personInfoCell = personInfoCell else { return }
            contentView.addSubview(personInfoCell)
            personInfoCell.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            // 이미 존재하는 cell의 정보를 갱신합니다.
            personInfoCell?.movieId = movie.id
            personInfoCell?.viewMode = viewMode
        }
        
        personInfoCell?.loadData()
    }
}
