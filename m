Return-Path: <SRS0=ubwn=OW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr720078.outbound.protection.outlook.com ([40.107.72.78]:1332
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727618AbeLMOVk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Dec 2018 09:21:40 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 0/5] trace-cmd reset fixes
Date: Thu, 13 Dec 2018 14:21:36 +0000
Message-ID: <20181213142125.12149-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch series fixes "trace-cmd reset" command to=20
restore default values of various ftrace configurations:
tracng_on, trace_clock, set_event_pid and tracing_max_latency.
It also fixes a segfault when the command is executed with=20
"-a -d" options.

Tzvetomir Stoyanov (5):
  fix "trace-cmd reset" command to restore "tracng_on"
  fix "trace-cmd reset -a -d" segfault
  fix "trace-cmd reset" command to restore default clock
  fix "trace-cmd reset" command to restore the default value of
    set_event_pid
  fix "trace-cmd reset" command to restore the default value of
    tracing_max_latency

 tracecmd/trace-record.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

--=20
2.19.2
