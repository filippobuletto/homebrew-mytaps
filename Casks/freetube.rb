cask "freetube" do
  arch arm: "arm64", intel: "x64"

  version "0.25.3"
  sha256 arm:   "2b445d64f5e56a873debea50c785cd41400bdabc387f0d67fc7be745b2b9146e",
         intel: "40fb6c671ec75905e035968ec0c14bfe717643730af80536e625d191455f49bf"

  url "https://github.com/FreeTubeApp/FreeTube/releases/download/v#{version}-beta/freetube-#{version}-beta-mac-#{arch}.dmg"
  name "FreeTube"
  desc "YouTube player focusing on privacy"
  homepage "https://freetubeapp.io/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)/i)
  end

  depends_on macos: :monterey

  app "FreeTube.app"

  # Ad-hoc signed, so Gatekeeper rejects it: drop the quarantine flag.
  postflight_steps do
    if_path_exists "{{appdir}}/FreeTube.app" do
      run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/FreeTube.app"]
    end
  end

  uninstall quit: "io.freetubeapp.freetube"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/io.freetubeapp.freetube.sfl*",
    "~/Library/Application Support/FreeTube",
    "~/Library/Preferences/io.freetubeapp.freetube.plist",
    "~/Library/Saved Application State/io.freetubeapp.freetube.savedState",
  ]
end
