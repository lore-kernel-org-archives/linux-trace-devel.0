Return-Path: <SRS0=wogL=LF=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46114 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728958AbeHVTHT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Aug 2018 15:07:19 -0400
Received: by mail-wr1-f66.google.com with SMTP id a108-v6so1965984wrc.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Aug 2018 08:41:55 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/5] Add drawing instrumentation to be used by the Qt-based KernelShark
Date: Wed, 22 Aug 2018 18:41:35 +0300
Message-Id: <20180822154140.3748-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The KernelShark plotting library is introduced in this series of patches.
The library will be used  by the GUI to draw CPU and Task Graphs. This is
also the first time KernelShark enters the world of C++.

Yordan Karadzhov (VMware) (5):
  kernel-shark-qt: Add OpenGL/GLUT as a third party dependency.
  kernel-shark-qt: Add basic instruments for OpenGL plotting.
  kernel-shark-qt: Add C++ API for drawing of Graphs
  kernel-shark-qt: Add an example showing how to draw shapes and Graphs.
  kernel-shark-qt: Version 0.8.0

 kernel-shark-qt/CMakeLists.txt          |    7 +-
 kernel-shark-qt/README                  |    2 +
 kernel-shark-qt/examples/CMakeLists.txt |    4 +
 kernel-shark-qt/examples/dataplot.cpp   |  213 +++++
 kernel-shark-qt/src/CMakeLists.txt      |   14 +
 kernel-shark-qt/src/KsPlotTools.cpp     | 1009 +++++++++++++++++++++++
 kernel-shark-qt/src/KsPlotTools.hpp     |  440 ++++++++++
 kernel-shark-qt/src/libkshark-plot.c    |  212 +++++
 kernel-shark-qt/src/libkshark-plot.h    |   69 ++
 9 files changed, 1968 insertions(+), 2 deletions(-)
 create mode 100644 kernel-shark-qt/examples/dataplot.cpp
 create mode 100644 kernel-shark-qt/src/KsPlotTools.cpp
 create mode 100644 kernel-shark-qt/src/KsPlotTools.hpp
 create mode 100644 kernel-shark-qt/src/libkshark-plot.c
 create mode 100644 kernel-shark-qt/src/libkshark-plot.h

-- 
2.17.1
