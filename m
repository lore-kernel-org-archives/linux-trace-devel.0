Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5553CC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 18:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3609C2075C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 18:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfBVSFw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 13:05:52 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34922 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfBVSFs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 13:05:48 -0500
Received: by mail-wm1-f67.google.com with SMTP id y15so2791314wma.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 10:05:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e7vNAgdfIx/4vQ4CqMbG+dM+t3UpAYqIhNR7wXHxReg=;
        b=HYVmE9noTTUhoGTGh+3DGVgeHR34fAh+D3yRKlnaXIyK0sByf8R7szl8ACmgDO1L6b
         a13QSyyiObGjFJVTxZYmWwziqdr7cBuwXTyGq2YxFU9Ne8U1mHDDEhqSFA4agwvsJnxR
         z9cBHwIPI++cdlLUncFt3D8J1JsEoNhAad5wd7ISEy9VHigJ4uf5ms3IryoX5k+ElHvC
         Bu4CnNz+B5YKnZkYjlfIFCVAJtz+gQ58KP78KejjAMaj95TysRkOuBa5OMYivZzXgMdi
         LmqXdO5hEZXS8lxH4KfiJIa93w94/BA8yRfHSTsLKMUXh0MJB04o821f/AVfI6YqSQxW
         rnOg==
X-Gm-Message-State: AHQUAuY/vLOA8bqynHJzby/zXPbxTmQKtahl1EnJcSoaYCbrcPM4C6+Z
        FVBLfuHbSAP4za5lN8IqGu2psuM=
X-Google-Smtp-Source: AHgI3IaMqQ+S2q1xHVbvicyFjje1Exgzzk8wAtQrUB67o58bHGqvU7Rav9g9jlUleDTYQyZaI8sC9A==
X-Received: by 2002:a1c:4009:: with SMTP id n9mr3212088wma.132.1550858745885;
        Fri, 22 Feb 2019 10:05:45 -0800 (PST)
Received: from localhost.localdomain ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id c18sm1320678wre.32.2019.02.22.10.05.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 10:05:45 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v8 00/13] Add VM kernel tracing over vsockets and FIFOs
Date:   Fri, 22 Feb 2019 20:05:26 +0200
Message-Id: <20190222180539.27439-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset adds support for tracing guest kernels to trace-cmd.

The first two patches in the series are minor cleanups which can be merged
separately.

Changes in v8:
 - refactored make_dir function per Steven's review feedback

Changes in v7:
 - fixed potential memory leak in add_arg()
 - call msg_free() in tracecmd_msg_recv_trace_req() eventhough we're stealing
   the message buffer
 - added is_guest and is_agent macros and use throughout tracecmd_record.c
   instead of testing instance->flags bits
 - avoid memory allocation in make_dir()

Changes in v6:
 - added specialized data transfer path over FIFOs making single splice() per
   iteration
 - made tracecmd_msg_recv_trace_req/tracecmd_msg_recv_trace_resp more defensive
   to invalid messages

Changes in v5:
 - add FIFOs transport for tracing data
 - fixed a bug in tracecmd_msg_wait_close

Changes in v4:
 - detect and use splice(2) on vsock sockets if possible
 - switch port numbers to unsigned int
 - trace-cmd record --date flag is now set for all guests if provided by the user
 - removed grow_cap and exponential buffer size growth

Changes in v3:
 - addressed Steven's feedback
 - detect and disable guest tracing if <linux/vm_sockets.h> is not available
 - the --date flag is now treated as global for all guest instances
 - fixed a bug that caused --date to be ignored for host tracing data when tracing guests

Changes in v2:
 - rebased on top of protocol V3
 - fixed system clock timestamps with the --date flag


Slavomir Kaslev (12):
  trace-cmd: Minor cleanup in tracecmd_start_recording()
  trace-cmd: Minor cleanup in print_stat()
  trace-cmd: Add tracecmd_create_recorder_virt function
  trace-cmd: Add TRACE_REQ and TRACE_RESP messages
  trace-cmd: Add buffer instance flags for tracing in guest and agent
    context
  trace-cmd: Add VM kernel tracing over vsockets transport
  trace-cmd: Use splice(2) for vsockets if available
  trace-cmd: Add `trace-cmd setup-guest` command
  trace-cmd: Try to autodetect number of guest CPUs in setup-guest if
    not specified
  trace-cmd: Add setup-guest flag for attaching FIFOs to the guest VM
    config
  trace-cmd: Add splice() recording from FIFO without additional pipe
    buffer
  trace-cmd: Add VM tracing over FIFOs transport

Steven Rostedt (VMware) (1):
  trace-cmd: Detect if vsockets are available

 Makefile                       |   7 +
 include/trace-cmd/trace-cmd.h  |  16 +-
 lib/trace-cmd/trace-recorder.c | 140 ++++--
 tracecmd/Makefile              |   7 +-
 tracecmd/include/trace-local.h |  29 ++
 tracecmd/trace-agent.c         | 257 +++++++++++
 tracecmd/trace-cmd.c           |   4 +
 tracecmd/trace-msg.c           | 219 ++++++++-
 tracecmd/trace-record.c        | 779 ++++++++++++++++++++++++++++++---
 tracecmd/trace-setup-guest.c   | 247 +++++++++++
 tracecmd/trace-usage.c         |  22 +-
 11 files changed, 1639 insertions(+), 88 deletions(-)
 create mode 100644 tracecmd/trace-agent.c
 create mode 100644 tracecmd/trace-setup-guest.c

-- 
2.19.1

