require 'erb'

class Licit::Licenser

  def initialize(options = {})
    defaults = { :dir => '.', :license => 'GPLv3', :exclude => [] }
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
    each_source_file do |source_file|
      if not check_file_header(source_file)
        result << [:error, source_file, "Missing header in #{source_file}"]
      end
    end
    result
  end

  def fix_headers
    each_source_file do |source_file|
      if not check_file_header(source_file)
        source_lines = File.readlines source_file



        File.open source_file, 'w' do |f|
          while should_skip? source_lines.first
            f.write source_lines.shift
          end
          header.each_line do |header_line|
            f.write "# #{header_line}"
          end
          f.write "\n"
          source_lines.each do |line|
            f.write line
          end
        end
      end
    end
  end

  def each_source_file
    Dir.chdir(dir) do
      Dir['**/*.rb'].each do |source_file|
        next if should_exclude source_file
        yield source_file
      end
    end
  end

  def check_file_header(file)
    at_beginning = true
    File.open(file, 'r') do |f|
      begin
        header.each_line do |header_line|
          begin
            file_line = f.readline
          end while at_beginning && should_skip?(file_line)
          at_beginning = false

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

  def should_skip? line
    line = line.strip
    return true if line.empty?
    return true if line.start_with? '#!'
    return line =~ /^#\s*(encoding|coding)/
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

  def should_exclude(file)
    @options[:exclude].each do |excluded|
      return true if file.start_with? excluded
    end
    false
  end

  def header
    @header ||= begin
      template = ERB.new File.read(File.join(license_dir, 'header.erb'))
      template.result binding
    end
  end

  def copyright
    @options[:copyright]
  end

  def program_name
    @options[:program_name]
  end

end