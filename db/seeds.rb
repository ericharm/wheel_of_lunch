default_options = [
  "Chickfilet",
  "Sophie's",
  "Yoga Mats"
]

default_options.each do |name|
  Option.create(name: name, default_on: true)
end
