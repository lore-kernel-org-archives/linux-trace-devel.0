Return-Path: <SRS0=xHrW=KR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38490 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732231AbeHBPx4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Aug 2018 11:53:56 -0400
Received: by mail-wm0-f68.google.com with SMTP id t25-v6so2677230wmi.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Aug 2018 07:02:34 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 00/24] Rename variables, data structures and functions in libtraceevent
Date: Thu,  2 Aug 2018 17:02:00 +0300
Message-Id: <20180802140224.19070-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". 
This series of patches perform the renaming. 

Tzvetomir Stoyanov (VMware) (24):
  tools/lib/traceevent, tools/perf: Rename struct pevent to struct
    tep_handle
  tools/lib/traceevent, tools/perf: Rename struct pevent_record to
    struct tep_record
  tools/lib/traceevent, tools/perf: Rename pevent plugin related APIs
  tools/lib/traceevent, tools/perf: Rename pevent alloc / free APIs
  tools/lib/traceevent, tools/perf: Rename pevent find APIs
  tools/lib/traceevent, tools/perf: Rename pevent parse APIs
  tools/lib/traceevent, tools/perf: Rename pevent print APIs
  tools/lib/traceevent, tools/perf: Rename pevent_read_number_* APIs
  tools/lib/traceevent, tools/perf: Rename pevent_register_* APIs
  tools/lib/traceevent, tools/perf: Rename pevent_set_* APIs
  tools/lib/traceevent, tools/perf: Rename traceevent_* APIs
  tools/lib/traceevent, tools/perf: Rename enum pevent_flag to enum
    tep_flag
  tools/lib/traceevent, tools/lib/lockdep/: Rename enunm pevent_errno to
    enum tep_errno
  tools/lib/traceevent: Rename pevent_function* APIs
  tools/lib/traceevent, tools/perf: Rename traceevent_* APIs
  tools/lib/traceevent: Rename pevent_filter* APIs
  Rename pevent_register / unregister APIs
  tools/lib/traceevent: Rename pevent_data_ APIs
  tools/lib/traceevent: Rename pevent field APIs
  tools/lib/traceevent: Rename pevent_find_* APIs
  tools/lib/traceevent: Rename various pevent get/set/is APIs
  tools/lib/traceevent: Rename internal parser related APIs
  tools/lib/traceevent: Rename various pevent APIs
  tools/lib/traceevent: Rename static variables and functions in
    event-parse.c

 tools/lib/lockdep/Makefile                    |   4 +-
 tools/lib/traceevent/Makefile                 |   4 +-
 tools/lib/traceevent/event-parse.c            | 696 +++++++++---------
 tools/lib/traceevent/event-parse.h            | 458 ++++++------
 tools/lib/traceevent/event-plugin.c           |  70 +-
 tools/lib/traceevent/parse-filter.c           | 288 ++++----
 tools/lib/traceevent/plugin_cfg80211.c        |  20 +-
 tools/lib/traceevent/plugin_function.c        |  34 +-
 tools/lib/traceevent/plugin_hrtimer.c         |  56 +-
 tools/lib/traceevent/plugin_jbd2.c            |  36 +-
 tools/lib/traceevent/plugin_kmem.c            |  66 +-
 tools/lib/traceevent/plugin_kvm.c             | 154 ++--
 tools/lib/traceevent/plugin_mac80211.c        |  28 +-
 tools/lib/traceevent/plugin_sched_switch.c    |  60 +-
 tools/lib/traceevent/plugin_scsi.c            |  24 +-
 tools/lib/traceevent/plugin_xen.c             |  20 +-
 tools/perf/builtin-kmem.c                     |   6 +-
 tools/perf/builtin-report.c                   |   6 +-
 tools/perf/builtin-script.c                   |   6 +-
 tools/perf/util/data-convert-bt.c             |   6 +-
 tools/perf/util/evsel.c                       |   2 +-
 tools/perf/util/header.c                      |   6 +-
 tools/perf/util/machine.h                     |   2 +-
 tools/perf/util/python.c                      |  10 +-
 .../util/scripting-engines/trace-event-perl.c |   2 +-
 .../scripting-engines/trace-event-python.c    |   6 +-
 tools/perf/util/sort.c                        |  16 +-
 tools/perf/util/sort.h                        |   2 +-
 tools/perf/util/trace-event-parse.c           |  34 +-
 tools/perf/util/trace-event-read.c            |  44 +-
 tools/perf/util/trace-event-scripting.c       |   4 +-
 tools/perf/util/trace-event.c                 |  28 +-
 tools/perf/util/trace-event.h                 |  20 +-
 33 files changed, 1109 insertions(+), 1109 deletions(-)

-- 
2.17.1
