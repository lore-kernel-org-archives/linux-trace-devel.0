Return-Path: <SRS0=qNMP=SY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A54CC10F11
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 14:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0080C20656
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 14:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfDVOz0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 10:55:26 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:39966 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfDVOz0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 10:55:26 -0400
Received: by mail-wr1-f51.google.com with SMTP id h4so16087847wre.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Apr 2019 07:55:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hwMqgEaooz83IbZqHHg2U0FBRJZaE8NIUqnWVCw4wOI=;
        b=f674+jBC2X/0ZPGtlzW1hDi9+nhU457PHUCFJPTks2aIbR4GzkgD710PO4WhygVQTz
         s72ql8TTL7p13mJ6g62mjgk1jECHtVEoKLqg75FyWqyyPtbxI79k3YswsJGjeHTG/NvN
         9kwuQ55SXP22sc+X3AOCAeONdwry9V+kxOVsmkQiNSsh4gw6BvKKSk37QANpen24ur8F
         m11lDI0Qrk0BpCyupPWyxfTVcO/+snGHgaTGZbpiDGnyIrCmV3fOTB2NyOrNBNLbmGTL
         UxWpRJw5KgSATAwB54QBmUum6gqmLy0dVKc9/Gu2Pa/rI3JD4T0wm5qoiLs/IiDPV/nq
         7DAQ==
X-Gm-Message-State: APjAAAVKcaqA1O+oYCnkyX7xJIWZuFKHbMPiI1YzIQ0U/VR2OBzIeH+Z
        mcWsPZvl1h+TR7JkUybZeFucOqavAg==
X-Google-Smtp-Source: APXvYqwfprgVSuckbSocBzCC0O1VGAeDIrYbqfcKcqCZpzZa0WZQXr9RyPUl+gQW/yyxghx18HmlmQ==
X-Received: by 2002:adf:8068:: with SMTP id 95mr1257395wrk.174.1555944924388;
        Mon, 22 Apr 2019 07:55:24 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f128sm17321087wme.28.2019.04.22.07.55.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Apr 2019 07:55:23 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v10 00/12] Add VM kernel tracing over vsockets and FIFOs
Date:   Mon, 22 Apr 2019 17:55:07 +0300
Message-Id: <20190422145519.16146-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset adds support for tracing guest kernels to trace-cmd.

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
  trace-cmd: Add support for tracing VMware Workstation VMs by name

Steven Rostedt (VMware) (1):
  trace-cmd: Detect if vsockets are available

 Makefile                       |   7 +
 include/trace-cmd/trace-cmd.h  |  18 +-
 lib/trace-cmd/trace-recorder.c | 145 ++++--
 tracecmd/Makefile              |   5 +
 tracecmd/include/trace-local.h |  29 ++
 tracecmd/trace-agent.c         | 294 ++++++++++++
 tracecmd/trace-cmd.c           |   4 +
 tracecmd/trace-listen.c        |  10 +-
 tracecmd/trace-msg.c           | 251 +++++++++-
 tracecmd/trace-record.c        | 843 +++++++++++++++++++++++++++++++--
 tracecmd/trace-setup-guest.c   | 247 ++++++++++
 tracecmd/trace-usage.c         |  22 +-
 12 files changed, 1781 insertions(+), 94 deletions(-)
 create mode 100644 tracecmd/trace-agent.c
 create mode 100644 tracecmd/trace-setup-guest.c

-- 
2.19.1

