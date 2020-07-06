# SwiftUI_ScrollView_Offset
The extension can monitor the offset of scrollView, and can control scrollview to scroll to the specified offset

## Display
![1](https://github.com/agelessman/SwiftUI_ScrollView_Offset/blob/master/Kapture%202020-07-06%20at%2017.30.24.gif)
![2](https://github.com/agelessman/SwiftUI_ScrollView_Offset/blob/master/Kapture%202020-07-06%20at%2017.47.46.gif)
## Usage
scrollOffsetX:
```swift
ScrollView(.horizontal) {
    LazyHStack {
        ForEach(0..<10) { index in
            Text("\(index)")
                .frame(width: 100, height: 240)
                .background(index == 6 ? Color.green : Color.orange.opacity(0.5))
                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
        }
    }
}
.scrollOffsetX(self.$offsetX)
```

scrollOffsetY:
```swift
ScrollView(.vertical) {
    LazyVStack(spacing: 20) {
        ForEach(0..<10) { index in
            Text("\(index)")
                .frame(width: 200, height: 140)
                .background(index == 6 ? Color.green : Color.orange.opacity(0.5))
                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
        }
    }
}
.scrollOffsetY(self.$offsetY)
```

Example code：[https://gist.github.com/agelessman/3bf1d4f4d7fb24495972ba962777874f](https://gist.github.com/agelessman/3bf1d4f4d7fb24495972ba962777874f)
