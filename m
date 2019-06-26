Return-Path: <SRS0=TDtF=UZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209C4C48BD3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5ABF20656
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:52:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eorUQnSE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfFZKwT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 06:52:19 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54097 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfFZKwT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 06:52:19 -0400
Received: by mail-wm1-f65.google.com with SMTP id x15so1595389wmj.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jun 2019 03:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dy8atXlBKCY5tbkoT93pb6kqdcYYZbGe6szCVTsyN6k=;
        b=eorUQnSEllL7ZZE0U98hWHGNgoTpnpMMcyXjOM006WyJZdQIZIIXF1Sl3iRTmXwutJ
         0awoWGMvcoPQcf5TFGJOpCEYwiuvvp1xzkTT70pmMk0X379idhfRyDV0mA+kFR46hWPP
         n53iYUoHTx8ymLUF6QXdQ75olgcqOpoCvh9fyJupg37J6v+wiyelLEpHs75nmTNsGj+e
         3O4GPDTLki+PK00WhBWAywO4oMllpiESugaZH6QvVsK4Cf2jVPTj5OaRcpq2D8GLfc3F
         37Y1958IDtpcuY4RzputtDWY4B7IqA/5uD/qdI7tXjzUfQnyrHdC83t9DbBuRxJcj2wT
         LBYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dy8atXlBKCY5tbkoT93pb6kqdcYYZbGe6szCVTsyN6k=;
        b=cmKsBpWUoujCOH3KjGCFX7ReBlaD7AA0pseh9nOUGJOs4p2tjZPrlpD/MuZuEGbX7I
         XBGGhwDLTJloMzhPws6D+AD+Dehxd/VQUSlkYdISiE0XD3djjfMs9kzxxWHqeite/HAq
         w5aZ76MRvFS+pt+kmkQWHcUx7CuwJxE09NoE3zheAqDOZd4NwEpVrU0nMNCyrTr9Hobw
         g70ajujIwIkfspYJ8Vu76WNTLN0jvoiPrHWpu0TLFsLYxdrajywnQgGR4JXSJ9fcSSaK
         BjzoFw2dqVTv+wxMwGCiPvUPj/gxpaIlJcYbKq6FDf64EzJwuMwHtjcbiUC6Va1/pnST
         qXlg==
X-Gm-Message-State: APjAAAVyPjf1nI+ZQ9Yz+mzY9TnAKHJf1OfWJoA4g4ziIMOysYwYsYHi
        pSHcGWDKaf2jtdTh3rEWruBBSSRHdA==
X-Google-Smtp-Source: APXvYqyI2OReA5QV5MfhuFZrJNxs2ZysYzjNuHZKeaMXRBdR688VYid3W3sw3kBu1B9Ym4l5uCPPBQ==
X-Received: by 2002:a1c:e009:: with SMTP id x9mr2270071wmg.5.1561546337468;
        Wed, 26 Jun 2019 03:52:17 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s10sm15456929wrt.49.2019.06.26.03.52.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 03:52:16 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v13 00/13] Add VM kernel tracing over vsockets and FIFOs
Date:   Wed, 26 Jun 2019 13:51:56 +0300
Message-Id: <20190626105209.13200-1-slavomir.kaslev@gmail.com>
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
 lib/trace-cmd/trace-recorder.c | 154 ++++--
 tracecmd/Makefile              |   5 +
 tracecmd/include/trace-local.h |  29 ++
 tracecmd/trace-agent.c         | 294 +++++++++++
 tracecmd/trace-cmd.c           |   4 +
 tracecmd/trace-listen.c        |  10 +-
 tracecmd/trace-msg.c           | 274 ++++++++++-
 tracecmd/trace-record.c        | 875 +++++++++++++++++++++++++++++++--
 tracecmd/trace-setup-guest.c   | 247 ++++++++++
 tracecmd/trace-usage.c         |  22 +-
 12 files changed, 1834 insertions(+), 107 deletions(-)
 create mode 100644 tracecmd/trace-agent.c
 create mode 100644 tracecmd/trace-setup-guest.c

-- 
2.20.1

