//
//  BookListView.swift
//  testITunes
//
//  Created by cmStudent on 2022/05/09.
//

import SwiftUI

struct BookListView: View {
    
    @ObservedObject private var bookListViewModel: BookListViewModel
    // ContentViewのbookName
    @Binding var bookName: String
    
    init(bookName: Binding<String>) {
        _bookName = bookName
        do {
            bookListViewModel = try BookListViewModel()
        } catch {
            fatalError("URL ERROR")
        }
    }
    
    var body: some View {
        
        VStack {
            if bookListViewModel.status == .success { // 成功したら
                List(bookListViewModel.iTunesSearchResult.results, id: \.self) { result in
                    Button {
                        for item in bookListViewModel.iTunesSearchResult.results {
                            // 選んだ本の名前とループで回してる本が同じだったら
                            if result.trackCensoredName == item.trackCensoredName {
                                bookListViewModel.iTunesUrl = item.trackViewUrl
                                print(bookListViewModel.iTunesUrl)
                            }
                        }
                        
                        bookListViewModel.isShowSafari.toggle()
                    } label: {
                        VStack(alignment: .leading) {
                            Text(result.trackCensoredName)
                                .padding(.bottom)
                                .font(.headline)
                            Text(result.artistName)
                            Text(result.formattedPrice)
                        }
                        .foregroundColor(.black)
                    }
                }
            } else if bookListViewModel.status == .unexecuted { // 読み込み中
                // インゲータの表示
                ProgressView("検索中です")
                    .foregroundColor(.blue)
                    .font(.system(size: 20))
            } else {
                Text("読み込みに失敗しました")
            }
        }
        .onAppear {
            try? bookListViewModel.settings(title: bookName)
        }
        .sheet(isPresented: $bookListViewModel.isShowSafari) {
            SafariView(url: URL(string: bookListViewModel.iTunesUrl)!)
        }
    }
}

