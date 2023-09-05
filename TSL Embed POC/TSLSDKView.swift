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
    @State var theme : String? = "light"
    @State var isShowingWebView: Bool = false
    @State var showID: String = "5Cn81MRw51ct"
    @State var isDarkMode = false
    @State var autoPlay : Bool = false
    @State var shouldAutoPlay : Bool? = false
    @State var expandChat : Bool = false
    @State var expandChatValue : Bool? = false
    @State var hideChat : Bool = false
    @State var hideChatValue : Bool? = false
    @State var singleVariantButtonText : String = "Add"
    @State var singleVariantButtonTextValue : String? = "Add"
    @State var singleVariantButtonIcon : String = "Plus"
    @State var singleVariantButtonIconValue : String? = "Plus"
    @State var multipleVariantButtonText : String = "Add"
    @State var multipleVariantButtonTextValue : String? = "Add"
    @State var dnt : Bool = false
    @State var dntValue : Bool? = false
        
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack {
                        Spacer(minLength: 30)
                        // SDK Buttons
                        Text("SDK Mode(Live)").padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)).fontWeight(.bold)
                        Spacer(minLength: 30)
                        
                        Group {
                            VStack {
                                HStack {
                                    Text("Enter Show ID").font(.body)
                                    Spacer()
                                }
                                TextField("", text: $showID).frame(height: 40).background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                            }
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            //
                            
                            HStack {
                                VStack {
                                    HStack {
                                        Text("Single Variant Button Text").font(.body)
                                        Spacer()
                                    }
                                    TextField("", text: $singleVariantButtonText).frame(height: 40).background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                                }
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .onChange(of: singleVariantButtonText) { newValue in
                                    singleVariantButtonTextValue = singleVariantButtonText
                                  }
                                
                                //
                                Spacer(minLength: 10)

                                VStack {
                                    HStack {
                                        Text("Single Variant Button Icon").font(.body)
                                        Spacer()
                                    }
                                    TextField("", text: $singleVariantButtonIcon).frame(height: 40).background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                                }
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .onChange(of: singleVariantButtonIcon) { newValue in
                                    singleVariantButtonIconValue = singleVariantButtonIconValue
                                  }
                            }
                            
                            //
                            Spacer(minLength: 20)
                            
                            VStack {
                                HStack {
                                    Text("Multiple Variant Button Text").font(.body)
                                    Spacer()
                                }
                                TextField("", text: $multipleVariantButtonText).frame(height: 40).background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                            }
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: multipleVariantButtonText) { newValue in
                                multipleVariantButtonTextValue = multipleVariantButtonText
                              }
                            
                            VStack {
                                //
                                Spacer(minLength: 20)
                                // Theme Selector
                                Toggle("Auto Play", isOn: $autoPlay)
                                    .onChange(of: autoPlay) {  newValue in
                                        shouldAutoPlay = newValue
                                                }
                                
                                //
                                Spacer(minLength: 20)
                                // Theme Selector
                                Toggle("Dark Mode(Webview)", isOn: $isDarkMode)
                                    .onChange(of: isDarkMode) {  newValue in
                                        theme = newValue ? "dark" : "light"
                                                }
                                
                                //
                                Spacer(minLength: 20)
                                // Theme Selector
                                Toggle("Auto Expand Chat", isOn: $expandChat)
                                    .onChange(of: expandChat) {  newValue in
                                        expandChatValue = newValue
                                                }
                                
                                //
                                Spacer(minLength: 20)
                                // Theme Selector
                                Toggle("Hide Chat", isOn: $hideChat)
                                    .onChange(of: hideChat) {  newValue in
                                        hideChatValue = newValue
                                                }
                                
                                //
                                Spacer(minLength: 20)
                                // Theme Selector
                                Toggle("Do not track", isOn: $dnt)
                                    .onChange(of: dnt) {  newValue in
                                        dntValue = newValue
                                                }
                            }
                        }.padding(.horizontal, 16)
                        
                        
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
                            TSLWebview(showID: $showID, theme: $theme, autoPlay: $shouldAutoPlay, expandChat: $expandChatValue, hideChat: $hideChatValue, singleVariantButtonText: $singleVariantButtonTextValue, singleVariantButtonIcon: $singleVariantButtonIconValue, multipleVariantButtonText: $multipleVariantButtonTextValue, dnt: $dntValue)
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
                        NavigationLink(destination: ScreenViewSDK(showID: $showID, theme: $theme, autoPlay: $shouldAutoPlay, expandChat: $expandChatValue, hideChat: $hideChatValue, singleVariantButtonText: $singleVariantButtonTextValue, singleVariantButtonIcon: $singleVariantButtonIconValue, multipleVariantButtonText: $multipleVariantButtonTextValue, dnt: $dntValue)) {
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
                        .background(colorScheme != .dark ? .black : .white)
                        .foregroundColor(colorScheme != .dark ? .white : .black)
                        .cornerRadius(8)
                        
                        Spacer(minLength: 100)
                        
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
    @Binding var theme: String?
    @Binding var autoPlay: Bool?
    @Binding var expandChat: Bool?
    @Binding var hideChat: Bool?
    @Binding var singleVariantButtonText: String?
    @Binding var singleVariantButtonIcon: String?
    @Binding var multipleVariantButtonText: String?
    @Binding var dnt: Bool?

        var body: some View {
            VStack {
                // Open url
                TSLWebview(showID: $showID, theme: $theme, autoPlay: $autoPlay, expandChat: $expandChat, hideChat: $hideChat, singleVariantButtonText: $singleVariantButtonText, singleVariantButtonIcon: $singleVariantButtonIcon, multipleVariantButtonText: $multipleVariantButtonText,
                    dnt: $dnt
                )
            }
        }
    }

struct TSLSDKView_Previews: PreviewProvider {
    static var previews: some View {
        TSLSDKView()
    }
}
