//
//  ContentView.swift
//  HRProjeUygulamasi
//
//  Created by Burak DÜNYA on 28.12.2024.
//

import SwiftUI
import CoreData

struct SignupView: View {
    @State var adnameText: String = ""
    @State var soyadnameText: String = ""
    @State var mailnameText: String = ""
    @State var passwordText: String = ""
    @State var isNavigation : Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
       
    //private var users : FetchedResults<Kullanicilar>

    // Email validasyonu için fonksiyon
    private func isValidEmail(_ email: String) -> Bool {
        return email.contains("@")
    }
    
    
    var body: some View {
        NavigationStack{
                VStack(spacing: 20) {
                    Spacer()
                    Text ("YSOFT HR").font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing)
                            )
                    Spacer()
                TextField("Ad", text: $adnameText).padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(Capsule())
                    .autocapitalization(.words)
                    .padding(.horizontal, 32)
                TextField("Soyad", text: $soyadnameText).padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(Capsule())
                    .autocapitalization(.words)
                    .padding(.horizontal, 32)
                TextField("Mail", text: $mailnameText).padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(Capsule())
                    .autocapitalization(.words)
                    .padding(.horizontal, 32)
                SecureField("Şifre", text: $passwordText).padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(Capsule())
                    .autocapitalization(.words)
                    .padding(.horizontal, 32)
                
                
                Button {
                    if adnameText.isEmpty || soyadnameText.isEmpty || mailnameText.isEmpty || passwordText.isEmpty {
                        isNavigation = false
                    }
                    else{
                        let kullaniciObject = Kullanicilar(context: viewContext)
                        kullaniciObject.adnameText = adnameText
                        kullaniciObject.soyadnameText = soyadnameText
                        kullaniciObject.passwordText = passwordText
                        kullaniciObject.mailnameText = mailnameText
                        do {
                            
                          try viewContext.save()
                        }
                        catch{
                            print(error.localizedDescription)
                        
                            print("error while saving kullanicilar ")
                        }
                        isNavigation = true
                    }
                } label: {
                    Text("Kayıt ol").bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }.padding(.horizontal, 32)
                .navigationDestination(isPresented: $isNavigation) {
                    HomeView().environment(\.managedObjectContext, viewContext)
                }
                NavigationLink {
                    LoginView()
                } label: {
                    Text("Zaten bir hesabınız var mı? Oturum aç")
                }

                Spacer()
            
            }
            
        }
    }
    
}

struct HomeView : View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: []
    ) private var users : FetchedResults<Kullanicilar>
    @State private var isLogoutActive = false
    
    
    
    var body: some View {
        VStack {
            HStack {
                            Spacer()
                            Button(action: {
                                isLogoutActive = true
                            }) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.red)
                                    .font(.system(size: 20))
                            }
                            .padding(.horizontal)
                        }
            Text("YSOFT HR")
                .font(.system(size: 25))
                .fontWeight(.heavy)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 30)
            
            Spacer(minLength: 20)
            
            NavigationLink {
                AddEmployeeView()
            } label: {
                Text("Çalışan Ekle")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        Capsule()
                            .stroke(Color.green, lineWidth: 2)
                    )
            }
            .padding(.bottom, 20)
            
            NavigationLink {
                ShowEmployeeView()
            } label: {
                Text("Çalışan listele")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        Capsule()
                            .stroke(Color.green, lineWidth: 2)
                    )
            }
            .padding(.bottom, 20)
            
            NavigationLink {
                AssignProjectView().environment(\.managedObjectContext, viewContext)
            } label: {
                Text("Proje Oluştur")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        Capsule()
                            .stroke(Color.green, lineWidth: 2)
                    )
            }
            .padding(.bottom, 30)
            Spacer(minLength: 40)
        }
        .padding()
        .navigationDestination(isPresented: $isLogoutActive) {
            LoginView()
                .navigationBarBackButtonHidden(true)
        }
        
    }
    
}


struct AssignProjectView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var projeAdi: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
                        Text("YSOFT HR")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 10)
            Spacer()
            Text("Proje Oluştur")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            TextField("Proje Adı", text: $projeAdi)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(Capsule())
                .autocapitalization(.words)
                .padding(.horizontal, 32)
            Spacer(minLength: 20)
            Button(action: {
                guard !projeAdi.isEmpty else { return }
                
                let yeniProje = Proje(context: viewContext)
                yeniProje.projeAdi = projeAdi
                
                do {
                    try viewContext.save()
                    presentationMode.wrappedValue.dismiss()
                } catch {
                    print("Proje kaydedilirken hata oluştu: \(error.localizedDescription)")
                }
            }) {
                Text("Kaydet")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            Spacer()
        }
        .padding()
    }
}


