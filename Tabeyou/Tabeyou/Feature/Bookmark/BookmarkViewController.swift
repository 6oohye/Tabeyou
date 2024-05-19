//
//  BookmarkViewController.swift
//  Tabeyou
//
//  Created by ユクヘジン on 5/10/24.
//

import UIKit

struct BookmarkItem {
    let restaurantId: String
    let imageUrl: String
    let title: String
    let station: String
    let price: String
    let access: String
}

class BookmarkViewController: UIViewController {
    var bookmarks: [BookmarkItem] = []
    @IBOutlet weak var tableView: UITableView!
    
    // 새로운 BookmarkTableViewCellViewModel 배열 생성
    var bookmarkViewModels: [BookmarkTableViewCellViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BookmarkTableViewCell", bundle: nil), forCellReuseIdentifier: BookmarkTableViewCell.identifier)
        
        // 북마크 목록을 저장하고 있는 bookmarks 배열을 업데이트합니다.
        loadBookmarks()
        
        // 각 북마크에 대한 뷰모델 생성
        bookmarkViewModels = bookmarks.map { bookmark in
            return BookmarkTableViewCellViewModel(
                imageUrl: bookmark.imageUrl,
                title: bookmark.title,
                station: bookmark.station,
                price: bookmark.price,
                access: bookmark.access
            )
        }
    }
    
    func loadBookmarks() {
            // 여기서는 임의로 아이디 값으로 북마크를 가져오는 예시를 보여줍니다.
            if let bookmark1 = BookmarkManager.shared.getBookmarkById("1") {
                bookmarks.append(bookmark1)
            }
            if let bookmark2 = BookmarkManager.shared.getBookmarkById("2") {
                bookmarks.append(bookmark2)
            }
        }
    
    // 북마크 목록을 업데이트하는 메서드
    func updateBookmarkList(_ newBookmarks: [BookmarkItem]) {
        // 업데이트된 북마크 목록을 전달하여 테이블 뷰를 업데이트
        self.bookmarks = newBookmarks
        self.tableView.reloadData()
    }
}

extension BookmarkViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkTableViewCell.identifier, for: indexPath) as! BookmarkTableViewCell
        
        // 수정된 부분: BookmarkTableViewCellViewModel을 사용하여 셀을 구성
        cell.configure(with: bookmarkViewModels[indexPath.row])
        
        return cell
    }
}
