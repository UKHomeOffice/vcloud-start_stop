require "fog"

module Vcloud
  module StartStop
    class Run
      def initialize(user, pass, host, org, vdc, status, opts = {})
        @org    = org
        @status = status.downcase
        @vdc    = vdc
        @vapps  = opts[:vapps] ? opts[:vapps] : false
        @power_vdc = opts[:power_vdc] ? opts[:power_vdc] : false
        @vcloud = Fog::Compute::VcloudDirector.new(:vcloud_director_username => user,
                                                   :vcloud_director_password => pass,
                                                   :vcloud_director_host     => host)
      end

      def run
        org = @vcloud.organizations.get_by_name(@org)
        raise "No such organization: #{@org}" if org.nil?
        
        vdc = org.vdcs.get_by_name(@vdc)
        raise "No such VDC: #{@vdc}" if vdc.nil?
        
        @vapps.each { |vapp_sd| vdc.vapps.get_by_name(vapp_sd).power_off } if @vapps and @status.match('stop')
        @vapps.each { |vapp_sd| vdc.vapps.get_by_name(vapp_sd).power_on } if @vapps and @status.match('start')
        
        vdc.vapps.each { |vapp| vapp.power_off } if @power_vdc and @status.match('stop')
        vdc.vapps_each { |vapp| vapp.power_on } if @power_vdc and not @status.match('start')
      end
    end 
  end
end
