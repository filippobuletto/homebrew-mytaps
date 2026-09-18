cask "aria2d" do
  version "1.4.2"
  sha256 "5ca7e037d934eac8d6b545db375e23fec1cbfacd99705f0b8d08eb0f98643e17"

  # Releases up to 1.4.1 were tagged "<version>(<build>)", so the cask used a
  # "version,build" pair; 1.4.2 dropped the build from the tag.
  url "https://github.com/xjbeta/Aria2D/releases/download/#{version}/Aria2D.zip"
  name "Aria2D"
  desc "Aria2 GUI"
  homepage "https://github.com/xjbeta/Aria2D"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "Aria2D.app"

  # Signed with a development certificate rather than a Developer ID one, so
  # Gatekeeper rejects it: drop the quarantine flag.
  postflight_steps do
    if_path_exists "{{appdir}}/Aria2D.app" do
      run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Aria2D.app"]
    end
  end

  zap trash: [
    "~/Library/Application Support/Aria2D",
    "~/Library/Application Support/com.xjbeta.Aria2D",
    "~/Library/Preferences/com.xjbeta.Aria2D.plist",
    "~/Library/Saved Application State/com.xjbeta.Aria2D.savedState",
  ]
end
