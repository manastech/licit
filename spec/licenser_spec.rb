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

    context "dir1" do
      let(:licenser) { Licit::Licenser.new(File.expand_path '../dir1', __FILE__) }
      after(:each) { FileUtils.rm_f Dir.glob(File.join(licenser.dir, '*')) }

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