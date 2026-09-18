cask "jd-gui" do
  version "1.6.6"
  sha256 "b16ce61bbcfd2f006046b66c8896c512a36c6b553afdca75896d7c5e27c7477d"

  url "https://github.com/java-decompiler/jd-gui/releases/download/v#{version}/jd-gui-osx-#{version}.tar"
  name "JD-GUI"
  desc "Standalone Java Decompiler GUI"
  homepage "https://java-decompiler.github.io/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "jd-gui-osx-#{version}/JD-GUI.app"

  # Unsigned, so Gatekeeper rejects it: drop the quarantine flag.
  postflight_steps do
    if_path_exists "{{appdir}}/JD-GUI.app" do
      run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/JD-GUI.app"]
    end
  end

  zap trash: "~/Library/Saved Application State/jd.jd-gui.savedState"
end
