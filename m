Return-Path: <SRS0=xbdb=2D=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA56C3B18E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 771E824721
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YnC86oEI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbfLMPaf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:30:35 -0500
Received: from mail-lj1-f171.google.com ([209.85.208.171]:39941 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbfLMPaf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 10:30:35 -0500
Received: by mail-lj1-f171.google.com with SMTP id s22so3072954ljs.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Dec 2019 07:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cfln0wqdoLxRD/IYvR/n5Pdg14M/AV/K1EzOSeryvgc=;
        b=YnC86oEI8zn95fO8gIBkF8G/v++xC2cMtg2RG/xKOP8+2rWXU46OaE3VkUDc7FIC8Z
         2J+2zarXPAnopyZE6v5XGcNCIBn07Bh7mGQbZLPO/vzCKqOdyKYNvnWEwfIUzX31Hvn4
         vqFHMm/x35K+lTQlvwD0loMX4JhEVJldXmFHA+5Xe9tzJkYiINjTLMsAKfCLvnenbnm/
         k0rmkw6YbEYejNJXUHlKwBXGvIA56bBGseZ8XmuPZnSla1T2gD//4OI4j3gu+GLi1umU
         f3LoASV/nF/hSI8927KsJ7oFC/GII9K2dClt6XSC04bBXpG1+vYP4b7dYGVjll8O4Jg5
         8N1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cfln0wqdoLxRD/IYvR/n5Pdg14M/AV/K1EzOSeryvgc=;
        b=VIWJtVv2vSGxThhbMf5ibrNeW97vtMV8jgfJ1+YA5jk0/BaOiONdc2N9vYnl9phxYg
         hyOHPCCowb4lGsRKGPM4dB1TfRT/EfDbebCluowCOy+IZQQdMdLQD0eVUJxQJVItKmZY
         qyCLvv908L5gJvsAFf0kqUQfYuvydgOEbZdB59/3dolF07z7dCQbBtxbOb6xUPpJEmY9
         D+t/bEpHyHJZJ3lB/JzZEt36zxyDsxvGgTdCQK/KieRG5Lb2sNLLG4AVTJ2SBdNajz/U
         jszVmGIYoNPaYamjH9zQQnJuKBmOcGP5ryzT7V3foN14Itsv8NlX/ryUjc8uI+CzcPpF
         TpoA==
X-Gm-Message-State: APjAAAUM2ial/6h3GHZ6wLszqpc1AerwD2nX/+6f0E2Lo7gNWQ+HhgFe
        X4IeIFhfNx6HkTBhfaaDty0R2zJTH2o=
X-Google-Smtp-Source: APXvYqw50Q+P8xY37ohWnN0cObEesEDdcgcMHkelY5bIPo+vpCSyWwK5KKSKVszQosTXJOJ+BFiygA==
X-Received: by 2002:a2e:9708:: with SMTP id r8mr9998593lji.92.1576251032529;
        Fri, 13 Dec 2019 07:30:32 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u19sm5012806ljk.75.2019.12.13.07.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:30:31 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v18 00/18]Timestamp synchronization of host - guest tracing session
Date:   Fri, 13 Dec 2019 17:30:11 +0200
Message-Id: <20191213153029.133570-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Basic infrastructure for host - guest timestamp synchronization and a
POC implementation of PTP-like algorithm. 

