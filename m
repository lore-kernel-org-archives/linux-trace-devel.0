Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710070.outbound.protection.outlook.com ([40.107.71.70]:36576
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727941AbeK2CSJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:09 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 00/17] More modifications and bug fixes toward KS 1.0
Date: Wed, 28 Nov 2018 15:16:04 +0000
Message-ID: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This series of patches continues adding various unrelated modifications
and bug fixes needed before releasing KernelShark 1.0. Some of the patches
from the previous series, which for various reasons didn't manage to move
upstream are sent again here.


Yordan Karadzhov (17):
  kernel-shark-qt: Updata Event filter mask when applaing filters to
    Graph
  kernel-shark-qt: Reprocess all CPU collections when the filtering
    changes
  kernel-shark-qt: Fix a byg in unset_event_filter_flag()
  kernel-shark qt: No error when Record authentication dialog is closed
  kernel-shark-qt: Protect all calls of tep_read_number_field()
  kernel-shark-qt: Ignore sched_wakeup events if the task is running.
  kernel-shark-qt: Fix the documentation of libkshark-model
  kernel-shark-qt: Add a method for easy retrieve of all Ids of a filter
  kernel-shark-qt: Add centralized context menu for View and Graph
    widgets
  kernel-shark-qt: Add keyboard shortcuts for deselecting the marker
  kernel-shark-qt: Sort all graphs before plotting
  kernel-shark-qt: Add CPU-based filtering to the C API
  kernel-shark-qt: Add CPU-based filtering to KsDataStore
  kernel-shark-qt: Add Hide CPU action to the Quick Context Menu
  kernel-shark-qt: Add the CPU filters to the Json config I/O
  kernel-shark-qt: Add "Hide CPU" checkbox dialog to the Main window
    menu
  kernel-shark-qt: Add the user filter mask to the Json config I/O

 kernel-shark-qt/src/CMakeLists.txt          |   2 +
 kernel-shark-qt/src/KsGLWidget.cpp          |  46 +--
 kernel-shark-qt/src/KsGLWidget.hpp          |  22 +-
 kernel-shark-qt/src/KsMainWindow.cpp        | 117 +++++++-
 kernel-shark-qt/src/KsMainWindow.hpp        |  14 +
 kernel-shark-qt/src/KsQuickContextMenu.cpp  | 302 ++++++++++++++++++++
 kernel-shark-qt/src/KsQuickContextMenu.hpp  | 142 +++++++++
 kernel-shark-qt/src/KsTraceGraph.cpp        |  96 +++++++
 kernel-shark-qt/src/KsTraceGraph.hpp        |  14 +
 kernel-shark-qt/src/KsTraceViewer.cpp       |  30 +-
 kernel-shark-qt/src/KsTraceViewer.hpp       |  32 ++-
 kernel-shark-qt/src/KsUtils.cpp             |  48 +++-
 kernel-shark-qt/src/KsUtils.hpp             |   6 +
 kernel-shark-qt/src/KsWidgetsLib.cpp        | 120 --------
 kernel-shark-qt/src/KsWidgetsLib.hpp        |  44 ---
 kernel-shark-qt/src/libkshark-configio.c    | 232 ++++++++++++---
 kernel-shark-qt/src/libkshark-model.c       |   4 +-
 kernel-shark-qt/src/libkshark.c             |  48 +++-
 kernel-shark-qt/src/libkshark.h             |  56 +++-
 kernel-shark-qt/src/plugins/SchedEvents.cpp |  15 +
 kernel-shark-qt/src/plugins/sched_events.c  |  52 ++--
 21 files changed, 1149 insertions(+), 293 deletions(-)
 create mode 100644 kernel-shark-qt/src/KsQuickContextMenu.cpp
 create mode 100644 kernel-shark-qt/src/KsQuickContextMenu.hpp

--=20
2.17.1
