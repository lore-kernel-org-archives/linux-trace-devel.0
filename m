Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA262C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 15:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B493820857
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 15:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfCSPzk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:55:40 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36683 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbfCSPzk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 11:55:40 -0400
Received: by mail-wm1-f65.google.com with SMTP id h18so8608677wml.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Mar 2019 08:55:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9pWfdrLFAGZvr0vjsxYXywCMkZPzdvKtZYYbx5/PvGc=;
        b=DSpk7xN+QViLUPYtQN1KGLt3Dt2BqIBrbEvhEGysNCJ7WvJtRobLrbBVDYoKO3N+E6
         dmUy3KUzNFFO1NZ9shrKe6rCFTJ/F+2hDL8GBivio1kijFP6Nyh6XCVedtnvP7zJvTpl
         NVWgXB+BAEalET3WVVdxe3JJ1k6IFPoTP1VQhYsywhE8o334FpA+QE0rv+jljU6wHCju
         0IFFF4Reb92W3UbojpSXoc3lqbiE9GVHX9a1N/2dfUzD1tqdFjtpkKB/+/fYGYyBPPGL
         xE64pYI2DqHepGBxqdbU5LgfytwspoxxH+ESnFDNEhnZvnHTiiXp/to6ktSEW8o+bRu2
         ZvhQ==
X-Gm-Message-State: APjAAAUGJGYrFuNgE7dt1vYe0SjU9wXvbQMMpFkBRy9zbyihEy+xvvUG
        73gXLDxJV0vfSt4TP6nlCfC46KjX
X-Google-Smtp-Source: APXvYqxDOIfUJtFE5koIECLRxTht7uy2UjdU97davM92dP5bcJbw3sRT1f/BnRrNY6PpMLhVvKnQKA==
X-Received: by 2002:a1c:f70c:: with SMTP id v12mr4146483wmh.19.1553010938325;
        Tue, 19 Mar 2019 08:55:38 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t15sm9365911wrr.16.2019.03.19.08.55.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Mar 2019 08:55:37 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 0/9] trace-cmd: Timetamps sync between host and guest machines, relying on vsock events.
Date:   Tue, 19 Mar 2019 17:55:27 +0200
Message-Id: <20190319155536.19381-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
 v7 changes:
  - Added warning messages in case time synchronization cannot be negotiated or fails.
  - Few optimizations and checks in read_qemu_guests_pids(), tsync_offset_load(), 
    and find_raw_events(), suggested by Slavomir Kaslev.
  - Reworked timestamp_correct() to not use static variables.
  - Check TRACECMD_OPTION_TIME_SHIFT before reading time sync samples from the trace.dat file

 v6 changes:
  - Refactored tracecmd_msg_snd_time_sync() and tracecmd_msg_rcv_time_sync() functions:
    removed any time sync calculations logic as separate functions in trace-timesync.c file
  - Defined TSYNC_PROBE, TSYNC_REQ and TSYNC_RESP messages, in order to make the time sync
    protocol comprehensible.
  - Addressed Steven Rostedt comments.
  - Addressed Slavomir Kaslev commnets.
	
 v5 changes:
  - Rebased to Slavomir's v8 "Add VM kernel tracing over vsockets and FIFOs"
    patch series.
  - Implemented an algorithm for time drift correction.
  - Addressed Slavomir's commnets.
  - Refactored the code: moved all time sync specific implementation in trace-timesync.c
  - Isolated all hardcoded event specific stuff in a structure, so it could be easily 
    moved to external plugins.
  - Added a check for VSOCK support: do not perform vsock dependent time synchronisation 
    in case there is no VSOCK support. 

 v4 changes:
  - Removed the implementation of PTP-like algorithm. The current 
    logic relies on matching time stamps of kvm_exit/virtio_transport_recv_pkt
    events on host to virtio_transport_alloc_pkt/vp_notify events on guest.
  - Rebased to Slavomir's v7 "Add VM kernel tracing over vsockets and FIFOs" 
    patch series.
  - Decreased the time synch probes from 5000 to 300.
  - Addressed Steven Rostedt comments.
  - Code cleanup. 

 v3 changes:
 - Removed any magic constants, used in the PTP-like algorithm,
   as Slavomir Kaslev suggested.
 - Implemented new algorithm, based on mapping kvm_exit events
   in host context to vsock_send events in guest context,
   suggested by Steven Rostedt.

 v2 changes:
  - Addressed Steven Rostedt comments.
  - Modified PTP-like timestamps sync algorithm to gain more accuracy, with the
    help of Yordan Karadzhov and Slavomir Kaslev.
]


This patch series is a POC for timestamps sync between guest and host machines.
The algorithm relies on matching time stamps of guest and host vsock events.

The patch series depends on Slavomir's changes, introduced by the v8 patch series
"Add VM kernel tracing over vsockets and FIFOs"

Tzvetomir Stoyanov (9):
  trace-cmd: Implemented new lib API: tracecmd_local_events_system()
  trace-cmd: Added support for negative time offsets in trace.dat file
  trace-cmd: Fix tracecmd_read_page_record() to read more than one event
  trace-cmd: Added implementation of htonll() and ntohll()
  trace-cmd: Refactored few functions in trace-record.c
  trace-cmd: Find and store pids of tasks, which run virtual CPUs of
    given VM
  trace-cmd: Implemented new API tracecmd_add_option_v()
  trace-cmd: Implemented new option in trace.dat file:
    TRACECMD_OPTION_TIME_SHIFT
  trace-cmd [POC]: Implemented timestamps synch  algorithm, using vsock
    events.

 include/trace-cmd/trace-cmd.h    |  31 +-
 include/traceevent/event-parse.h |   1 +
 lib/trace-cmd/trace-input.c      | 145 +++++-
 lib/trace-cmd/trace-util.c       |  95 ++--
 tracecmd/Makefile                |   1 +
 tracecmd/include/trace-local.h   |  43 +-
 tracecmd/include/trace-msg.h     |  10 +
 tracecmd/trace-agent.c           |  13 +-
 tracecmd/trace-msg.c             | 208 +++++++-
 tracecmd/trace-output.c          | 117 ++++-
 tracecmd/trace-read.c            |   4 +-
 tracecmd/trace-record.c          | 228 +++++++--
 tracecmd/trace-timesync.c        | 825 +++++++++++++++++++++++++++++++
 13 files changed, 1588 insertions(+), 133 deletions(-)
 create mode 100644 tracecmd/trace-timesync.c

-- 
2.20.1

