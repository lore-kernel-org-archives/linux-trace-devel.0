Return-Path: <SRS0=R/5S=OM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53974 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbeLCQJw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 3 Dec 2018 11:09:52 -0500
Received: by mail-wm1-f65.google.com with SMTP id y1so6428703wmi.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 03 Dec 2018 08:09:45 -0800 (PST)
From: Slavomir Kaslev <kaslevs@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] trace-cmd: Resend record --date fix
Date: Mon,  3 Dec 2018 18:09:35 +0200
Message-Id: <20181203160937.5285-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Resending "trace-cmd record --date" fix while keeping backward compatibility.

Ideally those two patches should land together since the second one assumes that
all v3 listeners follow new behavior and don't write options in the trace file.

Slavomir Kaslev (2):
  trace-cmd: Bump protocol version to v3
  trace-cmd: Fix record --date flag when sending tracing data to a
    listener

 include/trace-cmd/trace-cmd.h |  13 ++-
 tracecmd/include/trace-msg.h  |   6 +-
 tracecmd/trace-listen.c       |  37 +++----
 tracecmd/trace-msg.c          | 187 +++++++++++++++-------------------
 tracecmd/trace-output.c       |  26 +++--
 tracecmd/trace-record.c       |  78 +++++++-------
 6 files changed, 176 insertions(+), 171 deletions(-)

-- 
2.19.1
