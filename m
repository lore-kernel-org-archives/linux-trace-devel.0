Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:55297 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbeHTRvF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 13:51:05 -0400
Received: by mail-wm0-f52.google.com with SMTP id f21-v6so14549734wmc.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Aug 2018 07:35:10 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 00/24] trace-cmd: rename variables, data structures and functions in lib/traceevent
Date: Mon, 20 Aug 2018 17:34:41 +0300
Message-Id: <20180820143505.11525-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". 
This series of patches perform the renaming in the trace-cmd code.

Tzvetomir Stoyanov (VMware) (24):
  trace-cmd: Rename struct pevent to struct tep_handle
  trace-cmd: Rename struct pevent_record to struct tep_record
  trace-cmd: Rename pevent plugin related APIs
  trace-cmd: Rename pevent alloc / free APIs
  trace-cmd: Rename pevent find APIs
  trace-cmd: Rename pevent parse APIs
  trace-cmd: Rename pevent print APIs
  trace-cmd: Rename pevent_read_number_* APIs
  trace-cmd: Rename pevent_register_* APIs
  trace-cmd: Rename pevent_set_* APIs
  trace-cmd: Rename pevent_traceevent_* APIs
  trace-cmd: Rename enum pevent_flag to enum tep_flag
  trace-cmd: Rename enunm pevent_errno to enum tep_errno
  trace-cmd: Rename pevent_function* APIs
  trace-cmd: Rename traceevent_* APIs
  trace-cmd: Rename pevent_filter* APIs
  trace-cmd: Rename pevent_register / unregister APIs
  trace-cmd: Rename pevent_data_ APIs
  trace-cmd: Rename pevent field APIs
  trace-cmd: Rename pevent_find_* APIs
  trace-cmd: Rename various pevent get/set/is APIs
  trace-cmd: Rename internal parser related APIs
  trace-cmd: Rename various pevent APIs
  trace-cmd: Rename static variables and functions in event-parse.c

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
