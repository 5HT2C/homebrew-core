class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.77.15.tar.gz"
  sha256 "ebe361d5112b5547a4a94f92859dec70afa3bd00d79ca7e578bef46e5970749a"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66d05bb7f8387c802574d044693225fffa4e762a1d143f69116de6957efc3b96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66d05bb7f8387c802574d044693225fffa4e762a1d143f69116de6957efc3b96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66d05bb7f8387c802574d044693225fffa4e762a1d143f69116de6957efc3b96"
    sha256 cellar: :any_skip_relocation, sonoma:        "f29d62c7304593012cf4fc4ac1330e22d7f865703261f250aee280457731d779"
    sha256 cellar: :any_skip_relocation, ventura:       "f29d62c7304593012cf4fc4ac1330e22d7f865703261f250aee280457731d779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21243fa58b924a0c875b1b02d1aa24e1fc138382922688ad395dc660be27cfa7"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
