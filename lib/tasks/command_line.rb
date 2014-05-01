class CommandLine
  def self.backtick(command)
    `CF_COLOR=false; #{command}`
  end

  def self.system(command)
    Kernel.system(command)
  end
end
