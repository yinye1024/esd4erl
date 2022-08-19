%%%-------------------------------------------------------------------
%%% @author zenmind
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 四月 2021 14:09
%%%-------------------------------------------------------------------
-module(test_es).
-author("zenmind").
-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([init/0,get/1,put/0,delete/1,bulk/0,search/0]).
-define(IndexName,test1).
-define(ConnCfg,yyes_conn_cfg:new_cfg("192.168.43.29",9200)).

%% ===================================================================================
%% API functions implements
%% ===================================================================================

init()->

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

  yyes_es_api:init(?ConnCfg,?IndexName,  PropsMap),
  ?OK.

get(ItemId)->
  ?OK,Item = yyes_es_api:get(?ConnCfg,?IndexName,ItemId),
  {?OK,Item}.

delete(ItemId)->
  ?OK= yyes_es_api:delete(?ConnCfg,?IndexName,ItemId),
  ?OK.

%% new or replace
put()->
  Item =   #{
    id => 3,
    cuserId =>2001,
    dateAdded => 0,

    url => "https://sfafs.sdfs.com/afdaf",
    title => "好啊 标签1 hahahaa",
    tags =>["标签1"],          %% 标签
    content =>"检索摘要 标签 难啊 哈哈" %% 检索摘要
  },
  ?OK = yyes_es_api:put(?ConnCfg,?IndexName, Item),
  ?OK.


bulk()->
  Item =   #{
    id => 5,
    cuserId =>2001,
    dateAdded => 0,

    url => "https://sfafs.sdfs.com/afdaf",
    title => "好啊",
    tags =>["标签1","标签2"],          %% 标签
    content =>"检索摘要" %% 检索摘要
  },
  Item2 =   #{
    id => 6,
    cuserId =>2001,
    dateAdded => 0,

    url => "https://sfafs.sdfs.com/afdaf",
    title => "好啊",
    tags =>["标签1","标签2","标签3"],          %% 标签
    content =>"检索摘要" %% 检索摘要
  },
  ?OK = yyes_es_api:bulk(?ConnCfg,?IndexName, [Item,Item2]),
  ?OK.


search()->
  Text = "标签1",
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
  {?OK,EsHit} = yyes_es_api:search(?ConnCfg,?IndexName,PostMap),
  EsHit.
