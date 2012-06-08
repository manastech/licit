require 'spec_helper'
require 'licit'

describe Licit::Licenser do

  it "defaults to current directory" do
    subject.dir.should == '.'
  end

  context "GPLv3" do
    it "defaults to GPLv3" do
      subject.license.should == 'GPLv3'
    end

    it "list LICENSE file" do
      subject.files.should == ['LICENSE']
    end

    it "composes header" do
      licenser = Licit::Licenser.new :copyright => 'Copyright Line', :program_name => 'FooBar'
      licenser.copyright.should == 'Copyright Line'
      licenser.program_name.should == 'FooBar'
      licenser.header.should == <<-END
Copyright Line

This file is part of FooBar.

FooBar is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

FooBar is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with FooBar.  If not, see <http://www.gnu.org/licenses/>.
END
    end

    it "caches header" do
      subject.header.should be(subject.header)
    end

    context "dir1" do
      let(:licenser) { Licit::Licenser.new :dir => File.expand_path('../dir1', __FILE__) }
      after(:each) { FileUtils.rm_f Dir.glob(File.join(File.expand_path('../dir1', __FILE__), '*')) }

      it "checks missing files" do
        licenser.check_files.should == [[:error, 'LICENSE', 'Missing file LICENSE']]
      end

      it "fixes missing files" do
        licenser.fix_files
        File.exists?(File.expand_path('../dir1/LICENSE', __FILE__)).should be_true
      end
    end

    context "dir2" do
      let(:licenser) { Licit::Licenser.new :dir => File.expand_path('../dir2.tmp', __FILE__), :copyright => 'Copyright Line', :program_name => 'FooBar' }
      before(:each) { FileUtils.cp_r File.expand_path('../dir2', __FILE__), File.expand_path('../dir2.tmp', __FILE__)}
      after(:each) { FileUtils.rm_rf File.expand_path('../dir2.tmp', __FILE__) }

      it "check headers" do
        licenser.check_headers.should =~ [[:error, 'test.rb', 'Missing header in test.rb'], [:error, 'subdir/test1.rb', 'Missing header in subdir/test1.rb']]
      end

      it "check headers excluding directory" do
        licenser = Licit::Licenser.new :dir => File.expand_path('../dir2.tmp', __FILE__), :copyright => 'Copyright Line', :program_name => 'FooBar', :exclude => ['subdir/']
        licenser.check_headers.should =~ [[:error, 'test.rb', 'Missing header in test.rb']]
      end

      it "fixes headers" do
        file = File.expand_path '../dir2.tmp/subdir/test1.rb', __FILE__
        last_line_before = File.readlines(file).last
        licenser.fix_headers
        licenser.check_file_header(file).should be_true
        last_line_after = File.readlines(file).last
        last_line_after.should == last_line_before
      end
    end

  end

end