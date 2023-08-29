//
//  ContentView.swift
//  TSL Embed POC
//
//  Created by Daman Mehta on 2023-08-03.
//
import WebKit
import SwiftUI

let EMBED_URL = "https://publish-dev.talkshop.live/?v=1691163266&isEmbed=true&type=show&index=JyC00f6tVJv0&modus="
let DEFAULT_EMBED_URL = EMBED_URL + "JyC00f6tVJv0"
let EMBED_URL_LIVE = "https://publish.talkshop.live/?v=1691163266&&isEmbed=true&type=show&index=JyC00f6tVJv0&modus="
let DEFAULT_EMBED_URL_LIVE = EMBED_URL_LIVE + "5Cn81MRw51ct"
struct Webview: UIViewControllerRepresentable {
    var url: URL
    
    func makeUIViewController(context: Context) -> WebviewController {
        let webviewController = WebviewController()

        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        
        /* let htmlPath = Bundle.main.path(forResource: "embed", ofType: "html")
        let url = URL(fileURLWithPath: htmlPath!)
        let htmlRequest = URLRequest(url: url)
        webviewController.webview.load(htmlRequest) */
        webviewController.webview.load(request)

        return webviewController
    }

    func updateUIViewController(_ webviewController: WebviewController, context: Context) {
        //
    }
}

class WebviewController: UIViewController, WKNavigationDelegate {
    lazy var webview: WKWebView = WKWebView()
    lazy var progressbar: UIProgressView = UIProgressView()

    deinit {
        self.webview.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webview.scrollView.removeObserver(self, forKeyPath: "contentOffset")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webview.uiDelegate = self
        self.webview.navigationDelegate = self
        self.webview.allowsBackForwardNavigationGestures = true
        self.view.addSubview(self.webview)

        self.webview.frame = self.view.frame
        self.webview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            self.webview.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.webview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.webview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])

        self.webview.addSubview(self.progressbar)
        self.setProgressBarPosition()

        webview.scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)

        self.progressbar.progress = 0.1
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        guard let redirectURL = (navigationAction.request.url) else {
            decisionHandler(.cancel)
            return
        }
    
        // let _ = print("URL ->", redirectURL)
        if (redirectURL.absoluteString.contains("isEmbed=true")) {
            // Allows opening in the webview
            decisionHandler(.allow)
        } else if (redirectURL.absoluteString.starts(with: "https://talkshop.live") ||
                   redirectURL.absoluteString.starts(with: "https://dev-tvbdhuyxega.talkshop.live") ||
                   redirectURL.absoluteString.starts(with: "https://publish.talkshop.live") ||
                   redirectURL.absoluteString.starts(with: "https://support.talkshop.live") ||
                   redirectURL.absoluteString.starts(with: "https://www.facebook.com") ||
                   redirectURL.absoluteString.starts(with: "https://twitter.com") ||
                   redirectURL.absoluteString.starts(with: "https://m.facebook.com")
        ) {
            // Opens up in safari
            UIApplication.shared.open(redirectURL, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.cancel)
        }
    }

    func setProgressBarPosition() {
        self.progressbar.translatesAutoresizingMaskIntoConstraints = false
        self.webview.removeConstraints(self.webview.constraints)
        self.webview.addConstraints([
            self.progressbar.topAnchor.constraint(equalTo: self.webview.topAnchor, constant: self.webview.scrollView.contentOffset.y * -1),
            self.progressbar.leadingAnchor.constraint(equalTo: self.webview.leadingAnchor),
            self.progressbar.trailingAnchor.constraint(equalTo: self.webview.trailingAnchor),
        ])
    }

    // MARK: - Web view progress
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "estimatedProgress":
            if self.webview.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, animations: { () in
                    self.progressbar.alpha = 0.0
                }, completion: { finished in
                    self.progressbar.setProgress(0.0, animated: false)
                })
            } else {
                self.progressbar.isHidden = false
                self.progressbar.alpha = 1.0
                progressbar.setProgress(Float(self.webview.estimatedProgress), animated: true)
            }

        case "contentOffset":
            self.setProgressBarPosition()

        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

extension WebviewController: WKUIDelegate {

    func webView(_ webview: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        guard let url = navigationAction.request.url else {
            return nil
        }
        
        guard let targetFrame = navigationAction.targetFrame, targetFrame.isMainFrame else {
            webview.load(URLRequest(url: url))
            return nil
        }
        return nil
    }
}

