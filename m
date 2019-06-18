Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9DF6C31E5B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A8AE20B1F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PPVrhJdb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbfFROpE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:45:04 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:33416 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfFROpE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:45:04 -0400
Received: by mail-wr1-f52.google.com with SMTP id n9so14340656wru.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 07:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xRZNxWRzhLcujrPoZ56I4MYaiFUr/lxleXCQEk75HRw=;
        b=PPVrhJdb8qMPJ4QH/ZRxghn3Ah4x3fCt2Ls1W59+IDi5LqDUhCH5bdBZJC42Emx0Ie
         mDUGy9sXQC1inlVKx1BjheaVoSSyeoCG1I5v4O0OEhxWKxgnDvGhChuXQppSPupBShxs
         fymtRh39En5pFriEJxd6OLH6Zlf+spMK/wDgn9kL84ZoKQsZNCS/vOrG+wsMY5qA3gsq
         Yk5TLKapRww+y9rgNZ1ilP0sawR8BXlILOo8Hd6bIwN/R0SPtfJv/H8N7Gce0yj4GOGl
         eBWdoA9pYCxkUUcEJ4znUFviZJ3kSEIgQRu+LVPRFSkasUkvAq/3WVtQ1PenABsXaT2x
         Yzzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xRZNxWRzhLcujrPoZ56I4MYaiFUr/lxleXCQEk75HRw=;
        b=rZb7C66PRfOrZE24v3lgYD8jN80KrtPoKZqSo/6/KekgE7PNB+cBu5yLNpl3+fVLNY
         tZ7RxjmZ+AMxK2oI6qpdv9pwythDtITPL4nUyxr4Op5B2ZHJjRYjCmJ0BOsyM9P5v3fd
         5uRIBj2kRrDJgRLtzInBHGV1vrf2U/5AYfcrPHM/yodT9Ejahmd5p60+zrd4JscXVmfK
         dmcilk/5sT4vtBMQfvUeKkKI5Ze9eO0cuOuHpTyyo6Ix3VC0j/x93OQQtTScponOtSl6
         dwi19Zctp6Pbaf8E3MxTNeRHa+wpMqCGVj8maJ/ZmLcHXtD4ux/X+kn42iLTzwb/YJOc
         l91w==
X-Gm-Message-State: APjAAAUGIGxkQX19PTkgn4X5WRxs4+gpeg5VomEgzF/P9kWcRpNqLHmk
        w/+ogw5YgCERnaVgCHT9ctyAE0s=
X-Google-Smtp-Source: APXvYqzNFqCOis1NaPqsxi6NMtMHPtqc9O8dgcyUh8n/TbY2iXNkrdyQMsDLLw+XSIVrlWAqSfHMSA==
X-Received: by 2002:adf:b605:: with SMTP id f5mr23722801wre.305.1560869102193;
        Tue, 18 Jun 2019 07:45:02 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r3sm17686071wrr.61.2019.06.18.07.45.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:45:01 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v12 00/13] Add VM kernel tracing over vsockets and FIFOs
Date:   Tue, 18 Jun 2019 17:44:42 +0300
Message-Id: <20190618144455.3954-1-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset adds support for tracing guest kernels to trace-cmd.

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
  trace-cmd: Add splice() recording from FIFO without additional pipe
    buffer
  trace-cmd: Add support for tracing VMware Workstation VMs by name

Slavomir Kaslev (VMware) (1):
  trace-cmd: Switch stop recording signal to SIGUSR1

Steven Rostedt (VMware) (1):
  trace-cmd: Detect if vsockets are available

 Makefile                       |   7 +
 include/trace-cmd/trace-cmd.h  |  20 +-
 lib/trace-cmd/trace-recorder.c | 154 ++++--
 tracecmd/Makefile              |   5 +
 tracecmd/include/trace-local.h |  29 ++
 tracecmd/trace-agent.c         | 294 +++++++++++
 tracecmd/trace-cmd.c           |   4 +
 tracecmd/trace-listen.c        |  10 +-
 tracecmd/trace-msg.c           | 274 ++++++++++-
 tracecmd/trace-record.c        | 865 +++++++++++++++++++++++++++++++--
 tracecmd/trace-setup-guest.c   | 247 ++++++++++
 tracecmd/trace-usage.c         |  22 +-
 12 files changed, 1824 insertions(+), 107 deletions(-)
 create mode 100644 tracecmd/trace-agent.c
 create mode 100644 tracecmd/trace-setup-guest.c

--
2.20.1
