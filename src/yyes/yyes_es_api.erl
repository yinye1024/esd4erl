%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyes_es_api).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-export([init/3,get/3,muti_get/0,put/3,delete/3,bulk/3,delete_by_query/1,
  search/3,suggest/4,agg/4]).
%% API functions defined

%% ===================================================================================
%% API functions implements
%% ===================================================================================

init(ConnCfg,IndexName,PropsMap) when is_map(PropsMap)->

  IndexSettingMap = #{
    settings => #{
      number_of_shards => 1
    },
    mappings =>
    #{
      properties => PropsMap
    }
  },

  IndexUrl = yyes_conn_cfg:get_index_url(IndexName,ConnCfg),
  case yyes_restful:get(IndexUrl) of
    {?OK,?NOT_FOUND} ->
      {?OK,_Body} = yyes_restful:put(IndexUrl,yyu_json:map_to_json(IndexSettingMap)),
      ?OK;
    _Other ->?OK
  end,
  ?OK.

get(ConnCfg,IndexName, ItemId)->
  DocUrl = yyes_conn_cfg:get_doc_url(IndexName,ItemId,ConnCfg),
  case yyes_restful:get(DocUrl) of
    {?OK,?NOT_FOUND} ->
      ?NOT_SET;
    {?OK,Body} ->
      BodyMap = yyu_json:json_to_map(Body),
      Item = yyu_map:get_value('_source', BodyMap),
      Item
  end.


delete(ConnCfg,IndexName, ItemId)->
  DocUrl = yyes_conn_cfg:get_doc_url(IndexName,ItemId,ConnCfg),
  {?OK,_Body} = yyes_restful:delete(DocUrl),
  ?OK.

%% new or replace
put(ConnCfg,IndexName,Item)->
  {ItemId,Item} = priv_to_es_item(Item),
  DocUrl = yyes_conn_cfg:get_doc_url(IndexName,ItemId,ConnCfg),
  {?OK,_Body} = yyes_restful:put(DocUrl,Item),
  ?OK.

bulk(ConnCfg,IndexName, ItemList) when is_list(ItemList)->
  EsItemList = priv_to_es_itemList(ItemList,[]),
  BulkUrl = yyes_conn_cfg:get_bulk_url(IndexName,ConnCfg),
  BulkItemList = priv_build_bulk_data(EsItemList,[]),
  BulkData = yyu_string:concat(BulkItemList),
  {?OK,_Body} = yyes_restful:bulk(BulkUrl,BulkData),
  ?OK.

priv_build_bulk_data([{ItemId,Item}|Less], AccBulkItemList)->
  ItemJson = yyu_json:map_to_json(Item),
  BulkItem = io_lib:format("{ \"index\": {\"_id\": ~w } } ~n  ~s  ~n", [ItemId,ItemJson]),
  priv_build_bulk_data(Less,[BulkItem| AccBulkItemList]);
priv_build_bulk_data([], AccBulkItemList)->
  AccBulkItemList.

priv_to_es_itemList([Item|Less],AccList)->
  EsItem = priv_to_es_item(Item),
  priv_to_es_itemList(Less,[EsItem|AccList]);
priv_to_es_itemList([],AccList)->
  AccList.

priv_to_es_item(Item) when is_map(Item)->
  ItemId =
    case yyu_map:get_value(id,Item) of
      ?NOT_SET ->yyu_error:throw_error(http_error,"bulk item has no id");
      ItemIdTmp->ItemIdTmp
    end,
  {ItemId,Item}.

delete_by_query({Collection, QueryMap_LimitList}) when is_list(QueryMap_LimitList)->
  ?OK.

muti_get()->
  ?OK.

search(ConnCfg,IndexName,PostMap)->
  SearchUrl = yyes_conn_cfg:get_search_url(IndexName,ConnCfg),
  {?OK, Body} = yyes_restful:post(SearchUrl,PostMap),
  {?OK, yyes_result_hits:from_json(Body)}.

agg(ConnCfg,IndexName,PostMap,AggName)->
  SearchUrl = yyes_conn_cfg:get_search_url(IndexName,ConnCfg),
  {?OK, Body} = yyes_restful:post(SearchUrl,PostMap),
  {?OK, yyes_result_aggs:from_json(AggName,Body)}.

suggest(ConnCfg,IndexName,PostMap,SuggestName)->
  SearchUrl = yyes_conn_cfg:get_search_url(IndexName,ConnCfg),
  {?OK, Body} = yyes_restful:post(SearchUrl,PostMap),
  {?OK, yyes_result_suggests:from_json(SuggestName,Body)}.











