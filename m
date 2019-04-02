Return-Path: <SRS0=t+9I=SE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C950AC10F0B
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A14262133D
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732134AbfDBNpr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:45:47 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42828 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732120AbfDBNpr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:45:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id g3so16729189wrx.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:45:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SyxtBX4t21a99XKSDOMQsxLwLE4EVZ6wJrEUuELTo8s=;
        b=bhfcASmw7TzhY2BIUWW/IZ7vNEWq5MmEt+1R89YzJJdpIZsDxNAkEURjoRuMw2lavM
         pzIhFwQSxbsfU1fNBusfEkV0D5arfV5vcfjRGdihGeit9JFYmCpq0ygHPVvz6ZheL9cF
         2s+H+9eHfQQhfCqBnTs7JcSvnO0pdTem7BNu1ijYmgpH67929/6uwjUDrjx8ewhT0yx1
         RHG53aCiqX6jPQ1JHzIcTfF9RkMAKdNrv1WYBOwog3HdU96A04N8Gt1M6RxxAq9diX5Q
         V0SfujHY3j0Delq5kwHkUllAxcdFwOujYs6YkZFub9Q3421XYRxUw/Fysl6SZku4ijEN
         bNxQ==
X-Gm-Message-State: APjAAAXWTAZVPZ+atV5LccV2nxWNHs7h/499mFj/McSt5Vh+OYdp+Usa
        a3FSqeJPYYRsaRYtbcaIK8JvOChxUQ==
X-Google-Smtp-Source: APXvYqyTCmWXtd7V5HycXMCiU2h3hGhX1d/QmgD7UdWyoKw+3Jpa20c88V1LQvtPCfdsP3gTPiEWbA==
X-Received: by 2002:a5d:4087:: with SMTP id o7mr35342872wrp.9.1554212745429;
        Tue, 02 Apr 2019 06:45:45 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 17sm1765336wmk.39.2019.04.02.06.45.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 06:45:44 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v9 00/11] Add VM kernel tracing over vsockets and FIFOs
Date:   Tue,  2 Apr 2019 16:45:29 +0300
Message-Id: <20190402134540.32321-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset adds support for tracing guest kernels to trace-cmd.

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
