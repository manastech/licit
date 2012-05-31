require 'erb'

class Licit::Licenser

  def initialize(options = {})
    defaults = { dir: '.', license: 'GPLv3' }
    @options = defaults.merge options
  end

  def dir
    @options[:dir]
  end

  def license
    @options[:license]
  end

  def check_files
    result = []
    files.each do |file|
      target = File.join dir, file
      if not File.exists?(target)
        result << [:error, file, "Missing file #{file}"]
      end
    end

    result
  end

  def fix_files
    files.each do |file|
      target = File.join dir, file
      if not File.exists?(target)
        FileUtils.cp path_for(file), target
      end
    end
  end

  def check_headers
    result = []
    Dir.chdir(dir) do
      Dir['**/*.rb'].each do |source_file|
        if not check_file_header(source_file)
          result << [:error, source_file, "Missing header in #{source_file}"]
        end
      end
    end
    result
  end

  def fix_headers
    Dir.chdir(dir) do
      Dir['**/*.rb'].each do |source_file|
        if not check_file_header(source_file)
          source = File.read source_file
          File.open source_file, 'w' do |f|
            header.each_line do |header_line|
              f.write "# #{header_line}"
            end
            f.write "\n"
            f.write source
          end
        end
      end
    end
  end

  def check_file_header(file)
    File.open(file, 'r') do |f|
      begin
        header.each_line do |header_line|
          file_line = f.readline
          return false unless file_line.start_with? '#'
          file_line = file_line[1..-1].strip
          return false if file_line != header_line.chomp
        end
      rescue EOFError
        return false
      end
    end
    true
  end

  def files
    Dir.chdir(files_dir) do
      return Dir['**']
    end
  end

  def license_dir
    File.expand_path "../../../templates/#{license}", __FILE__
  end

  def files_dir
    File.join license_dir, 'files'
  end

  def path_for(file)
    File.join files_dir, file
  end

  def header
    template = ERB.new File.read(File.join(license_dir, 'header.erb'))
    template.result binding
  end

  def copyright
    @options[:copyright]
  end

  def program_name
    @options[:program_name]
  end

end