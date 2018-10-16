Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-dm3nam03on0058.outbound.protection.outlook.com ([104.47.41.58]:32513
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726778AbeJPXoK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 19:44:10 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 00/23]  Add Qt-based GUI for KernelShark
Date: Tue, 16 Oct 2018 15:52:56 +0000
Message-ID: <20181016155232.5257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In this series of patches the major components of the Qt-based
KernelShark GUI are introduced one by one in a sequence which follows
there internal dependence. The series ends with the fully functional
KernelShark GUI application.


Yordan Karadzhov (5):
  kernel-shark-qt: Fix a simple bug in KsDataStore::_freeData()
  kernel-shark-qt: Add "File exists" dialog.
  kernel-shark-qt: Fix the glitches in the preemption time visualization
  kernel-shark-qt: Add PolicyKit Configuration for kshark-record
  kernel-shark-qt: Add Record dialog to KS GUI.

Yordan Karadzhov (VMware) (18):
  kernel-shark-qt: Add Dual Marker for KernelShark GUI.
  kernel-shark-qt: Add model for showing trace data in a text format.
  kernel-shark-qt: Add Trace Viewer widget.
  kernel-shark-qt: Add visualization (graph) model
  kernel-shark-qt: Add widget for OpenGL rendering
  kernel-shark-qt: Add Trace Graph widget.
  kernel-shark-qt: Add dialog for Advanced filtering.
  kernel-shark-qt: Add a manager class for GUI sessions.
  kernel-shark-qt: Add Main Window widget for the KernelShark GUI.
  kernel-shark-qt: Add KernelShark GUI executable.
  kernel-shark-qt: Add dialog for of trace data recording
  kernel-shark-qt: Add kshark-record executable
  kernel-shark-qt: Instruct CMake to search for "pkexec"
  kernel-shark-qt: Add KernelShark icon
  kernel-shark-qt: Add kernelshark.desktop file
  kernel-shark-qt: Add make install
  kernel-shark-qt: Workaround for running as Root on Wayland
  kernel-shark-qt: Version 0.9.0

 kernel-shark-qt/CMakeLists.txt                |   15 +-
 kernel-shark-qt/bin/kshark-su-record          |    8 +
 kernel-shark-qt/build/cmake_clean.sh          |    1 +
 kernel-shark-qt/build/cmake_uninstall.sh      |   17 +
 kernel-shark-qt/build/deff.h.cmake            |    3 +
 kernel-shark-qt/build/ks.desktop.cmake        |    9 +
 kernel-shark-qt/icons/ksharkicon.png          |  Bin 0 -> 80474 bytes
 .../org.freedesktop.kshark-record.policy      |   18 +
 kernel-shark-qt/src/CMakeLists.txt            |   44 +-
 kernel-shark-qt/src/KsAdvFilteringDialog.cpp  |  440 +++++++
 kernel-shark-qt/src/KsAdvFilteringDialog.hpp  |   91 ++
 kernel-shark-qt/src/KsCaptureDialog.cpp       |  562 +++++++++
 kernel-shark-qt/src/KsCaptureDialog.hpp       |  185 +++
 kernel-shark-qt/src/KsDualMarker.cpp          |  336 ++++++
 kernel-shark-qt/src/KsDualMarker.hpp          |  190 +++
 kernel-shark-qt/src/KsGLWidget.cpp            |  913 +++++++++++++++
 kernel-shark-qt/src/KsGLWidget.hpp            |  220 ++++
 kernel-shark-qt/src/KsMainWindow.cpp          | 1029 +++++++++++++++++
 kernel-shark-qt/src/KsMainWindow.hpp          |  213 ++++
 kernel-shark-qt/src/KsModels.cpp              |  485 ++++++++
 kernel-shark-qt/src/KsModels.hpp              |  289 +++++
 kernel-shark-qt/src/KsSession.cpp             |  574 +++++++++
 kernel-shark-qt/src/KsSession.hpp             |  100 ++
 kernel-shark-qt/src/KsTraceGraph.cpp          |  690 +++++++++++
 kernel-shark-qt/src/KsTraceGraph.hpp          |  137 +++
 kernel-shark-qt/src/KsTraceViewer.cpp         |  657 +++++++++++
 kernel-shark-qt/src/KsTraceViewer.hpp         |  149 +++
 kernel-shark-qt/src/KsUtils.cpp               |    2 +
 kernel-shark-qt/src/KsWidgetsLib.cpp          |   29 +
 kernel-shark-qt/src/KsWidgetsLib.hpp          |    7 +
 kernel-shark-qt/src/kernelshark.cpp           |   93 ++
 kernel-shark-qt/src/kshark-record.cpp         |   29 +
 kernel-shark-qt/src/plugins/CMakeLists.txt    |    3 +
 kernel-shark-qt/src/plugins/SchedEvents.cpp   |  126 +-
 kernel-shark-qt/src/plugins/sched_events.c    |   13 +-
 35 files changed, 7628 insertions(+), 49 deletions(-)
 create mode 100755 kernel-shark-qt/bin/kshark-su-record
 create mode 100755 kernel-shark-qt/build/cmake_uninstall.sh
 create mode 100644 kernel-shark-qt/build/ks.desktop.cmake
 create mode 100644 kernel-shark-qt/icons/ksharkicon.png
 create mode 100644 kernel-shark-qt/org.freedesktop.kshark-record.policy
 create mode 100644 kernel-shark-qt/src/KsAdvFilteringDialog.cpp
 create mode 100644 kernel-shark-qt/src/KsAdvFilteringDialog.hpp
 create mode 100644 kernel-shark-qt/src/KsCaptureDialog.cpp
 create mode 100644 kernel-shark-qt/src/KsCaptureDialog.hpp
 create mode 100644 kernel-shark-qt/src/KsDualMarker.cpp
 create mode 100644 kernel-shark-qt/src/KsDualMarker.hpp
 create mode 100644 kernel-shark-qt/src/KsGLWidget.cpp
 create mode 100644 kernel-shark-qt/src/KsGLWidget.hpp
 create mode 100644 kernel-shark-qt/src/KsMainWindow.cpp
 create mode 100644 kernel-shark-qt/src/KsMainWindow.hpp
 create mode 100644 kernel-shark-qt/src/KsModels.cpp
 create mode 100644 kernel-shark-qt/src/KsModels.hpp
 create mode 100644 kernel-shark-qt/src/KsSession.cpp
 create mode 100644 kernel-shark-qt/src/KsSession.hpp
 create mode 100644 kernel-shark-qt/src/KsTraceGraph.cpp
 create mode 100644 kernel-shark-qt/src/KsTraceGraph.hpp
 create mode 100644 kernel-shark-qt/src/KsTraceViewer.cpp
 create mode 100644 kernel-shark-qt/src/KsTraceViewer.hpp
 create mode 100644 kernel-shark-qt/src/kernelshark.cpp
 create mode 100644 kernel-shark-qt/src/kshark-record.cpp

--=20
2.17.1
