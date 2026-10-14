# Source-of-truth Homebrew cask for agterm. scripts/release.sh seeds this into
# ZhilinS/homebrew-apps (Casks/agterm.rb) on first publish and rewrites the
# version + sha256 lines on every release.
cask "agterm" do
  version "0.36.0-fork.1"
  sha256 "3e044b2aea62c03d5165cae9e0fc2d0cc361d7bf61e85362f8569acfc3de9832"

  url "https://github.com/ZhilinS/agterm/releases/download/v#{version}/agterm-#{version}.dmg"
  name "agterm"
  desc "Terminal on libghostty with a workspace/session sidebar"
  homepage "https://github.com/ZhilinS/agterm"

  depends_on macos: :sonoma
  depends_on arch: :arm64

  app "agterm.app"
  binary "#{appdir}/agterm.app/Contents/MacOS/agtermctl", target: "agtermctl"

  # strip Homebrew's com.apple.quarantine so brew install/upgrade opens with no
  # "downloaded from the internet" prompt. the app is Developer ID signed, notarized,
  # and stapled, but that only removes the unidentified-developer block and the online
  # check - Gatekeeper still shows the first-launch confirm whenever the quarantine attr
  # is present, and brew re-stamps it on every fresh bundle.
  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/agterm.app"]
  end

  zap trash: [
    "~/Library/Application Support/agterm",
    "~/Library/Preferences/com.umputun.agterm.plist",
    "~/Library/Saved Application State/com.umputun.agterm.savedState",
  ]
end