// vzzg6tNu0qOv
struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var isShowingWebView: Bool = false
    @State var showSheet = false
    @State var fullURL: String = DEFAULT_EMBED_URL
    @State var showID: String = ""
        
        var body: some View {
            NavigationView {
                VStack {
                    // Dev Buttons
                    Text("Dev Mode").padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)).fontWeight(.bold)
                    TextField("Enter Show Id", text: $showID).onChange(of: showID) { newValue in
                        fullURL = "\(EMBED_URL)\(showID.isEmpty ? "JyC00f6tVJv0" : showID)&theme=\(colorScheme == .dark ? "dark" : "light")"
                    }
                    // Make sure no other style is mistakenly applied.
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        // Text alignment.
                        .multilineTextAlignment(.leading)
                        // Text/placeholder font.
                        .font(.title3.weight(.medium))
                        // TextField spacing.
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        // TextField border.
                        //.background(border)
                    // Text(fullURL)
                    //
                    // 1). --> Modal
                    //
                    Button(action: {
                        isShowingWebView = true
                    })
                    {
                        Text("Embed - Modal")
                    }
                    .sheet(isPresented: $isShowingWebView) {
                        // Open url
                        Webview(url: URL(string: fullURL)!)
                    }.buttonStyle(.borderedProminent)
                    
                    //
                    // 2). --> Full Modal
                    //
                    Button("Embed - Full Modal") {
                        showSheet = true
                    }.fullScreenCover(isPresented: $showSheet) {
                        SheetViewDev(inputUrl: $fullURL)
                    }.buttonStyle(.borderedProminent)
                    
                    //
                    // 3). --> New Screen
                    //
                    NavigationLink(destination: ScreenViewDev(inputUrl: $fullURL)) {
                                        Text("Embed - New Screen")
                    }.buttonStyle(.borderedProminent)
                    
                    
                    Text("").padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0)).fontWeight(.bold)
                    
                    NavigationLink(destination: ScreenView()) {
                                        Text("Switch to Live Mode")
                    }.buttonStyle(.borderedProminent)
                    
                    VStack {
                        Text("Full URL: \(fullURL)").font(.body)
                    }.padding(20)
                }.font(.title2).navigationBarTitle(Text("TSL Embed POC").font(.title3), displayMode: .inline)
                    .navigationBarHidden(false)
            }
        }
}


struct SheetView: View {
 @Environment(\.presentationMode) var presentationMode
    @Binding var inputUrlLive: String

  var body: some View {
      ZStack {
          // Open url
          Webview(url: URL(string:inputUrlLive)!)
          
          Button {
             presentationMode.wrappedValue.dismiss()
           } label: {
              Image(systemName: "xmark.circle")
                   .font(.title)
              .foregroundColor(.gray)
              .background(.white)
              .backgroundStyle(.brown)
              .cornerRadius(100)
              .position(x: 30, y: 0)
           }
    }
     .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
     .padding(0)
  }
}

struct SheetViewDev: View {
 @Environment(\.presentationMode) var presentationMode
    @Binding var inputUrl: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ZStack {
                // Open url
                Webview(url: URL(string:inputUrl)!)
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .foregroundColor(.gray)
                        .background(.white)
                        .backgroundStyle(.brown)
                        .cornerRadius(100)
                        .position(x: 30, y: 0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(0)
        }
    }
}

// HdLWbc0zNk54
// New Screen Live
struct ScreenView : View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State var isShowingWebView: Bool = false
    @State var showSheet = false
    
    @State var fullURL: String = DEFAULT_EMBED_URL_LIVE
    @State var showID: String = ""
        var body: some View {
            VStack {
                Text("Live Mode").padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0)).fontWeight(.bold)

                TextField("Enter Show Id", text: $showID).onChange(of: showID) { newValue in
                    fullURL = "\(EMBED_URL_LIVE)\(showID.isEmpty ? "5Cn81MRw51ct" : showID)&theme=\(colorScheme == .dark ? "dark" : "light")"
                }
                // Make sure no other style is mistakenly applied.
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    // Text alignment.
                    .multilineTextAlignment(.leading)
                    // Text/placeholder font.
                    .font(.title3.weight(.medium))
                    // TextField spacing.
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    // TextField border.
                    //.background(border)
                //
                // 1). --> Modal
                //
                Button(action: {
                    isShowingWebView = true
                })
                {
                    Text("Embed - Modal")
                }
                .sheet(isPresented: $isShowingWebView) {
                    // Open url
                    Webview(url: URL(string: fullURL)!)
                }.buttonStyle(.borderedProminent)
                
                //
                // 2). --> Full Modal
                //
                Button("Embed - Full Modal") {
                    showSheet = true
                }.fullScreenCover(isPresented: $showSheet) {
                    SheetView(inputUrlLive: $fullURL)
                }.buttonStyle(.borderedProminent)
                
                //
                // 3). --> New Screen
                //
                NavigationLink(destination: ScreenViewLive(inputUrl: $fullURL)) {
                                    Text("Embed - New Screen")
                }.buttonStyle(.borderedProminent)
                
                
                Text("").padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0)).fontWeight(.bold)
                
                Button("Switch to Dev Mode") {
                    presentationMode.wrappedValue.dismiss()
                }.buttonStyle(.borderedProminent)
                
                
                VStack {
                    Text("Full URL: \(fullURL)").font(.body)
                }.padding(20)
            }.font(.title2).navigationBarTitle(Text("").font(.title3), displayMode: .inline)
                .navigationBarHidden(true)
        }
    }

// New Screen Live
struct ScreenViewLive : View {
    @Binding var inputUrl: String
        var body: some View {
            NavigationView {
                VStack {
                    // Open url
                    Webview(url: URL(string:inputUrl)!)
                }.navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }
    }

// New Screen Dev
struct ScreenViewDev : View {
    @Binding var inputUrl: String
        var body: some View {
            NavigationView {
                VStack {
                    // Open url
                    Webview(url: URL(string:inputUrl)!)
                }.navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
