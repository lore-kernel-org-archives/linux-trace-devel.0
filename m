Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9C4C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 09:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhKVJdN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 04:33:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230447AbhKVJdN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 04:33:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAECF60E08;
        Mon, 22 Nov 2021 09:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637573407;
        bh=CnS2qGo9l59BrsDOrqDY/LOlk961IbioddE1fiSDPn4=;
        h=From:To:Cc:Subject:Date:From;
        b=Bhsj4La4+/uAxE//TkshK/7uCuRpVeh89uJdXttU2cknJfZQ3n5MSFeZm42oDN1qD
         EvIcvws5a86g50HIz4XKAssVu8oBlyTkX+WhmR6TeEFF1+eUkA5d/DyAAESCYDKKY/
         RjRL0gd4kbK7Sbw0o7342Pw0zWYhC8Eb7qIYLTToS/nZzE+4cinOmaWAt7zTA8+JAn
         rCOtdiLOvj7eKRmZ5afn5WXJT4SxTCtC1TQ5JpW85QsLqvdNwY0qj7L+1hTyKQKoi/
         RiwwFMMBXYDovYeSgMU3Fxc6CyFCQikQyL4NG0OgSEgL+av1PIIeqUv4BpDTUUqK3p
         aFn1XlJX58D/g==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/5] tracing: Add __rel_loc support
Date:   Mon, 22 Nov 2021 18:30:03 +0900
Message-Id: <163757340321.510314.9399950115238632705.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hello,

Here is the 2nd version of the series of '__rel_loc' relative
dynamic array attribute support. The previous version is here;

https://lore.kernel.org/all/163697159970.131454.2661507704362599471.stgit@devnote2/T/#u

In this version, I added bitmask support, since the bitmask
data is also allocated dynamically. And replace
TEP_FIELD_IS_REL_DYNAMIC with TEP_FIELD_IS_RELATIVE because
this new flag complements the TEP_FIELD_IS_DYNAMIC.

Here are 5 patches, [1/5] is the main and required patch, which
updates the event filter, histogram, and inject for '__rel_loc'.
[2/5] and [3/5] are sample code for '__rel_loc' attribute.
[2/5] adds macros which uses '__rel_loc' instead of '__data_loc'
and [3/5] expands example module of trace event.

[4/5] is updating in-kernel libtraceevent, which is deprecated
but perf-tools still need it. [5/5] is updating perf-tools itself.
I'll send a patch to current libtraceevent soon.

The __rel_loc
-----

The '__data_loc' is used for encoding the dynamic data location on
the trace event record. But '__data_loc' is not useful if the writer
doesn't know the event header (e.g. user event), because it records
the dynamic data offset from the entry of the record, not the field
itself.

This new '__rel_loc' attribute encodes the data location relatively
from the next of the field. For example, when there is a record like
below (the number in the parentheses is the size of fields)

 |header(N)|common(M)|fields(K)|__data_loc(4)|fields(L)|data(G)|

In this case, '__data_loc' field will be

 __data_loc = (G << 16) | (N+M+K+4+L)

If '__rel_loc' is used, this will be

 |header(N)|common(M)|fields(K)|__rel_loc(4)|fields(L)|data(G)|

where

 __rel_loc = (G << 16) | (L)

(Because this case shows L bytes after the '__rel_loc' attribute
 field, if there is no fields after the __rel_loc field, L must be 0.)

This is relatively easy (and no need to consider the kernel header
change) when the event data fields are composed by user who doesn't
know header and common fields.

NOTE: Event Injection doesn't work because of bitmask.

Preparation
----
/ # modprobe trace-events-sample.ko
/ # cd /sys/kernel/tracing/
/sys/kernel/tracing # cat events/sample-trace/foo_rel_loc/format 
name: foo_rel_loc
ID: 1259
format:
	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;

	field:__rel_loc char foo[];	offset:8;	size:4;	signed:1;
	field:int bar;	offset:12;	size:4;	signed:1;
	field:__rel_loc unsigned long bitmask[];	offset:16;	size:4;	signed:0;

