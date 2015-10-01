class Mbeanz < Formula
  desc "A tool for fuzzy finding and invoking mbean operations."
  homepage "https://github.com/ojung/mbeanz"
  url "https://github.com/ojung/mbeanz/releases/download/v1.0.0-beta/mbeanz-1.0.0-beta.tar.xz"
  version "1.0.0-beta"
  sha256 "4be611ae3b78b20c2ddcd10de0dbd94f9bdb65e2e7d3b690e42233f01f0dfa1f"

  depends_on :python if MacOS.version <= :snow_leopard

  depends_on "fzf"
  depends_on "requests" => :python

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    conf = <<-EOS.undent
      {:local {:object-pattern "java.lang:*"
               :jmx-remote-host "localhost"
               :jmx-remote-port 11080}}
    EOS

    open("#{etc}/mbeanz.edn", "w") { |file| file.write(conf) }

    bin.install Dir["./*"]
  end

  def caveats
    <<-EOS.undent

      You'll need to update the config file `#{etc}/mbeanz.edn` to make the mbeanz api aware of your jvm.
    EOS
  end

  def plist
    <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
          <dict>
              <key>Label</key>
              <string>mbeanz</string>
              <key>ProgramArguments</key>
              <array>
                  <string>java</string>
                  <string>-jar</string>
                  <string>#{bin}/mbeanz-1.0.0-beta-SNAPSHOT-standalone.jar</string>
                  <string>#{etc}/mbeanz.edn</string>
              </array>
              <key>KeepAlive</key>
              <true/>
          </dict>
      </plist>
    EOS
  end
end
