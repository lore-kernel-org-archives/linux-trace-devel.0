Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-cys01nam02on0068.outbound.protection.outlook.com ([104.47.37.68]:9040
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725752AbeKJFca (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 10 Nov 2018 00:32:30 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 0/8] New/improved KernelShark plugins
Date: Fri, 9 Nov 2018 19:50:23 +0000
Message-ID: <20181109195004.25455-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This series of patches combines a development which originally aimed to
make the drawing logic of the Sched event plugin more robust and easy
to understand. It turned out that this is not possible without
introducing custom KernelShark entries for "Missed events".

This is the second version of this series of patches.
Major changes from v1 are:

[2/8] The red box showing the time the task was preempted is open only if
the prev_state of the sched_switch event is "R" (val & 0xff =3D=3D 0).

[3/8] The call of KsGraphModel::update() is moved from
KsGLWidget::_makeGraphs to KsTraceGraph::_selfUpdate(). This is done becaus=
e
the first version of the patch can cause infinit recursion in som cases.


Yordan Karadzhov (8):
  kernel-shark-qt: Reset the second pass hash when reloading Sched
    plugin
  kernel-shark-qt: Improve the plotting logic of the Sched event plugin
  kernel-shark-qt: Update the visualization model when updating Graphs
  kernel-shark-qt: Add "Missed events" custom kshark_entry
  kernel-shark-qt: Add instrumentation for "Missed events" to the model
  kernel-shark-qt: Add tot_count field to the model descriptor
  kernel-shark-qt: Add "Missed events" plugin for KernelShark
  kernel-shark-qt: Update Sched Events plugin

 kernel-shark-qt/src/KsTraceGraph.cpp         |   1 +
 kernel-shark-qt/src/libkshark-model.c        |  67 +++++++
 kernel-shark-qt/src/libkshark-model.h        |  15 ++
 kernel-shark-qt/src/libkshark.c              | 196 +++++++++++++++----
 kernel-shark-qt/src/libkshark.h              |  16 ++
 kernel-shark-qt/src/plugins/CMakeLists.txt   |   6 +-
 kernel-shark-qt/src/plugins/MissedEvents.cpp | 149 ++++++++++++++
 kernel-shark-qt/src/plugins/SchedEvents.cpp  | 174 ++++++++--------
 kernel-shark-qt/src/plugins/missed_events.c  |  41 ++++
 kernel-shark-qt/src/plugins/missed_events.h  |  30 +++
 kernel-shark-qt/src/plugins/sched_events.c   |  65 ++++--
 kernel-shark-qt/src/plugins/sched_events.h   |  18 +-
 12 files changed, 630 insertions(+), 148 deletions(-)
 create mode 100644 kernel-shark-qt/src/plugins/MissedEvents.cpp
 create mode 100644 kernel-shark-qt/src/plugins/missed_events.c
 create mode 100644 kernel-shark-qt/src/plugins/missed_events.h

--=20
2.17.1
