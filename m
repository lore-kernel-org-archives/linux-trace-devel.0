Return-Path: <SRS0=YO3e=OC=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr720041.outbound.protection.outlook.com ([40.107.72.41]:43424
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2394868AbeKXAYR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Nov 2018 19:24:17 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 0/3] libtraceevent: Various API fixes 
Date: Fri, 23 Nov 2018 13:39:58 +0000
Message-ID: <20181123133946.16239-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch series contains few unrelated changes in=20
the library APIs. It improves the consistency of the APIs
return logic and removes a duplicated API.=20

Tzvetomir Stoyanov (3):
  tools/lib/traceevent: Remove tep_data_event_from_type() API
  tools/lib/traceevent: Changed return logic of
    tep_register_event_handler() API
  tools/lib/traceevent: Changed return logic of trace_seq_printf() and
    trace_seq_vprintf() APIs

 .../libtraceevent-reg_event_handler.txt       | 12 +++++++---
 .../libtraceevent-tseq_print.txt              |  9 ++++----
 .../Documentation/libtraceevent.txt           |  1 -
 tools/lib/traceevent/event-parse.c            | 22 +++++++------------
 tools/lib/traceevent/event-parse.h            |  6 ++++-
 tools/lib/traceevent/trace-seq.c              | 17 +++++++++-----
 6 files changed, 39 insertions(+), 28 deletions(-)

--=20
2.19.1
