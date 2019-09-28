use Mix.Config

config :n2o,
  pickler: :n2o_secret,
  app: :fin,
  mq: :n2o_syn,
  port: 8041,
  mqtt_services: [:erp, :plm],
  ws_services: [:chat],
  protocols: [:n2o_heart, :n2o_nitro, :n2o_ftp, :bpe_n2o2],
  routes: :bank_route

config :kvs,
  dba: :kvs_rocks,
  dba_st: :kvs_st,
  schema: [:kvs, :kvs_stream, :bpe_metainfo, :bank_kvs]

config :rpc,
  js: 'priv/static'

config :form,
  registry: [:bpe_row,:bpe_trace,:bpe_otp,:bpe_act]

config :bpe,
  procmodules: [:bpe, :bpe_account],
  logger_level: :debug,
  logger: [{:handler, :synrc, :logger_std_h,
            %{level: :debug,
              id: :synrc,
              max_size: 2000,
              module: :logger_std_h,
              config: %{type: :file, file: 'fin.log'},
              formatter: {:logger_formatter,
                          %{template: [:time,' ',:pid,' ',:module,' ',:msg,'\n'],
                            single_line: true,}}}}]

