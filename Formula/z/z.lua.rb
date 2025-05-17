class ZLua < Formula
  desc "New cd command that helps you navigate faster by learning your habits"
  homepage "https://github.com/skywind3000/z.lua"
  url "https://github.com/skywind3000/z.lua/archive/refs/tags/1.8.22.tar.gz"
  sha256 "7add6095130f53c2f91aad2cbf329552b0b8008794b92be5f969a451b1f14019"
  license "MIT"
  head "https://github.com/skywind3000/z.lua.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ad5ff87665c7ba4d6447a720162b11aaceed7fcf8ae16a92b4c3fa071275eb1e"
  end

  depends_on "lua"

  def install
    # Avoid using Cellar paths at runtime. This breaks when z.lua is upgraded.
    inreplace "z.lua.plugin.zsh", /^(ZLUA_SCRIPT=").*"$/, "\\1#{opt_pkgshare}/z.lua\""
    pkgshare.install "z.lua", "z.lua.plugin.zsh", "init.fish"
    doc.install "README.md", "LICENSE"
  end

  def caveats
    <<~EOS
      Zsh users: add line below to your ~/.zshrc
        eval "$(lua $(brew --prefix z.lua)/share/z.lua/z.lua --init zsh)"

      Bash users: add line below to your ~/.bashrc
        eval "$(lua $(brew --prefix z.lua)/share/z.lua/z.lua --init bash)"
    EOS
  end

  test do
    system "lua", "#{opt_pkgshare}/z.lua", "."
  end
end
