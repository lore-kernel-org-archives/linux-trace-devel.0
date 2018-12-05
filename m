Return-Path: <SRS0=ZRv/=OO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr770055.outbound.protection.outlook.com ([40.107.77.55]:6363
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726889AbeLEJVt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Dec 2018 04:21:49 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 0/6]  tools/lib/traceevent: Various changes in libtraceevent
 APIs
Date: Wed, 5 Dec 2018 09:21:45 +0000
Message-ID: <20181205092134.2214-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch series includes changes, related to transformation of=20
traceevent into a library:
 Renamed few libtracevent APIs.=20
 Introduced new API: tep_get_ref()
 Added support for pkg-config infrastructure

[backported from Linux kernel tree]

Tzvetomir Stoyanov (6):
  tools lib traceevent: Implement new API tep_get_ref()
  tools lib traceevent, perf tools: Rename 'struct tep_event_format' to
    'struct tep_event'
  tools lib traceevent: Rename tep_free_format() to tep_free_event()
  tools lib traceevent: traceevent API cleanup
  tools lib traceevent: Added support for pkg-config
  tools lib traceevent: Install trace-seq.h API header file

 Makefile                                     |  47 ++++-
 include/trace-cmd/trace-cmd.h                |   2 +-
 include/traceevent/event-parse.h             |  76 +++----
 kernel-shark-qt/examples/datafilter.c        |   2 +-
 kernel-shark-qt/src/KsAdvFilteringDialog.cpp |  10 +-
 kernel-shark-qt/src/KsAdvFilteringDialog.hpp |   2 +-
 kernel-shark-qt/src/KsCaptureDialog.cpp      |   4 +-
 kernel-shark-qt/src/KsMainWindow.cpp         |   2 +-
 kernel-shark-qt/src/KsWidgetsLib.cpp         |   2 +-
 kernel-shark-qt/src/libkshark-configio.c     |   6 +-
 kernel-shark-qt/src/libkshark.c              |   8 +-
 kernel-shark-qt/src/plugins/sched_events.c   |   2 +-
 kernel-shark-qt/src/plugins/sched_events.h   |   6 +-
 kernel-shark/include/trace-view-store.h      |   6 +-
 kernel-shark/trace-capture.c                 |   6 +-
 kernel-shark/trace-dialog.c                  |   4 +-
 kernel-shark/trace-filter.c                  |  24 +--
 kernel-shark/trace-graph.c                   |   8 +-
 kernel-shark/trace-plot-cpu.c                |   4 +-
 kernel-shark/trace-plot-task.c               |   4 +-
 kernel-shark/trace-view-store.c              |   2 +-
 lib/trace-cmd/trace-blk-hack.c               |   2 +-
 lib/trace-cmd/trace-ftrace.c                 |  16 +-
 lib/trace-cmd/trace-input.c                  |  14 +-
 lib/traceevent/event-parse-api.c             |  10 +-
 lib/traceevent/event-parse-local.h           |  13 +-
 lib/traceevent/event-parse.c                 | 206 ++++++++++---------
 lib/traceevent/libtraceevent.pc.template     |  10 +
 lib/traceevent/parse-filter.c                |  42 ++--
 plugins/plugin_blk.c                         |   4 +-
 plugins/plugin_function.c                    |   2 +-
 plugins/plugin_futex.c                       |   2 +-
 plugins/plugin_hrtimer.c                     |   4 +-
 plugins/plugin_kmem.c                        |   2 +-
 plugins/plugin_kvm.c                         |  14 +-
 plugins/plugin_mac80211.c                    |  10 +-
 plugins/plugin_sched_switch.c                |   4 +-
 plugins/plugin_tlb.c                         |   2 +-
 python/ctracecmd.i                           |  10 +-
 tracecmd/trace-hist.c                        |  22 +-
 tracecmd/trace-mem.c                         |  18 +-
 tracecmd/trace-output.c                      |   6 +-
 tracecmd/trace-profile.c                     |  10 +-
 tracecmd/trace-read.c                        |  16 +-
 tracecmd/trace-record.c                      |   2 +-
 tracecmd/trace-split.c                       |  19 +-
 46 files changed, 367 insertions(+), 320 deletions(-)
 create mode 100644 lib/traceevent/libtraceevent.pc.template

--=20
2.19.2
