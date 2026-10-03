class HexCli < Formula
  desc "hex: a thin, deterministic control plane that runs agent CLIs (Claude Code, Codex, Pi, opencode) over a bounded, journaled graph"
  homepage "https://github.com/k4black/hex"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/k4black/hex/releases/download/v0.1.1/hex-cli-aarch64-apple-darwin.tar.xz"
      sha256 "96f2eb12978cccef1636d56a79bbee0e65be676961b4e58c8e0f298d2e60132c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/k4black/hex/releases/download/v0.1.1/hex-cli-x86_64-apple-darwin.tar.xz"
      sha256 "3b49949310c899b995fc811d790f78680786d2dc91cbacffd4ca479db1cfc9e2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/k4black/hex/releases/download/v0.1.1/hex-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "e0c4031d0f0b45323533cb62681437c4490234385f37ce25d6751fad9c243df3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/k4black/hex/releases/download/v0.1.1/hex-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "976e34820fd967787fa131716f574b03d15f4825b340ad7d5dea3a48a46f06df"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "hex"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "hex"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "hex"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "hex"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
