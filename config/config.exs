use Mix.Config

config :n2o,
  pickler: :n2o_secret,
  app: :fin,
  mq: :n2o_syn,
  port: 8041,
  protocols: [:n2o_heart, :nitro_n2o, :n2o_ftp],
  routes: :fin_route

config :kvs,
  dba: :kvs_rocks,
  dba_st: :kvs_st,
  schema: [:kvs, :kvs_stream, :bpe_metainfo, :fin_kvs]

config :form,
  module: :form_backend,
  registry: [:bpe_row,:bpe_create,:bpe_trace,:bpe_pass]

config :bpe,
  procmodules: [:bpe, :bpe_account],
  logger_level: :info,
  logger: [{:handler, :synrc, :logger_std_h,
            %{level: :info,
              id: :synrc,
              max_size: 2000,
              module: :logger_std_h,
              config: %{type: :file, file: 'fin.log'},
              formatter: {:logger_formatter,
                          %{template: [:time,' ',:pid,' ',:module,' ',:msg,'\n'],
                            single_line: true,}}}}]

