cask "mew-notch" do
  version "2.4.0"
  sha256 "66b1308355e72720f29c7041083bbd0b81b3e9269411f63864eda1e4c4a6a44e"

  url "https://github.com/monuk7735/mew-notch/releases/download/#{version}/MewNotch-#{version}.dmg"
  name "MewNotch"
  desc "Media controls, system stats and file access in the notch area"
  homepage "https://monuk7735.github.io/mew-notch/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "MewNotch.app"

  postflight_steps do
    if_path_exists "{{appdir}}/MewNotch.app" do
      run "/usr/bin/xattr", args: ["-cr", "{{appdir}}/MewNotch.app"]
    end
  end

  zap trash: [
    "~/Library/Application Support/MewNotch",
    "~/Library/Preferences/com.monuk7735.mew-notch.plist",
    "~/Library/Saved Application State/com.monuk7735.mew-notch.savedState",
  ]
end
