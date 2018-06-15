Return-Path: <SRS0=1RmU=JB=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:40525 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752884AbeFOVZD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Jun 2018 17:25:03 -0400
Received: by mail-wr0-f193.google.com with SMTP id l41-v6so11159498wre.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Jun 2018 14:25:03 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/4]trace-filter: Detach trace-filter-hash from KS GUI.
Date: Sat, 16 Jun 2018 00:21:27 +0300
Message-Id: <20180615212131.28121-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In this series of patches, the implementation of the trace-filter-hash gets
detached from the Ker GUI, allowing the tools to be used by an user
application. This modifications are a preparation for the introduction of the
Qt-base version of KernelShark. 

Yordan Karadzhov (VMware) (4):
  trace-cmd: Header files management in trace-hash.h
  trace-filter: Remove the Gtk dependency in trace-filter-hash.
  trace-filter: Change the naming convention used in trace-filter-hash
  trace-filter: Change the hashing function used when filtering

 include/trace-cmd/trace-hash.h           |   3 -
 kernel-shark/include/kernel-shark.h      |   4 +-
 kernel-shark/include/trace-filter-hash.h |  73 +++++++---
 kernel-shark/include/trace-filter.h      |  12 +-
 kernel-shark/include/trace-graph.h       |  16 +--
 kernel-shark/include/trace-view-store.h  |  12 +-
 kernel-shark/include/trace-view.h        |   4 +-
 kernel-shark/kernel-shark.c              | 100 +++++++-------
 kernel-shark/trace-filter-hash.c         | 162 ++++++++++++-----------
 kernel-shark/trace-filter.c              |  18 +--
 kernel-shark/trace-graph.c               |  49 +++----
 kernel-shark/trace-plot-cpu.c            |   1 +
 kernel-shark/trace-plot-task.c           |   1 +
 kernel-shark/trace-plot.c                |   1 +
 kernel-shark/trace-view-main.c           |  22 +--
 kernel-shark/trace-view-store.c          |  30 ++---
 kernel-shark/trace-view.c                |   4 +-
 tracecmd/trace-hist.c                    |   1 +
 tracecmd/trace-profile.c                 |   2 +
 tracecmd/trace-read.c                    |   1 +
 20 files changed, 278 insertions(+), 238 deletions(-)

-- 
2.17.1
