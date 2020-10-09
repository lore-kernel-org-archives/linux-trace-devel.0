Return-Path: <SRS0=rOCb=DQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27165C433E7
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B918522261
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:03:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oQI3lMg/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbgJIODo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 10:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbgJIODo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 10:03:44 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B645AC0613D2
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Oct 2020 07:03:43 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a3so13191960ejy.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Oct 2020 07:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QbmpYWYrFUFCXSI3csTl3W2A+7yfoYllHADcrJWAxug=;
        b=oQI3lMg/+CHjbvzsP+rZgrCKXbKB0d9jpbfOslyzceTj9btCTXZpMleqI2sApPwTyB
         0HavQ7JYd7mQyfsOBunhbRft/Qo58VQMqOLjU53Go6npAxrI6ixrb8obJDA1MNY6qJ88
         BTcyOVsERpFR9ZYEXXoepAqCnb19GisDm3Zkrb2QPzNShJcsKIpsh3ZLVB0z0Qa6QGFj
         NYgVnsHH/HASDNEDL1Jb3k/DMqbztQCfK9ykOI78qlfrBz4ncGxFBa64kQ0Ut1advGHY
         l2cejwXmntJ089zE3tUceTchpGK/o64NUiGgj75v7GlqfEWnsZLut6I3GdZImtHx/zNE
         yN4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QbmpYWYrFUFCXSI3csTl3W2A+7yfoYllHADcrJWAxug=;
        b=UkUfJ9Q9nR9a8S8yuaO7Zqmmt6Vkv9fDIPZbgCC+ffidITdmLAkFuFuVv+MmrSM/gi
         8bAptCsDqNszREYa7oKqLkTo81u1OtmT4+aKKI2ShR3kXcmGYCnN394XaXizpuP8/3eK
         Yiepe+YV05tb3qF2+TnM+/+8D90uXPHLj9I3e8VLeyoHQq11PxiThPrjB9XXGnAmuOx6
         TR0l52kSuaZHRfUgo6eC2lcz7bcK1ovwb93RTbFVl9oVkjdIb9euLvkaCoRFxI5bsiXE
         6aLKLoqaT5E9k2W3+/swnaplP/72fYgr6JgHSJkuHkX+Gjf+tP6QL8Nw6z9E1NfQ/4lG
         WKVw==
X-Gm-Message-State: AOAM531tXN7iDhmfnvYi/U2Cr9XYvsTjt27oFAqhTTlBm2k3sBvdkXRD
        QFsh4VUbNWTeHThJROsTbG0WE+Ly+cxYTYUL
X-Google-Smtp-Source: ABdhPJwMIM2lrUm2RFyKkGawpS/fnNP5+9d/Ddt+HxBm5WGjgqlOgV5XZDp0hjSZ/oiKJJFn0RB4vg==
X-Received: by 2002:a17:906:c78a:: with SMTP id cw10mr14880272ejb.478.1602252222189;
        Fri, 09 Oct 2020 07:03:42 -0700 (PDT)
Received: from localhost.localdomain ([151.251.253.218])
        by smtp.gmail.com with ESMTPSA id ck19sm6362483ejb.99.2020.10.09.07.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 07:03:41 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v24 00/10] Timestamp synchronization of host - guest tracing session
Date:   Fri,  9 Oct 2020 17:03:28 +0300
Message-Id: <20201009140338.25260-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Basic infrastructure for host - guest timestamp synchronization and a
POC implementation of PTP-like and KVM algorithms. 

The KVM plugin is with higher weight than PTP, it is prefered in case both
are active. KVM is used only if x86-tsc clock is selected for the current
trace, PTP is used for all other cases.

[
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
]

Tzvetomir Stoyanov (VMware) (10):
  trace-cmd: [POC] PTP-like algorithm for host - guest timestamp
    synchronization
  trace-cmd: Debug scripts for PTP-like algorithm for host - guest
    timestamp synchronization
  trace-cmd: Add trace-cmd library APIs for ftrace clock name
  trace-cmd: Move VM related logic in a separate file
  trace-cmd: Add clock parameter to timestamp synchronization plugins
  trace-cmd: Add role parameter to timestamp synchronization plugins
  trace-cmd: Add host / guest role in timestamp synchronization context
  trace-cmd: Add guest CPU count PID in tracecmd_time_sync struct
  trace-cmd: Fixed bitmask logic tracecmd_tsync_proto_getall()
  trace-cmd [POC]: Add KVM timestamp synchronization plugin

 include/trace-cmd/trace-cmd.h             |  33 +-
 lib/trace-cmd/Makefile                    |   2 +
 lib/trace-cmd/include/trace-tsync-local.h |  13 +-
 lib/trace-cmd/trace-timesync-kvm.c        | 427 +++++++++++++
 lib/trace-cmd/trace-timesync-ptp.c        | 693 ++++++++++++++++++++++
 lib/trace-cmd/trace-timesync.c            |  59 +-
 lib/trace-cmd/trace-util.c                |  45 ++
 scripts/debug/tsync_hist.py               |  57 ++
 scripts/debug/tsync_readme                |  12 +
 scripts/debug/tsync_res.py                |  46 ++
 tracecmd/Makefile                         |   1 +
 tracecmd/include/trace-local.h            |  20 +
 tracecmd/trace-agent.c                    |   2 +
 tracecmd/trace-record.c                   | 260 ++------
 tracecmd/trace-tsync.c                    |  10 +-
 tracecmd/trace-vm.c                       | 214 +++++++
 16 files changed, 1648 insertions(+), 246 deletions(-)
 create mode 100644 lib/trace-cmd/trace-timesync-kvm.c
 create mode 100644 lib/trace-cmd/trace-timesync-ptp.c
 create mode 100644 scripts/debug/tsync_hist.py
 create mode 100644 scripts/debug/tsync_readme
 create mode 100644 scripts/debug/tsync_res.py
 create mode 100644 tracecmd/trace-vm.c

-- 
2.26.2

