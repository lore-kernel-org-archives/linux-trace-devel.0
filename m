Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38785 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729641AbeLNN56 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Dec 2018 08:57:58 -0500
Received: by mail-wm1-f66.google.com with SMTP id m22so5900309wml.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Dec 2018 05:57:57 -0800 (PST)
From: Slavomir Kaslev <kaslevs@vmware.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v4 0/3] trace-cmd: Resend record --date fix
Date: Fri, 14 Dec 2018 15:57:46 +0200
Message-Id: <20181214135749.12328-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Resending "trace-cmd record --date" fix while keeping backward compatibility.

Ideally those patches should land together since the last one assumes that all
v3 listeners follow new behavior and don't write options in the trace file.

Changes in v4:
  - split tracecmd_attach_cpu_data_fd into smaller functions
  - reorder the patches per Steven's request

Changes in v3:
  - added Signed-off-by

Changes in v2:
  - split into 3 patches for easier reviewing
  - fix tracecmd_msg_recv not reading cmd_size bytes it doesn't know about

Slavomir Kaslev (3):
  trace-cmd: Prepare for protocol bump to version 3
  trace-cmd: Fix record --date flag when sending tracing data to a
    listener
  trace-cmd: Bump protocol version to v3

 include/trace-cmd/trace-cmd.h |  16 ++-
 tracecmd/include/trace-msg.h  |   6 +-
 tracecmd/trace-listen.c       |  43 +++++---
 tracecmd/trace-msg.c          | 198 +++++++++++++++-------------------
 tracecmd/trace-output.c       |  78 +++++++-------
 tracecmd/trace-record.c       |  79 +++++++-------
 6 files changed, 210 insertions(+), 210 deletions(-)

-- 
2.19.1
