%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 六月 2021 19:07
%%%-------------------------------------------------------------------
-module(es_api_test).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("eunit/include/eunit.hrl").


-define(IndexName,test_yy).
-define(ConnCfg,yyes_conn_cfg:new_cfg("192.168.43.29",9200)).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
api_test_() ->
  yyu_logger:start(),

  [{setup,
    fun start_suite/0,
    fun stop_suite/1,
    fun (_SetupData) ->
      [
        {foreach,
          fun start_case/0,
          fun stop_case/1,
          [
            fun test_crud/1,
            fun test_bulk/1,
            fun test_search/1
          ]
        }
      ]
    end}].


start_suite() ->
  ?LOG_INFO({"api test start ======================"}),
  PropsMap = #{
    id => #{type => "long"},
    cuserId => #{type => "long"},
    dateAdded => #{type => "date"},

    url => #{type => "keyword"},
    title => #{type => "text"},
    tags =>#{
      type => "keyword",
      fields=> #{
        ft => #{
          type=> "text"
        }
      }
    },          %% 标签
    content =>#{type => "text"} %% 检索摘要
  },
  yyes_es_api:init(?ConnCfg,?IndexName, PropsMap),
  {?ConnCfg,?IndexName}.

stop_suite({ConnCfg,IndexName}) ->
  ?LOG_INFO({"api test end ======================",ConnCfg,IndexName}),
  ?OK.


start_case()->
  ?LOG_INFO({"start case ==================="}),
  %% 清理数据
  {?ConnCfg,?IndexName}.

stop_case({ConnCfg,IndexName})->
  %% 清理数据
  ?LOG_INFO({"stop case ===================",{ConnCfg,IndexName}}),
  ?OK.

test_crud({ConnCfg,IndexName})->
  ?LOG_INFO({"test test_crud ==================="}),
  ItemId = 3,
  Item = es_api_test_item:new_pojo(ItemId),

  ?OK = yyes_es_api:put(ConnCfg,IndexName, Item),
  Result_1 = yyes_es_api:get(ConnCfg,IndexName,ItemId),

  ?OK= yyes_es_api:delete(ConnCfg,IndexName,ItemId),
  Result_2 = yyes_es_api:get(ConnCfg,IndexName,ItemId),

  AssertCuserId = es_api_test_item:get_cuserId(Item),
  [
    ?_assertMatch(ItemId,es_api_test_item:get_id(Result_1)),
    ?_assertMatch(AssertCuserId,es_api_test_item:get_cuserId(Result_1)),
    ?_assertMatch(?NOT_SET,Result_2)
  ].


test_bulk({ConnCfg,IndexName})->
  ?LOG_INFO({"test test_bulk ==================="}),
  Item_1 = es_api_test_item:new_pojo(11,["标签1","标签2"]),
  Item_2 = es_api_test_item:new_pojo(12,["标签1","标签2","标签3"]),
  ?OK = yyes_es_api:bulk(ConnCfg,IndexName, [Item_1,Item_2]),

  Result_1 = yyes_es_api:get(ConnCfg,IndexName,11),
  Result_2 = yyes_es_api:get(ConnCfg,IndexName,12),

  ?OK= yyes_es_api:delete(ConnCfg,IndexName,11),
  ?OK= yyes_es_api:delete(ConnCfg,IndexName,12),
  [
    ?_assertMatch(11,es_api_test_item:get_id(Result_1)),
    ?_assertMatch(12,es_api_test_item:get_id(Result_2))
  ].



test_search({ConnCfg,IndexName})->
  ?LOG_INFO({"test test_search ==================="}),
  Item_1 = es_api_test_item:new_pojo(12,["标签1","标签2"]),
  Item_2 = es_api_test_item:new_pojo(13,["标签1","标签2","标签3"]),
  ?OK = yyes_es_api:bulk(ConnCfg,IndexName, [Item_1,Item_2]),

  Text = <<"标签1">>,
  PostMap = #{
    query =>#{
      bool=>#{
        should=> [
          #{ match=>#{
            tags=> #{
              query=> Text,
              boost=>3
            }}},
          #{ match=>#{
            title=> #{
              query=> Text,
              boost=>2
            }}},
          #{ match=>#{
            content=> #{
              query=> Text,
              boost=>1
            }}}
        ]
      }
    },
    highlight=> #{
      fields => #{
        content => #{}
      }
    }
  },
  %% wait for indexed
  yyu_time:sleep(1000),
  {?OK, EsHitMap} = yyes_es_api:search(?ConnCfg,?IndexName,PostMap),
  ItemList = yyu_map:get_value(hits, EsHitMap),

  ?OK= yyes_es_api:delete(ConnCfg,IndexName,12),
  ?OK= yyes_es_api:delete(ConnCfg,IndexName,13),
  ?LOG_INFO({eshit, EsHitMap}),
  [
    ?_assertMatch(?TRUE,yyu_list:size_of(ItemList)>0)
  ].