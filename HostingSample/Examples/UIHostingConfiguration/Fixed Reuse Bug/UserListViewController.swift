import SwiftUI

final class UserListViewController: UITableViewController {

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
      // When defining a UIHostingConfiguration, it's important to place an `id` on the outer
      // SwiftUI View. Otherwise, you will run into cell-reuse bugs.
      // In order to see this bug in action on the other view controller, try to slow down your
      // networking speed using the Network Link Conditioner.
      .id(user.username)
    }

    return cell
  }
}
