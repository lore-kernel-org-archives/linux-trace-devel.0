Return-Path: <SRS0=QejA=KV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39619 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730876AbeHFS3t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Aug 2018 14:29:49 -0400
Received: by mail-wr1-f65.google.com with SMTP id h10-v6so12920658wre.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Aug 2018 09:19:59 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 0/6] Add visualization model for the Qt-based KernelShark
Date: Mon,  6 Aug 2018 19:19:21 +0300
Message-Id: <20180806161927.11206-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This series of patches introduces the second part of the C API used by
the Qt-based version of KernelShark. This part of the API is responsible
for the visual navigation and browsing inside the trace data.

This is version 4 of this series of patches.
Major changes from v3 are:

[2/7] Corrections in the Doxygen documentation. Debugging in
ksmodel_set_upper_edge().

[4/7] Corrections in the Doxygen documentation & Change log.
Trying to eliminate the duplicated code in map_collection_back_request()
and map_collection_front_request().


Yordan Karadzhov (VMware) (6):
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
 kernel-shark-qt/src/libkshark-collection.c |  818 +++++++++++++
 kernel-shark-qt/src/libkshark-model.c      | 1224 ++++++++++++++++++++
 kernel-shark-qt/src/libkshark-model.h      |  167 +++
 kernel-shark-qt/src/libkshark.c            |  278 +++++
 kernel-shark-qt/src/libkshark.h            |  177 +++
 9 files changed, 2831 insertions(+), 2 deletions(-)
 create mode 100644 kernel-shark-qt/examples/datahisto.c
 create mode 100644 kernel-shark-qt/src/libkshark-collection.c
 create mode 100644 kernel-shark-qt/src/libkshark-model.c
 create mode 100644 kernel-shark-qt/src/libkshark-model.h

-- 
2.17.1
