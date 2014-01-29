require 'statemachine'

class TurnStileContext
  def alarm
    puts "You can't pass without a coin!"
  end

  def reset_alarm
    puts "Resetting alarm"
  end

  def unlock
    puts "Unlocking"
  end

  def lock
    puts "Locking"
  end

  def test_pass
    puts "Testing passing"
  end

  def thank_you
    "Thanks for the extra money, friend"
  end


end

turnstile = Statemachine.build do
  superstate :normal do
    state :locked do
      event :coin, :unlocked, :unlock
      event :pass, :violation, :alarm
    end
    state :unlocked do
      event :coin, :unlocked, :thanks
      event :pass, :unlocked, :lock
    end
    state :violation do
      event :coin, :violation
      event :pass, :violation
      event :ready, :locked
      event :restart, :violation, :reset_alarm
      on_entry :violation_mode
    end
    event :diagnose, :diagnose_mode, Proc.new { puts "Entering diagnostic mode" }
  end

  superstate :diagnose_mode do
    state :test_coin do
      event :coin, :test_pass, :thank_you
      event :pass, :test_coin, :thank_you_off
    end
  end

  state :diagnose_mode do
    event :test_alarm, :diagnose_mode, :alarm
    event :test_reset_alarm, :diagnose_mode, :reset_alarm
    event :test_unlock, :diagnose_mode, :unlock
    event :test_lock, :diagnose_mode, :lock
    event :test_coin, :coin, :test_pass
    event :test_pass, :pass, :test_coin
  end
  trans :diagnose_mode, :diagnostic_H, Proc.new { puts "Exiting diagnostic mode" }

  on_entry_of :unlocked, Proc.new { puts "Entering unlocked state" }
  on_entry_of :violation, Proc.new { puts "Entering violation state" }

  context TurnStileContext.new
end

puts turnstile.state
turnstile.pass
puts turnstile.state
turnstile.coin
puts turnstile.state
turnstile.pass
puts turnstile.state
turnstile.restart
puts turnstile.state
turnstile.ready
puts turnstile.state
turnstile.diagnose
puts turnstile.state
turnstile.test_alarm
puts turnstile.state
turnstile.test_reset_alarm
puts turnstile.state
turnstile.test_unlock
puts turnstile.state
turnstile.test_lock
puts turnstile.state
turnstile.coin
puts turnstile.state

turnstile.locked
puts turnstile.state
