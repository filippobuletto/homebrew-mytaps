cask "mew-notch" do
  version "2.2.2"
  sha256 "4af6dabf1bc78447b9403a4d4366f82fd57e1031cbcf3fcee1438d600d88ec47"

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
