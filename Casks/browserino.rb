cask "browserino" do
  version "1.1.16"
  sha256 "8de2b7fbd8ad0eb2510de413d9f08039fbdf69d208f5aa9416f91ef21509a5ba"

  url "https://github.com/AlexStrNik/Browserino/releases/download/v#{version}/Browserino.zip"
  name "Browserino"
  desc "Tiny browser selector written in SwiftUI"
  homepage "https://github.com/AlexStrNik/Browserino"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates false
  depends_on macos: :ventura

  app "Browserino.app"

  uninstall quit: "xyz.alexstrnik.Browserino"

  zap trash: "~/Library/Preferences/xyz.alexstrnik.Browserino.plist"
end
