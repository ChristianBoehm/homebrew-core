class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-8.3.2.tgz"
  sha256 "7f51c4c50d05498ff27c3a5724bbf6c0e8a90b094aa339eca8899fce771864e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "636d12e92baff071ff6b638ef473a5ab05e141a8efa7af4b73a165382edcd2b5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Make the bottles uniform
    inreplace_file = libexec/"lib/node_modules/zx/node_modules/@types/node/process.d.ts"
    inreplace inreplace_file, "/usr/local/bin", "#{HOMEBREW_PREFIX}/bin"
  end

  test do
    (testpath/"test.mjs").write <<~JAVASCRIPT
      #!/usr/bin/env zx

      let name = YAML.parse('foo: bar').foo
      console.log(`name is ${name}`)
      await $`touch ${name}`
    JAVASCRIPT

    output = shell_output("#{bin}/zx #{testpath}/test.mjs")
    assert_match "name is bar", output
    assert_path_exists testpath/"bar"

    assert_match version.to_s, shell_output("#{bin}/zx --version")
  end
end
