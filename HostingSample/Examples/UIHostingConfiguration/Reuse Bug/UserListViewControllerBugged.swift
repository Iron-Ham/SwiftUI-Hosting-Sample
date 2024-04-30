import SwiftUI

final class UserListViewControllerBugged: UITableViewController {

  private let users = User.all
  private let cellIdentifier = "cellIdentifier"

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    User.all.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    let user = users[indexPath.row]
    cell.contentConfiguration = UIHostingConfiguration {
      VStack(alignment: .leading) {
        AsyncImage(url: user.splashImage) { image in
          image
            .resizable()
            .scaledToFill()
            .containerRelativeFrame(.horizontal)
        } placeholder: {
          ProgressView()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .clipped()

        HStack {
          AsyncImage(url: user.imageURL) { image in
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
          } placeholder: {
            ProgressView()
          }
          .aspectRatio(1, contentMode: .fit)
          .frame(maxWidth: 200, maxHeight: 200)

          Text(user.username)
        }
        .padding()
      }
    }

    return cell
  }
}
