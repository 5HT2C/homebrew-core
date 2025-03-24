class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v1.0.61.tar.gz"
  sha256 "faef1fac90b6479eb992ec9bec01e3dcff4bef164f425d96c4a10953b668868a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9e8aba62e2110a9e432dd7ac211878e88eb8ac6702c298488d1f4558481ff33d"
    sha256 cellar: :any,                 arm64_sonoma:  "afb58a797870ffe10fa64ab02f433fcdee5bee5e884b25428b64d829b1660f1f"
    sha256 cellar: :any,                 arm64_ventura: "218c20ae98f5513925497ae20208c3dc7db109ee1135d88c768f6c0b2e8f2286"
    sha256 cellar: :any,                 ventura:       "2671840549efec1b96e2c2925a00d9f6cd4326be8d1f157ee882d41092e39a87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3aa4f5926a1203f2a60118a7d1271f18214ed663a64862a614d3fd4beea2b9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99420a3aeb83129340b5bab671176be4a7068f9fbde657f3730a0fd8320e7ff2"
  end

  depends_on "valkey" => :test
  depends_on "dotnet"

  on_linux do
    depends_on "cmake" => :build
    depends_on "util-linux" => :build
    depends_on "libaio"
  end

  def install
    if OS.linux?
      cd "libs/storage/Tsavorite/cc" do
        system "cmake", "-S", ".", "-B", "build", *std_cmake_args
        system "cmake", "--build", "build"
        rm "../cs/src/core/Device/runtimes/linux-x64/native/libnative_device.so"
        cp "build/libnative_device.so", "../cs/src/core/Device/runtimes/linux-x64/native/libnative_device.so"
      end
    end

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:EnableSourceLink=false
      -p:EnableSourceControlManagerQueries=false
    ]
    system "dotnet", "publish", "main/GarnetServer/GarnetServer.csproj", *args
    (bin/"GarnetServer").write_env_script libexec/"GarnetServer", DOTNET_ROOT: dotnet.opt_libexec

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    port = free_port
    fork do
      exec bin/"GarnetServer", "--port", port.to_s
    end
    sleep 3

    output = shell_output("#{Formula["valkey"].opt_bin}/valkey-cli -h 127.0.0.1 -p #{port} ping")
    assert_equal "PONG", output.strip
  end
end
