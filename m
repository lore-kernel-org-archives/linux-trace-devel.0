Return-Path: <SRS0=EnxC=OJ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr740071.outbound.protection.outlook.com ([40.107.74.71]:44320
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726084AbeLAAWZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Nov 2018 19:22:25 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 0/2] convert traceevent into a thread safe library
Date: Fri, 30 Nov 2018 13:13:06 +0000
Message-ID: <20181130131254.32621-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This short patch series begins tranformation of libtraceevent into a
thread safe library. It implements per thread local storage for=20
tep->last_event cache, and converts input_buf, input_buf_ptr
and input_buf_siz internal variables to be thread specific.

Tzvetomir Stoyanov (2):
  tools/lib/traceevent: make libtraceevent thread safe
  tools/lib/traceevent: make few libtraceevent internal variables to be
    per thread

 tools/lib/traceevent/Build                |  1 +
 tools/lib/traceevent/event-parse-local.h  | 15 ++++--
 tools/lib/traceevent/event-parse-thread.c | 63 +++++++++++++++++++++++
 tools/lib/traceevent/event-parse.c        | 45 ++++++++--------
 4 files changed, 100 insertions(+), 24 deletions(-)
 create mode 100644 tools/lib/traceevent/event-parse-thread.c

--=20
2.19.1
