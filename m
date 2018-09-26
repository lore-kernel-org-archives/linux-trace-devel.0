Return-Path: <SRS0=XLZm=MI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730062.outbound.protection.outlook.com ([40.107.73.62]:58268
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728120AbeIZSbk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Sep 2018 14:31:40 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 00/16] trace-cmd: rename variables, data structures and functions in lib/traceevent
Date: Wed, 26 Sep 2018 15:18:16 +0300
Message-Id: <20180926121832.16101-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tstoyanov@vmware.com>

Backport series of patches from kernel tree to trace-cmd. Patches are related to
renaming variables, data structures and functions in lib/traceevent, in order to 
make libtraceevent into a proper library.

Tzvetomir Stoyanov (VMware) (16):
  tools lib traceevent, perf tools: Split trace-seq related APIs in a
    separate header file
  tools lib traceevent, perf tools: Rename struct event_format to struct
    tep_event_format
  tools lib traceevent, perf tools: Rename struct format{_field} to
    struct tep_format{_field}
  tools lib traceevent, perf tools: Rename enum format_flags to enum
    tep_format_flags
  tools lib traceevent: Rename enum event_{sort_}type to enum
    tep_event_{sort_}type
  tools lib traceevent: Add prefix TEP_ to all EVENT_FL_* flags
  tools lib traceevent, perf tools: Add prefix tep_ to all print_*
    structures
  tools lib traceevent, perf tools: Rename enum print_arg_type to enum
    tep_print_arg_type
  tools lib traceevent: Add prefix tep_ to enums
    filter_{boolean,op,cmp}_type
  tools lib traceevent: Add prefix tep_ to enums filter_{exp,arg}_type
  tools lib traceevent: Add prefix tep_ to struct
    filter_{arg,value_type}
  tools lib traceevent: Add prefix tep_ to various structs filter_arg_*.
  tools lib traceevent: Add prefix tep_ to structs filter_type and
    event_filter
  tools lib traceevent: Rename struct plugin_list to struct
    tep_plugin_list
  tools lib traceevent: Rename data2host*() APIs
  tools lib traceevent: Add prefix tep_ to enum filter_trivial_type

 include/trace-cmd/trace-cmd.h              |   10 +-
 include/traceevent/event-parse.h           |  576 +++++-----
 include/traceevent/trace-seq.h             |   55 +
 kernel-shark-qt/examples/datafilter.c      |    4 +-
 kernel-shark-qt/src/libkshark-configio.c   |   10 +-
 kernel-shark-qt/src/libkshark.c            |    6 +-
 kernel-shark-qt/src/libkshark.h            |    2 +-
 kernel-shark-qt/src/plugins/sched_events.c |    2 +-
 kernel-shark-qt/src/plugins/sched_events.h |   18 +-
 kernel-shark/include/trace-filter.h        |   16 +-
 kernel-shark/include/trace-graph.h         |   22 +-
 kernel-shark/include/trace-view-store.h    |   16 +-
 kernel-shark/include/trace-view.h          |    2 +-
 kernel-shark/kernel-shark.c                |    8 +-
 kernel-shark/trace-capture.c               |    6 +-
 kernel-shark/trace-dialog.c                |    6 +-
 kernel-shark/trace-filter.c                |   78 +-
 kernel-shark/trace-graph.c                 |   24 +-
 kernel-shark/trace-plot-cpu.c              |    4 +-
 kernel-shark/trace-plot-task.c             |    4 +-
 kernel-shark/trace-view-main.c             |    4 +-
 kernel-shark/trace-view-store.c            |    4 +-
 kernel-shark/trace-view.c                  |   12 +-
 lib/trace-cmd/trace-blk-hack.c             |    4 +-
 lib/trace-cmd/trace-ftrace.c               |   18 +-
 lib/trace-cmd/trace-input.c                |   18 +-
 lib/trace-cmd/trace-util.c                 |   18 +-
 lib/traceevent/event-parse.c               | 1185 ++++++++++----------
 lib/traceevent/event-plugin.c              |   19 +-
 lib/traceevent/parse-filter.c              |  646 +++++------
 lib/traceevent/trace-seq.c                 |    2 +
 plugins/plugin_blk.c                       |    6 +-
 plugins/plugin_function.c                  |    3 +-
 plugins/plugin_futex.c                     |    2 +-
 plugins/plugin_hrtimer.c                   |    5 +-
 plugins/plugin_jbd2.c                      |    1 +
 plugins/plugin_kmem.c                      |    5 +-
 plugins/plugin_kvm.c                       |   15 +-
 plugins/plugin_mac80211.c                  |   17 +-
 plugins/plugin_sched_switch.c              |   11 +-
 plugins/plugin_scsi.c                      |    1 +
 plugins/plugin_tlb.c                       |    2 +-
 plugins/plugin_xen.c                       |    1 +
 python/ctracecmd.i                         |   20 +-
 tracecmd/trace-check-events.c              |    2 +-
 tracecmd/trace-hist.c                      |   64 +-
 tracecmd/trace-list.c                      |    4 +-
 tracecmd/trace-mem.c                       |   66 +-
 tracecmd/trace-output.c                    |    6 +-
 tracecmd/trace-profile.c                   |   34 +-
 tracecmd/trace-read.c                      |   36 +-
 tracecmd/trace-record.c                    |    4 +-
 tracecmd/trace-split.c                     |   12 +-
 53 files changed, 1571 insertions(+), 1545 deletions(-)
 create mode 100644 include/traceevent/trace-seq.h

-- 
2.17.1
