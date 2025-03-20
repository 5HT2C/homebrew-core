class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.46.0.tar.gz"
  sha256 "99998a9fe72a26cc852992a40dc689aeb269bfcd19360549d222a4e066d51162"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84d6189b2bb18b722626d22ece74dcf42e1b3efd2a362ac98b09dd0b521d6dda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84d6189b2bb18b722626d22ece74dcf42e1b3efd2a362ac98b09dd0b521d6dda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84d6189b2bb18b722626d22ece74dcf42e1b3efd2a362ac98b09dd0b521d6dda"
    sha256 cellar: :any_skip_relocation, sonoma:        "76d12eb2dbedc4a146eb7bf3e08731acc5d68ba0dcb84732c0665a457acc8d1c"
    sha256 cellar: :any_skip_relocation, ventura:       "76d12eb2dbedc4a146eb7bf3e08731acc5d68ba0dcb84732c0665a457acc8d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01297649f413294336070bf41a6dc35bf435b1b398a495f6fbd38d41eac30ba3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
