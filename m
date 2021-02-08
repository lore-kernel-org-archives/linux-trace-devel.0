Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D926C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Feb 2021 06:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC25F64E59
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Feb 2021 06:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhBHGSa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Feb 2021 01:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhBHGS2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Feb 2021 01:18:28 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E629C061786
        for <linux-trace-devel@vger.kernel.org>; Sun,  7 Feb 2021 22:17:48 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id p20so22765842ejb.6
        for <linux-trace-devel@vger.kernel.org>; Sun, 07 Feb 2021 22:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6gRK4cMA4EiHNCczeCbNkeGGIY6q1nb5wXmsSu48ifs=;
        b=VO0RGpNUz+rSv6M0c1oB/KS8AkDvYB2ILetbg25OtFmWxSENNd4ujpf7NBErnq1VZh
         N0L9DPJTAkm56h6obtVjJFY6Yh1U4Zsx0P9b6IZRfHGe6WFxKLInVIk2hJs2xvuLjcKi
         UfsfID2z5cnZGV4JuvcBrrXSnzyLSKNTbyp6napgC424zdXZJcp2i8VioRS3hZHLKw94
         l8IgaBIWT2BdVrzCx0gA9G75qf+N0Ba9RlwtIMCF59qNTSnqFx1+RXT+ORLo/2ms9yoJ
         3yqfMMChrkflWSVeJZmglNH9SWSm+a7vdouXdcv3kyneZUwBltheij6GZDMHKwvxBDZu
         5mHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6gRK4cMA4EiHNCczeCbNkeGGIY6q1nb5wXmsSu48ifs=;
        b=D3v9+L7V9AX1WlVDNTxqH3WQpBRZyCXJpV8kKMggEpJiVXHNhRMx8mzAFVSorLhwv+
         etp8XkXZ/7+0Yikw/pQbjEfN23QvYTCLAtljkvnS0RGJmGZBEu+NXil8qVcfDqxMX5Ow
         F0NcDcFd1ocEMpyjt2Zxm34DEnHkR4F6K+1kSxIrtWdiDJntmh+OAGMul2I9/SecNp6J
         UZBIrDvSE1tcoTFeoukuUPM4N5vej4tKA9wOk+HJGwd6uIh7HveUQNlz8bi/ccaCw2Dw
         OJVzVAthsLOcbMZnTf5vs2IyoU2egKOmtzEWYg9Ee2WEgC5cN2baXgxblzcIPkyjOUjq
         Rb9g==
X-Gm-Message-State: AOAM532d5SJLvx9bpopM79n2XGlLDAKW/YCGAyHlLtWEsUHIiJ/6yy/A
        iABImfdefbVGPsYO75U6VMo=
X-Google-Smtp-Source: ABdhPJyBGUyPW/oInqTaJtLa8zW2WwKkGN8vvume7WgLXqEIv1FFMfaOxsh+oqa8ByDUVPyXeot9FA==
X-Received: by 2002:a17:906:ecfb:: with SMTP id qt27mr15164432ejb.123.1612765066960;
        Sun, 07 Feb 2021 22:17:46 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 35sm135618edp.85.2021.02.07.22.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 22:17:45 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v28 0/8] Timestamp synchronization of host - guest tracing session
Date:   Mon,  8 Feb 2021 08:17:35 +0200
Message-Id: <20210208061743.510964-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Basic infrastructure for host - guest timestamp synchronization and a
PoC implementation of PTP-like and KVM algorithms. 

The KVM plugin is with higher weight than PTP, it is preferred in case both
are active. KVM is used only if x86-tsc clock is selected for the current
trace, PTP is used for all other cases.

