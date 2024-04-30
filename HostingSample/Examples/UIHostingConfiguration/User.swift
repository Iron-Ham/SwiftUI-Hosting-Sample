import Foundation

struct User {
  let username: String
  let imageURL: URL

  let splashImage: URL

  static var all: [User] {
    usernames.enumerated().map { i, e in
      User(
        username: e,
        imageURL: url(fromUsername: e),
        splashImage: url(fromIndex: i)
      )
    }
  }
}

private let usernames = [
  "iron-ham",
  "rnystrom",
  "eliperkins",
  "elisealix22",
  "colinshum",
  "mxie",
  "hensquared",
  "amrehman",
  "haldun",
  "taki-on",
  "esahmed21",
  "soffes",
  "aconsuegra",
  "brianlovin",
  "gavinmn",
  "cfahlbusch",
  "masachs",
  "imanmahjoubi",
  "stevepopovich",
  "alcere",
  "demoritas"
]

private let splashImages = [
  "https://images.unsplash.com/photo-1709374601273-57d0a44c9437?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTA4NA&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1709228886139-7c4c25745c0d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTEzOA&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1707653057279-b94dff636f62?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0NQ&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1701888281386-5ac0e1bb1ef4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0Nw&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1708556863286-16a9ada29871?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0Nw&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1709037805384-035dc3989923?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0Nw&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1709380526836-100c551cfc28?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0Nw&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1705651460189-cc7180ad8709?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0Nw&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1707680639756-d37ea04572a9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0Nw&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1708526404904-8b8ac3086039?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0OA&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1709409902991-dbc2ae8c3a4c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0OA&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1709978601970-036e92662b46?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0OA&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1699959272543-34b716605e61?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0OA&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1707057539184-27e90364e30a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0OA&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1707057539184-27e90364e30a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0OA&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1709983966012-d029ecc43684?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0OA&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1708804760932-d97756d67419?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0OQ&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1709056842187-a7c66a8647c4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0OQ&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1709136333082-f3ce4ad278a3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0OQ&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1706996488299-bbb736d9a15d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0OQ&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1709746837880-f96b4f588ce5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0OQ&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1708936201506-1765d86c0b16?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE0OQ&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1708516893277-232fb2bfb198?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE1MA&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1708545302676-3722b80dea57?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE1MA&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1709232584243-23b5677cef0f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE1MA&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1707757618962-010cdd24bbc2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE1MA&ixlib=rb-4.0.3&q=80&w=1080",
  "https://images.unsplash.com/photo-1708164863710-14fa216daa5c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTcxNDUxMTE1MA&ixlib=rb-4.0.3&q=80&w=1080"
]

private func url(fromUsername username: String) -> URL {
  URL(string: "https://github.com/\(username).png")!
}

private func url(fromIndex index: Int) -> URL {
  URL(string: splashImages[index])!
}
