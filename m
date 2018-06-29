Return-Path: <SRS0=62yJ=JP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:41592 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935115AbeF2P0N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Jun 2018 11:26:13 -0400
Received: by mail-wr0-f196.google.com with SMTP id h10-v6so9217095wrq.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jun 2018 08:26:12 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 0/9] Introduce the basic part of the C API of KS-1.0
Date: Fri, 29 Jun 2018 18:25:32 +0300
Message-Id: <20180629152541.10109-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This series of patches introduces the first part of the C API used
by the Qt-based version of KernelShark. This part of the API is
responsible for loading trace data files and for filtering of this
data. Examples, demonstrationg the usage of this part of the API are
added as well.

This is version 3 of this series of patches.
Major changes from v2 are:

In all patches: All function description comments are moved from the
header file to the source file.

[3/9] The linked list of Tasks is replaced by a hash table.
This version of the patch contains a number of improvements
suggested by Steven Rostedt in his review. Thanks Steven!

Yordan Karadzhov (VMware) (9):
  kernel-shark-qt: Add Cmake build system for the Qt based KernelShark
  kernel-shark-qt: Automatic generation of doxygen documentation
  kernel-shark-qt: Add API for loading trace.dat files
  kernel-shark-qt: Add an example showing how to load trace data
  kernel-shark-qt: Add a README file to trace-cmd/kernel-shark-qt
  kernel-shark-qt: Add filtering to the C API of KernelShark
  kernel-shark-qt: Add an example showing how to filter trace data
  kernel-shark-qt: Add Advanced filter to the session context.
  kernel-shark-qt: Add example of advanded filtering

 kernel-shark-qt/CMakeLists.txt           |  53 ++
 kernel-shark-qt/README                   |  44 ++
 kernel-shark-qt/build/FindTraceCmd.cmake |  70 ++
 kernel-shark-qt/build/cmake_clean.sh     |  11 +
 kernel-shark-qt/build/deff.h.cmake       |  20 +
 kernel-shark-qt/doc/dox_config           |  15 +
 kernel-shark-qt/examples/CMakeLists.txt  |   9 +
 kernel-shark-qt/examples/datafilter.c    | 152 +++++
 kernel-shark-qt/examples/dataload.c      |  86 +++
 kernel-shark-qt/src/CMakeLists.txt       |  13 +
 kernel-shark-qt/src/libkshark.c          | 794 +++++++++++++++++++++++
 kernel-shark-qt/src/libkshark.h          | 197 ++++++
 12 files changed, 1464 insertions(+)
 create mode 100644 kernel-shark-qt/CMakeLists.txt
 create mode 100644 kernel-shark-qt/README
 create mode 100644 kernel-shark-qt/build/FindTraceCmd.cmake
 create mode 100755 kernel-shark-qt/build/cmake_clean.sh
 create mode 100644 kernel-shark-qt/build/deff.h.cmake
 create mode 100644 kernel-shark-qt/doc/dox_config
 create mode 100644 kernel-shark-qt/examples/CMakeLists.txt
 create mode 100644 kernel-shark-qt/examples/datafilter.c
 create mode 100644 kernel-shark-qt/examples/dataload.c
 create mode 100644 kernel-shark-qt/src/CMakeLists.txt
 create mode 100644 kernel-shark-qt/src/libkshark.c
 create mode 100644 kernel-shark-qt/src/libkshark.h

-- 
2.17.1
