
unless os.windows?
  describe user('root') do
    it { should exist }
  end
end

describe port(8080) do
  it { should be_listening }
end

%w(jenkins ntp).each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe directory('/etc/jenkins_jobs') do
  it { should exist }
end
