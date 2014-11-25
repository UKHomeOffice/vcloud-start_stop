require "vcloud/start_stop/version"
require "vcloud/start_stop/exception"

require 'fog'

module Vcloud
  module StartStop
    class StartStop

      def initialize(user, pass, host, org, status, vdc, opts = {})
        @org    = org
        @status = status.downcase
        @vapps  = vapps
        @vdc    = vdc
        @vapps  = opts[:vapps] ? opts[:vapps] : false
        @power_vdc = opts[:power_vdc] ? opts[:power_vdc] : false
        @vcloud = Fog::Compute::VcloudDirector.new(:vcloud_director_username => user,
                                                   :vcloud_director_password => pass,
                                                   :vcloud_director_host     => host)
      end

      def run
        org = @vcloud.organizations.get_by_name(@org)
        vdc = org.vdcz.get_by_name(@vdc)
       
        vapps.each { |vapp_sd| vdc.vapps.get_by_name(vapp_sd).power_off } if @vapps and @status.match('stop')
        vapps.each { |vapp_sd| vdc.vapps.get_by_name(vapp_sd).power_on } if @vapps and @status.match('start')
        
        vdc.power_off if @power_vdc and @status.match('stop')
        vdc_power_on if @power_vdc and not @status.match('start')
      end
    
    end
  end
end
