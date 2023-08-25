# ios-embed-poc
Mobile iOS POC for Embed Webview

This example app uses TalkShopLive Embed player and open it up in a webview.

Development Embed URL: [https://publish-dev.talkshop.live/?v=1691163266&type=show&modus=JyC00f6tVJv0&index=JyC00f6tVJv0theme=light](https://publish-dev.talkshop.live/?v=1691163266&type=show&modus=JyC00f6tVJv0&index=JyC00f6tVJv0theme=light)

Live Embed URL: [https://publish.talkshop.live/?v=1691163266&type=show&modus=5Cn81MRw51ct&index=JyC00f6tVJv0&theme=light](https://publish.talkshop.live/?v=1691163266&type=show&modus=5Cn81MRw51ct&index=JyC00f6tVJv0&theme=light)

Change the modus for show ID.

Detailed documentation on configurable embed options can be found here:
[https://docs.talkshop.live/docs/embed-options](https://docs.talkshop.live/docs/embed-options)


Example Code:

````
import WebKit

let EMBED_URL = https://publish-dev.talkshop.live/?v=1691163266&type=show&modus=JyC00f6tVJv0&index=JyC00f6tVJv0theme=light

let webviewController = WebviewController()

let request = URLRequest(url: EMBED_URL, cachePolicy: .returnCacheDataElseLoad)

webviewController.webview.load(request)
````

