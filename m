Return-Path: <SRS0=NWCu=LL=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41049 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbeH1RA2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Aug 2018 13:00:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id z96-v6so1527612wrb.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Aug 2018 06:08:52 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 0/4] Add drawing instrumentation to be used by the Qt-based KernelShark
Date: Tue, 28 Aug 2018 16:08:34 +0300
Message-Id: <20180828130838.30790-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The KernelShark plotting library is introduced in this series of patches.
The library will be used by the GUI to draw CPU and Task Graphs. This is
also the first time KernelShark enters the world of C++.

This is the 3th version of this series of patches. The major change
from v2 is the debugging of the example ([PATCH 3/4]).

Yordan Karadzhov (VMware) (4):
  kernel-shark-qt: Add OpenGL/GLUT as a third party dependency.
  kernel-shark-qt: Add basic instruments for OpenGL plotting.
  kernel-shark-qt: Add C++ API for drawing of Graphs
  kernel-shark-qt: Add an example showing how to draw shapes and Graphs.

 kernel-shark-qt/CMakeLists.txt          |    3 +
 kernel-shark-qt/README                  |    2 +
 kernel-shark-qt/examples/CMakeLists.txt |    4 +
 kernel-shark-qt/examples/dataplot.cpp   |  231 +++++
 kernel-shark-qt/src/CMakeLists.txt      |   14 +
 kernel-shark-qt/src/KsPlotTools.cpp     | 1123 +++++++++++++++++++++++
 kernel-shark-qt/src/KsPlotTools.hpp     |  485 ++++++++++
 kernel-shark-qt/src/libkshark-plot.c    |  212 +++++
 kernel-shark-qt/src/libkshark-plot.h    |   69 ++
 9 files changed, 2143 insertions(+)
 create mode 100644 kernel-shark-qt/examples/dataplot.cpp
 create mode 100644 kernel-shark-qt/src/KsPlotTools.cpp
 create mode 100644 kernel-shark-qt/src/KsPlotTools.hpp
 create mode 100644 kernel-shark-qt/src/libkshark-plot.c
 create mode 100644 kernel-shark-qt/src/libkshark-plot.h

-- 
2.17.1
