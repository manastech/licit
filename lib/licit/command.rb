
class Licit::Command

  def run
    licenser = Licit::Licenser.new load_config
    if ARGV[0] == 'fix'
      fix licenser
    else
      check licenser
    end
  end

  def check(licenser)
    has_errors = false
    (licenser.check_files | licenser.check_headers).each do |severity, file, message|
      puts message
      has_errors = true if severity == :error
    end
    exit (has_errors ? 1 : 0)
  end

  def fix(licenser)
    licenser.fix_files
    licenser.fix_headers
  end

  def load_config
    config_file = find_file ['licit.yml', 'config/licit.yml']
    unless config_file
      puts "Could not find licit.yml config file"
      exit 1
    end

    config = {}
    YAML.load_file(config_file).each do |key, value|
      config[key.to_sym] = value
    end
    config
  end

  def find_file probes
    probes.each do |file|
      return file if File.exist? file
    end
    nil
  end

end
