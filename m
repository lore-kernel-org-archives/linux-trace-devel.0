Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-eopbgr820084.outbound.protection.outlook.com ([40.107.82.84]:56293
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725930AbfADUG0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Jan 2019 15:06:26 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 0/2] Improve/debug the searching logic
Date: Fri, 4 Jan 2019 20:06:19 +0000
Message-ID: <20190104200559.24471-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Two patches aiming to resolve the known issues in the searching
inside the trace data.

Yordan Karadzhov (2):
  kernel-shark-qt: Avoid race condition when reading data
  kernel-shark-qt: Implement State machine for searching in the data

 kernel-shark-qt/src/CMakeLists.txt         |   2 +
 kernel-shark-qt/src/KsModels.cpp           |  70 ++++--
 kernel-shark-qt/src/KsModels.hpp           |  39 ++--
 kernel-shark-qt/src/KsSearchFSM.cpp        | 232 ++++++++++++++++++++
 kernel-shark-qt/src/KsSearchFSM.hpp        | 209 ++++++++++++++++++
 kernel-shark-qt/src/KsTraceViewer.cpp      | 241 +++++++--------------
 kernel-shark-qt/src/KsTraceViewer.hpp      |  32 ++-
 kernel-shark-qt/src/libkshark.c            |  74 ++++---
 kernel-shark-qt/src/libkshark.h            |   3 -
 kernel-shark-qt/src/plugins/sched_events.c |   6 +-
 10 files changed, 650 insertions(+), 258 deletions(-)
 create mode 100644 kernel-shark-qt/src/KsSearchFSM.cpp
 create mode 100644 kernel-shark-qt/src/KsSearchFSM.hpp

--=20
2.17.1
