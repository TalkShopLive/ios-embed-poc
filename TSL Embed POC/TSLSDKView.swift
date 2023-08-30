//
//  TSLSDKView.swift
//  TSL Embed POC
//
//  Created by Daman Mehta on 2023-08-29.
//
import WebKit
import SwiftUI
import TSLWebview

struct TSLSDKView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State var index = 0
    @State var theme = "light"
    @State var isShowingWebView: Bool = false
    @State var showSheet = false
    @State var fullURL: String = DEFAULT_EMBED_URL
    @State var showID: String = "5Cn81MRw51ct"
    @State private var isDarkMode = false
    @State private var autoPlay = false
    
    init () {
        _theme = State(initialValue: colorScheme == .dark ? "dark" : "light")
        _isDarkMode = State(initialValue: colorScheme == .dark)
    }
        
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack {
                        Spacer(minLength: 30)
                        // SDK Buttons
                        Text("SDK Mode(Live)").padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)).fontWeight(.bold)
                        Spacer(minLength: 30)
                        
                        VStack {
                            HStack {
                                Text("Enter Show ID").font(.body)
                                Spacer()
                            }
                            TextField("Enter Show Id", text: $showID).onChange(of: showID) { newValue in
                                fullURL = "\(EMBED_URL)\(showID.isEmpty ? "JyC00f6tVJv0" : showID)&theme=\(theme)"
                            }.frame(height: 40).background(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            
                            //
                            Spacer(minLength: 20)
                            // Should autoPlay
                            Toggle("Auto Play", isOn: $autoPlay)
                            
                            //
                            Spacer(minLength: 20)
                            // Theme Selector
                            Toggle("Dark Mode(Webview)", isOn: $isDarkMode)
                                .onChange(of: isDarkMode) {  newValue in
                                    theme = newValue ? "dark" : "light"
                                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        
                        // Spacer
                        Spacer(minLength: 40)
                        
                        //
                        // 1). --> Modal
                        //
                        Button(action: {
                            isShowingWebView = true
                        }) {
                            Text("Modal")
                        }
                        .sheet(isPresented: $isShowingWebView) {
                            // Open url
                            TSLWebview(showID: $showID, theme: $theme, autoPlay: $autoPlay)
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(width: 240)
                        .padding(2)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        //
                        // 2). --> New Screen
                        //
                        NavigationLink(destination: ScreenViewSDK(showID: $showID, theme: $theme, autoPlay: $autoPlay)) {
                            Text("New Screen")
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(width: 240)
                        .padding(2)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        
                        Text("").padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0)).fontWeight(.bold)
                        
                        Button("Switch to URL Mode") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .frame(width: 240)
                        .padding(.vertical, 10)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                    }.font(.title2).navigationBarTitle(Text("TSL Embed POC").font(.title3), displayMode: .inline)
                        .navigationBarHidden(false)
                }
            }.navigationBarTitle(Text(""))
                .navigationBarHidden(true).navigationViewStyle(StackNavigationViewStyle())
                
        }
}

// New Screen
struct ScreenViewSDK : View {
    @Binding var showID: String
    @Binding var theme: String
    @Binding var autoPlay: Bool
        var body: some View {
            VStack {
                // Open url
                TSLWebview(showID: $showID, theme: $theme, autoPlay: $autoPlay)
            }
        }
    }

struct TSLSDKView_Previews: PreviewProvider {
    static var previews: some View {
        TSLSDKView()
    }
}
