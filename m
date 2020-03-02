Return-Path: <SRS0=nG5h=4T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5E9C3F2D1
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 10:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F368820870
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 10:14:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jMh+rP4p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgCBKOJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 05:14:09 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39712 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgCBKOJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 05:14:09 -0500
Received: by mail-lj1-f193.google.com with SMTP id o15so11056441ljg.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Mar 2020 02:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZWZ/yluxsqdAps7Or+7vNs7FWZbm/aUJaON3W/0wQNs=;
        b=jMh+rP4p4Ju3p4jcQToroDbPnsVf+BH3cg3XcV6VllqRiBypVe5qPKN8w3v2h7i5gr
         qCmNUGoWFhgOShSnGtbL7Ene9giwTPIvjxTqWw2G3pMi4kbZeR8btOJSDA3ywcVs6r8R
         UsX8ze2bYdztHXUdK/SQMN5pBDPLVCB2hOgviFPJJGnf1H6Wqbribie+YbnsCOkHFTYS
         RfUm09iUTkJ47f762HBc+lH/0DvJBbBgY2IZi7zcbcjBilItZyk2Y3cyL3MrRUbzgg1w
         l8OTFpFhffc4Utw2/6HvCyhNFMOXhAj1qSbP2EWfqwhgeALW4iDUtmOz//Ai9reF4sIX
         Jiqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZWZ/yluxsqdAps7Or+7vNs7FWZbm/aUJaON3W/0wQNs=;
        b=MSKzpcopecuxmyGgbrc5Ucl0E7KZNOuuRBy53vcjQOai617D5m+Ldon/+qkvvDilEA
         dvtfpRMoUIlYLBSdKT5JwBssD2U9UNarIlNzfWJsIB2jOGmXs6IUWaqIJm7LEHbVRFtp
         Uv+8HPDU4WDiHNAVnSA/Hkhv8PnJ7EWAtlkokQARizMObPVQmNjTs3t6pu7SEKvhS2py
         6qAeBtvATWlUHVZUZ4pDVQoD4lT185SG1UhWMYrO07GoJ3ahJDKjYLTcr3Q5ErAb7IEa
         02oAHIvDEhMhytm1OoDsofGcTrXMiivFGOA2/AfZdJ6EHSSTVlap6vAhrcpGQtpx5Brh
         vacA==
X-Gm-Message-State: ANhLgQ3WySi1VRvuPoxzEz+RVxusj6sQcws5IV7pK+OWLjID0iWyNuNd
        XoSBwINEw8PG4Udv5h7THoGfUbFW
X-Google-Smtp-Source: ADFU+vvEFbfNRJy2zbWbtxU/v73gqTi5AHyI1bENIsZtI+mXeLF1g7OHxKEAq5WpDYdWDQGOaAwczg==
X-Received: by 2002:a2e:6815:: with SMTP id c21mr10125997lja.10.1583144047400;
        Mon, 02 Mar 2020 02:14:07 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x10sm11048236ljd.68.2020.03.02.02.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 02:14:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v21 00/13]  Timestamp synchronization of host - guest tracing session
Date:   Mon,  2 Mar 2020 12:13:51 +0200
Message-Id: <20200302101404.150035-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Basic infrastructure for host - guest timestamp synchronization and a
POC implementation of PTP-like algorithm. 

[
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

Tzvetomir Stoyanov (4):
  trace-cmd: Find and store pids of tasks, which run virtual CPUs of
    given VM
  trace-cmd: Implement new API tracecmd_add_option_v()
  trace-cmd: Add definitions of htonll() and ntohll()
  trace-cmd: Implement new option in trace.dat file:
    TRACECMD_OPTION_TIME_SHIFT

Tzvetomir Stoyanov (VMware) (9):
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
 include/trace-cmd/trace-cmd.h             |  79 ++-
 include/traceevent/event-parse.h          |   1 +
 lib/trace-cmd/Makefile                    |   2 +
 lib/trace-cmd/include/trace-cmd-local.h   |  45 +-
 lib/trace-cmd/include/trace-tsync-local.h |  38 ++
 lib/trace-cmd/include/trace-write-local.h |  43 ++
 lib/trace-cmd/trace-input.c               | 332 ++++++++++-
 lib/trace-cmd/trace-msg.c                 | 402 +++++++++++--
 lib/trace-cmd/trace-output.c              | 119 +++-
 lib/trace-cmd/trace-timesync-ptp.c        | 651 ++++++++++++++++++++++
 lib/trace-cmd/trace-timesync.c            | 506 +++++++++++++++++
 lib/trace-cmd/trace-util.c                |  37 ++
 scripts/debug/tsync_hist.py               |  57 ++
 scripts/debug/tsync_readme                |  12 +
 scripts/debug/tsync_res.py                |  46 ++
 tracecmd/Makefile                         |   3 +-
 tracecmd/include/trace-local.h            |  24 +-
 tracecmd/trace-agent.c                    |  57 +-
 tracecmd/trace-dump.c                     | 122 ++++
 tracecmd/trace-record.c                   | 263 ++++++++-
 tracecmd/trace-tsync.c                    | 272 +++++++++
 tracecmd/trace-usage.c                    |   4 +
 23 files changed, 2981 insertions(+), 141 deletions(-)
 create mode 100644 lib/trace-cmd/include/trace-tsync-local.h
 create mode 100644 lib/trace-cmd/include/trace-write-local.h
 create mode 100644 lib/trace-cmd/trace-timesync-ptp.c
 create mode 100644 lib/trace-cmd/trace-timesync.c
 create mode 100644 scripts/debug/tsync_hist.py
 create mode 100644 scripts/debug/tsync_readme
 create mode 100644 scripts/debug/tsync_res.py
 create mode 100644 tracecmd/trace-tsync.c

-- 
2.24.1

