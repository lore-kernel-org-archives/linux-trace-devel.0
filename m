Return-Path: <SRS0=ZRv/=OO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56248 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbeLEJPd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Dec 2018 04:15:33 -0500
Received: by mail-wm1-f66.google.com with SMTP id y139so12342284wmc.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 05 Dec 2018 01:15:32 -0800 (PST)
From: Slavomir Kaslev <kaslevs@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/3] trace-cmd: Resend record --date fix
Date: Wed,  5 Dec 2018 11:15:21 +0200
Message-Id: <20181205091524.4789-1-kaslevs@vmware.com>
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

Changes v3:
- added Signed-off-by

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
