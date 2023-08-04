//
//  ContentView.swift
//  TSL Embed POC
//
//  Created by Daman Mehta on 2023-08-03.
//
import WebKit
import SwiftUI

let EMBED_URL = "https://publish-dev.talkshop.live/?v=1691163266&type=show&modus=JyC00f6tVJv0&index=JyC00f6tVJv0theme=light"
let EMBED_URL_LIVE = "https://publish.talkshop.live/?v=1691163266&type=show&modus=5Cn81MRw51ct&index=JyC00f6tVJv0&theme=light"
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

        self.webview.navigationDelegate = self
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

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowingWebView: Bool = false
    @State private var showSheet = false
    @State private var inputUrlLive: String = EMBED_URL_LIVE
    @State private var inputUrlStaging: String = EMBED_URL
        
        var body: some View {
            NavigationView {
                VStack {
                    Text("Live Mode").padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)).fontWeight(.bold)
                    TextField("Enter URL", text: $inputUrlLive)
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
                        Text("Live Embed - Modal")
                    }
                    .sheet(isPresented: $isShowingWebView) {
                        // Open url
                        Webview(url: URL(string: inputUrlLive)!)
                    }.buttonStyle(.borderedProminent)
                    
                    //
                    // 2). --> Full Modal
                    //
                    Button("Live Embed - Full Modal") {
                        showSheet = true
                    }.fullScreenCover(isPresented: $showSheet) {
                        SheetView(inputUrl: $inputUrlLive)
                    }.buttonStyle(.borderedProminent)
                    
                    //
                    // 3). --> New Screen
                    //
                    NavigationLink(destination: ScreenView(inputUrl: $inputUrlLive)) {
                                        Text("Live Embed - New Screen")
                    }.buttonStyle(.borderedProminent)
                    
                    // Dev Buttons
                    Text("Dev Mode").padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0)).fontWeight(.bold)
                    TextField("Enter URL", text: $inputUrlStaging)
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
                        Text("Dev Embed - Modal")
                    }
                    .sheet(isPresented: $isShowingWebView) {
                        // Open url
                        Webview(url: URL(string: inputUrlStaging)!)
                    }.buttonStyle(.borderedProminent)
                    
                    //
                    // 2). --> Full Modal
                    //
                    Button("Dev Embed - Full Modal") {
                        showSheet = true
                    }.fullScreenCover(isPresented: $showSheet) {
                        SheetViewDev(inputUrl: $inputUrlStaging)
                    }.buttonStyle(.borderedProminent)
                    
                    //
                    // 3). --> New Screen
                    //
                    NavigationLink(destination: ScreenViewDev(inputUrl: $inputUrlStaging)) {
                                        Text("Dev Embed - New Screen")
                    }.buttonStyle(.borderedProminent)
                }.font(.title2).navigationBarTitle(Text("TSL Embed POC").font(.title3), displayMode: .large)
                    .navigationBarHidden(false)
            }
        }
}


struct SheetView: View {
 @Environment(\.presentationMode) var presentationMode
    @Binding var inputUrl: String

  var body: some View {
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

struct SheetViewDev: View {
 @Environment(\.presentationMode) var presentationMode
    @Binding var inputUrl: String

  var body: some View {
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

// New Screen Live
struct ScreenView : View {
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
