%% Copyright 2011,  Filipe David Manana  <fdmanana@apache.org>
%% Web:  http://github.com/fdmanana/snappy-erlang-nif
%%
%% Licensed under the Apache License, Version 2.0 (the "License"); you may not
%% use this file except in compliance with the License. You may obtain a copy of
%% the License at
%%
%%  http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
%% WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
%% License for the specific language governing permissions and limitations under
%% the License.

-module(snappyer).

-export([compress/1, decompress/1]).
-export([uncompressed_length/1, is_valid/1]).

-on_load(init/0).

-ifndef(APPLICATION).
-define(APPLICATION, snappyer).
-endif.

-spec init() -> ok.
init() ->
  ok = erlang:load_nif(so_path(), 0).

-spec compress(iodata()) -> {ok, binary()} | {error, binary()}.
compress(_IoList) ->
  erlang:nif_error(snappy_nif_not_loaded).

-spec decompress(iodata()) -> {ok, binary()} | {error, binary()}.
decompress(_IoList) ->
  erlang:nif_error(snappy_nif_not_loaded).

-spec uncompressed_length(iodata()) -> {ok, non_neg_integer()} | {error, binary()}.
uncompressed_length(_IoList) ->
  erlang:nif_error(snappy_nif_not_loaded).

-spec is_valid(iodata()) -> boolean() | {error, binary()}.
is_valid(_IoList) ->
  erlang:nif_error(snappy_nif_not_loaded).

so_path() ->
  filename:join([get_nif_bin_dir(), "snappyer"]).

get_nif_bin_dir() ->
  {ok, Cwd} = file:get_cwd(),
  get_nif_bin_dir(
    [ code:priv_dir(?APPLICATION)
    , filename:join([Cwd, "..", "priv"])
    , filename:join(Cwd, "priv")
    , os:getenv("NIF_BIN_DIR")
    ]).

get_nif_bin_dir([]) -> erlang:error(snappyer_nif_not_found);
get_nif_bin_dir([false | Rest]) -> get_nif_bin_dir(Rest);
get_nif_bin_dir([Dir | Rest]) ->
  case filelib:wildcard(filename:join([Dir, "snappyer.*"])) of
    [] -> get_nif_bin_dir(Rest);
    [_ | _] -> Dir
  end.
