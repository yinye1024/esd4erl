%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 九月 2022 16:06
%%%-------------------------------------------------------------------
-module(es_api_test_item).
-author("yinye").

%% SRC_ROOT_FRW need to set by system env

%% API functions defined
-export([new_pojo/1,new_pojo/2]).

-export([get_id/1,set_id/2, get_cuserId/1,set_cuserId/2, get_dateAdded/1,set_dateAdded/2, get_url/1,set_url/2, get_title/1,set_title/2, get_tags/1,set_tags/2, get_content/1,set_content/2]).



%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(ItemId) ->
  #{
    id => ItemId,
    cuserId =>2001,
    dateAdded => 0,

    url => "https://sfafs.sdfs.com/afdaf",
    title => "好啊 标签1 hahahaa",
    tags =>["标签1"],          %% 标签
    content =>"检索摘要 标签 难啊 哈哈" %% 检索摘要
  }.
new_pojo(ItemId,TagList) ->
  #{
    id => ItemId,
    cuserId =>2001,
    dateAdded => 0,

    url => "https://sfafs.sdfs.com/afdaf",
    title => "好啊 标签1 hahahaa",
    tags =>TagList,          %% 标签
    content =>"检索摘要 标签 难啊 哈哈" %% 检索摘要
  }.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

set_id(Value, ItemMap) ->
  yyu_map:put_value(id, Value, ItemMap).

get_cuserId(ItemMap) ->
  yyu_map:get_value(cuserId, ItemMap).

set_cuserId(Value, ItemMap) ->
  yyu_map:put_value(cuserId, Value, ItemMap).

get_dateAdded(ItemMap) ->
  yyu_map:get_value(dateAdded, ItemMap).

set_dateAdded(Value, ItemMap) ->
  yyu_map:put_value(dateAdded, Value, ItemMap).

get_url(ItemMap) ->
  yyu_map:get_value(url, ItemMap).

set_url(Value, ItemMap) ->
  yyu_map:put_value(url, Value, ItemMap).

get_title(ItemMap) ->
  yyu_map:get_value(title, ItemMap).

set_title(Value, ItemMap) ->
  yyu_map:put_value(title, Value, ItemMap).

get_tags(ItemMap) ->
  yyu_map:get_value(tags, ItemMap).

set_tags(Value, ItemMap) ->
  yyu_map:put_value(tags, Value, ItemMap).

get_content(ItemMap) ->
  yyu_map:get_value(content, ItemMap).

set_content(Value, ItemMap) ->
  yyu_map:put_value(content, Value, ItemMap).

