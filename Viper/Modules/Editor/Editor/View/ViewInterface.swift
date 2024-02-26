protocol EditorViewInterface {
    var delegate: EditorDelegate? { get set }
    var editMode: EditorMode { get set }
    
    var titleString: String? { get }
    var contentString: String? { get }
    
    func updateTitleString(_ title: String)
    func updateContentString(_ content: String)
}