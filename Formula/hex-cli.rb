class HexCli < Formula
  desc "hex: a thin, deterministic control plane that runs agent CLIs (Claude Code, Codex, Pi, opencode) over a bounded, journaled graph"
  homepage "https://github.com/k4black/hex"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/k4black/hex/releases/download/v0.1.2/hex-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c31af89cc4299cb9b39168cf53cd6794c6914fa57dd232ef898d23a8fe3f9458"
    end
    if Hardware::CPU.intel?
      url "https://github.com/k4black/hex/releases/download/v0.1.2/hex-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a0fd3a90496d3f1854fec0bcab45d0f0469eb5b2ce5894a9be6646f7641fcbf1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/k4black/hex/releases/download/v0.1.2/hex-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "0623a0860ea253c88628dd1be34e479aa83281d344e888c2fbcc18431f70ef80"
    end
    if Hardware::CPU.intel?
      url "https://github.com/k4black/hex/releases/download/v0.1.2/hex-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "256e3eb70c0435e9896a0396867c7572bb94b4c7913e541c33af682667bf4b4a"
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
