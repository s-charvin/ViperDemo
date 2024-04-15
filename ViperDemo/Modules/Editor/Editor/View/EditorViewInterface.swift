protocol EditorViewInterface {
    var delegate: EditorDelegate? { get set }
    var editMode: EditorMode { get set }
    
    var editorTitle: String? { get }
    var content: String? { get }
    
    func updateTitle(_ title: String)
    func updateContent(_ content: String)
}
