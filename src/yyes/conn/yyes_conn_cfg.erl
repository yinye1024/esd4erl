%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyes_conn_cfg).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([new_cfg/2,get_index_url/2,get_doc_url/3,get_bulk_url/2,get_search_url/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================

new_cfg(Host,Port)->
  #{
    host => Host,
    port => Port
  }.

get_index_url(IndexName,ItemMap) ->
  yyu_string:concat([priv_get_base_url(ItemMap),  yyu_misc:to_list(IndexName)]).

get_doc_url(IndexName,DocId,ItemMap)->
  yyu_string:concat([priv_get_base_url(ItemMap), yyu_misc:to_list(IndexName),"/_doc/",yyu_misc:to_list(DocId)]).

get_search_url(IndexName,ItemMap)->
  yyu_string:concat([priv_get_base_url(ItemMap), yyu_misc:to_list(IndexName),"/_doc/_search"]).

get_bulk_url(IndexName,ItemMap)->
  yyu_string:concat([priv_get_base_url(ItemMap), yyu_misc:to_list(IndexName),"/_bulk/"]).

priv_get_base_url(ItemMap)->
  yyu_string:format("http://~s:~w/",[priv_get_host(ItemMap),priv_get_port(ItemMap)]).

priv_get_host(ItemMap) ->
  yyu_map:get_value(host,ItemMap).

priv_get_port(ItemMap) ->
  yyu_map:get_value(port,ItemMap).




