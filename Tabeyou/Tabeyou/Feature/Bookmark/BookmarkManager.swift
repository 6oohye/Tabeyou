//
//  BookmarkManager.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/20/24.
//

import Foundation

class BookmarkManager {
    static let shared = BookmarkManager()
    
    private var bookmarks: [BookmarkItem] = []
    
    // 북마크 배열에 북마크 추가
    func addBookmark(_ bookmark: BookmarkItem) {
        // 중복 확인 후 추가
        if !bookmarks.contains(where: { $0.restaurantId == bookmark.restaurantId }) {
            bookmarks.append(bookmark)
        }
    }
    
    // 북마크 배열에서 북마크 제거
    func removeBookmark(_ bookmark: BookmarkItem) {
        bookmarks.removeAll { $0.restaurantId == bookmark.restaurantId }
    }
    
    // 북마크 배열 반환
    func getBookmarks() -> [BookmarkItem] {
        return bookmarks
    }
    
    // 아이디 값으로 북마크 가져오기
    func getBookmarkById(_ id: String) -> BookmarkItem? {
        return bookmarks.first(where: { $0.restaurantId == id })
    }
}
