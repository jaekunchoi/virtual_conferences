class UserImportJob
  attr_accessor :job
  
  def initialize(importFile)
    @importFile = importFile
  end
  
  def perform_import
    fileStr = @importFile
      
    @processOutput = []
    columnMapping = nil
    
    @savedCount = @newCount = @rowIndex = 0
    
    fileLines = fileStr.lines
    
    lineCount = fileLines.size
    
    fileLines.each do |row|
      if @rowIndex == 0
        #figure out column mapping array
        columnMapping = determine_columns(row)
        if columnMapping == nil
          @processOutput << "Processing halted. Resolve column name issues."
          break
        end
      else
        process_row(row, columnMapping)
      end
      
      @job.at(@rowIndex, lineCount) if @job
      
      @rowIndex += 1
    end

    @rowIndex -= 1
    @processOutput.insert(0, "")
    @processOutput.insert(0, "*Summary:* Records: "+@rowIndex.to_s+
        ", Saved:"+@savedCount.to_s+
        ", New:"+ @newCount.to_s+
        ", Updated: "+(@savedCount-@newCount).to_s+
        ", *Failed: "+(@rowIndex-@savedCount).to_s)
  end

  def write_output_to_file
    tmpDir = Rails.root.to_s+"/tmp"
    Dir.mkdir(tmpDir) unless File.exists?(tmpDir)
    puts "Creating file"+tmpDir+'/user-import-'+Time.now.strftime("%d-%m-%Y-%H%M%S")+'.csv'
    outputFile = File.new(tmpDir+'/user-import-'+Time.now.strftime("%d-%m-%Y-%H%M%S")+'.csv', "w")
    @processOutput.each do |line|
      outputFile.write(line+"\n")
    end
    outputFile.close
    
    return outputFile.path
    
  end

  
  def determine_columns(row)
    columnMapping = []
    user = User.new()
    failedColumns = false

    row.split(/,/).each_with_index do |column_name, index|
      column_name = column_name.strip.downcase
        
      if column_name.blank?
        #ignore
      elsif (column_name =~ /^[a-z]\w+$/).nil?
        write_column_error(column_name, "not a valid column name")
        failedColumns = true
      elsif !eval("user.respond_to? '"+column_name+"'")
        write_column_error(column_name, "not found on user")
        failedColumns = true
      else
        columnMapping[index] = column_name
      end
    end
    
    if columnMapping.index("email").nil?
      write_column_error("email", "'email' address is a required parameter.")
      failedColumns = true
    end
    if columnMapping.index("events").nil?
      write_column_error("events", "'events' column should be included.")
    end
    if failedColumns
      write_column_error("<HeaderRecord>", "Processing halted. Resolve column name issues.")
      return nil
    end
    return columnMapping
  end

  
  def process_row(row, columnMapping)
    rowContentArr = row.split(/,/)
    
    #do some inital checks on the row to see if we can process it
    if rowContentArr.size != columnMapping.size
      write_row_error(@rowIndex, "Ignoring row, column count ("+rowContentArr.size.to_s+") does not match mapping ("+columnMapping.size.to_s+")", row)
      return
    end
    
    email = rowContentArr[columnMapping.index("email")].strip.downcase
    if email.blank?
      write_row_error(@rowIndex, "Ignoring row, email address cannot be empty")
      return
    elsif (email =~ /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$/).nil?
      write_row_error(@rowIndex, "Ignoring row, email address("+email+") must be a valid email address", row)
      return
    end
    
    user = User.where(email: email).first
    
    if (user.nil?)
      password = rowContentArr[columnMapping.index("password")].strip
      if password.blank?
        write_row_error(@rowIndex, "Password must be set when creating a user", row)
        return
      end
      
      user = User.new({email: email, password: password})
      user.roles = Role.where(name: "visitor").first unless columnMapping.index("roles")
      user.confirm!
      @newCount += 1
    end
    
    row.split(/,/).each_with_index do |column_value, index|
      column_value = column_value.strip
      column_name = columnMapping[index]

      next if column_name.blank?
      if column_name == "email" && column_value
        column_value = column_value.downcase
      end
      
      if column_name == "roles"
        if column_value.blank?
          column_value = "visitor"
          write_row_error(@rowIndex, "No roles set, defaulting to visitor")
        end
        
        roles = column_value.split(",").map { |role| Role.where(name: role).first}
        write_row_error(@rowIndex, "Roles may not all exist: '"+column_value+"'") if roles.include?(nil)
        roles.compact!
        column_value = "roles"
      elsif column_name == "events"
        events = column_value.split(",").map { |event| Event.where(name: event).first}
        write_row_error(@rowIndex, "Events may not all exist: '"+column_value+"'") if events.include?(nil)
        events.compact!
        column_value = "events"
      elsif column_value.blank?
        column_value = "nil"
      elsif column_value =~ /^\d$/
        column_value = column_value
      else
        column_value = '"'+column_value+'"'
      end
      
      eval("user."+column_name+" = "+column_value)
    end
    
    user.save(:validate => true)
    @savedCount += 1
  end
  
  def write_row_error(rowIndex, message, row = nil)
    @processOutput << "*Line "+rowIndex.to_s+":* "+message
    @processOutput << "*Line "+rowIndex.to_s+" Row:* "+row if row
  end
    
  def write_column_error(column_name, message)
    @processOutput << "*Column '"+column_name+"':* "+message
  end
end