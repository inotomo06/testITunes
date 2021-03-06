//
//  ContentView.swift
//  testITunes
//
//  Created by cmStudent on 2022/05/09.
//

import SwiftUI

struct ContentView: View {
    // サブメニューのやつ
    @State var isOpenSideMenu = false
    // textfieldのやつ
    @State private var bookName = ""
    // 検索をかけたら遷移するやつ
    @State private var isLink = false
    // 履歴用の配列
    @State private var recordArray = []
    
    var body: some View {
        
        ZStack {
            NavigationView {
                VStack {
                    TextField("タイトルを入力してくだい", text: $bookName, onCommit: { // 検索用のtextfield
                        print(bookName)
                        // 履歴用に配列にためておく
                        recordArray.append(bookName)
                        // 配列を保存
                        UserDefaults.standard.set(recordArray, forKey: "key")
                        
                        isLink.toggle()
                    })
                    .padding()
                    .background(Color(.systemGray4))
                    .cornerRadius(17)
                    .padding()
                    .keyboardType(.webSearch)

                    .navigationBarItems(leading: (  // サブメニュー用
                        Button {
                            isOpenSideMenu.toggle()
                            
                        } label: {
                            Image(systemName: "line.horizontal.3")
                                .imageScale(.large)
                        }))
                    // 検索結果のファイルに遷移
                    NavigationLink(destination: BookListView(bookName: $bookName), isActive: $isLink) {
                        EmptyView()
                    }
                    .navigationTitle(bookName)
                    
                    Spacer()
                }
            }
            SideMenuView(isOpen: $isOpenSideMenu)
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            // 起動時にUserdefaultに保存して、エラーを回避
            UserDefaults.standard.set(recordArray, forKey: "key")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
