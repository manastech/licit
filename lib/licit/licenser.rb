class Licit::Licenser

  attr_reader :license
  attr_reader :dir

  def initialize(dir = '.', license = 'GPLv3')
    @dir = dir
    @license = license
  end

  def check_files
    result = []
    files.each do |file|
      target = File.join @dir, file
      if not File.exists?(target)
        result << [:error, file, "Missing file #{file}"]
      end
    end

    result
  end

  def fix_files
    files.each do |file|
      target = File.join @dir, file
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

  def files_dir
    File.expand_path "../../../templates/#{@license}/files", __FILE__
  end

  def path_for(file)
    File.join files_dir, file
  end


end