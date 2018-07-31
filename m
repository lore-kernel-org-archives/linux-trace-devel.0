Return-Path: <SRS0=gflo=KP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:52631 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732160AbeGaPdo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 Jul 2018 11:33:44 -0400
Received: by mail-wm0-f68.google.com with SMTP id o11-v6so3170037wmh.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 Jul 2018 06:53:18 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 0/7]  Add visualization model for the Qt-based KernelShark
Date: Tue, 31 Jul 2018 16:52:41 +0300
Message-Id: <20180731135248.30587-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This series of patches introduces the second part of the C API used by
the Qt-based version of KernelShark. This part of the API is responsible
for the visual navigation and browsing inside the trace data.

This is the second version of this series of patches.
Major changes from v1 are:

[1/7] New patch. Changes the type of the fields of struct kshark_entry.

[2/7], [3/7] and [5/7 ] This version of the patchs contains a number of
improvements suggested by Steven Rostedt in his review. Thanks Steven!


Yordan Karadzhov (VMware) (7):
  kernel-shark-qt: Change the type of the fields in struct kshark_entry
  kernel-shark-qt: Add generic instruments for searching inside the
    trace data
  kernel-shark-qt: Introduce the visualization model used by the
    Qt-based KS
  kernel-shark-qt: Add an example showing how to manipulate the Vis.
    model.
  kernel-shark-qt: Define Data collections
  kernel-shark-qt: Make the Vis. model use Data collections.
  kernel-shark-qt: Changed the KernelShark version identifier.

 kernel-shark-qt/CMakeLists.txt             |    2 +-
 kernel-shark-qt/examples/CMakeLists.txt    |    4 +
 kernel-shark-qt/examples/datahisto.c       |  159 +++
 kernel-shark-qt/src/CMakeLists.txt         |    4 +-
 kernel-shark-qt/src/libkshark-collection.c |  828 ++++++++++++++
 kernel-shark-qt/src/libkshark-model.c      | 1174 ++++++++++++++++++++
 kernel-shark-qt/src/libkshark-model.h      |  152 +++
 kernel-shark-qt/src/libkshark.c            |  250 ++++-
 kernel-shark-qt/src/libkshark.h            |  173 ++-
 9 files changed, 2738 insertions(+), 8 deletions(-)
 create mode 100644 kernel-shark-qt/examples/datahisto.c
 create mode 100644 kernel-shark-qt/src/libkshark-collection.c
 create mode 100644 kernel-shark-qt/src/libkshark-model.c
 create mode 100644 kernel-shark-qt/src/libkshark-model.h

-- 
2.17.1
