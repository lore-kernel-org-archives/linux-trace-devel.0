Return-Path: <SRS0=T0vY=QL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00681C282C4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 06:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C91DF20811
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 06:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbfBDG66 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Feb 2019 01:58:58 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40018 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfBDG66 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Feb 2019 01:58:58 -0500
Received: by mail-wm1-f65.google.com with SMTP id f188so12075691wmf.5
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Feb 2019 22:58:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KL3MX9Oa31+wvpYiK/MlpxGMwW2sM/s0Ukv4wtLtazo=;
        b=RB1JeTdc0J+td0zrleym1rlgHBi0okHrGHO89qEGiS8NW7o9974g9wuiYL3K/Q4IcK
         rhuWjczK1jPWvSPAC/vNtNmlorOjjlFOhbkHAOWe6+2oKiEJ8ciuPS/lif5IwhGbj2PV
         SO5cgjhrGfZM3gfqvcKmye7d/v15/V7CYcy3+iCp/RtyP+47ha6J1buwXoo1Surf81Jx
         lxQUMFoK087latBACfTH0bFgExe7hNDiGY8aOtgp9wh0mWHrtQtp9Vt05lA8F+Ny0db3
         FpdtfdUiNm6R46fqXx05We5INCAe+Y6ZhcqD2sI/Dcd8OaDuYrwHNWky9ZcV6vG6MYCL
         lKxw==
X-Gm-Message-State: AHQUAub6+9+7U6cZjGso9l7/itZci7kTjlflIsLKXEpIEND7D+82cdXA
        LJGdH1ogoVqk3rrbfbZ0n/KPpSu0ew==
X-Google-Smtp-Source: AHgI3IY6Rn9tarwC+MoJPjRmPFtVxPcqARqdcO4rorabYQuLodejvHuVuCUE79ZA8lvzROF7E06R0w==
X-Received: by 2002:a1c:6489:: with SMTP id y131mr11868554wmb.34.1549263536024;
        Sun, 03 Feb 2019 22:58:56 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id q12sm12596809wrx.31.2019.02.03.22.58.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 22:58:55 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: [RFC PATCH v5 00/11] Add VM kernel tracing over vsockets and FIFOs
Date:   Mon,  4 Feb 2019 08:58:37 +0200
Message-Id: <20190204065848.8248-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset adds support for tracing guest kernels to trace-cmd.

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
  trace-cmd: Make setup-guest auto attach FIFOs to the guest VM config
  trace-cmd: Set both input and output to non-blocking when recording is
    stopped
  trace-cmd: Add VM tracing over FIFOs transport

Steven Rostedt (VMware) (1):
  trace-cmd: Detect if vsockets are available

 Makefile                       |   7 +
 include/trace-cmd/trace-cmd.h  |  17 +-
 lib/trace-cmd/trace-recorder.c |  69 ++-
 tracecmd/Makefile              |   7 +-
 tracecmd/include/trace-local.h |  26 ++
 tracecmd/trace-agent.c         | 257 +++++++++++
 tracecmd/trace-cmd.c           |   4 +
 tracecmd/trace-msg.c           | 222 +++++++++-
 tracecmd/trace-record.c        | 759 +++++++++++++++++++++++++++++++--
 tracecmd/trace-setup-guest.c   | 243 +++++++++++
 tracecmd/trace-usage.c         |  21 +-
 11 files changed, 1557 insertions(+), 75 deletions(-)
 create mode 100644 tracecmd/trace-agent.c
 create mode 100644 tracecmd/trace-setup-guest.c

--
2.19.1
