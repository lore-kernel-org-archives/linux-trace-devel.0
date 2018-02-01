Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:44430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751735AbeBAWu7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Feb 2018 17:50:59 -0500
Date: Thu, 1 Feb 2018 17:50:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org"
        <linux-trace-users@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Yordan Karadzhov <y.karadz@gmail.com>,
        Vladislav Valtchev <vladislav.valtchev@gmail.com>
Subject: [ANNOUNCE] trace-cmd v2.7
Message-ID: <20180201175056.319d575c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Features since 2.6:

 - Add "--quiet" (-q) to trace-cmd record to surpress output

 - trace-cmd stat has some more data

 - trace-cmd record splice() how handles more than one page

 - Add --module filtering option to associate modules to filters

 - New -O offset for function plugin

 - Bash completion for -O options.

 - Bash completion for -B instance buffers

 - New trace-cmd clear to simply clear out the trace-cmd buffers

And lots of internal churn to prepare for bigger features in the
future.

Short log:

Baruch Siach (1):
      trace-cmd: use the standard PATH_MAX macro

Cheng Jian (1):
      tools/lib/traceevent/parse-filter.c: clean up clang build warning

Daniel Borkmann (1):
      lib, traceevent: add PRINT_HEX_STR variant

Deepak Das (1):
      trace-cmd record: Add module filtering option

Federico Vaga (2):
      trace-cmd record: Use direname instead of custom code
      trace-cmd: Use asprintf when possible

Greg Kroah-Hartman (1):
      License cleanup: add SPDX GPL-2.0 license identifier to files with no license

Jan Kiszka (3):
      trace-cmd record: Don't set wildcard filter for non-existing module
      event-parse: Print value of unknown symbolic fields
      trace-view: Pick up sched_wakeup_new event

Masahiro Yamada (1):
      scripts/spelling.txt: add "overide" pattern and fix typo instances

Michael Sartain (13):
      event-parse: Fix bad force_token escape sequence
      trace-cmd: Fix unsigned return values being error checked as negative
      trace-cmd: Fix read / write data offsets in read / write loops
      trace-cmd: Fix function prototypes for __vwarning, __vpr_stat, and __vdie
      kernelshark: Fix cases where string literals were passed as string format args
      trace-cmd: Fix incorrect malloc size arg: *item instead of item
      trace-cmd: Fix NULL pointer being passed to memcpy
      trace-cmd: Add UL suffix to MISSING_EVENTS since ints shouldn't be left shifted by 31
      trace-cmd: Use unsigned values in Hsieh's trace_hash fast hash function
      trace-cmd: Fix use after free for recorder global
      trace-cmd: Replace normalize_size loop with branchless previous pow2 algorithm
      trace-cmd: Fix reading of overrun / commit_overrun cpu stat fields
      trace-cmd: Add trace-cmd clear command

Mike Rapoport (1):
      trace-cmd-record: Update documentation for "-c" option

Namhyung Kim (1):
      tools lib traceevent: Fix kbuffer_read_at_offset()

Steven Rostedt (Red Hat) (15):
      trace-cmd msg: Add debug prints of messages sent and received
      trace-cmd msg: Move the saved closing fd to the caller
      trace-cmd listen: Add better output on error of connections
      trace-cmd msg: Create a msg_handle to pass around for saved state
      trace-cmd msg: Add server structure of msg_handler
      trace-cmd: Remove global use_tcp variable
      trace-cmd: Move protocol version into msg_handler
      tracecmd: Clean up handling of cpu_count
      tracecmd listen: Have pagesize passed as return not parameter
      trace-cmd: Have cpu_count reside in instances and not be global
      trace-cmd: Add option CPUCOUNT to buffer instance options
      trace-cmd: Have msg_handle part of the buffer instance
      trace-cmd record: Allow instances to be recorded over the network
      trace-cmd: Have keep and profile be flags of buffer instance
      trace-cmd: Add network handle into buffer instance

