//
//  ContentView.swift
//  Week2Lab4
//
//  Created by Muhammed on 8/2/23.
//

import SwiftUI

struct CardData: Identifiable {
    var id: UUID = UUID()
    let title: String
    let price: Int
    let imageURL: URL?
    let description: String
}

func makeCardData() -> [CardData] {
    return fruitsList.map { fruit in
    
        return CardData(
            title: fruit,
            price: 8,
            imageURL: URL(string: "https://source.unsplash.com/500x300/?\(fruit)"),
            description: "This is a picture of \(fruit)."
        )
    }
}

struct ContentView: View {
    var cardDataArray = makeCardData()
    @State private var searchText = ""

    var filteredCardDataArray: [CardData] {
        if searchText.isEmpty {
            return cardDataArray
        } else {
            return cardDataArray.filter { cardData in
                cardData.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding()
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredCardDataArray) { cardData in
                            NavigationLink(destination: FruitDetailView(cardData: cardData)) {
                                HStack(spacing: 16) {
                                    if let imageURL = cardData.imageURL {
                                        AsyncImage(url: imageURL) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 80, height: 80)
                                                .cornerRadius(8)
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 80, height: 80)
                                                .background(Color.gray.opacity(0.1))
                                                .cornerRadius(8)
                                        }
                                    }
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(cardData.title)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\(cardData.price) SR")
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.black)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding(.bottom)
            }
            .padding()
            .navigationTitle("Fruits Catalog")
        }
    }

}


struct FruitDetailView: View {
    let cardData: CardData
    
    @State private var isDisplayed = false

    var body: some View {
        VStack {
            if let imageURL = cardData.imageURL {
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxHeight: 200)
            }
            Text(cardData.title)
                .font(.largeTitle)
                .padding()
            
            Text(cardData.description)
                .padding()
        }
        .navigationTitle(cardData.title)
        .animation(.easeIn)
        .onAppear {
            isDisplayed = true
        }
    }
}

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    @State private var emailError: String?
    @State private var passwordError: String?
    @State private var showingAlert = false

    var body: some View {
        Form {
            Section(header: Text("Sign Up Details")) {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                    .onChange(of: email, perform: validateEmail)

                SecureField("Password", text: $password)
                    .onChange(of: password, perform: validatePassword)
            }

            Section {
                Button(action: signUp) {
                    Text("Sign Up")
                }
            }
        }
        .navigationTitle("Sign Up")
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text("Please enter valid information"), dismissButton: .default(Text("OK")))
        }
    }

    private func validateEmail(_ newEmail: String) {
        if newEmail.isEmpty {
            emailError = "Email is required"
        } else if !newEmail.isValidEmail {
            emailError = "Invalid email"
        } else {
            emailError = nil
        }
    }

    private func validatePassword(_ newPassword: String) {
        if newPassword.count < 6 {
            passwordError = "Password must be at least 6 digits"
        } else {
            passwordError = nil
        }
    }

    func signUp() {
        if emailError != nil || passwordError != nil {
            showingAlert = true
            return
        }
        print("Username: \(name)")
        print("Email: \(email)")
        print("Password: \(password)")
    }
}

extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                
                SignUpView()
                    .tabItem {
                        Label("Sign Up", systemImage: "person.fill")
                    }
            }
        }
    }
}


let fruitsList: Array<String> = """
Apple
Orange
Kiwi
Strawberry
Berry
Banana
Peach
Grape
Mango
Pineapple
Coconut
Watermelon
"""
    .components(separatedBy: "\n")
