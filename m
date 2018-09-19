Return-Path: <SRS0=cF1r=MB=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46935 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731742AbeISUP2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Sep 2018 16:15:28 -0400
Received: by mail-wr1-f68.google.com with SMTP id a108-v6so6046285wrc.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Sep 2018 07:37:13 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 0/7] Add infrastructure for plugins.
Date: Wed, 19 Sep 2018 17:36:50 +0300
Message-Id: <20180919143657.19472-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The infrastructure for plugins used by the Qt-based version of KernelShark
is introduced in this series of patches. This is the last major component
of the C API. The last patch adds a plugin for dealing with "sched" events.

This is version 4 of this series of patches. The major changes from v3 are
in [PATCH v4 1/7]. The procedure for registering and initializing
(unregistering and deinitializing respectively) of the plugins has been
modified. This modification is inspired by the comments and suggestions
made by Steven Rostedt during our phone conversations.

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
 kernel-shark-qt/src/libkshark-plugin.c      | 292 +++++++++++++++++++
 kernel-shark-qt/src/libkshark-plugin.h      | 179 ++++++++++++
 kernel-shark-qt/src/libkshark.c             |  33 ++-
 kernel-shark-qt/src/libkshark.h             |  18 ++
 kernel-shark-qt/src/plugins/CMakeLists.txt  |  27 ++
 kernel-shark-qt/src/plugins/SchedEvents.cpp | 263 +++++++++++++++++
 kernel-shark-qt/src/plugins/sched_events.c  | 294 ++++++++++++++++++++
 kernel-shark-qt/src/plugins/sched_events.h  |  76 +++++
 11 files changed, 1235 insertions(+), 3 deletions(-)
 create mode 100644 kernel-shark-qt/src/KsPlugins.hpp
 create mode 100644 kernel-shark-qt/src/libkshark-plugin.c
 create mode 100644 kernel-shark-qt/src/libkshark-plugin.h
 create mode 100644 kernel-shark-qt/src/plugins/CMakeLists.txt
 create mode 100644 kernel-shark-qt/src/plugins/SchedEvents.cpp
 create mode 100644 kernel-shark-qt/src/plugins/sched_events.c
 create mode 100644 kernel-shark-qt/src/plugins/sched_events.h

-- 
2.17.1
