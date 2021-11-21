/// Copyright (c) 2020 HappyGuy LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

// This struct returns a SwiftUI View that renders an image with either the data fetched from a RemoteImageFetcher or
// a placeholder image provided during initialization.
public struct RemoteImageView<Content: View>: View {
	
	// !!!: When remote image fetcher finish image downloading, this var will update UI automatically
	@ObservedObject var imageFetcher: RemoteImageFetcher
	
	var content: (_ image: Image) -> Content
	let placeholderImage: Image // placeholder image
	
	@State var previousURL: URL? = nil
	@State var imageData: Data = Data()
	
	// MARK: - Public APIs
	
	public init(placeholder: Image,
				imageFetcher: RemoteImageFetcher,
				content: @escaping (_ image: Image) -> Content) {
		self.placeholderImage = placeholder
		self.imageFetcher = imageFetcher
		self.content = content
	}
	
	// Note: When you move the code into a package, you also need to make sure the struct and body property is public.
    public var body: some View {
		
		DispatchQueue.main.async {
			if self.previousURL != self.imageFetcher.getURL() { // need update URL
				self.previousURL = self.imageFetcher.getURL()
			}
			
			if !self.imageFetcher.imageData.isEmpty { // update image data
				self.imageData = self.imageFetcher.imageData
			}
		}
		
		// Data -> UIImage -> Image
		let uiImage = imageData.isEmpty ? nil : UIImage(data: imageData)
		let image: Image? = (uiImage != nil) ? Image(uiImage: uiImage!) : nil
		
		// Return a SwiftUI View that renders an image
		return ZStack() {
			if image != nil {
				content(image!)
			} else {
				content(placeholderImage)
			}
		}
		// load image when the View appears
		.onAppear(perform: loadImage)
    }
	
	// MARK: - Private Helpers
	
	private func loadImage() {
		imageFetcher.fetch()
	}
	
}

//struct RemoteImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        RemoteImageView()
//    }
//}
