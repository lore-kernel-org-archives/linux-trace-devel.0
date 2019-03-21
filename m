Return-Path: <SRS0=gVBF=RY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952CDC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 15:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68B0B218A5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 15:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbfCUPrN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:47:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42437 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728439AbfCUPrN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 11:47:13 -0400
Received: by mail-wr1-f65.google.com with SMTP id g3so1788435wrx.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Mar 2019 08:47:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5ZPJcJ5X46PPjrrFCugceXesJsXWq+MYXmFDuG0EjnA=;
        b=AJmNkJU2otbd0Ssqmot8OR1CKHk++CTgnO+4oIL46f0AiCGlEIh9/YtEvov0BB2xf6
         NCXzP8c1BmpEd8yI07KXOz1QXH68BEvsvoLEKAaIy9gUv8phpIHrt8V785tj/2jPvrYq
         pB/JXNh/dLro0A5r09j+6tNPK1ZooOA5oLv59cik0IGphoZEC+0SHJfNS7taFDy2kDvG
         3JCCT1PqzPTR4mcmt6YJQxb+41MONI0dDybJo7Wykgd+n4TJLmajC0ljxGkAYEVcEyhj
         vcskkD3KpErp3fHApuFzHXrwQGIQZuS9uLQBTBGvmOZznPby3LRYU5U8snu6zbnJOIw2
         mxMg==
X-Gm-Message-State: APjAAAVRcgKequcWKJv+UlkoAsWh03tdS/6M9pMFAeIniRdoiSQ3amyc
        r2y9Do3XQIlnZUS/BJRObBSS2woE
X-Google-Smtp-Source: APXvYqxzeDWlz92txp92Ddl+E/fTs6v1qV8IXEn4GRf1YODxjfINC9wWy12Keykds+Aj3gFkiQ3UCw==
X-Received: by 2002:adf:eed1:: with SMTP id a17mr2960042wrp.268.1553183231620;
        Thu, 21 Mar 2019 08:47:11 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c10sm8940049wrt.65.2019.03.21.08.47.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Mar 2019 08:47:10 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 0/9] trace-cmd: Timetamps sync between host and guest machines, relying on vsock events.
Date:   Thu, 21 Mar 2019 17:47:00 +0200
Message-Id: <20190321154709.24163-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
 v8 changes:
  - Added rmdir() call in tracecmd_remove_instance(), to completely remove the instance. 
  However, there is an issue with deleting the instances using rmdir(), which is investigated.
  - Few changes in read_qemu_guests_pids(), timestamp_correct(), tsync_offset_load() 
 tracecmd_clock_context_new() and find_raw_events() suggested by Slavomir. 

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
 lib/trace-cmd/trace-input.c      | 144 +++++-
 lib/trace-cmd/trace-util.c       |  95 ++--
 tracecmd/Makefile                |   1 +
 tracecmd/include/trace-local.h   |  43 +-
 tracecmd/include/trace-msg.h     |  10 +
 tracecmd/trace-agent.c           |  13 +-
 tracecmd/trace-msg.c             | 208 +++++++-
 tracecmd/trace-output.c          | 117 ++++-
 tracecmd/trace-read.c            |   4 +-
 tracecmd/trace-record.c          | 230 +++++++--
 tracecmd/trace-timesync.c        | 805 +++++++++++++++++++++++++++++++
 13 files changed, 1569 insertions(+), 133 deletions(-)
 create mode 100644 tracecmd/trace-timesync.c

-- 
2.20.1

