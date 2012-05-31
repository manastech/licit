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