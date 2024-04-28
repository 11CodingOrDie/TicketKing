//
//  VideoTableViewCell.swift
//  TicketKing
//
//  Created by David Jang on 4/29/24.
//

import UIKit
import SnapKit
import AVKit
import WebKit

class VideoTableViewCell: UITableViewCell {
    
    private var titleLabel = UILabel()
    private let webView = WKWebView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.left.right.equalTo(contentView).inset(16)
            make.height.equalTo(20)
        }

        contentView.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalTo(contentView).inset(16)
            make.height.equalTo(200) // 비디오 높이
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .left
    }

    func configure(with video: Video) {
        titleLabel.text = video.name
        loadYouTube(videoID: video.key)
    }

    private func loadYouTube(videoID: String) {
        let htmlString = """
        <html>
        <body style="margin: 0; padding: 0;">
        <iframe width="100%" height="100%" src="https://www.youtube.com/embed/\(videoID)" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
        </body>
        </html>
        """
        webView.loadHTMLString(htmlString, baseURL: nil)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        webView.loadHTMLString("", baseURL: nil)
    }
}

//// UITableView에서 셀 높이 동적 조정
//extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 250 // 타이틀 높이(20) + 상하 마진(16) + 비디오 높이(200) + 추가 여백(14)
//    }
//}



