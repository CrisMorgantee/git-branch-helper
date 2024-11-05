class Gkb < Formula
  desc "Git branch management utility"
  homepage "https://github.com/crismorgantee/git-branch-helper"
  url "https://github.com/crismorgantee/git-branch-helper/archive/v0.1.tar.gz"
  sha256 "e9f0c448ca1f64c5ed78db91637fba9bc760fa501a3db54d4c8d5ee773c08d50"
  license "MIT"

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