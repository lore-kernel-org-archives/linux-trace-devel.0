Return-Path: <SRS0=I4ei=R4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06DAFC10F06
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Mar 2019 14:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C85742084D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Mar 2019 14:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbfCYOYo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:24:44 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35148 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729127AbfCYOYn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Mar 2019 10:24:43 -0400
Received: by mail-wm1-f67.google.com with SMTP id y197so9332993wmd.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 25 Mar 2019 07:24:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bpf1Ibe+3kqok6WIhvZkOYnaOJrfjrmiyogtTh8xGXc=;
        b=Bkehhc3Kg+nbWkBdeXzQj1s3NkpZh1bp8F+D5kSOL9jid5FJUczYy47888oX3OuV2J
         mKiOdcGTrr3WB9fNBoHxhXBqG9LY95FJcqsd6Ep7cRdZBw/Xal2YPI8XNunmDbxB8TGA
         OKiCKHakdaPGnjqFg3ubfY23VHxBdQ5VQaqG5iLhszyk3Hzq72XeagxZccGbt6FY8ncU
         /qGJ6a4b3FVfMoxTQBqgknq/SDqT9NjkrrvB49yGRdmvnzhbyHCvDw+l5U1s5iCm3h4y
         MBuZFPLWs0YNOpBzx6uXJV5I2TyJHczHTpeT6w6tobWZz8E3y4pIubB7YeuVlj7bnGVF
         3Y1A==
X-Gm-Message-State: APjAAAUQYISCl2Gw7qzUXF2FGmU1x8zlIfa/0AjzSY+/OzOV1196FbcE
        L3Ej+XhRPDOonTAEXC290dmRcYfd
X-Google-Smtp-Source: APXvYqwKbWwH6AJulb0T26VBLIBMk37c4EktTIkdsTc2JKDhMtOzEbAvJJzny/jd0q/YaieFf5R1KA==
X-Received: by 2002:a1c:f20e:: with SMTP id s14mr1326670wmc.93.1553523881767;
        Mon, 25 Mar 2019 07:24:41 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s2sm1293440wmc.7.2019.03.25.07.24.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Mar 2019 07:24:40 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v9 0/9]  trace-cmd: Timetamps sync between host and guest machines, relying on vsock events.
Date:   Mon, 25 Mar 2019 16:24:30 +0200
Message-Id: <20190325142439.22032-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
 v9 changes:
  - Fixed implementation of binary search algorithm in timestamp_correct()

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

