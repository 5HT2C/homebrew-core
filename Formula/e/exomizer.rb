class Exomizer < Formula
  desc "File compressor optimized for decompression in 8-bit environments"
  homepage "https://bitbucket.org/magli143/exomizer/wiki/Home"
  url "https://bitbucket.org/magli143/exomizer/wiki/downloads/exomizer-3.1.2.zip"
  sha256 "8896285e48e89e29ba962bc37d8f4dcd506a95753ed9b8ebf60e43893c36ce3a"
  license all_of: [
    "Zlib",
    "GPL-3.0-or-later" => { with: "Bison-exception-2.2" },
  ]

  livecheck do
    url "https://bitbucket.org/magli143/exomizer/wiki/browse/downloads/"
    regex(/href=.*?exomizer[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  def install
    cd "src" do
      system "make"
      bin.install %w[exobasic exomizer]
    end
  end

  test do
    (testpath/"test.txt").write("Hello World! Hello World! Hello World! Hello World!\n")
    system bin/"exomizer", "raw", "test.txt", "-o", "compressed.exo"
    system bin/"exomizer", "raw", "-d", "compressed.exo", "-o", "expanded.txt"
    assert_match "iHelo", File.binread("compressed.exo")
    assert_match File.read("test.txt"), File.read("expanded.txt")
  end
end
