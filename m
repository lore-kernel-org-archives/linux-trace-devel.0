Return-Path: <SRS0=K4HJ=PW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAABC43444
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jan 2019 15:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DAF92087E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jan 2019 15:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfANP2K (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jan 2019 10:28:10 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56128 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfANP2K (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jan 2019 10:28:10 -0500
Received: by mail-wm1-f68.google.com with SMTP id y139so9274768wmc.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jan 2019 07:28:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZRUFwgZ0rFlNASSCuhWLU66l7x00NHNa04VgcGI8LB0=;
        b=ClXYrtQDvSxBCPew+Gsj7YuzLQz4TfmEwE5wOgDX3mILtj742941kzbxKotDJbkBW3
         E9cH0zqwFNSIFFY4NNk6N9u96lwJo/Qcv7GFprjPiLck21n2SP60VEmd5JggWxxece5m
         O6Tto26HV34hUzQ85XNhojbMfA3h3S8IkNbXFsbE5nhEVqf8C3k0mQXtO1WCFPq9043s
         3TI8GMy6XH8sdYSl0I86BD8XPDcXqSmY80EckQLxYOXURQCM+mt3ay6x0XmX+ZbgpaK0
         yh4ikDe2anG0WhrqZOtvfBS8s/thEzqlvuAV3TQskSjcP8XD8RZwCBwLAm1KJcOc+Bml
         d2Lw==
X-Gm-Message-State: AJcUukfjAIDhmkAaLCMucrCUsPoZeQ2h9pZqMu1lLsM4K4VpEIFVjaOO
        tPAixb/gBgcIpTdagvKilBGPkuOfMg==
X-Google-Smtp-Source: ALg8bN780O57lQMjLz5oP3ouRQ/c+vuh73BXgQsxq1G0VPcRK8gok/4TKhtLb0Jb4YUZwaIylq+6DA==
X-Received: by 2002:a1c:f71a:: with SMTP id v26mr11562771wmh.131.1547479687830;
        Mon, 14 Jan 2019 07:28:07 -0800 (PST)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a132sm34784167wmh.5.2019.01.14.07.28.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 07:28:07 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v3 0/6] Add VM kernel tracing over vsock sockets
Date:   Mon, 14 Jan 2019 17:27:54 +0200
Message-Id: <20190114152800.31060-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset adds support for tracing guest kernels to trace-cmd.

Changes in v3:
 - addressed Steven's feedback
 - detect and disable guest tracing if <linux/vm_sockets.h> is not available
 - the --date flag is now treated as global for all guest instances
 - fixed a bug that caused --date to be ignored for host tracing data when tracing guests

Changes in v2:
 - rebased on top of protocol V3
 - fixed system clock timestamps with the --date flag

Slavomir Kaslev (5):
  trace-cmd: Minor refactoring
  trace-cmd: Add tracecmd_create_recorder_virt function
  trace-cmd: Add TRACE_REQ and TRACE_RESP messages
  trace-cmd: Add buffer instance flags for tracing in guest and agent
    context
  trace-cmd: Add VM kernel tracing over vsock sockets transport

Steven Rostedt (VMware) (1):
  trace-cmd: Detect if vsock sockets are available

 Makefile                       |   7 +
 include/trace-cmd/trace-cmd.h  |  13 +
 lib/trace-cmd/trace-recorder.c |  53 ++-
 tracecmd/Makefile              |   6 +-
 tracecmd/include/trace-local.h |  19 +
 tracecmd/trace-agent.c         | 229 ++++++++++
 tracecmd/trace-cmd.c           |   3 +
 tracecmd/trace-msg.c           | 199 ++++++++-
 tracecmd/trace-record.c        | 757 ++++++++++++++++++++++++++++-----
 tracecmd/trace-usage.c         |  13 +-
 10 files changed, 1185 insertions(+), 114 deletions(-)
 create mode 100644 tracecmd/trace-agent.c

-- 
2.19.1

