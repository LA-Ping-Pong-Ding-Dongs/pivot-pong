require_relative './command_line'
require_relative './route'

class CloudFoundryCliError < StandardError; end

class CloudFoundry
  DEBUG = false

  def self.push(app)
    puts "self.push" if DEBUG
    cmd = "cf push #{app}"
    success = CommandLine.system(cmd)
    handle_success_or_failure(cmd, success)
  end

  def self.routes
    routes = []
    cmd = "cf routes"
    output = CommandLine.backtick(cmd)
    success = !output.include?('FAILED')
    if success
      lines = output.lines
      found_header = false
      lines.each do |line|
        line = line.split
        if line[0] == 'host'
          found_header = true
          next
        end

        if found_header
          routes << Route.new(line[0], line[1], line[2])
        end
      end
      puts routes.inspect if DEBUG
      routes
    else
      raise CloudFoundryCliError.new("\"#{cmd}\" returned \"#{success}\".  The output of the command was \n\"#{output}\".")
    end
  end

  def self.unmap_route(app, domain, host)
    puts "self.unmap_route(app, domain, host)" if DEBUG
    cmd = "cf unmap-route #{app} #{domain} -n #{host}"
    success = CommandLine.system(cmd)
    handle_success_or_failure(cmd, success)
  end

  def self.map_route(app, domain, host)
    puts "self.map_route(app, domain, host)" if DEBUG
    cmd = "cf map-route #{app} #{domain} -n #{host}"
    success = CommandLine.system(cmd)
    handle_success_or_failure(cmd, success)
  end

  private

  def self.handle_success_or_failure(cmd, success)
    if success
      return success
    else
      raise CloudFoundryCliError.new("\"#{cmd}\" returned \"#{success}\".  Look for details in \"FAILED\" above.")
    end
  end
end
