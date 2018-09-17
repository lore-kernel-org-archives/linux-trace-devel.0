Return-Path: <SRS0=TioG=L7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f52.google.com ([209.85.221.52]:42278 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728158AbeIQUK4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Sep 2018 16:10:56 -0400
Received: by mail-wr1-f52.google.com with SMTP id v17-v6so17598609wrr.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Sep 2018 07:43:16 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 0/7] Add infrastructure for plugins.
Date: Mon, 17 Sep 2018 17:42:19 +0300
Message-Id: <20180917144226.8653-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The infrastructure for plugins used by the Qt-based version of KernelShark
is introduced in this series of patches. This is the last major component
of the C API. The last patch adds a plugin for dealing with "sched" events.

This is the version 3 of this series of patches. The major change
from v2 is the correction of the return type of the LOADER/RELOADER/UNLOADER
functions in src/plugins/sched_events.c [PATCH v3 7/7].

Yordan Karadzhov (VMware) (7):
  kernel-shark-qt: Add plugin infrastructure to be used by the Qt-baset
    KS.
  kernel-shark-qt: Add Plugin event handlers to session.
  kernel-shark-qt: Add C++/C conversion for args of a plugin draw
    function.
  kernel-shark-qt: Make kshark_read_at() non-static.
  kernel-shark-qt: Add src/plugins dir. to hold the source code of the
    plugins
  kernel-shark-qt: Tell Doxygen to enter ../src/plugins/
  kernel-shark-qt: Add a plugin for sched events.

 kernel-shark-qt/doc/dox_config              |   2 +-
 kernel-shark-qt/src/CMakeLists.txt          |   3 +
 kernel-shark-qt/src/KsPlugins.hpp           |  51 ++++
 kernel-shark-qt/src/libkshark-plugin.c      | 297 +++++++++++++++++++
 kernel-shark-qt/src/libkshark-plugin.h      | 171 +++++++++++
 kernel-shark-qt/src/libkshark.c             |  33 ++-
 kernel-shark-qt/src/libkshark.h             |  18 ++
 kernel-shark-qt/src/plugins/CMakeLists.txt  |  27 ++
 kernel-shark-qt/src/plugins/SchedEvents.cpp | 263 +++++++++++++++++
 kernel-shark-qt/src/plugins/sched_events.c  | 306 ++++++++++++++++++++
 kernel-shark-qt/src/plugins/sched_events.h  |  76 +++++
 11 files changed, 1244 insertions(+), 3 deletions(-)
 create mode 100644 kernel-shark-qt/src/KsPlugins.hpp
 create mode 100644 kernel-shark-qt/src/libkshark-plugin.c
 create mode 100644 kernel-shark-qt/src/libkshark-plugin.h
 create mode 100644 kernel-shark-qt/src/plugins/CMakeLists.txt
 create mode 100644 kernel-shark-qt/src/plugins/SchedEvents.cpp
 create mode 100644 kernel-shark-qt/src/plugins/sched_events.c
 create mode 100644 kernel-shark-qt/src/plugins/sched_events.h

-- 
2.17.1
