require 'sinatra/activerecord'

def self.connect_to_database_prod
  begin
    config = {
      :adapter  => "mysql2",
      :host     => "#{ENV["DATABASE_SERVICE_HOST"]}",
      :port     => "#{ENV["DATABASE_SERVICE_PORT"]}",
      :database => "#{ENV["MYSQL_DATABASE"]}"
    }
    if ENV.key?("MYSQL_ROOT_PASSWORD")
      config[:password] = "#{ENV["MYSQL_ROOT_PASSWORD"]}"
    else
      config[:username] = "#{ENV["MYSQL_USER"]}"
      config[:password] = "#{ENV["MYSQL_PASSWORD"]}"
    end

    if ENV.key?("RDS_ENDPOINT_ADDRESS")
      config[:host]     = "#{ENV["RDS_ENDPOINT_ADDRESS"]}"
      config[:port]     = "#{ENV["RDS_PORT"]}"
      config[:username] = "#{ENV["RDS_MASTER_USERNAME"]}"
      config[:password] = "#{ENV["RDS_MASTER_USER_PASSWORD"]}"
      config[:database] = "#{ENV["RDS_DB_NAME"]}"
    end

    puts "Connecting to production database (#{config[:username]}@#{config[:host]}:#{config[:port]})..."
    ActiveRecord::Base.establish_connection(config)

    ActiveRecord::Base.connection.active?

  rescue Exception => e
    if not /Can't connect to MySQL server/ =~ e.message
      puts e.message
    end
    return false
  end
end

def self.connect_to_database_test
  begin
    config = {
      :adapter  => "mysql2",
      :host     => "#{ENV["DATABASE_TEST_SERVICE_HOST"]}",
      :port     => "#{ENV["DATABASE_TEST_SERVICE_PORT"]}",
      :database => "#{ENV["MYSQL_DATABASE"]}"
    }
    if ENV.key?("MYSQL_ROOT_PASSWORD")
      config[:password] = ENV["MYSQL_ROOT_PASSWORD"]
    else
      config[:username] = ENV["MYSQL_USER"]
      config[:password] = ENV["MYSQL_PASSWORD"]
    end

    if ENV.key?("RDS_ENDPOINT_ADDRESS")
      config[:host]     = "#{ENV["RDS_ENDPOINT_ADDRESS"]}"
      config[:port]     = "#{ENV["RDS_PORT"]}"
      config[:username] = "#{ENV["RDS_MASTER_USERNAME"]}"
      config[:password] = "#{ENV["RDS_MASTER_USER_PASSWORD"]}"
      config[:database] = "#{ENV["RDS_DB_NAME"]}"
    end


    puts "Connecting to test database (#{config[:username]}@#{config[:host]}:#{config[:port]})..."
    ActiveRecord::Base.establish_connection(config)

    ActiveRecord::Base.connection.active?

  rescue Exception => e
    if not /Can't connect to MySQL server/ =~ e.message
      puts e.message
    end
    return false
  end
end
