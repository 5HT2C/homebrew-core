class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/11.8.2/flyway-commandline-11.8.2.tar.gz"
  sha256 "b01677117b6be97e669314cc502da85bdce20b426bafc291738368ab980c8ca5"
  license "Apache-2.0"
  head "https://github.com/flyway/flyway.git", branch: "main"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2ff1db3dee88891fe0e013b62a63c4e8a4029e953099f1aadc4ddab2a15cd070"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    chmod "g+x", "flyway"
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", Language::Java.overridable_java_home_env
  end

  test do
    system bin/"flyway", "-url=jdbc:h2:mem:flywaydb", "validate"
  end
end