These changes depend on commits:
 "trace-cmd: Fix plist allocation check in trace-msg.c"
   https://patchwork.kernel.org/project/linux-trace-devel/patch/20210203165431.792152a4@gandalf.local.home/
 "trace-cmd: Fix SEGFAULT when no tsync_protos are supplied"
   https://patchwork.kernel.org/project/linux-trace-devel/patch/20210203171018.5b82a0a7@gandalf.local.home/

 v28 changes:
  - Fix bugs, introduced by previous trace-cmd commits, related to tracefs
    library usage.
  - Removed unused type defines for trace packets.
 v27 changes:
  - Fixed broken compilation due to usage of old libtracefs APIs.
  - Rewrote complex macros to follow the Linux kernel requirements for macros.
  - Removed pathces from the set, that were already merged upstream.
 v26 changes:
  - Rebased on top of latest master.
  - Abstracted Time sync protocol names in a structure, to avoid using
    triple char pointers.
  - Removed a patch from the set, as it is already merged:
    "trace-cmd: Add new libtrasefs API to get the current trace clock".
  - Minor coding style changes, for better code readability.
 v25 changes:
  - Addressed Steven's comments.
  - Reorded the patches in the plugin - put the PTP and KVM PoC patches
    last and all other fixes and improvements before them.
  - Implemented a new libtrasefs API to get the current trace clock.
  - Replaced IDs of trace timestamps synchronization protocols with strings.
  - Implemented an "accuracy" parameter for timestamps synchronization
    protocols.
  - Added "scaling ratio" correction, calculated by the timestamp
    synchronization protocols.
  - Added flags, declared by the timestamps synchronization protocols,
    and stored in the trace.dat file, together with the calculated
    time offsets.
  - Implemented timestamp offset calculation per virtual CPU.
 v24 changes:
  - trace-cmd internal refactoring, needed for KVM timestamp synchronization
    plugin.
  - Added KVM timestamp synchronization plugin.

 v23 changes:
  - Added flags to PTP start message to control the behaviour of the
    algorithm. This is for development purposes mostly, to compare and
    evaluate how these changes affect the accuracy.
	PTP_FLAG_FASTEST_RESPONSE:  Consider only the probe with fastest
				    response time, otherwise make a histogram
				    from all probes.
	PTP_FLAG_USE_MARKER: Use trace marker to get the clock,
 			     otherwise use directly the system clock

 v22 changes, addressed Steven's comments:
  - Fixed error flow in read_qemu_guests_pids(), free allocated resources
    in case of an error.
  - Fixed initialisation of reallocated memmory in set_vcpu_pid_mapping().
  - Fixed bitmask logic in tracecmd_tsync_proto_select().
  - Fixed usage of wrong structure in make_trace_resp().

 v21 changes:
  - Rebased on top of latest master.
  - Remove these two patches from the set, as they are already merged:
       trace-cmd: Add new library API for local CPU count
       trace-cmd: Add support for negative time offsets in trace.dat file
  - Added more descriptive warning message when fails to extract Time Shift
    information from the trace.dat file.
  - Added a warning message when fails to obtain vcpu - pid mappings.
  - Handle the case with sparse VCPU numbers in VCPU - PID mapping
    array.
  - Fixed broken recording over FIFOs.
 v20 changes:
  - Rebased on top of latest master.
  - Removed the VCPUS_MAX hardcoded limit, reimplemented the cpu_pid[] array
    to be dynamically allocated.
  - Added a warning when reading of TRACECMD_OPTION_TIME_SHIFT option
    fails, due to unexpected option's size.
  - Improved loading of TRACECMD_OPTION_GUEST option data, as Steven
    suggested.
 v19 changes:
  - Rebased on top of latest master. The librtacefs is already merged,
    this allows to drop few patches from the set and use librtacefs APIs
    instead.
  - Reimplemented all new trace.dat options to be in binary format,
    instead of text. Leverage the new "trace-cmd dump" sub command to
    track what is written in the file.
  - Addressed Steven's comments.

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
Tzvetomir Stoyanov (VMware) (8):
  trace-cmd: Save command lines in VM agent
  trace-cmd: Fix bug in getting tracing dir in trace-cmd agent
  trace-cmd: Removed unused s64 define
  trace-cmd: Add timestamp synchronization per vCPU
  trace-cmd: Add dummy function to initialize timestamp sync logic
  trace-cmd: [POC] PTP-like algorithm for host - guest timestamp
    synchronization
  trace-cmd: Debug scripts for PTP-like algorithm for host - guest
    timestamp synchronization
  trace-cmd [POC]: Add KVM timestamp synchronization plugin

 lib/trace-cmd/Makefile                        |   2 +
 .../include/private/trace-cmd-private.h       |   5 +-
 lib/trace-cmd/include/trace-tsync-local.h     |  23 +-
 lib/trace-cmd/trace-input.c                   | 188 +++--
 lib/trace-cmd/trace-msg.c                     |   1 -
 lib/trace-cmd/trace-output.c                  |   4 +-
 lib/trace-cmd/trace-timesync-kvm.c            | 460 +++++++++++
 lib/trace-cmd/trace-timesync-ptp.c            | 715 ++++++++++++++++++
 lib/trace-cmd/trace-timesync.c                | 222 ++++--
 scripts/debug/tsync_hist.py                   |  57 ++
 scripts/debug/tsync_readme                    |  12 +
 scripts/debug/tsync_res.py                    |  46 ++
 tracecmd/trace-agent.c                        |   2 +
 tracecmd/trace-dump.c                         |  52 +-
 tracecmd/trace-record.c                       |  26 +-
 tracecmd/trace-tsync.c                        |  67 +-
 16 files changed, 1698 insertions(+), 184 deletions(-)
 create mode 100644 lib/trace-cmd/trace-timesync-kvm.c
 create mode 100644 lib/trace-cmd/trace-timesync-ptp.c
 create mode 100644 scripts/debug/tsync_hist.py
 create mode 100644 scripts/debug/tsync_readme
 create mode 100644 scripts/debug/tsync_res.py

-- 
2.29.2

