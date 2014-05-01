require_relative './command_line'
require_relative './route'

class CloudFoundry
  def self.push(app)
    puts "self.push"
    CommandLine.system("cf push #{app}")
  end
  def self.routes
    puts "self.routes"
    routes = []
    lines = CommandLine.backtick("cf routes").lines
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
    routes
  end

  def self.unmap_route(app, domain, host)
    puts "self.unmap_route(app, domain, host)"
    CommandLine.system("cf unmap-route #{app} #{domain} -n #{host}")
  end

  def self.map_route(app, domain, host)
    puts "self.map_route(app, domain, host)"
    CommandLine.system("cf map-route #{app} #{domain} -n #{host}")
  end
end
