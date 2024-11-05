class Gkb < Formula
  desc "Git branch management utility"
  homepage "https://github.com/crismorgantee/git-branch-helper"
  url "https://github.com/crismorgantee/git-branch-helper/archive/v0.2.tar.gz"
  sha256 "d990aea8545f5083e4f74be239c9981782aeec57d4237358a19f0df83eaf412a"
  license "MIT"

   version "0.2"

    def install
      cd "git-branch-helper-#{version}" do
        bin.install "bin/gkb"
        etc.install "config/gkb.conf" => "gkb/gkb.conf"
        man1.install "man/gkb.1"
        prefix.install "aliases/git-aliases.sh"
      end
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