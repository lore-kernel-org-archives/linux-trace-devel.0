Return-Path: <SRS0=cF1r=MB=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:59072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731639AbeITAgj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Sep 2018 20:36:39 -0400
Message-Id: <20180919185643.358126338@goodmis.org>
Date: Wed, 19 Sep 2018 14:56:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH 00/15] tools/lib/traceevent: Namespace updates to make traceevent into a library
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


Jiri,

This is another series to fix the namespace of libtraceevent.

Please pull in these patches or if you choose, pull in the branch.
The code is based off of the latest tip/perf/core.

These changes can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: bb730b5833b5bddf5cb226865e5f4496770d00b0
9bc7aeba01678955c3724052966ab8ad61053c89


Tzvetomir Stoyanov (VMware) (15):
      tools/lib/traceevent, tools/perf: Rename struct event_format to struct tep_event_format
      tools/lib/traceevent, tools/perf: Rename struct format{_field} to struct tep_format{_field}
      tools/lib/traceevent, tools/perf: Rename enum format_flags to enum tep_format_flags
      tools/lib/traceevent: Rename enum event_{sort_}type to enum tep_event_{sort_}type
      tools/lib/traceevent: Add prefix TEP_ to all EVENT_FL_* flags
      tools/lib/traceevent, tools/perf: Add prefix tep_ to all print_* structures
      tools/lib/traceevent, tools/perf: Rename enum print_arg_type to enum tep_print_arg_type
      tools/lib/traceevent: Add prefix tep_ to enums filter_{boolean,op,cmp}_type
      tools/lib/traceevent: Add prefix tep_ to enums filter_{exp,arg}_type
      tools/lib/traceevent: Add prefix tep_ to struct filter_{arg,value_type}
      tools/lib/traceevent: Add prefix tep_ to various structs filter_arg_*.
      tools/lib/traceevent: Add prefix tep_ to structs filter_type and event_filter
      tools/lib/traceevent: Rename struct plugin_list to struct tep_plugin_list
      tools/lib/traceevent: Rename data2host*() APIs
      tools/lib/traceevent: Add prefix tep_ to enum filter_trivial_type

----
 tools/lib/traceevent/event-parse.c                 | 1184 ++++++++++----------
 tools/lib/traceevent/event-parse.h                 |  532 ++++-----
 tools/lib/traceevent/event-plugin.c                |   18 +-
 tools/lib/traceevent/parse-filter.c                |  646 +++++------
 tools/lib/traceevent/plugin_function.c             |    2 +-
 tools/lib/traceevent/plugin_hrtimer.c              |    4 +-
 tools/lib/traceevent/plugin_kmem.c                 |    4 +-
 tools/lib/traceevent/plugin_kvm.c                  |   14 +-
 tools/lib/traceevent/plugin_mac80211.c             |    6 +-
 tools/lib/traceevent/plugin_sched_switch.c         |   10 +-
 tools/perf/builtin-trace.c                         |   18 +-
 tools/perf/tests/evsel-tp-sched.c                  |    4 +-
 tools/perf/util/data-convert-bt.c                  |   56 +-
 tools/perf/util/evsel.c                            |   10 +-
 tools/perf/util/evsel.h                            |   10 +-
 tools/perf/util/evsel_fprintf.c                    |    2 +-
 tools/perf/util/header.c                           |    2 +-
 tools/perf/util/python.c                           |   20 +-
 .../perf/util/scripting-engines/trace-event-perl.c |   66 +-
 .../util/scripting-engines/trace-event-python.c    |  100 +-
 tools/perf/util/sort.c                             |   22 +-
 tools/perf/util/trace-event-parse.c                |   18 +-
 tools/perf/util/trace-event-read.c                 |    4 +-
 tools/perf/util/trace-event.c                      |    8 +-
 tools/perf/util/trace-event.h                      |   20 +-
 25 files changed, 1390 insertions(+), 1390 deletions(-)
