class Gkb < Formula
  desc "Utilitário de gerenciamento de branches Git"
  homepage "https://github.com/crismorgantee/git-branch-helper"
  url "https://github.com/crismorgantee/git-branch-helper/archive/v1.0.tar.gz"
  sha256 "seu_tarball_sha256"

  def install
    bin.install "bin/gkb"
    etc.install "config/gkb.conf"
    man1.install "man/gkb.1"
  end

  def caveats
    <<~EOS
      Configurações padrão instaladas em #{etc}/gkb.conf
      Você pode sobrescrevê-las criando um arquivo ~/.gkb_config.
    EOS
  end
end