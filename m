Return-Path: <SRS0=D2WB=J3=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:55631 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387865AbeGKNm6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Jul 2018 09:42:58 -0400
Received: by mail-wm0-f66.google.com with SMTP id v128-v6so2453736wme.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Jul 2018 06:38:34 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/6] Add visualization model for the Qt-based KernelShark
Date: Wed, 11 Jul 2018 16:38:08 +0300
Message-Id: <20180711133814.26854-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This series of patches introduces the second part of the C API used by
the Qt-based version of KernelShark. This part of the API is responsible
for the visual navigation and browsing inside the trace data.

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
 kernel-shark-qt/src/libkshark-collection.c |  719 ++++++++++++
 kernel-shark-qt/src/libkshark-model.c      | 1180 ++++++++++++++++++++
 kernel-shark-qt/src/libkshark-model.h      |  147 +++
 kernel-shark-qt/src/libkshark.c            |  285 ++++-
 kernel-shark-qt/src/libkshark.h            |  155 ++-
 9 files changed, 2650 insertions(+), 5 deletions(-)
 create mode 100644 kernel-shark-qt/examples/datahisto.c
 create mode 100644 kernel-shark-qt/src/libkshark-collection.c
 create mode 100644 kernel-shark-qt/src/libkshark-model.c
 create mode 100644 kernel-shark-qt/src/libkshark-model.h

-- 
2.17.1
