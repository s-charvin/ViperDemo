import UIKit



class NoteListViewController: UIViewController, ViperView,
                              NoteListViewInterface {

    var eventHandler: ViperViewEventHandler? = nil
    var viewDataSource: ViperPresenter? = nil
    var appeared = false // 表示视图是否已经出现
    // var noteListTableView (lazy)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initUI()
    }

    func initUI() {

        self.noteListTableView.delegate = self
        self.noteListTableView.dataSource = self
        self.noteListTableView.register(
            NoteListTableViewCell.self,
            forCellReuseIdentifier: "noteListCell"
        )
        self.view.addSubview(self.noteListTableView)

        NSLayoutConstraint.activate([
            self.noteListTableView.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor
            ),
            self.noteListTableView.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor
            ),
            self.noteListTableView.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor
            ),
            self.noteListTableView.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.appeared == false {

            guard let eventHandler = self.eventHandler as? NoteListViewEventHandler else {
                return
            }

            // 添加上下文菜单交互
            let interaction = UIContextMenuInteraction(delegate: self)
            self.view.addInteraction(interaction)

            let addNoteItem = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self.eventHandler,
                action: #selector(
                    self.didTouchNavigationBarAddButton
                )
            )
            self.navigationItem.rightBarButtonItem = addNoteItem
            
            eventHandler.viperViewIsReady()
            self.appeared = true
        }
        self.eventHandler?.viperViewDidAppear(animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.eventHandler?.viperViewDidAppear(animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.eventHandler?.viperViewWillDisappear(animated: animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.eventHandler?.viperViewDidDisappear(animated: animated)
        if self.isRemoving() {
            self.eventHandler?.viperViewWasRemoved()
        }
    }

    // MARK: NoteListViewInterface

    func cellForRowAt(_ indexPath: IndexPath, text: String, detailText: String) -> UITableViewCell {
        let cell = self.noteListTableView.dequeueReusableCell(withIdentifier: NoteListTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = text
        cell.detailTextLabel?.text = detailText
        return cell
    }
    
    // MARK: - Other methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc private func didTouchNavigationBarAddButton() {
        if let eventHandler = self.eventHandler as? NoteListViewEventHandler {
            eventHandler.didTouchNavigationBarAddButton()
        }
    }

    // MARK: Lazy vars
    lazy var noteListTableView: UITableView = {
            let noteListTableView = UITableView(frame: .zero, style: .plain)
            noteListTableView.translatesAutoresizingMaskIntoConstraints = false
            noteListTableView.rowHeight = 44
            noteListTableView.sectionHeaderHeight = 28
            noteListTableView.sectionFooterHeight = 28
            noteListTableView.backgroundColor = .white
            return noteListTableView
    }()
}

extension NoteListViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewDataSource = self.viewDataSource as? NoteListViewPresenter else {
            return 0
        }
        return viewDataSource.numberOfRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewDataSource = self.viewDataSource as? NoteListViewPresenter else {
            return UITableViewCell()
        }

        let text = viewDataSource.textOfCellForRowAt(indexPath: indexPath)
        let detailText = viewDataSource.detailTextOfCellForRowAt(indexPath: indexPath)
        return self.cellForRowAt(indexPath, text: text, detailText: detailText)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let eventHandler = self.eventHandler as? NoteListViewPresenter else {
            return false
        }

        return eventHandler.canEditRow(at: indexPath)
    }

    private func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) async {
        guard let eventHandler = self.eventHandler as? NoteListViewPresenter else {
            return
        }

        if editingStyle == .delete {
            eventHandler.handleDeleteCellForRow(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        guard let eventHandler = self.eventHandler as? NoteListViewPresenter else {
            return nil
        }
        // 创建一个删除操作
        let deleteAction = UIContextualAction(
            style: .destructive, title: "Delete") { _,_,_ in
            // 处理删除
            eventHandler.handleDeleteCellForRow(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        // 可以自定义删除按钮的背景色和图标
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash.fill")

        // 创建配置并返回
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true // 允许全滑动执行第一个操作

        return configuration
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let eventHandler = self.eventHandler as? NoteListViewPresenter else {
            return
        }

        tableView.deselectRow(at: indexPath, animated: true)
        eventHandler.handleDidSelectRow(at: indexPath)
    }
}


// MARK: UIContextMenuInteractionDelegate

extension NoteListViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let eventHandler = self.eventHandler as? NoteListViewPresenter else {
            return nil
        }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let addAction = UIAction(title: "Add", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { action in
                eventHandler.didTouchNavigationBarAddButton()
            }
            return UIMenu(title: "", children: [addAction])
        }
    }
}