Steven Rostedt (VMware) (55):
      trace-cmd-v2.7.dev
      trace-cmd: Fix completions
      trace-cmd: Fix the fix for completions
      trace-cmd: Have trace-cmd start, profile and stream use record completion
      trace-cmd: Add trace-cmd show completion for bash
      trace-cmd: Add bash completions for instance buffers for -B option
      trace-cmd: Have bash completions look at all options by default
      trace-cmd: Add bash completion for trace-cmd report -O
      trace-cmd report: Fix pointer check in option -r
      trace-cmd listen: Replace tab with spaces in help output
      trace-cmd report: Add -O offset for function plugin
      event-parse: Show contents (in hex) of data of unrecognized type records
      parse-events: Fix get_field_str() for dynamic strings
      trace-cmd record: Update man pages for some missing options
      trace-cmd record: Have --module affect function filters listed after it
      trace-cmd record: Update documentation for -c with -P
      event-parse: Show value of flags that have not been parsed
      trace-cmd msg: Remove unused tracecmd_msg_str
      trace-cmd recorder: Always return if the read splice() does not read anything
      trace-cmd record: Only write what was read in splice_data()
      trace-cmd record: Make sure all is written in splice_data()
      trace-cmd recorder: Use full pipe size in splice_data()
      trace-cmd report: Add offsets and record sizes to --debug option
      trace-cmd recorder: Make sure to write as much as was read in read_data()
      trace-cmd listen: Do not kill client recorders
      trace-cmd listen: Make sure to write everything that was read
      trace-cmd recorder: Add define of F_GETPIPE_SZ if not already defined
      trace-cmd build: Do not build python code if swig is not installed
      trace-cmd recorder: Check if pipe_size was modified by fcntl(F_GETPIPE_SZ)
      pevent: Simplify pointer print logic and fix %pF
      pevent: Handle new pointer processing of bprint strings
      trace-cmd record: Fix clearing out the ctx->instance when used in for_all_instances()
      trace-cmd: Remove the creating of msg out of tracecmd_msg_send()
      trace-cmd: Move tracecmd_msg_send_and_wait_for_msg() into its only user
      trace-cmd: Turn tracecmd_msg data into an anonymous union
      trace-cmd: Remove unused structure tracecmd_msg_error
      trace-cmd: Move size and cmd in tracecmd_msg into its own header struct
      trace-cmd: Move the tracecmd_msg pointers into their own union
      trace-cmd: Just use the buf field for sending pointers
      trace-cmd: Use an array to map msg types and min sizes
      trace-cmd: Merge msg_do_write_check() into msg_write()
      trace-cmd: Simplify msg_free() by using min sizes
      trace-cmd: Add tracecmd_msg_init() helper function
      trace-cmd: Remove mulitplexer tracecmd_msg_create()
      trace-cmd: Simplify msg_read_extra()
      trace-cmd: Have msg_free() zero out msg contents
      trace-cmd: Verify RINIT was received after TINIT msg sent
      trace-cmd: Make send_metadata a flag in the output handle
      trace-cmd: Pass cpu count and port array to make_rinit()
      trace-cmd: Pass cpu_count instead of having it as a global
      trace-cmd: Pass in client_ports instead of using a global variable
      trace-cmd: Fix leaking of port_array memory
      trace-cmd msg: Set the min size of a message on init
      trace-cmd TAGS: Fix tags to not parse .pc directory of patch
      trace-cmd: Version 2.7

Vladislav Valtchev (VMware) (20):
      trace-cmd: Fix err msg for record w/o the -e option
      trace-cmd: s/plugin/tracer/ in record's man page
      trace-cmd: Extract trace_stop() from trace_record()
      trace-cmd: Extract trace_restart() from trace_record()
      trace-cmd: Extract trace_reset() from trace_record()
      trace-cmd: Consolidate ARRAY_SIZE() in trace-cmd.h
      trace-cmd: Making the "die" functions noreturn
      trace-cmd: Extract parse_record_options() from trace_record()
      trace-cmd: Replacing cmd flags w/ a trace_cmd enum
      trace-cmd: Extracting record_trace()
      trace-cmd: Rename trace_profile() to do_trace_profile()
      trace-cmd: Making start,extract,stream,profile separate funcs
      trace-cmd: Extract profile-specific code from record_trace
      trace-cmd: Move init_common_record_context() into parse_record_options()
      trace-cmd: Introducing get_trace_cmd_type()
      trace-cmd: Extract finalize_record_trace()
      trace-cmd: Fork record_trace() for the extract case
      trace-cmd: Make read_proc() to return int status via OUT arg
      trace-cmd: Remove the die() call from read_proc()
      trace-cmd: Making stat to report when the stack tracer is ON

Will Hawkins (2):
      trace-cmd record: Add --quiet (-q) option
      trace-cmd record: Fix syntax in make_pid_filter

Yordan Karadzhov (VMware) (1):
      kernelshark: Fix the GUI plugin loading

Ziqian SUN (Zamir) (1):
      trace-cmd report: Fix hash.key in option -w

Enjoy,

-- Steve
