class XmlSecurityC < Formula
  desc "Implementation of primary security standards for XML"
  homepage "https://santuario.apache.org/"
  url "https://shibboleth.net/downloads/xml-security-c/3.0.0/xml-security-c-3.0.0.tar.bz2"
  sha256 "a4c9e1ae3ed3e8dab5d82f4dbdb8414bcbd0199a562ad66cd7c0cd750804ff32"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/xml-security-c/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ef901d1dd62aede4b0a35b64342b969c1895b519dbe5c41dd2b1a5f82d8c7dc"
    sha256 cellar: :any,                 arm64_sonoma:  "eb8d5c236aae4140590391f48ac857513958496d3e3d6e593201ef72cc321e40"
    sha256 cellar: :any,                 arm64_ventura: "ce3ae37e20ef8933d995af0447d498c1fa0f244298694e589b998467323851c2"
    sha256 cellar: :any,                 sonoma:        "9e8f17a36572dcf16e4da2ecc143a77b58647a5c15e4d7a67bd23bb1261907ed"
    sha256 cellar: :any,                 ventura:       "516a9bcaa920f654420dd343fab87694cf5902a15d17ec5cfa949c007e01b416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "027db5710abf606d13b530d94cbfd9c9b0f6b619080dd2aff53fcec7a965ed9d"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "xerces-c"

  # Apply Debian patch to avoid segfault in test
  patch do
    url "https://sources.debian.org/data/main/x/xml-security-c/3.0.0-2/debian/patches/Provide-the-Xerces-URI-Resolver-for-the-tests.patch"
    sha256 "585938480165026990e874fecfae42601dde368f345f1e6ee54b189dbcd01734"
  end

  def install
    system "./configure", "--with-openssl=#{Formula["openssl@3"].opt_prefix}", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "All tests passed", pipe_output("#{bin}/xsec-xtest 2>&1")
  end
end
