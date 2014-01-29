require 'statemachine'
class TurnStileContext

  def unlock
    puts "Unlocking"
  end

  def lock
    puts "Locking"
  end

  def alarm
    puts "You can't pass without a coin!"
  end

  def thanks
    puts "Thanks for the extra money, friend"
  end

  def violation_mode
    puts "Violation Mode"
  end

  def reset_alarm
    puts "Resetting alarm"
  end
  

end

turnstile = Statemachine.build do
  state :locked do
    event :coin, :unlocked, :unlock
    event :pass, :violation, :alarm
  end
  state :unlocked do
    event :coin, :unlocked, :thanks
    event :pass, :locked, :lock
  end
  state :violation do
    event :coin, :violation
    event :pass, :violation
    event :ready, :locked
    event :restart, :violation, :reset_alarm
    on_entry :violation_mode
  end
  context TurnStileContext.new
end


# Getting into Violation Mode
turnstile.pass # pass without paying -- violation
puts turnstile.state
turnstile.pass # pass while in violation -- violation 
puts turnstile.state
turnstile.coin # coin while in violation -- violation
puts turnstile.state
turnstile.restart # resets alarm still in violation
puts turnstile.state
turnstile.ready # get out of violation mode
puts turnstile.state # in locked mode now
turnstile.coin # get out of locked mode by inserting a coin
puts turnstile.state
turnstile.coin # insert another coin while unlocked, get a thank you, still in unlock mode
puts turnstile.state
turnstile.pass # pass through to get back into lock mode
puts turnstile.state
