Return-Path: <SRS0=S9Jt=ON=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f53.google.com ([209.85.221.53]:37250 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbeLDKXc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 Dec 2018 05:23:32 -0500
Received: by mail-wr1-f53.google.com with SMTP id j10so15297248wru.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 04 Dec 2018 02:23:31 -0800 (PST)
From: Slavomir Kaslev <kaslevs@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/3] trace-cmd: Resend record --date fix
Date: Tue,  4 Dec 2018 12:23:17 +0200
Message-Id: <20181204102320.31609-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Resending "trace-cmd record --date" fix while keeping backward compatibility.

Ideally those patches should land together since the last one assumes that all
v3 listeners follow new behavior and don't write options in the trace file.

Changes v2:
- split into 3 patches for easier reviewing
- fix tracecmd_msg_recv not reading cmd_size bytes it doesn't know about

Slavomir Kaslev (3):
  trace-cmd: Prepare for protocol bump to version 3
  trace-cmd: Bump protocol version to v3
  trace-cmd: Fix record --date flag when sending tracing data to a
    listener

 include/trace-cmd/trace-cmd.h |  13 ++-
 tracecmd/include/trace-msg.h  |   6 +-
 tracecmd/trace-listen.c       |  27 ++---
 tracecmd/trace-msg.c          | 198 +++++++++++++++-------------------
 tracecmd/trace-output.c       |  26 +++--
 tracecmd/trace-record.c       |  78 +++++++-------
 6 files changed, 173 insertions(+), 175 deletions(-)

-- 
2.19.1
