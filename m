Return-Path: <SRS0=lMx0=LH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:55239 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbeHXR42 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Aug 2018 13:56:28 -0400
Received: by mail-wm0-f67.google.com with SMTP id c14-v6so1764901wmb.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Aug 2018 07:21:35 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 0/4] Add drawing instrumentation to be used by the Qt-based KernelShark
Date: Fri, 24 Aug 2018 17:21:12 +0300
Message-Id: <20180824142116.21339-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The KernelShark plotting library is introduced in this series of patches.
The library will be used by the GUI to draw CPU and Task Graphs. This is
also the first time KernelShark enters the world of C++.

This is the second version of this series of patches. The major change
from v1 is the modified inheritance tree of the classes in KsPlotTools.


Yordan Karadzhov (VMware) (4):
  kernel-shark-qt: Add OpenGL/GLUT as a third party dependency.
  kernel-shark-qt: Add basic instruments for OpenGL plotting.
  kernel-shark-qt: Add C++ API for drawing of Graphs
  kernel-shark-qt: Add an example showing how to draw shapes and Graphs.

 kernel-shark-qt/CMakeLists.txt          |    3 +
 kernel-shark-qt/README                  |    2 +
 kernel-shark-qt/examples/CMakeLists.txt |    4 +
 kernel-shark-qt/examples/dataplot.cpp   |  217 +++++
 kernel-shark-qt/src/CMakeLists.txt      |   14 +
 kernel-shark-qt/src/KsPlotTools.cpp     | 1127 +++++++++++++++++++++++
 kernel-shark-qt/src/KsPlotTools.hpp     |  465 ++++++++++
 kernel-shark-qt/src/libkshark-plot.c    |  212 +++++
 kernel-shark-qt/src/libkshark-plot.h    |   69 ++
 9 files changed, 2113 insertions(+)
 create mode 100644 kernel-shark-qt/examples/dataplot.cpp
 create mode 100644 kernel-shark-qt/src/KsPlotTools.cpp
 create mode 100644 kernel-shark-qt/src/KsPlotTools.hpp
 create mode 100644 kernel-shark-qt/src/libkshark-plot.c
 create mode 100644 kernel-shark-qt/src/libkshark-plot.h

-- 
2.17.1
