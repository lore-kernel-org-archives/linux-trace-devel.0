Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCBBC3A5A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B34ED2189D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:57:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dbymv1Hb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfH1I5v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 04:57:51 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39784 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbfH1I5v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 04:57:51 -0400
Received: by mail-wr1-f68.google.com with SMTP id t16so1639184wra.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Aug 2019 01:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8OtgbPFMZ4pX837IVWawVzdA9M+1W+yZ289aljjfoq4=;
        b=Dbymv1HbKcXNt4GO1fcA+t/5MK/02T/OOyl2+34+oIkI5PR79a3ti/E733Ym7RdIjK
         OC4YWJKnQnWzmHMtJYWbVjF37/WSdkyoTZ3U6a0rMlBnw2a+h9EE0sbGpNb02vKWokn+
         soSJbXFo/GNCDxVIiKxDAY9MOR3xoHRYChNwYGzQQkKn5yEZi7QllukpRy5rNhTtofaf
         UgUg62aXG5RisXqS/dgdj+CkCgR6Zl3Ch0aiHPWTsK1DZskFX4mWiSCVQ0qbDohK0w+X
         q7OHK7sb8rcCeferOmv3e6bmA4LrMhww5oLOm3eo+athcnpNICa9O8DKO6f4a0w+WC0v
         xpFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8OtgbPFMZ4pX837IVWawVzdA9M+1W+yZ289aljjfoq4=;
        b=XrdakNB4p7dorwM/8sorclqRtoj7DHGsJipGHkcywULoSoFSI9tnL6EqByaZzUa/gN
         UO+DtawY3SKhxAvDLPRfoEerZfrGY6m6nixsgxyQRgVOqLHVWQW6dS2/dOEIuJHU9ZGA
         G/SYkqp1fsWPdsRZRTtbs87oMswqLhHmrqTTnHwxKtqz3vJxVAxck8zhTQaqBFqta1Jh
         KI0Udqr/IWajiGRbFoZlyjb8X7LWuysDyztvLlhjAyAks2kBcnJgGY4CpTHc7PpDhxKA
         qvZlxRbDhbboLGhQMtui6dCD+2oLwqcnY1Os2fux2Y5XpjSPb0NRxJYesufI3hj+b2RA
         jWhg==
X-Gm-Message-State: APjAAAVNG8eFImONWbq0/FFE5GNhH2DshtGxbSqj0mAy/2sjfRV+tYBf
        N5TPJOiOyvVwcbT4kmwQIthiIeDF
X-Google-Smtp-Source: APXvYqxYURuhfSqc1z+s+u14RPsCWh6Xy1W+JBxfJktHqwFe6CLf2vOIrlLGaxRMaYhe8+EyqzJ/rA==
X-Received: by 2002:adf:e5cd:: with SMTP id a13mr3129682wrn.316.1566982668357;
        Wed, 28 Aug 2019 01:57:48 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u186sm2579433wmu.26.2019.08.28.01.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 01:57:47 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v12 0/9] trace-cmd: Timetamps sync between host and guest machines, relying on vsock events.
Date:   Wed, 28 Aug 2019 11:57:37 +0300
Message-Id: <20190828085746.26231-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

POC implementation of algorithm for timestamps sync between guest and host machines.
The algorithm relies on matching time stamps of guest and host vsock events.

The patch series depends on Slavomir's changes, introduced by the v13 patch series
"Add VM kernel tracing over vsockets and FIFOs"

[
 v12 changes:
  - Rebased on top of Slavomir's v13 "Add VM kernel tracing over vsockets and FIFOs"

 v11 changes:
  - Rebased on top of Slavomir's v10 "Add VM kernel tracing over vsockets and FIFOs"
  - Addressed Slavomir's commnents from version 10 of the patch series.

 v10 changes:
  - Fixed broken compilation, call to timestamp_correction_calc() in timestamp_correct
    was smashed.
  - Replaced deprecated tep_data_event_from_type() API with tep_find_event().
  - Fixed a warning on assignment const to non const.

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
  trace-cmd [POC]: Implemented timestamps synch algorithm, using vsock
    events.

 include/trace-cmd/trace-cmd.h    |  30 +-
 include/traceevent/event-parse.h |   1 +
 lib/trace-cmd/trace-input.c      | 145 +++++-
 lib/trace-cmd/trace-util.c       |  98 ++--
 tracecmd/Makefile                |   1 +
 tracecmd/include/trace-local.h   |  42 +-
 tracecmd/include/trace-msg.h     |  10 +
 tracecmd/trace-agent.c           |  13 +-
 tracecmd/trace-msg.c             | 210 +++++++-
 tracecmd/trace-output.c          | 114 ++++-
 tracecmd/trace-read.c            |   4 +-
 tracecmd/trace-record.c          | 224 +++++++--
 tracecmd/trace-timesync.c        | 810 +++++++++++++++++++++++++++++++
 13 files changed, 1571 insertions(+), 131 deletions(-)
 create mode 100644 tracecmd/trace-timesync.c

-- 
2.21.0

