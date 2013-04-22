require 'pry'
require 'net/netconf/jnpr'
require 'junos-ez/stdlib'

# list of targets to make the change.  Hardcoding these as array
# but you could load them from a file, etc.

targets = [ 'vsrx', 'ex-10', 'ex-20', 'ex-33' ]

# let's assume that all targets use the same login/password ...

login = { :username => 'jeremy',  :password => 'jeremy1',  }


# -------------------------------------------------------------------
# define a function to do the configuration actions
# -------------------------------------------------------------------

def load_stuff( login )

  ## create a NETCONF object to manage the device and open the connection ...
  ndev = Netconf::SSH.new( login )
  $stdout.print "Connecting to device #{login[:target]} ... "
  ndev.open
  $stdout.puts "OK!"
  
  Junos::Ez::Provider( ndev )
  Junos::Ez::Loader::Utils( ndev, :load )
  
  # lock the candidate config 
  #    ndev.load.lock!
  
  # examples of loading ...
  #    ndev.load.config! :filename => 'load_sample.conf'
  #    ndev.load.config! :content => File.read( 'load_sample.conf' ), :format => :text
  #    ndev.load.config! :filename => 'load_sample.set'
  
  binding.pry
  
  # check to see if the config is OK to commit
  #   ndev.load.commit?  
  
  # perform the commit
  #   ndev.load.commit!
  
  # unlock the config
  #   ndev.load.unlock!
  
  ndev.close
end

### -----------------------------------------------------------------
### run through each of the target names and load configs ..
### -----------------------------------------------------------------

targets.each do |target| 
  login[:target] = target
  load_stuff( login )
end
