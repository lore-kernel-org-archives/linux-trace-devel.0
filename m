Return-Path: <SRS0=7BWw=MC=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44761 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727029AbeITWk1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Sep 2018 18:40:27 -0400
Received: by mail-wr1-f68.google.com with SMTP id v16-v6so10118407wro.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 20 Sep 2018 09:56:03 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 0/8]  Add infrastructure for plugins.
Date: Thu, 20 Sep 2018 19:55:36 +0300
Message-Id: <20180920165544.17579-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The infrastructure for plugins used by the Qt-based version of KernelShark
is introduced in this series of patches. This is the last major component
of the C API. The last patch adds a plugin for dealing with "sched" events.

This is version 5 of this series of patches. In this version I address the
final comments made by Steven Rostedt in his review of v4. The criteria for
deciding when to start plotting latencies ([PATCH v5 8/8]) will stay as a
TODO action item.

Yordan Karadzhov (VMware) (8):
  kernel-shark-qt: Add plugin infrastructure to be used by the Qt-baset
    KS.
  kernel-shark-qt: Add Plugin event handlers to session.
  kernel-shark-qt: Add C++/C conversion for args of a plugin draw
    function.
  kernel-shark-qt: Make kshark_read_at() non-static.
  kernel-shark-qt: Remove the TODO action in kshark_read_at()
  kernel-shark-qt: Add src/plugins dir. to hold the source code of the
    plugins
  kernel-shark-qt: Tell Doxygen to enter ../src/plugins/
  kernel-shark-qt: Add a plugin for sched events.

 kernel-shark-qt/doc/dox_config              |   2 +-
 kernel-shark-qt/src/CMakeLists.txt          |   3 +
 kernel-shark-qt/src/KsPlugins.hpp           |  51 ++++
 kernel-shark-qt/src/libkshark-plugin.c      | 290 +++++++++++++++++++
 kernel-shark-qt/src/libkshark-plugin.h      | 179 ++++++++++++
 kernel-shark-qt/src/libkshark.c             |  38 ++-
 kernel-shark-qt/src/libkshark.h             |  20 ++
 kernel-shark-qt/src/plugins/CMakeLists.txt  |  27 ++
 kernel-shark-qt/src/plugins/SchedEvents.cpp | 263 +++++++++++++++++
 kernel-shark-qt/src/plugins/sched_events.c  | 305 ++++++++++++++++++++
 kernel-shark-qt/src/plugins/sched_events.h  |  76 +++++
 11 files changed, 1248 insertions(+), 6 deletions(-)
 create mode 100644 kernel-shark-qt/src/KsPlugins.hpp
 create mode 100644 kernel-shark-qt/src/libkshark-plugin.c
 create mode 100644 kernel-shark-qt/src/libkshark-plugin.h
 create mode 100644 kernel-shark-qt/src/plugins/CMakeLists.txt
 create mode 100644 kernel-shark-qt/src/plugins/SchedEvents.cpp
 create mode 100644 kernel-shark-qt/src/plugins/sched_events.c
 create mode 100644 kernel-shark-qt/src/plugins/sched_events.h

-- 
2.17.1
