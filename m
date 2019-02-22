Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB3AC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 14:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D9272075A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 14:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfBVO2k (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:28:40 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46834 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfBVO2k (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 09:28:40 -0500
Received: by mail-wr1-f66.google.com with SMTP id i16so2555591wrs.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 06:28:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IqguCvAIpHYSiatzGMcEAz6C9OgC7nBKz6eZ/LSxNaE=;
        b=frNqP1fAXllix9yg/T4OOMLi9V64BqR1Hoi2ZokPKek9ARS8neMu/+iJJQIqQPLEog
         aFAok/WlFEY20nD0uIKFVM2GuMgzCLw4BRtOJylSAAJ229z7CIbND1qF6r/EBo7k+jYS
         FNYsooA6Kv4FgzUgQBHWvow3b/Q8eOFgL4DDhFV3pJnZ7iJzMpmkVOIhPH3+hIFbcVda
         ktDu1GGZtgBWbPS8aIKIUBUmtM5SmKKo2hsi6TU0tgiiH3Xi8c/YUcmoqwokB0kCPspN
         rA4IQfNxLZneamrItCR17XH76Gr2PSn1c+BxHfIkn7MRnJIKmf9RacQdCh9qoZuzrqdI
         sRmA==
X-Gm-Message-State: AHQUAua7+/H7zvUsC1cOcwg0KJjAoWPZcBgqTAiYjq6ynz0q4LxJtMv7
        RqEjxqfksJ9sM2dI88WW3CP6efbS
X-Google-Smtp-Source: AHgI3IY898tbEy0seGKsNzerAI8mCwLdFjleksQmkt6ixb7HQAlNh13UHtXRxNqvdZhM3zB+tJ+6qQ==
X-Received: by 2002:adf:b784:: with SMTP id s4mr3136657wre.155.1550845718250;
        Fri, 22 Feb 2019 06:28:38 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q9sm848987wrv.26.2019.02.22.06.28.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Feb 2019 06:28:37 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 0/7][POC] trace-cmd: Timetamps sync between host and guest machines, relying on vsock events.
Date:   Fri, 22 Feb 2019 16:28:29 +0200
Message-Id: <20190222142836.12596-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
 V4 changes:
  - Removed the implementation of PTP-like algorithm. The current 
    logic relies on matching time stamps of kvm_exit/virtio_transport_recv_pkt
    events on host to virtio_transport_alloc_pkt/vp_notify events on guest.
  - Rebased to Slavomir's v7 "Add VM kernel tracing over vsockets and FIFOs" 
    patch series.
  - Decreased the time synch probes from 5000 to 300.
  - Addressed Steven Rostedt comments.
  - Code cleanup. 

 V3 changes:
 - Removed any magic constants, used in the PTP-like algorithm,
   as Slavomir Kaslev suggested.
 - Implemented new algorithm, based on mapping kvm_exit events
   in host context to vsock_send events in guest context,
   suggested by Steven Rostedt.

 V2 changes:
  - Addressed Steven Rostedt comments.
  - Modified PTP-like timestamps sync algorithm to gain more accuracy, with the
    help of Yordan Karadzhov and Slavomir Kaslev.
]

This patch series is a POC for timestamps sync between guest and host machines.
The algorithm relies on matching time stamps of guest and host vsock events.

The patch series depends on Slavomir's changes, introduced by the v7 patch series
"Add VM kernel tracing over vsockets and FIFOs"

Tzvetomir Stoyanov (7):
  trace-cmd: Implemented new lib API: tracecmd_local_events_system()
  trace-cmd: Added support for negative time offsets in trace.dat file
  trace-cmd: Fix tracecmd_read_page_record() to read more than one event
  trace-cmd: Added implementation of htonll() and ntohll()
  trace-cmd: Refactored make_instances() and tracecmd_remove_instances()
  trace-cmd: Find and store pids of tasks, which run virtual CPUs of
    given VM
  trace-cmd [POC]: Implemented timestamps synch algorithm, using vsock
    events.

 include/trace-cmd/trace-cmd.h  |   8 +-
 lib/trace-cmd/trace-input.c    |  18 +-
 lib/trace-cmd/trace-util.c     |  99 ++++---
 tracecmd/include/trace-local.h |  16 ++
 tracecmd/include/trace-msg.h   |  10 +
 tracecmd/trace-listen.c        |   3 +
 tracecmd/trace-msg.c           | 477 ++++++++++++++++++++++++++++++++-
 tracecmd/trace-read.c          |   4 +-
 tracecmd/trace-record.c        | 267 +++++++++++++++---
 9 files changed, 816 insertions(+), 86 deletions(-)

-- 
2.20.1

