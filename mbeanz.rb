class Mbeanz < Formula
  desc "A tool for fuzzy finding and invoking mbean operations."
  homepage "https://github.com/ojung/mbeanz"
  url "https://github.com/ojung/mbeanz/releases/download/v1.1.2/mbeanz-1.1.2.tar.xz"
  version "1.1.2"
  sha256 "3f75d26da0a05c68f0ad4c46531abaa49d4d899006fcad03ef373e99cb9a7376"

  depends_on :python

  depends_on "fzf"

  depends_on "requests" => :python

  def install
    if (not File.exists?("#{etc}/mbeanz.edn")) then
      conf = <<-EOS.undent
      {:local {:object-pattern "java.lang:*"
               :jmx-remote-host "localhost"
               :jmx-remote-port 11080}}
      EOS

      open("#{etc}/mbeanz.edn", "w") { |file| file.write(conf) }
    end

    bin.install Dir["./*"]
  end

  def caveats
    <<-EOS.undent

      You will need to update the config file `#{etc}/mbeanz.edn` to make the mbeanz api aware of your jvm.
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
                  <string>#{bin}/mbeanz-1.1.1-SNAPSHOT-standalone.jar</string>
                  <string>#{etc}/mbeanz.edn</string>
              </array>
              <key>KeepAlive</key>
              <true/>
          </dict>
      </plist>
    EOS
  end
end
