Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wr0-f174.google.com ([209.85.128.174]:45478 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755415AbdLTSIB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 13:08:01 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH 00/18] trace-cmd: restructure the project's source tree
Date: Wed, 20 Dec 2017 20:07:30 +0200
Message-Id: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This series restructures trace-cmd's source tree in a way that each component
inside the repo has its own directory. Now the two libraries, the GUI apps, the
plugins, the python C modules, the trace-cmd's application and all of their
headers are organized in dedicated directories. Almost all of the effort in this
series has been spent on updating the build system to support the new structure.
The side-effect of that is a simpler and easier to maintain build system.

Vladislav Valtchev (VMware) (18):
  trace-cmd: Rename libparsevent to libtraceevent
  trace-cmd: Move libtraceevent headers in include/traceevent
  trace-cmd: Move trace-cmd headers in include/trace-cmd
  trace-cmd: Move event-utils.h in lib/traceevent/include
  trace-cmd: Extract part of Makefile in scripts/utils.mk
  trace-cmd: Move libtraceevent *.c files in lib/traceevent
  trace-cmd: Move trace-hash-local.h in lib/trace-cmd/include
  trace-cmd: Move libtracecmd *.c files in lib/trace-cmd
  trace-cmd: Move GUI headers in kernel-shark/include
  trace-cmd: Move GUI *.c files in kernel-shark/
  trace-cmd: Move plugin_* files in plugins/
  trace-cmd: Fix the broken target ctracecmdgui.so
  trace-cmd: Move python-related files in python/
  trace-cmd: Move tracecmd headers in tracecmd/include
  trace-cmd: Move version.h in include/
  trace-cmd: Move trace-cmd app files in tracecmd/
  trace-cmd: Fix the logic behind SWIG_DEFINED in the Makefile
  trace-cmd: Make the build to tell when python-dev is missing

 Makefile                                           | 499 +++++----------------
 trace-cmd.h => include/trace-cmd/trace-cmd.h       |   0
 trace-hash.h => include/trace-cmd/trace-hash.h     |   0
 event-parse.h => include/traceevent/event-parse.h  |   0
 kbuffer.h => include/traceevent/kbuffer.h          |   0
 version.h => include/version.h                     |   0
 kernel-shark/Makefile                              |  88 ++++
 cpu.h => kernel-shark/include/cpu.h                |   0
 .../include/kernel-shark.h                         |   0
 .../include/kshark-plugin.h                        |   0
 .../include/trace-capture.h                        |   0
 .../include/trace-compat.h                         |   0
 .../include/trace-filter-hash.h                    |   0
 .../include/trace-filter.h                         |   0
 .../include/trace-graph.h                          |   0
 trace-gui.h => kernel-shark/include/trace-gui.h    |   0
 .../include/trace-view-store.h                     |   0
 trace-view.h => kernel-shark/include/trace-view.h  |   0
 trace-xml.h => kernel-shark/include/trace-xml.h    |   0
 kernel-shark.c => kernel-shark/kernel-shark.c      |   0
 trace-capture.c => kernel-shark/trace-capture.c    |   0
 trace-compat.c => kernel-shark/trace-compat.c      |   0
 trace-dialog.c => kernel-shark/trace-dialog.c      |   0
 .../trace-filter-hash.c                            |   0
 trace-filter.c => kernel-shark/trace-filter.c      |   0
 .../trace-graph-main.c                             |   0
 trace-graph.c => kernel-shark/trace-graph.c        |   0
 trace-plot-cpu.c => kernel-shark/trace-plot-cpu.c  |   0
 .../trace-plot-task.c                              |   0
 trace-plot.c => kernel-shark/trace-plot.c          |   0
 .../trace-view-main.c                              |   0
 .../trace-view-store.c                             |   0
 trace-view.c => kernel-shark/trace-view.c          |   0
 trace-xml.c => kernel-shark/trace-xml.c            |   0
 lib/trace-cmd/Makefile                             |  47 ++
 .../trace-cmd/include/trace-hash-local.h           |   0
 trace-blk-hack.c => lib/trace-cmd/trace-blk-hack.c |   0
 trace-ftrace.c => lib/trace-cmd/trace-ftrace.c     |   0
 trace-hash.c => lib/trace-cmd/trace-hash.c         |   0
 trace-hooks.c => lib/trace-cmd/trace-hooks.c       |   0
 trace-input.c => lib/trace-cmd/trace-input.c       |   0
 trace-recorder.c => lib/trace-cmd/trace-recorder.c |   0
 trace-util.c => lib/trace-cmd/trace-util.c         |   0
 lib/traceevent/Makefile                            |  45 ++
 event-parse.c => lib/traceevent/event-parse.c      |   0
 event-plugin.c => lib/traceevent/event-plugin.c    |   0
 .../traceevent/include/event-utils.h               |   0
 kbuffer-parse.c => lib/traceevent/kbuffer-parse.c  |   0
 parse-filter.c => lib/traceevent/parse-filter.c    |   0
 parse-utils.c => lib/traceevent/parse-utils.c      |   0
 str_error_r.c => lib/traceevent/str_error_r.c      |   0
 trace-seq.c => lib/traceevent/trace-seq.c          |   0
 plugins/Makefile                                   |  69 +++
 plugin_blk.c => plugins/plugin_blk.c               |   0
 plugin_cfg80211.c => plugins/plugin_cfg80211.c     |   0
 plugin_function.c => plugins/plugin_function.c     |   0
 plugin_hrtimer.c => plugins/plugin_hrtimer.c       |   0
 plugin_jbd2.c => plugins/plugin_jbd2.c             |   0
 plugin_kmem.c => plugins/plugin_kmem.c             |   0
 plugin_kvm.c => plugins/plugin_kvm.c               |   0
 plugin_mac80211.c => plugins/plugin_mac80211.c     |   0
 plugin_python.c => plugins/plugin_python.c         |   0
 .../plugin_sched_switch.c                          |   0
 plugin_scsi.c => plugins/plugin_scsi.c             |   0
 plugin_tlb.c => plugins/plugin_tlb.c               |   0
 plugin_xen.c => plugins/plugin_xen.c               |   0
 python/Makefile                                    |  40 ++
 ctracecmd.i => python/ctracecmd.i                  |   0
 ctracecmdgui.i => python/ctracecmdgui.i            |   0
 event-viewer.py => python/event-viewer.py          |   0
 tracecmd.py => python/tracecmd.py                  |   0
 tracecmdgui.py => python/tracecmdgui.py            |   0
 scripts/utils.mk                                   | 117 +++++
 tracecmd/Makefile                                  |  73 +++
 bug.h => tracecmd/include/bug.h                    |   0
 list.h => tracecmd/include/list.h                  |   0
 .../include/trace-cmd-local.h                      |   0
 trace-local.h => tracecmd/include/trace-local.h    |   0
 trace-msg.h => tracecmd/include/trace-msg.h        |   0
 .../trace-check-events.c                           |   0
 trace-cmd.bash => tracecmd/trace-cmd.bash          |   0
 trace-cmd.c => tracecmd/trace-cmd.c                |   0
 trace-hist.c => tracecmd/trace-hist.c              |   0
 trace-list.c => tracecmd/trace-list.c              |   0
 trace-listen.c => tracecmd/trace-listen.c          |   0
 trace-mem.c => tracecmd/trace-mem.c                |   0
 trace-msg.c => tracecmd/trace-msg.c                |   0
 trace-output.c => tracecmd/trace-output.c          |   0
 trace-profile.c => tracecmd/trace-profile.c        |   0
 trace-read.c => tracecmd/trace-read.c              |   0
 trace-record.c => tracecmd/trace-record.c          |   0
 trace-restore.c => tracecmd/trace-restore.c        |   0
 trace-show.c => tracecmd/trace-show.c              |   0
 trace-snapshot.c => tracecmd/trace-snapshot.c      |   0
 trace-split.c => tracecmd/trace-split.c            |   0
 trace-stack.c => tracecmd/trace-stack.c            |   0
 trace-stat.c => tracecmd/trace-stat.c              |   0
 trace-stream.c => tracecmd/trace-stream.c          |   0
 trace-usage.c => tracecmd/trace-usage.c            |   0
 99 files changed, 593 insertions(+), 385 deletions(-)
 rename trace-cmd.h => include/trace-cmd/trace-cmd.h (100%)
 rename trace-hash.h => include/trace-cmd/trace-hash.h (100%)
 rename event-parse.h => include/traceevent/event-parse.h (100%)
 rename kbuffer.h => include/traceevent/kbuffer.h (100%)
 rename version.h => include/version.h (100%)
 create mode 100644 kernel-shark/Makefile
 rename cpu.h => kernel-shark/include/cpu.h (100%)
 rename kernel-shark.h => kernel-shark/include/kernel-shark.h (100%)
 rename kshark-plugin.h => kernel-shark/include/kshark-plugin.h (100%)
 rename trace-capture.h => kernel-shark/include/trace-capture.h (100%)
 rename trace-compat.h => kernel-shark/include/trace-compat.h (100%)
 rename trace-filter-hash.h => kernel-shark/include/trace-filter-hash.h (100%)
 rename trace-filter.h => kernel-shark/include/trace-filter.h (100%)
 rename trace-graph.h => kernel-shark/include/trace-graph.h (100%)
 rename trace-gui.h => kernel-shark/include/trace-gui.h (100%)
 rename trace-view-store.h => kernel-shark/include/trace-view-store.h (100%)
 rename trace-view.h => kernel-shark/include/trace-view.h (100%)
 rename trace-xml.h => kernel-shark/include/trace-xml.h (100%)
 rename kernel-shark.c => kernel-shark/kernel-shark.c (100%)
 rename trace-capture.c => kernel-shark/trace-capture.c (100%)
 rename trace-compat.c => kernel-shark/trace-compat.c (100%)
 rename trace-dialog.c => kernel-shark/trace-dialog.c (100%)
 rename trace-filter-hash.c => kernel-shark/trace-filter-hash.c (100%)
 rename trace-filter.c => kernel-shark/trace-filter.c (100%)
 rename trace-graph-main.c => kernel-shark/trace-graph-main.c (100%)
 rename trace-graph.c => kernel-shark/trace-graph.c (100%)
 rename trace-plot-cpu.c => kernel-shark/trace-plot-cpu.c (100%)
 rename trace-plot-task.c => kernel-shark/trace-plot-task.c (100%)
 rename trace-plot.c => kernel-shark/trace-plot.c (100%)
 rename trace-view-main.c => kernel-shark/trace-view-main.c (100%)
 rename trace-view-store.c => kernel-shark/trace-view-store.c (100%)
 rename trace-view.c => kernel-shark/trace-view.c (100%)
 rename trace-xml.c => kernel-shark/trace-xml.c (100%)
 create mode 100644 lib/trace-cmd/Makefile
 rename trace-hash-local.h => lib/trace-cmd/include/trace-hash-local.h (100%)
 rename trace-blk-hack.c => lib/trace-cmd/trace-blk-hack.c (100%)
 rename trace-ftrace.c => lib/trace-cmd/trace-ftrace.c (100%)
 rename trace-hash.c => lib/trace-cmd/trace-hash.c (100%)
 rename trace-hooks.c => lib/trace-cmd/trace-hooks.c (100%)
 rename trace-input.c => lib/trace-cmd/trace-input.c (100%)
 rename trace-recorder.c => lib/trace-cmd/trace-recorder.c (100%)
 rename trace-util.c => lib/trace-cmd/trace-util.c (100%)
 create mode 100644 lib/traceevent/Makefile
 rename event-parse.c => lib/traceevent/event-parse.c (100%)
 rename event-plugin.c => lib/traceevent/event-plugin.c (100%)
 rename event-utils.h => lib/traceevent/include/event-utils.h (100%)
 rename kbuffer-parse.c => lib/traceevent/kbuffer-parse.c (100%)
 rename parse-filter.c => lib/traceevent/parse-filter.c (100%)
 rename parse-utils.c => lib/traceevent/parse-utils.c (100%)
 rename str_error_r.c => lib/traceevent/str_error_r.c (100%)
 rename trace-seq.c => lib/traceevent/trace-seq.c (100%)
 create mode 100644 plugins/Makefile
 rename plugin_blk.c => plugins/plugin_blk.c (100%)
 rename plugin_cfg80211.c => plugins/plugin_cfg80211.c (100%)
 rename plugin_function.c => plugins/plugin_function.c (100%)
 rename plugin_hrtimer.c => plugins/plugin_hrtimer.c (100%)
 rename plugin_jbd2.c => plugins/plugin_jbd2.c (100%)
 rename plugin_kmem.c => plugins/plugin_kmem.c (100%)
 rename plugin_kvm.c => plugins/plugin_kvm.c (100%)
 rename plugin_mac80211.c => plugins/plugin_mac80211.c (100%)
 rename plugin_python.c => plugins/plugin_python.c (100%)
 rename plugin_sched_switch.c => plugins/plugin_sched_switch.c (100%)
 rename plugin_scsi.c => plugins/plugin_scsi.c (100%)
 rename plugin_tlb.c => plugins/plugin_tlb.c (100%)
 rename plugin_xen.c => plugins/plugin_xen.c (100%)
 create mode 100644 python/Makefile
 rename ctracecmd.i => python/ctracecmd.i (100%)
 rename ctracecmdgui.i => python/ctracecmdgui.i (100%)
 rename event-viewer.py => python/event-viewer.py (100%)
 rename tracecmd.py => python/tracecmd.py (100%)
 rename tracecmdgui.py => python/tracecmdgui.py (100%)
 create mode 100644 scripts/utils.mk
 create mode 100644 tracecmd/Makefile
 rename bug.h => tracecmd/include/bug.h (100%)
 rename list.h => tracecmd/include/list.h (100%)
 rename trace-cmd-local.h => tracecmd/include/trace-cmd-local.h (100%)
 rename trace-local.h => tracecmd/include/trace-local.h (100%)
 rename trace-msg.h => tracecmd/include/trace-msg.h (100%)
 rename trace-check-events.c => tracecmd/trace-check-events.c (100%)
 rename trace-cmd.bash => tracecmd/trace-cmd.bash (100%)
 rename trace-cmd.c => tracecmd/trace-cmd.c (100%)
 rename trace-hist.c => tracecmd/trace-hist.c (100%)
 rename trace-list.c => tracecmd/trace-list.c (100%)
 rename trace-listen.c => tracecmd/trace-listen.c (100%)
 rename trace-mem.c => tracecmd/trace-mem.c (100%)
 rename trace-msg.c => tracecmd/trace-msg.c (100%)
 rename trace-output.c => tracecmd/trace-output.c (100%)
 rename trace-profile.c => tracecmd/trace-profile.c (100%)
 rename trace-read.c => tracecmd/trace-read.c (100%)
 rename trace-record.c => tracecmd/trace-record.c (100%)
 rename trace-restore.c => tracecmd/trace-restore.c (100%)
 rename trace-show.c => tracecmd/trace-show.c (100%)
 rename trace-snapshot.c => tracecmd/trace-snapshot.c (100%)
 rename trace-split.c => tracecmd/trace-split.c (100%)
 rename trace-stack.c => tracecmd/trace-stack.c (100%)
 rename trace-stat.c => tracecmd/trace-stat.c (100%)
 rename trace-stream.c => tracecmd/trace-stream.c (100%)
 rename trace-usage.c => tracecmd/trace-usage.c (100%)

-- 
2.14.1
