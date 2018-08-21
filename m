Return-Path: <SRS0=yn/p=LE=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:54922 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbeHUQxn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Aug 2018 12:53:43 -0400
Received: by mail-wm0-f68.google.com with SMTP id c14-v6so2944871wmb.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Aug 2018 06:33:31 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 00/24] trace-cmd: rename variables, data structures and functions in lib/traceevent
Date: Tue, 21 Aug 2018 16:33:04 +0300
Message-Id: <20180821133328.3249-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". 
This series of patches perform the renaming in the trace-cmd code.
This is v2 of the patches, with correct changelog. 

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

 include/trace-cmd/trace-cmd.h         |  82 +--
 include/traceevent/event-parse.h      | 458 ++++++++---------
 kernel-shark-qt/examples/datafilter.c |   8 +-
 kernel-shark-qt/examples/dataload.c   |   4 +-
 kernel-shark-qt/src/libkshark.c       |  56 +--
 kernel-shark-qt/src/libkshark.h       |   6 +-
 kernel-shark/include/trace-filter.h   |   6 +-
 kernel-shark/include/trace-graph.h    |  20 +-
 kernel-shark/include/trace-gui.h      |   8 +-
 kernel-shark/kernel-shark.c           |  14 +-
 kernel-shark/trace-capture.c          |  16 +-
 kernel-shark/trace-dialog.c           |  16 +-
 kernel-shark/trace-filter.c           | 104 ++--
 kernel-shark/trace-graph.c            | 126 ++---
 kernel-shark/trace-plot-cpu.c         |  56 +--
 kernel-shark/trace-plot-task.c        |  92 ++--
 kernel-shark/trace-plot.c             |   4 +-
 kernel-shark/trace-view-main.c        |   8 +-
 kernel-shark/trace-view-store.c       |  66 +--
 kernel-shark/trace-view.c             |  10 +-
 lib/trace-cmd/trace-blk-hack.c        |  20 +-
 lib/trace-cmd/trace-ftrace.c          |  98 ++--
 lib/trace-cmd/trace-input.c           | 132 ++---
 lib/trace-cmd/trace-util.c            | 116 ++---
 lib/traceevent/event-parse.c          | 696 +++++++++++++-------------
 lib/traceevent/event-plugin.c         |  70 +--
 lib/traceevent/parse-filter.c         | 288 +++++------
 plugins/plugin_blk.c                  |  46 +-
 plugins/plugin_cfg80211.c             |  20 +-
 plugins/plugin_function.c             |  36 +-
 plugins/plugin_futex.c                |  26 +-
 plugins/plugin_hrtimer.c              |  44 +-
 plugins/plugin_jbd2.c                 |  38 +-
 plugins/plugin_kmem.c                 |  64 +--
 plugins/plugin_kvm.c                  | 152 +++---
 plugins/plugin_mac80211.c             |  34 +-
 plugins/plugin_python.c               |   8 +-
 plugins/plugin_sched_switch.c         |  60 +--
 plugins/plugin_scsi.c                 |  24 +-
 plugins/plugin_tlb.c                  |  20 +-
 plugins/plugin_xen.c                  |  20 +-
 python/ctracecmd.i                    |  34 +-
 python/tracecmd.py                    |  34 +-
 tracecmd/include/trace-local.h        |   4 +-
 tracecmd/trace-check-events.c         |   6 +-
 tracecmd/trace-hist.c                 | 148 +++---
 tracecmd/trace-list.c                 |  12 +-
 tracecmd/trace-mem.c                  |  82 +--
 tracecmd/trace-output.c               |  26 +-
 tracecmd/trace-profile.c              | 144 +++---
 tracecmd/trace-read.c                 | 156 +++---
 tracecmd/trace-record.c               |  24 +-
 tracecmd/trace-split.c                |  20 +-
 tracecmd/trace-stream.c               |   2 +-
 54 files changed, 1932 insertions(+), 1932 deletions(-)

-- 
2.17.1
