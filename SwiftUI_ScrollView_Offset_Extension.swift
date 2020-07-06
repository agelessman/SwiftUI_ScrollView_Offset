
extension View {
    func scrollOffsetX(_ offsetX: Binding<CGFloat>) -> some View {
        return MyScrollViewControllerRepresentable(offset: offsetX, isOffsetX: true, content: self)
    }
}

extension View {
    func scrollOffsetY(_ offsetY: Binding<CGFloat>) -> some View {
        return MyScrollViewControllerRepresentable(offset: offsetY, isOffsetX: false, content: self)
    }
}

struct MyScrollViewControllerRepresentable<Content>: UIViewControllerRepresentable where Content: View {
    var offset: Binding<CGFloat>
    let isOffsetX: Bool
    var content: Content
    
    func makeUIViewController(context: Context) -> MyScrollViewUIHostingController<Content> {
        MyScrollViewUIHostingController(offset: offset, isOffsetX:isOffsetX, rootView: content)
    }
    
    func updateUIViewController(_ uiViewController: MyScrollViewUIHostingController<Content>, context: Context) {
        uiViewController.scroll(to: offset.wrappedValue, animated: true)
    }
}

class MyScrollViewUIHostingController<Content>: UIHostingController<Content> where Content: View {
    var offset: Binding<CGFloat>
    let isOffsetX: Bool
    var showed = false
    var sv: UIScrollView?
    
    init(offset: Binding<CGFloat>, isOffsetX: Bool,  rootView: Content) {
        self.offset = offset
        self.isOffsetX = isOffsetX
        super.init(rootView: rootView)
    }
    
    @objc dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /// 保证设置一次监听
        if showed {
            return
        }
        showed = true
        
        /// 查找UIScrollView
        sv = findScrollView(in: view)
        
        /// 设置监听
        sv?.addObserver(self,
                        forKeyPath: #keyPath(UIScrollView.contentOffset),
                        options: [.old, .new],
                        context: nil)
        
        /// 滚动到指定位置
        scroll(to: offset.wrappedValue, animated: false)
        
        super.viewDidAppear(animated)
    }
    
    func scroll(to position: CGFloat, animated: Bool = true) {
        if let s = sv {
            if position != (self.isOffsetX ? s.contentOffset.x : s.contentOffset.y) {
                let offset = self.isOffsetX ? CGPoint(x: position, y: 0) : CGPoint(x: 0, y: position)
                sv?.setContentOffset(offset, animated: animated)
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(UIScrollView.contentOffset) {
            if let s = self.sv {
                DispatchQueue.main.async {
                    self.offset.wrappedValue = self.isOffsetX ? s.contentOffset.x : s.contentOffset.y
                }
            }
        }
    }
    
    func findScrollView(in view: UIView?) -> UIScrollView? {
        if view?.isKind(of: UIScrollView.self) ?? false {
            return view as? UIScrollView
        }
        
        for subview in view?.subviews ?? [] {
            if let sv = findScrollView(in: subview) {
                return sv
            }
        }
        
        return nil
    }
}
