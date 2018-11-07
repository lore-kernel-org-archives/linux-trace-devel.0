Return-Path: <SRS0=o0t1=NS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-bl2nam02on0062.outbound.protection.outlook.com ([104.47.38.62]:11903
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727546AbeKHBpf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Nov 2018 20:45:35 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 0/8] New/improved KernelShark plugins
Date: Wed, 7 Nov 2018 16:14:31 +0000
Message-ID: <20181107161410.22507-1-ykaradzhov@vmware.com>
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

Yordan Karadzhov (8):
  kernel-shark-qt: Reset the second pass hash when reloading Sched
    plugin
  kernel-shark-qt: Improve the plotting logic of the Sched event plugin
  kernel-shark-qt: Update the visualization model before plotting new
    graphs
  kernel-shark-qt: Add "Missed events" custom kshark_entry
  kernel-shark-qt: Add instrumentation for "Missed events" to the model
  kernel-shark-qt: Add tot_count field to the model descriptor
  kernel-shark-qt: Add "Missed events" plugin for KernelShark
  kernel-shark-qt: Update Sched Events plugin

 kernel-shark-qt/src/KsGLWidget.cpp           |   2 +
 kernel-shark-qt/src/libkshark-model.c        |  67 +++++++
 kernel-shark-qt/src/libkshark-model.h        |  15 ++
 kernel-shark-qt/src/libkshark.c              | 196 +++++++++++++++----
 kernel-shark-qt/src/libkshark.h              |  16 ++
 kernel-shark-qt/src/plugins/CMakeLists.txt   |   6 +-
 kernel-shark-qt/src/plugins/MissedEvents.cpp | 149 ++++++++++++++
 kernel-shark-qt/src/plugins/SchedEvents.cpp  | 171 +++++++---------
 kernel-shark-qt/src/plugins/missed_events.c  |  41 ++++
 kernel-shark-qt/src/plugins/missed_events.h  |  30 +++
 kernel-shark-qt/src/plugins/sched_events.c   |  54 +++--
 kernel-shark-qt/src/plugins/sched_events.h   |  15 +-
 12 files changed, 615 insertions(+), 147 deletions(-)
 create mode 100644 kernel-shark-qt/src/plugins/MissedEvents.cpp
 create mode 100644 kernel-shark-qt/src/plugins/missed_events.c
 create mode 100644 kernel-shark-qt/src/plugins/missed_events.h

--=20
2.17.1
