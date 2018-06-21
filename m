Return-Path: <SRS0=aTL9=JH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:42518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933307AbeFUPrX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jun 2018 11:47:23 -0400
Message-Id: <20180621154347.794581572@goodmis.org>
Date: Thu, 21 Jun 2018 11:43:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 0/5] trace-cmd: Update for moving trace-filter-hash into libtracecmd.a
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Now that the borrowed GPL code has been removed from trace-filter-hash,
we can relicense it from GPL to LGPL and include it into libtracecmd.a.

Note, because we moved these files into a library that will be in the
future exported to other applications, the names of the functions and
the data structures had to be changed. A prefix of "tracecmd_" has
been added to keep the namespace unique.

I also converted all the files that had license headers to the SPDX
format, to make it easier to know what files is for what. Note,
this is not complete. There are still files that need a license marker.
I only modified the files that had license headers. Those that are without
will need to be modified in the future.


Steven Rostedt (VMware) (5):
      kernelshark: Change the license of trace-filter-hash.[ch] for LPGL
      trace-cmd/kernelshark: Move trace-filter-hash.o libtracecmd.a
      trace-cmd: Move the Knuth functions out of trace-filter-hash.h
      trace-cmd: Add "tracecmd_" to namespace of filter hash
      Change to SPDX License format

----
 COPYING                                            | 343 +-------------
 LICENSES/GPL-2.0                                   | 359 +++++++++++++++
 LICENSES/LGPL-2.1                                  | 503 +++++++++++++++++++++
 include/trace-cmd/trace-cmd.h                      |  16 +-
 include/trace-cmd/trace-filter-hash.h              |  40 ++
 include/trace-cmd/trace-hash.h                     |  16 +-
 include/traceevent/event-parse.h                   |  16 +-
 include/traceevent/kbuffer.h                       |  17 +-
 kernel-shark/Makefile                              |   2 +-
 kernel-shark/include/cpu.h                         |  16 +-
 kernel-shark/include/kernel-shark.h                |  20 +-
 kernel-shark/include/kshark-plugin.h               |  16 +-
 kernel-shark/include/trace-capture.h               |  16 +-
 kernel-shark/include/trace-compat.h                |  16 +-
 kernel-shark/include/trace-filter-hash.h           |  85 ----
 kernel-shark/include/trace-filter.h                |  28 +-
 kernel-shark/include/trace-graph.h                 |  32 +-
 kernel-shark/include/trace-gui.h                   |  16 +-
 kernel-shark/include/trace-view-store.h            |  30 +-
 kernel-shark/include/trace-view.h                  |  20 +-
 kernel-shark/include/trace-xml.h                   |  16 +-
 kernel-shark/kernel-shark.c                        | 136 +++---
 kernel-shark/trace-capture.c                       |  16 +-
 kernel-shark/trace-compat.c                        |  16 +-
 kernel-shark/trace-dialog.c                        |  16 +-
 kernel-shark/trace-filter.c                        |  38 +-
 kernel-shark/trace-graph-main.c                    |  16 +-
 kernel-shark/trace-graph.c                         |  88 ++--
 kernel-shark/trace-plot-cpu.c                      |  16 +-
 kernel-shark/trace-plot-task.c                     |  16 +-
 kernel-shark/trace-plot.c                          |  16 +-
 kernel-shark/trace-view-main.c                     |  56 +--
 kernel-shark/trace-view-store.c                    |  52 +--
 kernel-shark/trace-view.c                          |  20 +-
 kernel-shark/trace-xml.c                           |  16 +-
 lib/trace-cmd/Makefile                             |   1 +
 lib/trace-cmd/include/trace-hash-local.h           |  16 +-
 lib/trace-cmd/trace-blk-hack.c                     |  17 +-
 .../trace-cmd}/trace-filter-hash.c                 | 100 ++--
 lib/trace-cmd/trace-ftrace.c                       |  16 +-
 lib/trace-cmd/trace-hash.c                         |  16 +-
 lib/trace-cmd/trace-hooks.c                        |  16 +-
 lib/trace-cmd/trace-input.c                        |  16 +-
 lib/trace-cmd/trace-recorder.c                     |  17 +-
 lib/trace-cmd/trace-util.c                         |  16 +-
 lib/traceevent/event-parse.c                       |  16 +-
 lib/traceevent/event-plugin.c                      |  16 +-
 lib/traceevent/include/event-utils.h               |  16 +-
 lib/traceevent/kbuffer-parse.c                     |  17 +-
 lib/traceevent/parse-filter.c                      |  16 +-
 lib/traceevent/parse-utils.c                       |  16 +-
 lib/traceevent/trace-seq.c                         |  16 +-
 plugins/plugin_blk.c                               |  18 +-
 plugins/plugin_function.c                          |  17 +-
 plugins/plugin_futex.c                             |  16 +-
 plugins/plugin_hrtimer.c                           |  17 +-
 plugins/plugin_jbd2.c                              |  17 +-
 plugins/plugin_kmem.c                              |  17 +-
 plugins/plugin_kvm.c                               |  17 +-
 plugins/plugin_mac80211.c                          |  17 +-
 plugins/plugin_sched_switch.c                      |  17 +-
 plugins/plugin_tlb.c                               |  17 +-
 tracecmd/include/list.h                            |  16 +-
 tracecmd/include/trace-cmd-local.h                 |  16 +-
 tracecmd/include/trace-local.h                     |  16 +-
 tracecmd/trace-check-events.c                      |  16 +-
 tracecmd/trace-cmd.c                               |  16 +-
 tracecmd/trace-hist.c                              |  17 +-
 tracecmd/trace-list.c                              |  16 +-
 tracecmd/trace-listen.c                            |  16 +-
 tracecmd/trace-mem.c                               |  16 +-
 tracecmd/trace-msg.c                               |  16 +-
 tracecmd/trace-output.c                            |  16 +-
 tracecmd/trace-profile.c                           |  16 +-
 tracecmd/trace-read.c                              |  16 +-
 tracecmd/trace-record.c                            |  15 +-
 tracecmd/trace-restore.c                           |  16 +-
 tracecmd/trace-show.c                              |  16 +-
 tracecmd/trace-snapshot.c                          |  17 +-
 tracecmd/trace-split.c                             |  16 +-
 tracecmd/trace-stack.c                             |  16 +-
 tracecmd/trace-stat.c                              |  16 +-
 tracecmd/trace-stream.c                            |  16 +-
 83 files changed, 1218 insertions(+), 1774 deletions(-)
 create mode 100644 LICENSES/GPL-2.0
 create mode 100644 LICENSES/LGPL-2.1
 create mode 100644 include/trace-cmd/trace-filter-hash.h
 delete mode 100644 kernel-shark/include/trace-filter-hash.h
 rename {kernel-shark => lib/trace-cmd}/trace-filter-hash.c (54%)
