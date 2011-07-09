%%
%% %CopyrightBegin%
%%
%% Copyright Ericsson AB 2002-2009. All Rights Reserved.
%%
%% The contents of this file are subject to the Erlang Public License,
%% Version 1.1, (the "License"); you may not use this file except in
%% compliance with the License. You should have received a copy of the
%% Erlang Public License along with this software. If not, it can be
%% retrieved online at http://www.erlang.org/.
%%
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and limitations
%% under the License.
%%
%% %CopyrightEnd%
%%
-define(SYSFORM,
	" ~-72w~10s~n"
	" Load:  cpu  ~8w               Memory:  total    ~8w    binary   ~8w~n"
	"        procs~8w                        processes~8w    code     ~8w~n"
	"        runq ~8w                        atom     ~8w    ets      ~8w~n").

-record(opts, {node=node(), port = 8415, accum = false, intv = 5000, lines = 10,
	       width = 700, height = 340, sort = runtime, tracing = on,
	       %% Other state information
	       out_mod=etop2_json, out_proc, server, host, tracer, store,
	       accum_tab, remote}).
