Return-Path: <SRS0=9KLN=XM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1DEC4CEC9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 13:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A1D1214AF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 13:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfIQNPr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 09:15:47 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33808 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfIQNPr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 09:15:47 -0400
Received: by mail-wr1-f67.google.com with SMTP id a11so3164707wrx.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Sep 2019 06:15:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MUXynM7QTeGwMghBrXUNx2dx9+U/NeDGd9vhUFd42Qk=;
        b=sDp++w/ORpnClAo7FNahXzxhqBcdpvnRSLie7RdF8r/ftbr6uLZ12Jehly2NXooBkN
         55PmtKGY4eLy4ls8e/NoIO9HYhbVX7yFIYga9sW8QpT0r0X0dbeHyzthLZecY4IrvPw3
         byPtW3RbhZPqmb+kcY0oU4HTpUs1UKZf+9EjwEeMOUYknqk7dRtkbZga6SREm5TCvRwV
         ber/MIb+dCcNOt8l3FygT8SI29F+wGu3t/pHLy/Me03AF1ZL6OB6+WdtYkw70nGhUG0M
         lqoCn1uZMNJin+b45XnfvXaZcm+QycbtKIIbUP630LTzHn/fTJAlBLMpuFhzYwXALq4Q
         8D7g==
X-Gm-Message-State: APjAAAXXkzr3EtitXLPpJgY/DajaaPq0RPKPzFKTZcw5ZF1PBH8d7ALr
        WRUmtSYiGchurkejZKi69OXVEbPt2w==
X-Google-Smtp-Source: APXvYqwhTFwYsZAljaMPRGTu48ySzUjpsI3zxPSGpeyTgLgwrYowDT/AHeWaHRLXz5nCxXdZ4M/abg==
X-Received: by 2002:adf:b3c1:: with SMTP id x1mr3141710wrd.33.1568726145186;
        Tue, 17 Sep 2019 06:15:45 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d22sm1667265wmb.44.2019.09.17.06.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 06:15:44 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v14 00/13] Add VM kernel tracing over vsockets and FIFOs
Date:   Tue, 17 Sep 2019 16:15:25 +0300
Message-Id: <20190917131538.31926-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset adds support for tracing guest kernels to trace-cmd.

Changes in v13:
 - ignore SIGINT in recording processes
 - add more checks for memory allocation failures

Changes in v12:
 - fix patches' Signed-off-by tags

Changes in v11:
 - fix flushing tracing data bug when doing VM recording

Changes in v10:
 - add support for specifying VMware Workstation guests by name on the command line
 - add docstring for tracecmd_create_recorder_virt()
 - add a comment on why we need to poll() in direct_splice_data()

Changes in v9:
 - none

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

Slavomir Kaslev (11):
  trace-cmd: Make ports unsigned int
  trace-cmd: Add tracecmd_create_recorder_virt() function
  trace-cmd: Add VM tracing protocol messages
  trace-cmd: Add buffer instance flags for tracing in guest and agent
    context
  trace-cmd: Add VM kernel tracing over vsockets transport
  trace-cmd: Use splice(2) for vsockets if available
  trace-cmd: Add `trace-cmd setup-guest` command
  trace-cmd: Try to autodetect number of guest CPUs in setup-guest if
    not specified
  trace-cmd: Add setup-guest flag for attaching FIFOs to the guest VM
    config
  trace-cmd: Add VM kernel tracing over FIFO transport
  trace-cmd: Add support for tracing VMware Workstation VMs by name

Slavomir Kaslev (VMware) (1):
  trace-cmd: Switch stop recording signal to SIGUSR1

Steven Rostedt (VMware) (1):
  trace-cmd: Detect if vsockets are available

 Makefile                       |   7 +
 include/trace-cmd/trace-cmd.h  |  20 +-
 lib/trace-cmd/trace-msg.c      | 274 ++++++++++-
 lib/trace-cmd/trace-recorder.c | 154 ++++--
 tracecmd/Makefile              |   5 +
 tracecmd/include/trace-local.h |  29 ++
 tracecmd/trace-agent.c         | 294 +++++++++++
 tracecmd/trace-cmd.c           |   4 +
 tracecmd/trace-listen.c        |  10 +-
 tracecmd/trace-record.c        | 875 +++++++++++++++++++++++++++++++--
 tracecmd/trace-setup-guest.c   | 247 ++++++++++
 tracecmd/trace-usage.c         |  22 +-
 12 files changed, 1834 insertions(+), 107 deletions(-)
 create mode 100644 tracecmd/trace-agent.c
 create mode 100644 tracecmd/trace-setup-guest.c

-- 
2.20.1

