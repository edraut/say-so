require 'pubnub'
require 'awesome_print'

class String
  def black;          "\033[30m#{self}\033[0m" end
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end
  def brown;         "\033[33m#{self}\033[0m" end
  def blue;           "\033[34m#{self}\033[0m" end
  def magenta;        "\033[35m#{self}\033[0m" end
  def cyan;           "\033[36m#{self}\033[0m" end
  def gray;           "\033[37m#{self}\033[0m" end
  def bg_black;       "\033[40m#{self}\0330m"  end
  def bg_red;         "\033[41m#{self}\033[0m" end
  def bg_green;       "\033[42m#{self}\033[0m" end
  def bg_brown;       "\033[43m#{self}\033[0m" end
  def bg_blue;        "\033[44m#{self}\033[0m" end
  def bg_magenta;     "\033[45m#{self}\033[0m" end
  def bg_cyan;        "\033[46m#{self}\033[0m" end
  def bg_gray;        "\033[47m#{self}\033[0m" end
  def bold;           "\033[1m#{self}\033[22m" end
  def reverse_color;  "\033[7m#{self}\033[27m" end
end

class DemoConsole

  OPTIONS = {
      :'1'  => :Publish,
      :'2'  => :Subscribe,
      :'3'  => :Presence,
      :'4'  => :Leave,
      :'5'  => :History,
      :'6'  => :HereNow,
      :'7'  => :WhereNow,
      :'8'  => :State,
      :'9'  => :Heartbeat,
      :'10' => :Time,
      :'11' => :Audit,
      :'12' => :Grant,
      :'13' => :Revoke,
      :A    => :set_uuid,
      :B    => :set_auth_key,
      :C    => :show_state,
      :D    => :set_state,
      :EXIT => :exit
  }

  def initialize

    welcome
    
    keys_option = select_keys

    case keys_option.to_s
    when '1'
      @origin        = 'pubsub.pubnub.com'
      @subscribe_key = 'demo-36'
      @publish_key   = 'demo-36'
      @secret_key    = nil

    when '2'
      @origin        = 'pubsub.pubnub.com'
      @subscribe_key = 'sub-c-a478dd2a-c33d-11e2-883f-02ee2ddab7fe'
      @publish_key   = 'pub-c-a2650a22-deb1-44f5-aa87-1517049411d5'
      @secret_key    = 'sec-c-YjFmNzYzMGMtYmI3NC00NzJkLTlkYzYtY2MwMzI4YTJhNDVh'

    when '3'
      puts `clear`
      print_pubnub
      puts 'Okey, now you have to provide me your data or accept default:'.green
      print 'origin [pubsub.pubnub.com]: '.white
      @origin = gets.chomp!
      print 'subscribe_key [demo-36]: '.white
      @subscribe_key = gets.chomp!
      print 'publish_key [demo-36]: '.white
      @publish_key = gets.chomp!
      print 'secret_key (nil by default): '.white
      @secret_key = gets.chomp!

      @origin        = 'pubsub.pubnub.com' if @origin.blank?
      @subscribe_key = 'demo-36'           if @subscribe_key.blank?
      @publish_key   = 'demo-36'           if @publish_key.blank?
      @secret_key    = nil                 if @secret_key.blank?
    else
      @origin        = 'pubsub.pubnub.com'
      @subscribe_key = 'demo-36'
      @publish_key   = 'demo-36'
      @secret_key    = nil
    end

    set_uuid_and_auth

    @pubnub = Pubnub.new(
      :subscribe_key  => @subscribe_key,
      :publish_key    => @publish_key,
      :secret_key     => @secret_key,
      :error_callback => method(:error_callback),
      :auth_key       => @auth_key
    )

    @pubnub.set_uuid(@uuid) unless @uuid.blank?

    ap @pubnub

    start_console

  end

  def welcome
    puts `clear`
    print_pubnub
    puts 'Hello in interactive PubNub console!'.white
    puts 'Feel free to play around with it!'.white
    puts '--'
    puts '[Hit ENTER to continue]'
    gets
    puts `clear`
  end

  def select_keys
    print_pubnub
    puts 'Before we start, you have to select demo app keys or add your own.'.green
    print "\n"
    puts '1. Basic demo keys  -- You will be limited to standard events, no PAM features'.white
    puts '2. PAM supprot keys -- You can check out all pubnub features, including PAM'.white
    puts '3. Custom keys      -- If you already have your own keys, you can set them here'.white
    print "\n"
    print 'Your choice: '.green
    gets.chomp!
  end

  def set_uuid_and_auth
    puts `clear`
    print_pubnub
    puts 'You can set up now your uuid and auth_key: '.green
    print 'uuid [random_default]: '.white
    @uuid = gets.chomp!
    print 'auth_key (blank by default): '.white
    @auth_key = gets.chomp
  end

  def set_uuid(uuid)
    @pubnub.set_uuid(uuid)
  end

  def set_auth_key(auth_key)
    @pubnub.set_auth_key(auth_key)
  end

  def start_console
    puts `clear`
    print_pubnub
    puts 'CONSOLE STARTED!'.white.bg_green
    exit = false
    choice = false
    until exit
      until OPTIONS.keys.include?(choice)
        puts 'Choose your next operation (type \'exit\' to exit):'.green
        puts 'Events:'.green
        puts '1.  Publish'.white
        puts '2.  Subscribe'.white
        puts '3.  Presence'.white
        puts '4.  Leave (unsubscribe)'.white
        puts '5.  History'.white
        puts '6.  HereNow'.white
        puts '7.  WhereNow'.white
        puts '8.  State'.white
        puts '9.  Heartbeat'.white
        puts '10. Time'.white
        puts '11. Audit'.white  if @secret_key
        puts '12. Grant'.white  if @secret_key
        puts '13. Revoke'.white if @secret_key
        puts "\nPubnub::Client interaction:".green
        puts 'A. Set UUID'.white
        puts 'B. Set auth_key'.white
        puts 'C. Check state'.white
        puts 'D. Set state'.white
        print "\nYour choice: ".red
        choice = gets.chomp!.to_s.upcase.to_sym
      end
      choice = OPTIONS[choice]

      case choice
      when :exit
        exit = true      
      when :Publish
        options = ask_about(:sync, :message, :channel)
        @pubnub.publish(options)
      when :Subscribe
        options = ask_about(:sync, :channel)
        @pubnub.subscribe(options)
      when :Presence
        options = ask_about(:sync, :channel)
        @pubnub.presence(options)
      when :Leave
        options = ask_about(:sync, :channel)
        @pubnub.leave(options)
      when :History
        options = ask_about(:sync, :channel, :reverse, :history_start, :history_end)
        @pubnub.history(options)
      when :HereNow
        options = ask_about(:sync, :channel)
        @pubnub.here_now(options)
      when :WhereNow
        options = ask_about(:sync, :uuid)
        @pubnub.where_now(options)
      when :State
        options = ask_about(:sync, :channel, :uuid)
        @pubnub.state(options)
      when :Heartbeat
        options = ask_about(:sync, :heartbeat)
        @pubnub.heartbeat(options)
      when :Time
        options = ask_about(:sync)
        @pubnub.time(options)
      when :Audit
        options = ask_about(:sync, :channel, :subscribe_key)
        @pubnub.audit(options)
      when :Grant
        options = ask_about(:sync, :channel, :subscribe_key, :read, :write)
        @pubnub.grant(options)
      when :Revoke
        options = ask_about(:sync, :channel, :subscribe_key, :read, :write)
        @pubnub.revoke(options)
      end
      choice = nil
    end
  end

  # that adds callback method as :callback in options
  def ask_about(*things)
    options = {}
    things.each do |thing|
      case thing
      when :sync
        print 'Should event be async? '.white
        options[:http_sync] = !acceptance

      when :message
        while options[:message].blank?
          puts 'Write below message to publish:'.white
          options[:message] = gets.chomp!
        end

      when :channel
        while options[:channel].blank?
          print 'Specify channel(s): '.white
          options[:channel] = gets.chomp!
        end
      end
    end
    options.merge({:callback => method(:callback)})
  end

  def acceptance
    %w(Y 1).include?(gets.chomp!.to_s.upcase)
  end

  def print_pubnub
    puts '
    __________     ___.     _______       ___.       ________       ________
    \______   \__ _\_ |__   \      \  __ _\_ |__     \_____  \     /  _____/
     |     ___/  |  \ __ \  /   |   \|  |  \ __ \      _(__  <    /   __  \ 
     |    |   |  |  / \_\ \/    |    \  |  / \_\ \    /       \   \  |__\  \
     |____|   |____/|___  /\____|__  /____/|___  /   /______  / /\ \_____  /
                        \/         \/          \/           \/  \/       \/ 

                                                   Pubnub 3.6.x Demo Console
    '.red
  end

  def callback(envelope)
    ap envelope
  end

  def connect_callback(data)
    puts 'Connection established'.bg_green.white
  end

  def error_callback(error)
    puts 'ERROR'.bg_red.white
    ap error
  end
end

DemoConsole.new