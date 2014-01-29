require 'statemachine'
class TurnStileContext
  def unlock
    puts "Unlocking..."
  end

  def locked_mode
    puts "The turnstile is locked"
  end

  def operation_mode
    puts "Walk through the turnstile"
  end

  def lock
    puts "The turnstile is locking"
  end

  def alarm
    puts "You can't pass without a coin!"
  end

  def thanks
    puts "Thanks for the extra money, friend"
  end
end

turnstile = Statemachine.build do
  state :locked do
    event :coin, :unlocked, :unlock
    event :pass, :locked, :alarm
    on_entry :locked_mode
    on_exit :operation_mode
  end
  trans :unlocked, :pass, :locked, :lock
  trans :unlocked, :coin, :unlocked, :thanks
  context TurnStileContext.new
end

turnstile.pass
turnstile.coin
turnstile.coin
turnstile.pass

