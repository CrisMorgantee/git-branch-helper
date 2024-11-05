class Gkb < Formula
  desc "Git branch management utility"
  homepage "https://github.com/crismorgantee/git-branch-helper"
  url "https://github.com/crismorgantee/git-branch-helper/archive/v1.0.tar.gz"
  sha256 "PUT_THE_ACTUAL_SHA256_HASH_HERE"
  license "MIT"

  def install
    bin.install "bin/gkb"
    etc.install "config/gkb.conf" => "gkb/gkb.conf"
    man1.install "man/gkb.1"
    prefix.install "aliases/git-aliases.sh"
  end

  def caveats
    <<~EOS
      The default configuration file has been installed to:
        #{etc}/gkb/gkb.conf

      To customize gkb, you can create a user-specific configuration file at:
        $HOME/.gkb_config

      To use the included Git aliases, add the following line to your shell configuration:
        source #{opt_prefix}/git-aliases.sh
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/gkb -h")
  end
end