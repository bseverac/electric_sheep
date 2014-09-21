require 'spec_helper'
require 'timecop'

describe ElectricSheep::Commands::Database::MongoDBDump do
  include Support::Command

  it{
    defines_options :user, :password
  }

  it 'should have registered as "mongodb_dump"' do
    ElectricSheep::Agents::Register.command("mongodb_dump").must_equal subject
  end

  describe "executing the command" do

    before do
      @project, @logger, @shell = ElectricSheep::Metadata::Project.new, mock, mock
      database = ElectricSheep::Resources::Database.new name: 'MyDatabase'
      @project.start_with! database

      @command = subject.new(@project, @logger, @shell, @metadata = mock)

      @seq = sequence('command')
      @logger.expects(:info).in_sequence(@seq).with "Creating a dump of the \"MyDatabase\" MongoDB database"
    end

    def assert_product
      product = @project.last_product
      product.wont_be_nil
      product.path.must_equal '/tmp/MyDatabase-20140605-040302'
    end

    def expects_directory_resource
      @shell.expects(:directory_resource).
        with(path: '/tmp/MyDatabase-20140605-040302').
        returns(directory('/tmp/MyDatabase-20140605-040302'))
    end

    def assert_command
      expects_directory_resource
      @command.perform
      assert_product
    end

    it 'executes the backup command' do
      @metadata.stubs(:user).returns(nil)
      @metadata.stubs(:password).returns(nil)
      Timecop.travel Time.utc(2014, 6, 5, 4, 3, 2) do
        @shell.expects(:exec).in_sequence(@seq).
          with("mongodump -d \"MyDatabase\" "+
               "-o \"/tmp/MyDatabase-20140605-040302\" &> /dev/null"
          )
        assert_command
      end
    end

    it 'appends credentials to the command' do
      @metadata.stubs(:user).returns('operator')
      @metadata.stubs(:password).returns('secret')
      Timecop.travel Time.utc(2014, 6, 5, 4, 3, 2) do
        @shell.expects(:exec).in_sequence(@seq).
          with regexp_matches(/-u "operator" -p "secret"/)
        assert_command
      end
    end

  end
end