[
 v18 changes: addressed Steven Rostdet comments:
  - Replaced semaphores with pthread mutexes.
  - Made bitmask with time sync protocols unlimited, so we can support
    more than 32 protocols. That required to redesign the trace request
    packet format.
  - A lot of small fixes.
	
 v17 changes:
  - Implemented new PTP logic for calculating the clocks offset, using
    histogram of all PTP samples. It gives better results than the logic
    with the fastest response time, so set the new one as default in the
    POC patch.

 v16 changes:
  - Fixed compilation in case no VSOCK is available (Thanks to Slavomir Kaslev)
  - Fixed a typo in trace-cmd-record.1.txt (Thanks to Slavomir Kaslev)
  - Added forgotten file in the patch "trace-cmd: Add new library APIs for
    ftrace instances." - trace-instance.c
  - Fixed few compilation warnings related to TSYNC_DEBUG code.
  - Removed a blank line at the end of "tsync_readme" file. 

 v15 changes:
  - Removed the patch for "--proc-map" from the series, as it should not
    be part of it.

 v14 changes:
  - Bring back the PTP-like algorithm and removed the ftrace event based logic.
  - Reimplemented the PTP-like algorithm to use raw ftrace markers, instead of clock_gettime() API.
  - Refactored the logic to be algorithm independent and plugin friendly.
  - Implemented continuous timestamps synchronization, while the trace is running.
  - Moved logic from trace-cmd application to libtracecmd, as new library APIs.
  - Implemented new trace id functionality.
  - Implemented new guest section in host trace.dat file.
	
 v13 changes:
  - Remove few patches from the set, as they were merged.
  - Rebased to the latest master, Slavomirs patchest "Add VM kernel tracing over
    vsockets and FIFOs" got merged!
 	
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

Tzvetomir Stoyanov (7):
  trace-cmd: Implement new lib API: tracecmd_local_events_system()
  trace-cmd: Add support for negative time offsets in trace.dat file
  trace-cmd: Add implementations of htonll() and ntohll()
  trace-cmd: Add new library APIs for ftrace instances.
  trace-cmd: Find and store pids of tasks, which run virtual CPUs of
    given VM
  trace-cmd: Implement new API tracecmd_add_option_v()
  trace-cmd: Implement new option in trace.dat file:
    TRACECMD_OPTION_TIME_SHIFT

Tzvetomir Stoyanov (VMware) (11):
  trace-cmd: Add new library API for local CPU count
  trace-cmd: Add new library API for reading ftrace buffers
  trace-cmd: Add new API to generate a unique ID of the tracing session
  trace-cmd: Store the session tracing ID in the trace.dat file
  trace-cmd: Exchange tracing IDs between host and guest
  trace-cmd: Add guest information in host's trace.dat file
  trace-cmd: Add host trace clock as guest trace argument
  trace-cmd: Refactor few trace-cmd internal functions.
  trace-cmd: Basic infrastructure for host - guest timestamp
    synchronization
  trace-cmd: [POC] PTP-like algorithm for host - guest timestamp
    synchronization
  trace-cmd: Debug scripts for PTP-like algorithm for host - guest
    timestamp synchronization

 Documentation/trace-cmd-record.1.txt      |   7 +
 include/trace-cmd/trace-cmd.h             | 121 +++-
 include/trace-cmd/trace-msg.h             |  10 +
 include/traceevent/event-parse.h          |   1 +
 lib/trace-cmd/Makefile                    |   3 +
 lib/trace-cmd/include/trace-cmd-local.h   |  33 +-
 lib/trace-cmd/include/trace-tsync-local.h |  38 ++
 lib/trace-cmd/trace-input.c               | 323 ++++++++++-
 lib/trace-cmd/trace-instance.c            | 335 +++++++++++
 lib/trace-cmd/trace-msg.c                 | 403 ++++++++++++--
 lib/trace-cmd/trace-output.c              | 117 +++-
 lib/trace-cmd/trace-timesync-ptp.c        | 649 ++++++++++++++++++++++
 lib/trace-cmd/trace-timesync.c            | 504 +++++++++++++++++
 lib/trace-cmd/trace-util.c                | 374 +++++++++++--
 scripts/debug/tsync_hist.py               |  57 ++
 scripts/debug/tsync_readme                |  12 +
 scripts/debug/tsync_res.py                |  46 ++
 tracecmd/Makefile                         |   3 +-
 tracecmd/include/trace-local.h            |  33 +-
 tracecmd/trace-agent.c                    |  58 +-
 tracecmd/trace-list.c                     |   2 +-
 tracecmd/trace-profile.c                  |   2 +-
 tracecmd/trace-read.c                     |   4 +-
 tracecmd/trace-record.c                   | 612 ++++++++++----------
 tracecmd/trace-show.c                     |   2 +
 tracecmd/trace-stat.c                     |  24 +-
 tracecmd/trace-tsync.c                    | 271 +++++++++
 tracecmd/trace-usage.c                    |   4 +
 28 files changed, 3563 insertions(+), 485 deletions(-)
 create mode 100644 lib/trace-cmd/include/trace-tsync-local.h
 create mode 100644 lib/trace-cmd/trace-instance.c
 create mode 100644 lib/trace-cmd/trace-timesync-ptp.c
 create mode 100644 lib/trace-cmd/trace-timesync.c
 create mode 100644 scripts/debug/tsync_hist.py
 create mode 100644 scripts/debug/tsync_readme
 create mode 100644 scripts/debug/tsync_res.py
 create mode 100644 tracecmd/trace-tsync.c

-- 
2.23.0

