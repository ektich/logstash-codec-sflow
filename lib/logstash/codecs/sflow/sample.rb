require 'bindata'
require 'logstash/codecs/sflow/flow_record'
require 'logstash/codecs/sflow/counter_record'

class FlowSample < BinData::Record
  endian :big
  uint32 :sequence_number
  uint8 :source_id_type
  uint24 :source_id_index
  uint32 :sampling_rate
  uint32 :sample_pool
  uint32 :drops
  uint32 :input_interface
  uint32 :output_interface
  uint32 :record_count
  array :records, :initial_length => :record_count do
    bit20 :record_entreprise
    bit12 :record_format
    uint32 :record_length
    choice :record_data, :selection => :record_format do
      raw_packet_header 1
      ethernet_frame_data 2
      ip4_data 3
      ip6_data 4
      extended_switch_data 1001
      extended_router_data 1002
      skip :default, :length => :record_length
    end
  end
end

class CounterSample < BinData::Record
  endian :big
  uint32 :sample_seq_number
  uint8 :source_id_type
  uint24 :source_id_index
  uint32 :record_count
  array :records, :initial_length => :record_count do
    bit20 :record_entreprise
    bit12 :record_format
    uint32 :record_length
    choice :record_data, :selection => :record_format do
      generic_interface 1
      ethernet_interfaces 2
      token_ring 3
      hundred_base_vg 4
      vlan 5
      processor_information 1001
      skip :default, :length => :record_length
    end
    #processor_information :record_data
  end
end
