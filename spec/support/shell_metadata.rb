module Support
    module ShellMetadata
        extend ActiveSupport::Concern

        included do

            it 'should be empty' do
                subject_instance.size.must_equal 0
            end

            it 'should add execs' do
                shell = subject_instance
                shell.add(ElectricSheeps::Metadata::Exec.new('exec_id', Object))
                shell.size.must_equal 1
            end
        end

        def subject_instance
            subject.new
        end
    end
end

