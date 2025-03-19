class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "70dab074f1012bd4922ab1550ff2780100174be0c550c9ffcfe54ed6c5b81f76"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b20595947f40b35e985bcc28229bb4771c7bbcb9205de1d171d1dfb174a6ef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b20595947f40b35e985bcc28229bb4771c7bbcb9205de1d171d1dfb174a6ef7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b20595947f40b35e985bcc28229bb4771c7bbcb9205de1d171d1dfb174a6ef7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6379456e0d9262bd6d1354d06d0a6d6b56dee31929374ed10e73e298574f21c"
    sha256 cellar: :any_skip_relocation, ventura:       "d6379456e0d9262bd6d1354d06d0a6d6b56dee31929374ed10e73e298574f21c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22871ac69e35514f99f8dfd1848ceae27c96825a2d9628276fcf9f7a94878d97"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pinact"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinact --version")

    (testpath/"action.yml").write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v3
            - run: npm install && npm test
    YAML

    system bin/"pinact", "run", "action.yml"

    assert_match(%r{.*?actions/checkout@[a-f0-9]{40}}, (testpath/"action.yml").read)
  end
end
