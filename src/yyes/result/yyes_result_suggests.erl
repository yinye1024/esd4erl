%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyes_result_suggests).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").

-export([from_json/2]).
-export([get_list/1]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================

from_json(SuggestName,BodyJson)->
  BodyMap = yyu_json:json_to_map(BodyJson),
  SuggestMap = yyu_map:get_value(suggest,BodyMap),
  [NameMap|_Less] = yyu_map:get_value(SuggestName,SuggestMap),
  OptionList = yyu_map:get_value(options,NameMap),
  SourceList = priv_to_source_list(OptionList,[]),
  #{
    list => SourceList
  }.

priv_to_source_list([OptionMap|Less],AccList)->
  SourceMap = yyu_map:get_value('_source',OptionMap),
  priv_to_source_list(Less,[SourceMap|AccList]);
priv_to_source_list([],AccList)->
  yyu_list:reverse(AccList).

get_list(ItemMap) ->
  yyu_map:get_value(list, ItemMap).
