import UIKit

class NoteListViewController: ViperView,
                              NoteListViewInterface, 
                              UITableViewDelegate, UITableViewDataSource,
                              UIContextMenuInteractionDelegate {
    // MARK: ViperView
    var eventHandler: NoteListViewEventHandler?
    var viewDataSource: NoteListViewDataSource?

    var routeSource: UIViewController {
        return self
    }

    // MARK: Self
    var appeared = false // 表示视图是否已经出现
    // lazy var noteListTableView

    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func initUI() {
        self.noteListTableView.delegate = self
        self.noteListTableView.dataSource = self
        self.noteListTableView.register(NoteListTableViewCell.self, forCellReuseIdentifier: "noteListCell")
        self.view.addSubview(self.noteListTableView)

        NSLayoutConstraint.activate([
            noteListTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            noteListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            noteListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            noteListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.appeared == false {
            self.registerForPreviewing(with: self.eventHandler!, sourceView: self.view)
            // // 添加 UIContextMenuInteraction
            // let interaction = UIContextMenuInteraction(delegate: self)
            // self.view.addInteraction(interaction)

            let addNoteItem = UIBarButtonItem(barButtonSystemItem: .add, target: self.eventHandler, action: #selector(self.eventHandler!.didTouchNavigationBarAddButton))
            self.navigationItem.rightBarButtonItem = addNoteItem
            
            self.eventHandler?.handleViewReady()
            self.appeared = true
        }
        self.eventHandler?.handleViewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.eventHandler?.handleViewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.eventHandler?.handleViewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.eventHandler?.handleViewDidDisappear(animated)
        if self.isRemoving() {
            self.eventHandler?.handleViewRemoved()
        }
    }

    // MARK: NoteListViewInterface
    func noteListTableView() -> UITableView {
        return self.noteListTableView
    }

    func cellForRowAt(indexPath: IndexPath, text: String, detailText: String) -> UITableViewCell {
        let cell = self.noteListTableView.dequeueReusableCell(withIdentifier: NoteListTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = text
        cell.detailTextLabel?.text = detailText
        return cell
    }

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewDataSource?.numberOfRowsInSection(section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let text = self.viewDataSource?.textOfCellForRowAt(indexPath),
              let detailText = self.viewDataSource?.detailTextOfCellForRowAt(indexPath) else {
            fatalError("Unable to get text or detailText from viewDataSource")
        }
        return self.cellForRowAt(indexPath: indexPath, text: text, detailText: detailText)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.eventHandler?.canEditRowAt(indexPath) ?? false
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.eventHandler?.handleDeleteCellForRowAt(indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { action, indexPath in
            self.eventHandler?.handleDeleteCellForRowAt(indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.eventHandler?.handleDidSelectRowAt(indexPath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // // MARK: UIContextMenuInteractionDelegate
    // func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    //     return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
    //         let addAction = UIAction(title: "Add", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { action in
    //             self.eventHandler!.didTouchNavigationBarAddButton()
    //         }
    //         return UIMenu(title: "", children: [addAction])
    //     }
    // }

    // MARK: Lazy vars
    lazy var noteListTableView = { () -> UITableView in
        let noteListTableView = UITableView(frame: .zero, style: .plain)
        noteListTableView.translatesAutoresizingMaskIntoConstraints = false
        noteListTableView.rowHeight = 44
        noteListTableView.sectionHeaderHeight = 28
        noteListTableView.sectionFooterHeight = 28
        noteListTableView.backgroundColor = .white
        return noteListTableView
    }()
}
