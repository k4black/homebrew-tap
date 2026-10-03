class HexCli < Formula
  desc "hex: a thin, deterministic control plane that runs agent CLIs (Claude Code, Codex, Pi, opencode) over a bounded, journaled graph"
  homepage "https://github.com/k4black/hex"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/k4black/hex/releases/download/v0.1.0/hex-cli-aarch64-apple-darwin.tar.xz"
      sha256 "32b16e1d735f9dd14d022a516d39b94e45217e02c93a1cd0f1ce8f7339d3e464"
    end
    if Hardware::CPU.intel?
      url "https://github.com/k4black/hex/releases/download/v0.1.0/hex-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b453aa5eb143d2099f2a3ad1f141ba5881e528bf7660d851b52608d494125ea1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/k4black/hex/releases/download/v0.1.0/hex-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "6dcf07110591c13f037b6f6de536f09f0c7274139de5e074020d6052e8ee9f40"
    end
    if Hardware::CPU.intel?
      url "https://github.com/k4black/hex/releases/download/v0.1.0/hex-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "38a6028d2bf85d59b33c81260310d943bcbe88b47b50697bb89dae41e619ebec"
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
