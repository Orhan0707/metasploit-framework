# -*- coding: binary -*-

module Msf
  module Java
    module Jmx
      module Mbean
        # This module provides methods which help to handle with MBean related calls.
        # Specially, simulating calls with the Java javax.management.MBeanServerConnection
        # class
        module ServerConnection

          # Builds a Rex::Java::Serialization::Model::Stream to simulate a call
          # to the createMBean method.
          #
          # @param opts [Hash{Symbol => String}]
          # @option opts [String] :obj_id the jmx endpoint ObjId
          # @option opts [String] :name the name of the MBean
          # @return [Rex::Java::Serialization::Model::Stream]
          def create_mbean_stream(opts = {})
            name = opts[:name] || ''
            object_number = opts[:object_number] || 0
            uid_number = opts[:uid_number] || 0
            uid_time = opts[:uid_time] || 0
            uid_count = opts[:uid_count] || 0

            arguments = [
              Rex::Java::Serialization::Model::Utf.new(nil, name),
              Rex::Java::Serialization::Model::NullReference.new,
              Rex::Java::Serialization::Model::NullReference.new
            ]

            call = build_call(
              object_number: object_number,
              uid_number: uid_number,
              uid_time: uid_time,
              uid_count: uid_count,
              operation: -1,
              hash: 2510753813974665446,
              arguments: arguments
            )

            call
          end

          # Builds a Rex::Java::Serialization::Model::Stream to simulate a call to the
          # Java getObjectInstance method.
          #
          # @param opts [Hash{Symbol => String}]
          # @option opts [String] :obj_id the jmx endpoint ObjId
          # @option opts [String] :name the name of the MBean
          # @return [Rex::Java::Serialization::Model::Stream]
          def get_object_instance_stream(opts = {})
            object_number = opts[:object_number] || 0
            uid_number = opts[:uid_number] || 0
            uid_time = opts[:uid_time] || 0
            uid_count = opts[:uid_count] || 0
            name = opts[:name] || ''
            builder = Rex::Java::Serialization::Builder.new

            new_object = builder.new_object(
              name: 'javax.management.ObjectName',
              serial: 0xf03a71beb6d15cf, # serialVersionUID
              flags: 3
            )

            arguments = [
              new_object,
              Rex::Java::Serialization::Model::Utf.new(nil, name),
              Rex::Java::Serialization::Model::EndBlockData.new,
              Rex::Java::Serialization::Model::NullReference.new
            ]

            call = build_call(
              object_number: object_number,
              uid_number: uid_number,
              uid_time: uid_time,
              uid_count: uid_count,
              operation: -1,
              hash: 6950095694996159938,
              arguments: arguments
            )

            call
          end

          # Builds a Rex::Java::Serialization::Model::Stream to simulate a call
          # to the Java invoke method.
          #
          # @param opts [Hash{Symbol => String}]
          # @option opts [String] :obj_id the jmx endpoint ObjId
          # @option opts [String] :object the object whose method we want to call
          # @option opts [String] :method the method name to invoke
          # @option opts [String] :args the arguments of the method to invoke
          # @return [Rex::Java::Serialization::Model::Stream]
          def invoke_stream(opts = {})
            object_number = opts[:object_number] || 0
            uid_number = opts[:uid_number] || 0
            uid_time = opts[:uid_time] || 0
            uid_count = opts[:uid_count] || 0
            object_name = opts[:object] || ''
            method_name = opts[:method] || ''
            args = opts[:args] || {}
            builder = Rex::Java::Serialization::Builder.new

            new_object = builder.new_object(
              name: 'javax.management.ObjectName',
              serial: 0xf03a71beb6d15cf, # serialVersionUID
              flags: 3
            )

            data_binary = builder.new_array(
              name: '[B',
              serial: 0xacf317f8060854e0, # serialVersionUID
              values_type: 'byte',
              values: invoke_arguments_stream(args).encode.unpack('C*')
            )

            marshall_object = builder.new_object(
              name: 'java.rmi.MarshalledObject',
              serial: 0x7cbd1e97ed63fc3e, # serialVersionUID
              fields: [
                ['int', 'hash'],
                ['array', 'locBytes', '[B'],
                ['array', 'objBytes', '[B']
              ],
              data: [
                ["int", 1919492550],
                Rex::Java::Serialization::Model::NullReference.new,
                data_binary
              ]
            )

            new_array = builder.new_array(
              name: '[Ljava.lang.String;',
              serial: 0xadd256e7e91d7b47, # serialVersionUID
              values_type: 'java.lang.String;',
              values: args.keys.collect { |k| Rex::Java::Serialization::Model::Utf.new(nil, k) }
            )

            arguments = [
              new_object,
              Rex::Java::Serialization::Model::Utf.new(nil, object_name),
              Rex::Java::Serialization::Model::EndBlockData.new,
              Rex::Java::Serialization::Model::Utf.new(nil, method_name),
              marshall_object,
              new_array,
              Rex::Java::Serialization::Model::NullReference.new
            ]

            call = build_call(
              object_number: object_number,
              uid_number: uid_number,
              uid_time: uid_time,
              uid_count: uid_count,
              operation: -1,
              hash: 1434350937885235744,
              arguments: arguments
            )

            call
          end

          # Builds a Rex::Java::Serialization::Model::Stream with the arguments to
          # simulate a call to the Java invoke method method.
          #
          # @param args [Hash] the arguments of the method to invoke
          # @return [Rex::Java::Serialization::Model::Stream]
          def invoke_arguments_stream(args = {})
            builder = Rex::Java::Serialization::Builder.new

            new_array = builder.new_array(
              name: '[Ljava.lang.Object;',
              serial: 0x90ce589f1073296c, # serialVersionUID
              annotations: [Rex::Java::Serialization::Model::EndBlockData.new],
              values_type: 'java.lang.Object;',
              values: args.values.collect { |arg| Rex::Java::Serialization::Model::Utf.new(nil, arg) }
            )

            stream = Rex::Java::Serialization::Model::Stream.new
            stream.contents << new_array

            stream
          end
        end
      end
    end
  end
end
