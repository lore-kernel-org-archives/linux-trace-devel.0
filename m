Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37802 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730355AbeHAO17 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Aug 2018 10:27:59 -0400
Received: by mail-wm0-f68.google.com with SMTP id n11-v6so6871181wmc.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Aug 2018 05:42:21 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 00/24] Rename variables, data structures and functions in libtraceevent
Date: Wed,  1 Aug 2018 15:41:32 +0300
Message-Id: <20180801124156.20894-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". 
This series of patches perform the renaming. 

Tzvetomir Stoyanov (VMware) (24):
  tools/lib/traceevent, tools/perf: Rename struct pevent
  tools/lib/traceevent, tools/perf: Rename struct pevent_record
  tools/lib/traceevent, tools/perf: Rename pevent plugin related APIs
  tools/lib/traceevent, tools/perf: Rename pevent alloc / free APIs
  tools/lib/traceevent, tools/perf: Rename pevent find APIs
  tools/lib/traceevent, tools/perf: Rename pevent parse APIs
  tools/lib/traceevent, tools/perf: Rename pevent print APIs
  tools/lib/traceevent, tools/perf: Rename pevent_read_number_* APIs
  tools/lib/traceevent, tools/perf: Rename pevent_register_* APIs
  tools/lib/traceevent, tools/perf: Rename pevent_set_* APIs
  tools/lib/traceevent, tools/perf: Rename traceevent_* APIs
  tools/lib/traceevent, tools/perf: Rename enum pevent_flag
  tools/lib/traceevent, tools/lib/lockdep/: Rename enunm pevent_errno
  tools/lib/traceevent: Rename pevent_function* APIs
  tools/lib/traceevent, tools/perf: Rename traceevent_* APIs
  tools/lib/traceevent: Rename pevent_filter* APIs
  tools/lib/traceevent: Rename pevent_register / unregister APIs
  tools/lib/traceevent: Rename pevent_data_ APIs
  tools/lib/traceevent: Rename pevent filed APIs
  tools/lib/traceevent: Rename pevent_find_* APIs
  tools/lib/traceevent: Rename various pevent get/set/is APIs
  tools/lib/traceevent: Rename internal parser related APIs
  tools/lib/traceevent: Rename various pevent APIs
  tools/lib/traceevent: Rename static variables and functions in
    event-parse.c

 tools/lib/lockdep/Makefile                    |   4 +-
 tools/lib/traceevent/Makefile                 |   4 +-
 tools/lib/traceevent/event-parse.c            | 606 +++++++++---------
 tools/lib/traceevent/event-parse.h            | 366 +++++------
 tools/lib/traceevent/event-plugin.c           |  66 +-
 tools/lib/traceevent/parse-filter.c           | 270 ++++----
 tools/lib/traceevent/plugin_cfg80211.c        |  14 +-
 tools/lib/traceevent/plugin_function.c        |  30 +-
 tools/lib/traceevent/plugin_hrtimer.c         |  34 +-
 tools/lib/traceevent/plugin_jbd2.c            |  24 +-
 tools/lib/traceevent/plugin_kmem.c            |  38 +-
 tools/lib/traceevent/plugin_kvm.c             | 110 ++--
 tools/lib/traceevent/plugin_mac80211.c        |  20 +-
 tools/lib/traceevent/plugin_sched_switch.c    |  48 +-
 tools/lib/traceevent/plugin_scsi.c            |  18 +-
 tools/lib/traceevent/plugin_xen.c             |  14 +-
 tools/perf/builtin-kmem.c                     |   6 +-
 tools/perf/builtin-report.c                   |   2 +-
 tools/perf/builtin-script.c                   |   2 +-
 tools/perf/util/data-convert-bt.c             |   4 +-
 tools/perf/util/evsel.c                       |   2 +-
 tools/perf/util/header.c                      |   6 +-
 tools/perf/util/machine.h                     |   2 +-
 tools/perf/util/python.c                      |   8 +-
 .../util/scripting-engines/trace-event-perl.c |   2 +-
 .../scripting-engines/trace-event-python.c    |   4 +-
 tools/perf/util/sort.c                        |  14 +-
 tools/perf/util/sort.h                        |   2 +-
 tools/perf/util/trace-event-parse.c           |  34 +-
 tools/perf/util/trace-event-read.c            |  42 +-
 tools/perf/util/trace-event-scripting.c       |   4 +-
 tools/perf/util/trace-event.c                 |  28 +-
 tools/perf/util/trace-event.h                 |  20 +-
 33 files changed, 924 insertions(+), 924 deletions(-)

-- 
2.17.1
