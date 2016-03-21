def prompt(message)
  puts("=> #{message}")
end

prompt("Welcome to the Mortgage Calculator.")

loop do
  prompt("Please enter the amount of your loan:")

  loan = ''
  loop do
    loan = gets.chomp
    break unless loan.empty? || loan.to_f <= 0
    prompt("That is not a valid amount. Please omit dollar signs, commas, etc.")
  end

  prompt("Please enter your APR.")
  prompt("For example, if your rate is 3.5%, please enter 3.5")

  apr = ''
  loop do
    apr = gets.chomp
    break unless apr.empty? || apr.to_f <= 0
    prompt("That is not a valid rate. Must enter a positive number.")
  end

  annual_rate = apr.to_f / 100
  monthly_rate = annual_rate / 12

  prompt("Finally, enter the duration of your loan. How many years remain?")

  years = ''
  loop do
    years = gets.chomp
    break unless years.empty? || years.to_i < 0
    prompt("Please enter a valid number.")
  end

  prompt("and how many months?")

  remainder_months = ''
  loop do
    remainder_months = gets.chomp
    break unless remainder_months.empty? || remainder_months.to_i < 0
    prompt("Please enter a valid number.")
  end

  total_months = (years.to_i * 12) + remainder_months.to_i

  monthly_payment = (loan.to_f * (monthly_rate * (1 + monthly_rate)**total_months)) / (((1 + monthly_rate)**total_months) - 1)
  monthly_payment = monthly_payment.round(2)

  output = <<-MSG
  Your loan of $#{loan} borrowed at a #{apr}% APR and repayed
  over #{years} years and #{remainder_months} months will cost you:
  ----------------------------
  $#{monthly_payment} a month.
  ----------------------------
  Thank you for using our Mortgage Calculator.
  Would you like to calculate payment for another loan? (hit 'Y' for yes)
  MSG

  print output

  answer = gets.chomp

  break unless answer.downcase.start_with?('y')
end

prompt("Good luck paying off your loan, chump!")
