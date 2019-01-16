Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E6DC43387
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 13:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FB01206C2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 13:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393159AbfAPNnS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Jan 2019 08:43:18 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52837 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733175AbfAPNnR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Jan 2019 08:43:17 -0500
Received: by mail-wm1-f66.google.com with SMTP id m1so2030896wml.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Jan 2019 05:43:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B8R7yoylf9z3jVz0Jigm4Us0swl7zs4qy1ZZ/uEb92k=;
        b=TVK+T4mFIB8UP4IdpULAR/oWHB3C2a6qZnfEelGw+Aljf866SFrsQEUC+mYGbHibbR
         zSQ/TGTH+9vCjIgTr9ugtCNP5islbp0WnqehhVuVS1oc5aUh7+t7eV2RaFpYTQ13kmph
         vFR0A1eOuaMyt1PvVI0y+OX7uYgW+BmAhVpPSJfQFOriNY3kAODYJ7GoSwLCrAMI/vr6
         yw/L2Z3gs+oPhW0kIN5VqbThHKna9rxbZB9gg4pAQb9ol6iN5wEwQJR6/8CkA1xVOTQX
         awKrr/lq77cuFIkwo/e2veLAynneCLsyCApirwGI+fJmzunqUM5Nc7joJ9qDmkL5rX2S
         LCAQ==
X-Gm-Message-State: AJcUukdfzq2Zg6dJhwagDHFVfgEgt1tgksh3do9XM5fTnJfRox3wXsgy
        9gKt43IRmXPGN9ldy4+Ye7/0P1Bp5jul
X-Google-Smtp-Source: ALg8bN4coksjXO6r7Ac5IZwOvuaC1snGqmmWNnMurm1KlkbqkX75Be2C7qQHSCRKMT5SSw8qG2iRwg==
X-Received: by 2002:a1c:44d6:: with SMTP id r205mr7952371wma.50.1547646195510;
        Wed, 16 Jan 2019 05:43:15 -0800 (PST)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y13sm34636460wme.2.2019.01.16.05.43.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jan 2019 05:43:14 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v4 0/8] Add VM kernel tracing over vsock sockets
Date:   Wed, 16 Jan 2019 15:42:59 +0200
Message-Id: <20190116134307.4185-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset adds support for tracing guest kernels to trace-cmd.

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

Slavomir Kaslev (6):
  trace-cmd: Minor refactoring
  trace-cmd: Add tracecmd_create_recorder_virt function
  trace-cmd: Add TRACE_REQ and TRACE_RESP messages
  trace-cmd: Add buffer instance flags for tracing in guest and agent
    context
  trace-cmd: Add VM kernel tracing over vsock sockets transport
  trace-cmd: Use splice(2) for vsock sockets if available

Steven Rostedt (VMware) (1):
  trace-cmd: Detect if vsock sockets are available

Tzvetomir Stoyanov (1):
  trace-cmd: Use unsigned int for trace-cmd client ports

 Makefile                       |   7 +
 include/trace-cmd/trace-cmd.h  |  17 +-
 lib/trace-cmd/trace-recorder.c |  53 ++-
 tracecmd/Makefile              |   6 +-
 tracecmd/include/trace-local.h |  18 +
 tracecmd/trace-agent.c         | 230 ++++++++++
 tracecmd/trace-cmd.c           |   3 +
 tracecmd/trace-msg.c           | 210 ++++++++-
 tracecmd/trace-record.c        | 803 +++++++++++++++++++++++++++++----
 tracecmd/trace-usage.c         |  13 +-
 10 files changed, 1243 insertions(+), 117 deletions(-)
 create mode 100644 tracecmd/trace-agent.c

-- 
2.19.1

