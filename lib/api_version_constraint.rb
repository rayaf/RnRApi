class ApiVersionConstraint
  def initialize(options)
    @version = options[:version]
    @defaults = options[:defaults]
  end

  def matches?(req)
    @defaults || req.headers['Accept'].include?("application/vnd.taskmanager.v#{@version}")
  end
end