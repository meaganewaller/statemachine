require 'statemachine'

# Origin State   Event    Destination State
# Locked         Coin     Unlocked
# Unlocked       Pass     Locked

turnstile = Statemachine.build do
  trans :locked, :coin, :unlocked
  trans :unlocked, :pass, :locked
end


puts turnstile.state
turnstile.coin
puts turnstile.state
turnstile.pass
puts turnstile.state
