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
      licenser = Licit::Licenser.new copyright: 'Copyright Line', program_name: 'FooBar'
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

    context "dir1" do
      let(:licenser) { Licit::Licenser.new dir: File.expand_path('../dir1', __FILE__) }
      after(:each) { FileUtils.rm_f Dir.glob(File.join(File.expand_path('../dir1', __FILE__), '*')) }

      it "checks missing files" do
        licenser.check_files.should == [[:error, 'LICENSE', 'Missing file LICENSE']]
      end

      it "fixes missing files" do
        licenser.fix_files
        File.exists?(File.expand_path('../dir1/LICENSE', __FILE__)).should be_true
      end
    end

  end

end