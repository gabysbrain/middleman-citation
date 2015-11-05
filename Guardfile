
guard 'rspec' do
  # watch /lib/ files
  watch(%r{^lib/(.+).rb$}) do |m|
    system %{rake spec}
  end

  # watch /spec/ files
  watch(%r{^spec/(.+).rb$}) do |m|
    system %{rake spec}
  end
end
