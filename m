Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21036C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F05802080A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393634AbfBNONu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 09:13:50 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40219 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387589AbfBNONu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 09:13:50 -0500
Received: by mail-wr1-f68.google.com with SMTP id q1so6628927wrp.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Feb 2019 06:13:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dZv/aiIkBCBGDlGhbzWpYcVFsOM5oMw6lOaK1TIJtoI=;
        b=ekiCw1v+GexkspPBFYRZIf1SwgSWMWe3exB1Fb8QOUY5Ysfoixp1jsg/VceVHoCiYj
         v6sCgcrfPN9Xl+gQiqHyl661shati7a8AQrDhMJ/LWJpLPJIhTne82eekDBfwUA5EH3o
         ZHRnOVVo1ZXaoTOQgLOo3LKHMBsmWFjhCcP/KT4pybLZNIwy4aprR3CcQGiJiSOAWH08
         CZLpiVQY1nhuZ5OLtYtdWKVfqYfGobVMT7pROe4VB4y2Ng7t2dyv8duDQiOadUKo03hc
         c9jDkiRrHtWxWkC1G24hfFOpivWYN7KRf1Tfg5W7fwWvHUodNDemYTnYB2FPVve9jGkO
         6s3g==
X-Gm-Message-State: AHQUAuagi6BUwtJvxqbhkJlCGqDJ45TB0LXSjjF9b49GbfKdNbtr9mR0
        ZtjXCup3kl3QKx50jqQqzA==
X-Google-Smtp-Source: AHgI3IYjA5GTjNc/PknTA9536nKM1n/9DK6joUFZdCObuOAwx4m6nKsh/Gsr3UA9/l5CGrPGoDNtAA==
X-Received: by 2002:a5d:4711:: with SMTP id y17mr3188213wrq.141.1550153628669;
        Thu, 14 Feb 2019 06:13:48 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id m4sm1844840wml.2.2019.02.14.06.13.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 06:13:47 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v6 00/11] Add VM kernel tracing over vsockets and FIFOs
Date:   Thu, 14 Feb 2019 16:13:24 +0200
Message-Id: <20190214141335.28144-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset adds support for tracing guest kernels to trace-cmd.

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


Slavomir Kaslev (10):
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
 tracecmd/include/trace-local.h |  26 ++
 tracecmd/trace-agent.c         | 257 +++++++++++
 tracecmd/trace-cmd.c           |   4 +
 tracecmd/trace-msg.c           | 216 ++++++++-
 tracecmd/trace-record.c        | 779 ++++++++++++++++++++++++++++++---
 tracecmd/trace-setup-guest.c   | 255 +++++++++++
 tracecmd/trace-usage.c         |  22 +-
 11 files changed, 1641 insertions(+), 88 deletions(-)
 create mode 100644 tracecmd/trace-agent.c
 create mode 100644 tracecmd/trace-setup-guest.c

-- 
2.19.1

