Return-Path: <SRS0=t+9I=SE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9E6C10F0D
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DE282146E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731862AbfDBNmj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:42:39 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51118 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731854AbfDBNmi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:42:38 -0400
Received: by mail-wm1-f67.google.com with SMTP id z11so3510508wmi.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sqr/xpZhtDiNDPRnRhYQZZHcL9b6yX3tZGzIlKNJq9o=;
        b=dSBbsUN6s90yXjdOklxS4R48ePyL0UOkBEeo1fihyFYkHVxKW0wo+6PGyw7WFnA3WB
         X0lE8+WzXFj7Yyat4CyLcl38w59yrDjj0ZFxdBpXNRflXtRVRrMdM2DBUH7iloIHYoI0
         JkVKCQFBG02WEnhRxkCpmTtjPuLMzQu6G+J4/Bbc6WKKzto5WngBQpgTtHVmwBHhU997
         oxjahFlLg8duVuWF1dkLNvf7JrZDIXqlfy5hZxiC+mZmpKoCTZkTIuPEyfoLmsuNWLby
         XqBMnb6HZG267I9v4Nzzg2WAtinkdwAx+Punuy+Sfach7H/fJteuaSBAvaUlkp08oRMz
         PWqw==
X-Gm-Message-State: APjAAAVwna5cR1byieXmVT+aQr9Vhc4vMEZv777GyAvECclImAkdNXIF
        SFSOznq3Oi3mMIGXbhbiK18sbkCx8Q==
X-Google-Smtp-Source: APXvYqyqCu4SYSvwF2pO3d334so+V9rIGuQtAH808Z4aQGmEf2f42dlyVxsOjFo3ySOvj5JEohSfhw==
X-Received: by 2002:a1c:7d92:: with SMTP id y140mr3875036wmc.54.1554212556923;
        Tue, 02 Apr 2019 06:42:36 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h84sm19207083wmf.15.2019.04.02.06.42.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 06:42:36 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v8 00/11] Add VM kernel tracing over vsockets and FIFOs
Date:   Tue,  2 Apr 2019 16:42:06 +0300
Message-Id: <20190402134230.30988-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset adds support for tracing guest kernels to trace-cmd.

Changes in v8:
 - switched protocol message encoding of ports to text
 - switched ports data type to unsigned since vsockets port numbers can overflow int and be confused with errors codes by other code
 - added automatic naming for guests with no names (for VMware Workstation guests currently)
 - added --debug option to trace-cmd agent

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

Slavomir Kaslev (10):
  trace-cmd: Make ports unsigned int
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

Steven Rostedt (VMware) (1):
  trace-cmd: Detect if vsockets are available

 Makefile                       |   7 +
 include/trace-cmd/trace-cmd.h  |  18 +-
 lib/trace-cmd/trace-recorder.c | 129 ++++--
 tracecmd/Makefile              |   5 +
 tracecmd/include/trace-local.h |  29 ++
 tracecmd/trace-agent.c         | 294 +++++++++++++
 tracecmd/trace-cmd.c           |   4 +
 tracecmd/trace-listen.c        |  10 +-
 tracecmd/trace-msg.c           | 249 ++++++++++-
 tracecmd/trace-record.c        | 773 +++++++++++++++++++++++++++++++--
 tracecmd/trace-setup-guest.c   | 247 +++++++++++
 tracecmd/trace-usage.c         |  22 +-
 12 files changed, 1695 insertions(+), 92 deletions(-)
 create mode 100644 tracecmd/trace-agent.c
 create mode 100644 tracecmd/trace-setup-guest.c

-- 
2.19.1

