Return-Path: <SRS0=pqkA=MY=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-co1nam03on0041.outbound.protection.outlook.com ([104.47.40.41]:22067
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728537AbeJLXrA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Oct 2018 19:47:00 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 00/10] Add Qt-based GUI for KernelShark
Date: Fri, 12 Oct 2018 19:13:08 +0300
Message-Id: <20181012161318.5302-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In this series of patches the major components of the Qt-based
KernelShark GUI are introduced one by one in a sequence which follows
there internal dependence. The series ends with the introduction of
the MainWindow widget and the KernelShark executable itself.

Yordan Karadzhov (VMware) (10):
  kernel-shark-qt: Add Dual Marker for KernelShark GUI.
  kernel-shark-qt: Add model for showing trace data in a text format.
  kernel-shark-qt: Add Trace Viewer widget.
  kernel-shark-qt: Add visualization (graph) model
  kernel-shark-qt: Add widget for OpenGL rendering
  kernel-shark-qt: Add Trace Graph widget.
  kernel-shark-qt: Add dialog for Advanced filtering.
  kernel-shark-qt: Add a manager class for GUI sessions.
  kernel-shark-qt: Add Main Window widget gir the KernelShark GUI.
  kernel-shark-qt: Add KernelShark GUI executable.

 kernel-shark-qt/CMakeLists.txt               |   5 +
 kernel-shark-qt/src/CMakeLists.txt           |  23 +-
 kernel-shark-qt/src/KsAdvFilteringDialog.cpp | 440 +++++++++
 kernel-shark-qt/src/KsAdvFilteringDialog.hpp |  91 ++
 kernel-shark-qt/src/KsDualMarker.cpp         | 336 +++++++
 kernel-shark-qt/src/KsDualMarker.hpp         | 190 ++++
 kernel-shark-qt/src/KsGLWidget.cpp           | 913 +++++++++++++++++++
 kernel-shark-qt/src/KsGLWidget.hpp           | 220 +++++
 kernel-shark-qt/src/KsMainWindow.cpp         | 909 ++++++++++++++++++
 kernel-shark-qt/src/KsMainWindow.hpp         | 191 ++++
 kernel-shark-qt/src/KsModels.cpp             | 485 ++++++++++
 kernel-shark-qt/src/KsModels.hpp             | 289 ++++++
 kernel-shark-qt/src/KsSession.cpp            | 574 ++++++++++++
 kernel-shark-qt/src/KsSession.hpp            | 100 ++
 kernel-shark-qt/src/KsTraceGraph.cpp         | 690 ++++++++++++++
 kernel-shark-qt/src/KsTraceGraph.hpp         | 137 +++
 kernel-shark-qt/src/KsTraceViewer.cpp        | 655 +++++++++++++
 kernel-shark-qt/src/KsTraceViewer.hpp        | 144 +++
 kernel-shark-qt/src/kernelshark.cpp          |  93 ++
 19 files changed, 6483 insertions(+), 2 deletions(-)
 create mode 100644 kernel-shark-qt/src/KsAdvFilteringDialog.cpp
 create mode 100644 kernel-shark-qt/src/KsAdvFilteringDialog.hpp
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

-- 
2.17.1
