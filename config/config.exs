use Mix.Config

config :n2o,
  pickler: :n2o_secret,
  app: :fin,
  mq: :n2o_syn,
  port: 8041,
  mqtt_services: [:erp, :plm],
  ws_services: [:chat],
  protocols: [:n2o_heart, :n2o_nitro, :n2o_ftp, :bpe_n2o],
  routes: :bank_route

config :kvs,
  dba: :kvs_rocks,
  dba_st: :kvs_st,
  schema: [:kvs, :kvs_stream, :bpe_metainfo, :bank_kvs]

config :form,
  registry: [:bpe_row,:bpe_trace,:bpe_otp,:bpe_act]
