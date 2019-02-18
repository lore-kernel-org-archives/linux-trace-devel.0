Return-Path: <SRS0=zcJY=QZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E79C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D3F621479
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbfBROy6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:54:58 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42528 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728893AbfBROy6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Feb 2019 09:54:58 -0500
Received: by mail-wr1-f65.google.com with SMTP id r5so5323238wrg.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Feb 2019 06:54:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lYcF8j9zOFnPu/Jpal3bhWmJWs646HLeTZI78cI1Yak=;
        b=fPIqxQRQ4qCh4pGpOFSUtulUXclQvjIXM4KJuf/2nQSzR8R/d9+GyP6UG0pXe8HdMb
         O+SDHJSEbS8Au/9CD4n+Jl9yHsJpNYmU5FZaTvfBWcuqgWIecIbkny2PKYfOK1A0zgrK
         wncKkdXbV1IaSg+5tzyeAF+nhrU2SdDgZOBAA0nRp60deuyGRUT7FEuDcYzNlDFLTS/a
         zKcd0VavYfIbJy2dlP5h7ohHg11Rq65/iQdq0qdeVnHzZSF7Ttoet1ApTcAJ2OZKfu/K
         CR5XvXm5JRG/UfVAfekOlGW9eZ5NqdTbHORGRu31WeSP9AT+BRoBMXr8t0k/MdSGgJPK
         LAqg==
X-Gm-Message-State: AHQUAuZYveL6oeppB4QQ8T8ekJgazOwvo/4kIGZHul65bgzXGHGFALbi
        JcfFJWKkdE5zv3Hqw+HxGA==
X-Google-Smtp-Source: AHgI3IZDUZt+JTj6vPslVB86fA1s1ruQOgi+g/5teXfK6klKdhEvwILx7IOz/qaj5kotHVBhvcNRhg==
X-Received: by 2002:adf:eb45:: with SMTP id u5mr16379074wrn.102.1550501697015;
        Mon, 18 Feb 2019 06:54:57 -0800 (PST)
Received: from localhost.localdomain ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id n11sm10172528wrw.60.2019.02.18.06.54.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Feb 2019 06:54:56 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@vmware.com, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v7 00/13] Add VM kernel tracing over vsockets and FIFOs
Date:   Mon, 18 Feb 2019 16:54:36 +0200
Message-Id: <20190218145449.13360-1-kaslevs@vmware.com>
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
 tracecmd/trace-setup-guest.c   | 245 +++++++++++
 tracecmd/trace-usage.c         |  22 +-
 11 files changed, 1637 insertions(+), 88 deletions(-)
 create mode 100644 tracecmd/trace-agent.c
 create mode 100644 tracecmd/trace-setup-guest.c

--
2.19.1
