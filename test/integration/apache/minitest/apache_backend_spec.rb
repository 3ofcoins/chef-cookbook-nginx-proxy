# -*- coding: utf-8 -*-

require_relative './spec_helper'

require 'net/http'

describe 'Nginx / Apache proxy' do
  let(:http) { Net::HTTP.new('127.0.0.1', port) }
  let(:public_ip) do
    Socket
      .ip_address_list
      .find { |addr| addr.ipv4? && !addr.ipv4_loopback? }
      .ip_address
  end

  describe 'apache' do
    let(:port) { 81 }

    it 'listens on localhost' do
      expect { rescuing { TCPSocket.new('127.0.0.1', port).close }.nil? }
    end

    it 'does not listen globally' do
      expect do
        rescuing { TCPSocket.new(public_ip, port).close }
          .is_a? Errno::ECONNREFUSED
      end
    end

    it 'is handled by Apache' do
      resp = http.request(Net::HTTP::Get.new('/'))
      expect { resp.code.to_i == 200 }
      expect { resp['server'] =~ /apache/i }
      expect { resp.body == "HELLO APACHE\n" }
    end
  end

  describe 'nginx' do
    let(:port) { 80 }

    it 'listens on localhost' do
      expect { rescuing { TCPSocket.new('127.0.0.1', port).close }.nil? }
    end

    it 'listens globally' do
      expect { rescuing { TCPSocket.new(public_ip, port).close }.nil? }
    end

    it 'is handled by Nginx' do
      resp = http.request(Net::HTTP::Get.new('/'))
      expect { resp.code.to_i == 200 }
      expect { resp['server'] =~ /nginx/i }
      expect { resp.body == "HELLO NGINX\n" }
    end

    it 'is forwarding the `apache.localdomain` vhost to Apache' do
      resp = http.request(Net::HTTP::Get.new('/',
                                             'Host' => 'apache.localdomain'))
      expect { resp.code.to_i == 200 }
      expect { resp['server'] =~ /nginx/i }
      expect { resp.body == "HELLO APACHE\n" }
    end
  end
end
