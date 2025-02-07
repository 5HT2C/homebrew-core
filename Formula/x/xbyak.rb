class Xbyak < Formula
  desc "C++ JIT assembler for x86 (IA32), x64 (AMD64, x86-64)"
  homepage "https://github.com/herumi/xbyak"
  url "https://github.com/herumi/xbyak/archive/refs/tags/v7.23.1.tar.gz"
  sha256 "17678579963314463cf51bd0f9070f33dfe47667754d9b6239de1000e67fe259"
  license "BSD-3-Clause"
  head "https://github.com/herumi/xbyak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4d9e5d9e9ece85e9da35bb1333741b0895fb9f49aed162fe23c6349b5447f447"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <xbyak/xbyak_util.h>

      int main() {
        Xbyak::util::Cpu cpu;
        cpu.has(Xbyak::util::Cpu::tSSE42);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-c", "-I#{include}"
  end
end
