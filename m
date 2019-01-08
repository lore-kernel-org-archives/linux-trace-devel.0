Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39656 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727678AbfAHPAW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Jan 2019 10:00:22 -0500
Received: by mail-pl1-f193.google.com with SMTP id 101so2014853pld.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Jan 2019 07:00:22 -0800 (PST)
From: Slavomir Kaslev <kaslevs@vmware.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v2 0/6] Add VM guest kernel tracing using vsock sockets for transport
Date: Tue,  8 Jan 2019 17:00:09 +0200
Message-Id: <20190108150015.21327-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patchset adds support for tracing guest kernels to trace-cmd.

Changes in v2:
 - rebased on top of protocol V3
 - fixed system clock timestamps with the --date flag

Slavomir Kaslev (6):
  trace-cmd: Fix indentation
  trace-cmd: Fix warnings reported by gcc 8.2
  trace-cmd: Add tracecmd_create_recorder_virt function
  trace-cmd: Simplify and fix memory leaks in tracecmd_msg_collect_data
  trace-cmd: Add TRACE_REQ and TRACE_RESP messages
  trace-cmd: Add VM kernel tracing using vsock socket for transport

 include/trace-cmd/trace-cmd.h  |  14 +
 lib/trace-cmd/trace-input.c    |   2 +-
 lib/trace-cmd/trace-recorder.c |  53 ++-
 tracecmd/Makefile              |   1 +
 tracecmd/include/trace-local.h |  19 +
 tracecmd/trace-agent.c         | 228 ++++++++++
 tracecmd/trace-cmd.c           |   1 +
 tracecmd/trace-msg.c           | 213 +++++++++-
 tracecmd/trace-read.c          |   8 +-
 tracecmd/trace-record.c        | 733 ++++++++++++++++++++++++++++-----
 tracecmd/trace-usage.c         |  11 +-
 11 files changed, 1162 insertions(+), 121 deletions(-)
 create mode 100644 tracecmd/trace-agent.c

-- 
2.19.1
