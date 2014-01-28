require 'statemachine'
vending_machine = Statemachine.build do
  superstate :operational do
    trans :waiting, :dollar, :paid
    trans :paid, :selection, :waiting
    trans :waiting, :selection, :waiting
    trans :paid, :dollar, :paid

    event :repair, :repair_mode, Proc.new { puts "Entering Repair Mode" }
  end

  trans :repair_mode, :operate, :operational_H, Proc.new { puts "Exiting Repair Mode" }

  on_entry_of :waiting, Proc.new { puts "Entering Waiting State" }
  on_entry_of :paid, Proc.new { puts "Entering Paid State" }
end

vending_machine.repair
vending_machine.operate
vending_machine.dollar
vending_machine.repair
vending_machine.operate



