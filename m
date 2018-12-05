Return-Path: <SRS0=ZRv/=OO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710060.outbound.protection.outlook.com ([40.107.71.60]:45856
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727025AbeLEJWO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Dec 2018 04:22:14 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 0/2] convert traceevent into a thread safe library
Date: Wed, 5 Dec 2018 09:22:11 +0000
Message-ID: <20181205092200.2291-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

thread safe library. It implements per thread local storage for=20
tep->last_event cache, and converts input_buf, input_buf_ptr
and input_buf_siz internal variables to be thread specific.

[backported from Linux kernel tree]

Tzvetomir Stoyanov (2):
  tools/lib/traceevent: make libtraceevent thread safe
  tools/lib/traceevent: make few libtraceevent internal variables to be
    per thread

 lib/traceevent/Makefile             |  1 +
 lib/traceevent/event-parse-local.h  | 15 +++++--
 lib/traceevent/event-parse-thread.c | 63 +++++++++++++++++++++++++++++
 lib/traceevent/event-parse.c        | 45 +++++++++++----------
 4 files changed, 100 insertions(+), 24 deletions(-)
 create mode 100644 lib/traceevent/event-parse-thread.c

--=20
2.19.2
