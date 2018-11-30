Return-Path: <SRS0=EnxC=OJ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr740058.outbound.protection.outlook.com ([40.107.74.58]:6592
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726127AbeLACwW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Nov 2018 21:52:22 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 0/2] Make Sched event plugin use its own data collections
Date: Fri, 30 Nov 2018 15:42:35 +0000
Message-ID: <20181130154211.4575-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

These two patches aim to restore the log(n) time complexity of
the latency plotting, by adding Data Collections for Sched events.

Steven, please try playing with this modification before applying it.
If you can test this, when doing some real work this would be great.

Yordan Karadzhov (2):
  kernel-shark-qt: Add a method for adding a new collection to a list
  kernel-shark-qt: Make Sched event plugin use its own data collections

 kernel-shark-qt/src/libkshark-collection.c  | 45 ++++++++++++++++++++-
 kernel-shark-qt/src/libkshark.c             |  1 +
 kernel-shark-qt/src/libkshark.h             |  9 +++++
 kernel-shark-qt/src/plugins/SchedEvents.cpp | 33 ++++++---------
 kernel-shark-qt/src/plugins/sched_events.c  | 21 ++++++++++
 kernel-shark-qt/src/plugins/sched_events.h  |  6 +++
 6 files changed, 93 insertions(+), 22 deletions(-)

--=20
2.17.1
