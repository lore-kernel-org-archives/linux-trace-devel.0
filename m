Return-Path: <SRS0=Qwo8=ZV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2166BC43215
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7BC7217D7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mdep5VpQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfK2KRk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Nov 2019 05:17:40 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:36733 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfK2KRk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Nov 2019 05:17:40 -0500
Received: by mail-lj1-f181.google.com with SMTP id k15so31416368lja.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Nov 2019 02:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2XA+FUc2LtOXiY5fZbK16qWLC8mdHdGq4DtHkusIsnA=;
        b=Mdep5VpQrP7D7Vw3VVH660SIulD6MLc69UUZMBBlgQdhwD9ceVlgnmCiMdmrCdNAmS
         O8s4FEyk2p+43zBdLwG5U5vHD4VP3O2r1sNvPOnYbbF7k4VDbipsCbyN/i9h2UYXN49Z
         +8/am+kScPZGlUtpNq53oAYUXYWGl3NDSI7DPp0Yrd9xBcoGVe6KYKMRNVD8Poz2yLgA
         14u9sRPNvNbvM7rzqfZPUwa4BrB9WaukpVUDeZ8Pn7oUnxpK0ZODdFq7c7Btupcc6Nab
         yvk3twvrJ3y+OL9wa99j2k7WeEaqkSFYWuW8qce9XWz2goE+IIolaQYUWp9hMi9BzirT
         I1fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2XA+FUc2LtOXiY5fZbK16qWLC8mdHdGq4DtHkusIsnA=;
        b=G7kZ69ZqwPWnJvBtdUO18yzM1wo6N29z70iPoGYRiw2kRZK4Hdu3c295VGgcvLb1K8
         kkQF8v31EfRqR2rtTHsybFe+s5EhBJxs1ykI8KUZVJ2SCvH36BlQ4G4+ehJvx/5Zs9mA
         2U7p93Gpdh9j3r1kUZdMq8e3OQ1YGXDJG5qc1Nl0b+GAGAvVJ+E7TDQ/VyOAzsfxrshP
         RAK8ArZwP9bhmp8K/Vkgs5II7uoaV/ZNKC4XHB+RLx5cET4nFO0oTAS8cfzRDg+vMFw3
         oSPTnKmL+gaEPk3vQBssCH5EPvV5fl0FbSBQOFcWD0Rut4DbeA0XN2YZhNExuekGiSbc
         y6oQ==
X-Gm-Message-State: APjAAAXkCBX2I42/Pd6N4bwCesv8iDTvnOfbDFUc/K/9ogL/7f6hDDio
        qSaQR06VXkq7dEnx8eFIonVZY3gOva8=
X-Google-Smtp-Source: APXvYqxCATEnu2fEL5+thHb4R4jPh6mjN8a30d/NVhS86VgJtMBMnZioh+RLhtnFkgdaTYllkpppHw==
X-Received: by 2002:a2e:5751:: with SMTP id r17mr6586092ljd.254.1575022656588;
        Fri, 29 Nov 2019 02:17:36 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x29sm11367935lfg.45.2019.11.29.02.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 02:17:35 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v16 00/18]Timestamp synchronization of host - guest tracing session
Date:   Fri, 29 Nov 2019 12:17:15 +0200
Message-Id: <20191129101733.375808-1-tz.stoyanov@gmail.com>
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

 Documentation/trace-cmd-record.1.txt      |   6 +
 include/trace-cmd/trace-cmd.h             | 116 +++-
 include/trace-cmd/trace-msg.h             |  10 +
 include/traceevent/event-parse.h          |   1 +
 lib/trace-cmd/Makefile                    |   3 +
 lib/trace-cmd/include/trace-cmd-local.h   |  33 +-
 lib/trace-cmd/include/trace-tsync-local.h |  36 ++
 lib/trace-cmd/trace-input.c               | 314 +++++++++-
 lib/trace-cmd/trace-instance.c            | 265 +++++++++
 lib/trace-cmd/trace-msg.c                 | 162 +++++-
 lib/trace-cmd/trace-output.c              | 116 +++-
 lib/trace-cmd/trace-timesync-ptp.c        | 666 ++++++++++++++++++++++
 lib/trace-cmd/trace-timesync.c            | 469 +++++++++++++++
 lib/trace-cmd/trace-util.c                | 358 ++++++++++--
 scripts/debug/tsync_hist.py               |  57 ++
 scripts/debug/tsync_readme                |  12 +
 scripts/debug/tsync_res.py                |  46 ++
 tracecmd/Makefile                         |   3 +-
 tracecmd/include/trace-local.h            |  33 +-
 tracecmd/trace-agent.c                    |  48 +-
 tracecmd/trace-list.c                     |   2 +-
 tracecmd/trace-profile.c                  |   2 +-
 tracecmd/trace-read.c                     |   4 +-
 tracecmd/trace-record.c                   | 600 ++++++++++---------
 tracecmd/trace-show.c                     |   2 +
 tracecmd/trace-stat.c                     |  24 +-
 tracecmd/trace-tsync.c                    | 268 +++++++++
 tracecmd/trace-usage.c                    |   4 +
 28 files changed, 3216 insertions(+), 444 deletions(-)
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

