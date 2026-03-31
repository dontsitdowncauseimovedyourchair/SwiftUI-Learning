//
//  UserDetailView.swift
//  Friendify
//
//  Created by Alejandro González on 31/03/26.
//

import SwiftUI

struct UserDetailView: View {
    var user : User
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Text(user.name)
                    .font(.title.bold())
                Text(user.isActive ? "⦿ Active" : "⦿ Offline")
                    .foregroundStyle(user.isActive ? .green : .red)
                
                Text("Member since: \(user.registered.formatted(date: .long, time: .omitted))")
                    .padding(.vertical, 7)
                
                Group {
                    Text("🏢 \(user.company)")
                    Text("📧 \(user.email)")
                    Text("📍 \(user.address)")
                }
                .font(.headline.weight(.light))
                
                VStack(alignment: user.tags.count >= 5 ? .center : .leading) {
                    if (!user.tags.isEmpty) {
                        Text("Tags")
                            .font(.title2.bold())
                            .padding(.vertical, 6)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(user.tags, id: \.self) { tag in
                                    Text(tag)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 8)
                                        .background(.gray.opacity(0.75))
                                        .foregroundStyle(.white)
                                        .clipShape(.capsule)
                                }
                            }
                        }
                    }
                }
                
                Rectangle()
                    .fill(.gray)
                    .frame(width: .infinity, height: 1)
                    .padding(.vertical)
                
                VStack(alignment: .leading) {
                    Text(user.about)
                    
                    if (!user.friends.isEmpty) {
                        
                        Rectangle()
                            .fill(.gray)
                            .frame(width: .infinity, height: 1)
                            .padding(.vertical)
                        
                        Text("Friends")
                            .font(.title2.bold())
                        
                        ForEach(user.friends) { friend in
                            Text("• \(friend.name)")
                                .font(.system(size: 17))

                        }
                    }
                    
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        UserDetailView(user: User(id: UUID(), isActive: true, name: "Alex", age: 20, company: "Flop de Monterrey", email: "A04921384@tec.mx", address: "Aqui y Ahora", about: "Es un papu super duper mega pro", registered: .now, tags: ["Super", "Pro"], friends: [Friend(id: UUID(), name: "Papu 1"), Friend(id: UUID(), name: "Papu 2")]))

    }
}
