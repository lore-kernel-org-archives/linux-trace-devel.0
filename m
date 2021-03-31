Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F198C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 07:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BCEC61996
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 07:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbhCaH3h (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbhCaH3F (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 03:29:05 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D03C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 Mar 2021 00:29:05 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id kt15so28498983ejb.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 Mar 2021 00:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ep1gIkiy0d4MVe71Zl4ruxyLZXUMdtpUQz8f15NCIbU=;
        b=YdobR+3Fbxy7TWLDKZHrDzw8a8ZFEOdupNjCBnDkKJKZxKZDsAV5EEv+KnqjzUwgRZ
         DYZEfB6tfuqWvLXCTszPfoTD1RyJgoNc6L2muIvo2e569j63VP3rzjV3FiIQlLfunSnT
         7DB8L5PVXYu7KMCtd23t7mGzGB0Iy4wx+oPsQaFd39KCjvXuylPIHnm35qO6Em8CXAPI
         z0milGJtsq15Jez60Of7BP3Cvi271aDAyZHGSXD0DnFS+Kp7ntJgK7PvWqG5uefdkB3x
         138H4UZVE/kYdHDIToI7AbhABrouS4T2Wm6RWklZvgMDgxUNWHZIWGJQ//bcgtUuDmU2
         agZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ep1gIkiy0d4MVe71Zl4ruxyLZXUMdtpUQz8f15NCIbU=;
        b=dFgfg/wNXJa3EeB9XVmLKuo34VmOwqbMFh0YYrF171H/e5Vprc3O/UUKIUHZ9vkjrK
         zmeLsut2x7WwEq9NT+72Ry80ij/vtxOhh7+t9eme4n1u+aFZVCjHfWBGuarL2ZeGzptm
         os3yyZNlM2ktoQJcbm+pJfytfj8JTMOftZkaxMfzroYH7coV/YT7vBERsFnaNN4pZhjN
         RAqOxCA7vbWLm9ANP7tMsz8VBUljYG1PUoYKBu4kyCkn++ObtOD6YvGiV5TQLRXlK5Dz
         J7/hwbCzgm46EhWcpbae4JpcvUYWrdH7EZoKbxXsdpYx71dYGT1GpxKNfcCvDum8ldKT
         NOEw==
X-Gm-Message-State: AOAM531T0TMWuLUlbdmZ+2Jrhkv8AaghmBLLJxcdDwbboYKpVrvMwfBR
        H5P8FDZOH3f1qfMJ1bnruIywYcYMM4Rn7g==
X-Google-Smtp-Source: ABdhPJwFTefoRIEiwGr35Bin1+GWwxGKrVLH2WRLpFiDaD7pkJkVQILe8OxUGwyVioI2Nv6vgZjRNg==
X-Received: by 2002:a17:906:7f84:: with SMTP id f4mr1973407ejr.525.1617175743848;
        Wed, 31 Mar 2021 00:29:03 -0700 (PDT)
Received: from oberon.vmware.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id ho11sm587469ejc.112.2021.03.31.00.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 00:29:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v34 0/5] Timestamp synchronization of host - guest tracing session
Date:   Wed, 31 Mar 2021 10:28:56 +0300
Message-Id: <20210331072901.152880-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
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

These changes depend on:
   "Refactoring and improvements of time sync logic" patch set.
   "TSC trace clock to nanosecond conversion" patch set.

 v34 changes:
  - Fixed typo in the name of the local function that reads long long
    integer from a file.
  - Changed reading a long long integer from a file to autodetect the format
    instead of hardcoding it to decimal.
  - Removed POC label from the patch introducing the KVM time sync algorithm.
 v33 changes:
  - Check for non-default KVM scaling. If such is detected, fail back to the
    ptp algorithm. The problem with the KVM scaling is
    Reported-by: Stefano De Venuto <stefano.devenuto99@gmail.com>
 v32 changes:
  - Reduced the patch set by moving the logic for TSC to nanosecond
    conversion in a separate set.
  - Moved the logic for internal refactoring of existing and already merged
    time sync logic in a separate set.
 v31 changes:
  - Removed POC label from the patch introducing the PTP time sync
    algorithm.
  - Implemented logic for TSC clock to nanoseconds conversion.
  - Select x86-tsc clock for the tracing session, is KVM timesync plugin is
    available and the user did not specify any trace clock.
 v30 changes:
  - Moved all time sync logic in the trace-cmd library.
  - Separate the logic for pthread barrier time sync threads synchronization
    in its own patch.
 v29 changes:
  - Included <linux/types.h> in trace-timesync-kvm.c for __s64 type.
  - Added pthread barrier to host time sync pthread, to ensure times are
    synchronized before starting the trace.
  - Removed already merged patches from the set.
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
Tzvetomir Stoyanov (VMware) (5):
  trace-cmd: Add dummy function to initialize timestamp sync logic
  trace-cmd: Add timestamp synchronization per vCPU
  trace-cmd: PTP-like algorithm for host - guest timestamp
    synchronization
  trace-cmd: Debug scripts for PTP-like algorithm for host - guest
    timestamp synchronization
  trace-cmd: Add KVM timestamp synchronization plugin

 lib/trace-cmd/Makefile                        |   4 +
 .../include/private/trace-cmd-private.h       |   2 +-
 lib/trace-cmd/include/trace-tsync-local.h     |  23 +-
 lib/trace-cmd/trace-input.c                   | 175 +++--
 lib/trace-cmd/trace-timesync-kvm.c            | 533 +++++++++++++
 lib/trace-cmd/trace-timesync-ptp.c            | 715 ++++++++++++++++++
 lib/trace-cmd/trace-timesync.c                | 292 +++++--
 scripts/debug/tsync_hist.py                   |  57 ++
 scripts/debug/tsync_readme                    |  12 +
 scripts/debug/tsync_res.py                    |  46 ++
 tracecmd/trace-agent.c                        |   1 +
 tracecmd/trace-dump.c                         |  52 +-
 tracecmd/trace-record.c                       |  25 +-
 13 files changed, 1757 insertions(+), 180 deletions(-)
 create mode 100644 lib/trace-cmd/trace-timesync-kvm.c
 create mode 100644 lib/trace-cmd/trace-timesync-ptp.c
 create mode 100644 scripts/debug/tsync_hist.py
 create mode 100644 scripts/debug/tsync_readme
 create mode 100644 scripts/debug/tsync_res.py

-- 
2.30.2

