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
        
        if @vapps and @status.match('stop')
          @vapps.each do |vapp_sd|
            if vdc.vapps.get_by_name(vapp_sd).nil?
              puts "#{vapp_sd} Doesn't exist.. moving on"
              next
            end
            puts "Powering off #{vapp_sd}.."
            vdc.vapps.get_by_name(vapp_sd).power_off
          end
        end

        if @vapps and @status.match('destroy')
          @vapps.each do |vapp_sd|
            if vdc.vapps.get_by_name(vapp_sd).nil?
              puts "#{vapp_sd} Doesn't exist.. moving on"
              next
            end
            puts "Suspending #{vapp_sd}.."
            vdc.vapps.get_by_name(vapp_sd).undeploy
            puts "Destroying #{vapp_sd}.."
            vdc.vapps.get_by_name(vapp_sd).destroy
          end
        end

        if @vapps and @status.match('start')
          @vapps.each do |vapp_sd|
            if vdc.vapps.get_by_name(vapp_sd).nil?
              puts "#{vapp_sd} Doesn't exist.. moving on"
              next
            end
            puts "Powering on #{vapp_sd}.."
            vdc.vapps.get_by_name(vapp_sd).power_on
          end
        end
        
        vdc.vapps.each { |vapp| vapp.power_off } if @power_vdc and @status.match('stop')
        vdc.vapps_each { |vapp| vapp.power_on } if @power_vdc and not @status.match('start')
      end
    end 
  end
end
