class UsersImport
  include Resque::Plugins::Status

  PARAM_INPUT_FILE = "import_file"
  
  def perform
    begin
      puts "Starting import..."
      
      user = User.find(options["current_user_id"])
        
      importJob = UserImportJob.new(options[PARAM_INPUT_FILE])
      importJob.job = self
      importJob.perform_import
      logFile = File.open(importJob.write_output_to_file)
      
      if user.update(:csv_file_attributes => { :assets => logFile })
        begin
          File.unlink(logFile)
          puts "Removed temp file"
        rescue Exception => e
          puts "Couldn't remove log file."
        end
      else
        puts "Update failed, messages:"
        puts user.errors.messages.to_s
      end
      puts "Import finished"
    rescue Exception => e
      puts "Import Failed:"
      puts e.message  
      puts e.backtrace.inspect
      raise e
    end  
  end
end