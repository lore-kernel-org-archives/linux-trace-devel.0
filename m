Return-Path: <SRS0=GMWY=KZ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36099 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727534AbeHJPrh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Aug 2018 11:47:37 -0400
Received: by mail-wm0-f67.google.com with SMTP id w24-v6so1877738wmc.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Aug 2018 06:17:44 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 00/14] Rename variables, data structures and functions in libtraceevent
Date: Fri, 10 Aug 2018 16:17:18 +0300
Message-Id: <20180810131732.24677-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". 
This series of patches continue the renaming. 

Tzvetomir Stoyanov (VMware) (14):
  tools/lib/traceevent, tools/perf: Rename struct event_format to struct
    tep_event_format
  tools/lib/traceevent, tools/perf: Rename struct format to struct
    tep_format and struct format_field to struct tep_format_field
  tools/lib/traceevent, tools/perf: Rename enum format_flags to enum
    tep_format_flags, add prefix TEP_ to all of its members
  tools/lib/traceevent: Rename enum event_type to enum tep_event_type,
    enum event_sort_type to enum tep_event_sort_type and add prefix TEP_
    to all enum's members
  tools/lib/traceevent: Add prefix TEP_ to all members of nameless enum
    EVENT_FL_*
  tools/lib/traceevent, tools/perf: Add prefix tep_ to all print_*
    structures
  tools/lib/traceevent, tools/perf: Rename enum print_arg_type to enum
    tep_print_arg_type and add prefix TEP_ to all its members.
  tools/lib/traceevent: Add prefix tep_ to enums filter_boolean_type,
    filter_op_type, filter_cmp_type and all enum's members
  tools/lib/traceevent: Add prefix tep_ to enums filter_exp_type,
    filter_arg_type and all enum's members
  tools/lib/traceevent: Add prefix tep_ to struct filter_arg, enum
    filter_value_type and all enum's members.
  tools/lib/traceevent: Add prefix tep_ to various structs filter_arg_*.
  tools/lib/traceevent: Add prefix tep_ to structs filter_type and
    event_filter
  tools/lib/traceevent: Add prefix tep_ to enum filter_trivial_type and
    all its members. Rename data2host*() APIs
  tools/lib/traceevent: Rename struct plugin_list to struct
    tep_plugin_list

 tools/lib/traceevent/event-parse.c            | 1184 ++++++++---------
 tools/lib/traceevent/event-parse.h            |  532 ++++----
 tools/lib/traceevent/event-plugin.c           |   18 +-
 tools/lib/traceevent/parse-filter.c           |  646 ++++-----
 tools/lib/traceevent/plugin_function.c        |    2 +-
 tools/lib/traceevent/plugin_hrtimer.c         |    4 +-
 tools/lib/traceevent/plugin_kmem.c            |    4 +-
 tools/lib/traceevent/plugin_kvm.c             |   14 +-
 tools/lib/traceevent/plugin_mac80211.c        |    6 +-
 tools/lib/traceevent/plugin_sched_switch.c    |   10 +-
 tools/perf/builtin-trace.c                    |   26 +-
 tools/perf/tests/evsel-tp-sched.c             |    4 +-
 tools/perf/util/data-convert-bt.c             |   56 +-
 tools/perf/util/evsel.c                       |   10 +-
 tools/perf/util/evsel.h                       |   10 +-
 tools/perf/util/evsel_fprintf.c               |    2 +-
 tools/perf/util/header.c                      |    2 +-
 tools/perf/util/python.c                      |   20 +-
 .../util/scripting-engines/trace-event-perl.c |   66 +-
 .../scripting-engines/trace-event-python.c    |  100 +-
 tools/perf/util/sort.c                        |   22 +-
 tools/perf/util/trace-event-parse.c           |   18 +-
 tools/perf/util/trace-event-read.c            |    4 +-
 tools/perf/util/trace-event.c                 |    8 +-
 tools/perf/util/trace-event.h                 |   20 +-
 25 files changed, 1394 insertions(+), 1394 deletions(-)

-- 
2.17.1