print fmt: "foo_rel_loc %s, %d, %s", __get_rel_str(foo), REC->bar, __get_rel_bitmask(bitmask)


Test Event Histogram
----

/sys/kernel/tracing # echo 'hist:key=foo' >> events/sample-trace/foo_rel_loc/trigger 
/sys/kernel/tracing # cat events/sample-trace/foo_rel_loc/hist 
# event histogram
#
# trigger info: hist:keys=foo:vals=hitcount:sort=hitcount:size=2048 [active]
#

{ foo: Hello __rel_loc                                    } hitcount:         11

Totals:
    Hits: 11
    Entries: 1
    Dropped: 0


Test Event Filter
----
/sys/kernel/tracing # echo 'foo == "Hello __rel_loc"' >> events/sample-trace/foo_rel_loc/filter
/sys/kernel/tracing # echo > trace
/sys/kernel/tracing # echo 1 >  events/sample-trace/foo_rel_loc/enable 
/sys/kernel/tracing # cat trace
# tracer: nop
#
# entries-in-buffer/entries-written: 4/4   #P:8
#
#                                _-----=> irqs-off
#                               / _----=> need-resched
#                              | / _---=> hardirq/softirq
#                              || / _--=> preempt-depth
#                              ||| / _-=> migrate-disable
#                              |||| /     delay
#           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
#              | |         |   |||||     |         |
    event-sample-143     [001] .....   780.160062: foo_rel_loc: foo_rel_loc Hello __rel_loc, 752, 00000000,deadbeef
    event-sample-143     [001] .....   781.183814: foo_rel_loc: foo_rel_loc Hello __rel_loc, 753, 00000000,deadbeef
    event-sample-143     [001] .....   782.208076: foo_rel_loc: foo_rel_loc Hello __rel_loc, 754, 00000000,deadbeef
    event-sample-143     [001] .....   783.232116: foo_rel_loc: foo_rel_loc Hello __rel_loc, 755, 00000000,deadbeef

Thank you,

---

Masami Hiramatsu (5):
      tracing: Support __rel_loc relative dynamic data location attribute
      tracing: Add '__rel_loc' using trace event macros
      samples/trace_event: Add '__rel_loc' using sample event
      libtraceevent: Add __rel_loc relative location attribute support
      tools/perf: Add '__rel_loc' event field parsing support


 include/linux/trace_events.h                       |    1 
 include/trace/bpf_probe.h                          |   16 +++
 include/trace/perf.h                               |   16 +++
 include/trace/trace_events.h                       |  120 ++++++++++++++++++++
 kernel/trace/trace.h                               |    4 +
 kernel/trace/trace_events_filter.c                 |   32 +++++
 kernel/trace/trace_events_hist.c                   |   21 +++-
 kernel/trace/trace_events_inject.c                 |   11 ++
 samples/trace_events/trace-events-sample.c         |    3 +
 samples/trace_events/trace-events-sample.h         |   33 ++++++
 tools/lib/traceevent/event-parse.c                 |   59 +++++++---
 tools/lib/traceevent/event-parse.h                 |    5 +
 tools/lib/traceevent/parse-filter.c                |    5 +
 tools/perf/builtin-trace.c                         |    2 
 tools/perf/util/data-convert-bt.c                  |    2 
 tools/perf/util/evsel.c                            |    2 
 tools/perf/util/python.c                           |    2 
 .../perf/util/scripting-engines/trace-event-perl.c |    2 
 .../util/scripting-engines/trace-event-python.c    |    2 
 tools/perf/util/sort.c                             |    2 
 20 files changed, 310 insertions(+), 30 deletions(-)

--
Masami Hiramatsu (Linaro) <mhiramat@kernel.org>