struct ShowEmployeeView : View {
     @Environment(\.managedObjectContext) private var viewContext
        @FetchRequest(
            sortDescriptors: []
        ) private var users : FetchedResults<Calisanlar>
    
    @State private var showingDeleteAlert = false
        @State private var calisanToDelete: IndexSet?
   
    @State private var searchText = ""
    var filteredUsers: [Calisanlar] {
           if searchText.isEmpty {
               return Array(users) // Arama metni boşsa, tüm verileri döndür
           } else {
               // Arama metnine göre filtrele
               return users.filter { user in
                   let departman = user.departman ?? ""
                   return departman.lowercased().contains(searchText.lowercased())
                       
               }
           }
       }
    
    var body: some View {
        
        List {
                    // Eğer veri yoksa gösterilecek metin
                    if users.isEmpty {
                        Text("Henüz kullanıcı bulunmuyor.")
                            .padding()
                    } else {
                        // Kullanıcı bilgilerini ForEach ile listele
                        TextField("Arama", text: $searchText)
                                        .padding()
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.horizontal)
                        
                        ForEach(filteredUsers, id: \.self) { user in
                            
                            let adname = user.ad ?? "Bilgi Yok"
                            let soyadname = user.soyad ?? "Bilgi Yok"
                            let mailname = user.mail ?? "Bilgi Yok"
                            let telefon = user.telefon ?? "Bilgi Yok"
                            let isebaslamatarihi = user.isebaslama ?? "Bilgi Yok"
                            let dogumutarihi = user.dogumtarihi ?? "Bilgi Yok"
                            let departman = user.departman ?? "Bilgi Yok"
                            let askerlikdurum = user.askerlikdurum ?? "Bilgi Yok"
                            let projebilgisi = user.projebilgisi ?? "Bilgi Yok"
                            
                        
                                                
                                                VStack(alignment: .leading) {
                                                    Divider()
                                                    Text("Ad: \(adname)")
                                                        .padding(.bottom, 5)
                                                    Text("Soyad: \(soyadname)")
                                                        .padding(.bottom, 5)
                                                    Text("Mail: \(mailname)")
                                                        .padding(.bottom, 5)
                                                    Text("Telefon: \(telefon)")
                                                        .padding(.bottom, 5)
                                                    Text("İşe Başlama Tarihi: \(isebaslamatarihi)")
                                                        .padding(.bottom, 5)
                                                    Text("Doğum Tarihi: \(dogumutarihi)")
                                                        .padding(.bottom, 5)
                                                    Text("Departman: \(departman)")
                                                        .padding(.bottom, 5)
                                                    Text("Proje bilgisi: \(projebilgisi)")
                                                        .padding(.bottom, 5)
                                                    Text("Askerlik Durumu: \(askerlikdurum)")
                                                        .padding(.bottom, 5)
                                                    Divider()
                          
                                                }.padding()
                    }
                    Spacer()
                }
        }
    }
}
struct AddEmployeeView : View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var adnameText: String = ""
    @State var soyadnameText: String = ""
    @State var mailnameText: String = ""
    @State var telefon: String = ""
    @State var isebaslamatarihi: String = ""
    @State var dogumutarihi: String = ""
    @State var departman: String = ""
    @State var askerlikdurum: String = ""
    
    @State var projebilgisi: String = ""
    @FetchRequest(sortDescriptors: []) private var projects: FetchedResults<Proje>
        
        @State private var selectedProject: Proje? // Seçilen proje
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var departmanlar = ["Yönetici", "Analist", "Tasarımcı", "Programcı"]
    var body: some View {
        VStack(spacing: 20) {
            TextField("Ad", text: $adnameText)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(Capsule())
                .autocapitalization(.words)
                .padding(.horizontal, 32)
            
            TextField("Soyad", text: $soyadnameText)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(Capsule())
                .autocapitalization(.words)
                .padding(.horizontal, 32)

            TextField("Mail", text: $mailnameText)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(Capsule())
                .autocapitalization(.words)
                .padding(.horizontal, 32)

            TextField("Telefon", text: $telefon)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(Capsule())
                .autocapitalization(.words)
                .padding(.horizontal, 32)
                .keyboardType(.phonePad)

            TextField("İşe Başlama Tarihi", text: $isebaslamatarihi)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(Capsule())
                .autocapitalization(.words)
                .padding(.horizontal, 32)
                .keyboardType(.decimalPad) // Sayısal giriş için
            
            TextField("Doğum Tarihi", text: $dogumutarihi)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(Capsule())
                .autocapitalization(.words)
                .padding(.horizontal, 32)
                .keyboardType(.decimalPad) // Sayısal giriş için

            TextField("Askerlik Durumu", text: $askerlikdurum)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(Capsule())
                .autocapitalization(.words)
                .padding(.horizontal, 32)
            
            HStack{
                Text("Departman").padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(Capsule())
                    .autocapitalization(.words)
                Picker("departman seçiniz", selection: $departman) {
                    ForEach(departmanlar, id: \.self) {
                        Text($0)
                    }
                }
            };
            
            HStack{
                Text("Proje").padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(Capsule())
                    .autocapitalization(.words)
                Picker("Select a Project", selection: $selectedProject) {
                    ForEach(projects, id: \.self) { project in
                        Text(project.projeAdi ?? "Unnamed Project")
                            .tag(project as Proje?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                if let selected = selectedProject {
                    Text("\(selected.projeAdi ?? "Unnamed")")
                }
            };
            
            Button(action: {
                let calisanlarObject = Calisanlar(context: viewContext)
                calisanlarObject.ad = adnameText
                calisanlarObject.soyad = soyadnameText
                calisanlarObject.askerlikdurum = askerlikdurum
                calisanlarObject.departman = departman
                calisanlarObject.isebaslama = isebaslamatarihi
                calisanlarObject.mail = mailnameText
                calisanlarObject.telefon = telefon
                calisanlarObject.dogumtarihi = dogumutarihi
                calisanlarObject.projebilgisi = selectedProject?.projeAdi
                
                do {
                    try viewContext.save()
                    alertMessage = "Çalışan başarıyla kaydedildi!"
                    showingAlert = true
                } catch {
                    alertMessage = "Hata: Çalışan kaydedilemedi!"
                    showingAlert = true
                }
            }) {
                Text("Çalışan Kaydet").bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }

            Spacer()
        }
        .padding(.horizontal, 32)
        .alert("Bildirim", isPresented: $showingAlert) {
            Button("Tamam") {
                if alertMessage == "Çalışan başarıyla kaydedildi!" {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
}

struct LoginView : View {
    @State var mailnameText: String = ""
    @State var passwordText: String = ""
    @State var isNavigation : Bool = false
    
    
    @FetchRequest(
        sortDescriptors: []
    ) private var users : FetchedResults<Kullanicilar>
    
    @Environment(\.managedObjectContext) private var viewContext
       
    //private var users : FetchedResults<Kullanicilar>



    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                Spacer()
                Text ("YSOFT HR").font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing)
                        )
                Spacer()
           
                TextField("Mail", text: $mailnameText).padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(Capsule())
                    .padding(.horizontal, 32)
                SecureField("Şifre", text: $passwordText).padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(Capsule())
                    .padding(.horizontal, 32)
                
                Button {
                    if  mailnameText.isEmpty || passwordText.isEmpty {
                        isNavigation = false
                    }
                    else{
                        let filteredUsers = users.filter { user in
                            if user.mailnameText == mailnameText && user.passwordText == passwordText {
                                isNavigation = true
                            }
                            
                            
                            return true
                        }
                        

                        if filteredUsers.isEmpty {
                            isNavigation = false
                        } else {
                            // Eğer kullanıcı doğrulandıysa, yeni sayfaya geçiş yap
                          
                        }
                        
                       
                    }
                } label: {
                    Text("Oturum Aç").bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }.padding(.horizontal, 32)
                .navigationDestination(isPresented: $isNavigation) {
                    HomeView().environment(\.managedObjectContext, viewContext)
                    
                };NavigationLink {
                    SignupView()
                } label: {
                    
                    Text("Hesabınız yok mu? Kaydol")
                }

                
                Spacer()
            
            }
        }
    }
    
}




#Preview {
    SignupView()
}
