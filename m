Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65CCBC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 08:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3956F21872
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 08:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfCOIh6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 04:37:58 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40135 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727055AbfCOIh6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 04:37:58 -0400
Received: by mail-wr1-f68.google.com with SMTP id t5so8629908wri.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Mar 2019 01:37:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MdDaulp0dmRPFZjb5JUUsqt4YcTFdJLyY+K+uiuNDXU=;
        b=Gt2+ZoCMlDtMBEujLEPy+LA5aYql/FyEgBi1xmXcveJ00u52z8UE4Z9I4bNbqcMC/v
         KWXiUb5SCvHh28FfhufVRmPOfl4ugJ2Am3y5YURB1RduILJIF9sGsfl4WwomSRQbBNUs
         fs8txm7EagV2ivUhQeYus6dZn1R8nyqOyO6zU0M189i0WOEEA0eH708exaR/sKzoagNN
         lMTURBbRsuq6EAFaVbuJlYNRv6ahHMeumGl1TiLbAX0MOyVL8Qcw4mljN2znEQtthzT2
         3xPA2h19UhNLrrx8dUvfjZKjPw8oJO5hVJ5OmotP0GvbPl+iGokRhaXaACplCvFmeflj
         /RxA==
X-Gm-Message-State: APjAAAWqf8KtQNMaFvTJGSNy3K2rS+A7urZGPULs1eKO8xVM1Lin9X0Y
        VEHoHmvC+pDyFIzc7hEOsFMIBq8s
X-Google-Smtp-Source: APXvYqxWfFvqkTPfgLU9o9OAVwsN46iUO2YJT4+dl1fPk/kQnh9yZp3qg2aKEQkt5tENDEJHzj9M0w==
X-Received: by 2002:adf:ed48:: with SMTP id u8mr1629767wro.185.1552639076562;
        Fri, 15 Mar 2019 01:37:56 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o5sm979395wmh.12.2019.03.15.01.37.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Mar 2019 01:37:55 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 0/9][POC] trace-cmd: Timetamps sync between host and guest machines, relying on vsock events.
Date:   Fri, 15 Mar 2019 10:37:45 +0200
Message-Id: <20190315083754.27532-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
 V6 changes:
  - Refactored tracecmd_msg_snd_time_sync() and tracecmd_msg_rcv_time_sync() functions:
 removed any time sync calculations logic as separate functions in trace-timesync.c file
  - Defined TSYNC_PROBE, TSYNC_REQ and TSYNC_RESP messages, in order to make the time sync
 protocol comprehensible.
  - Addressed Steven Rostedt comments.
  - Addressed Slavomir Kaslev commnets.
	
 V5 changes:
  - Rebased to Slavomir's v8 "Add VM kernel tracing over vsockets and FIFOs"
    patch series.
  - Implemented an algorithm for time drift correction.
  - Addressed Slavomir's commnets.
  - Refactored the code: moved all time sync specific implementation in trace-timesync.c
  - Isolated all hardcoded event specific stuff in a structure, so it could be easily 
    moved to external plugins.
  - Added a check for VSOCK support: do not perform vsock dependent time synchronisation 
    in case there is no VSOCK support. 

 V4 changes:
  - Removed the implementation of PTP-like algorithm. The current 
    logic relies on matching time stamps of kvm_exit/virtio_transport_recv_pkt
    events on host to virtio_transport_alloc_pkt/vp_notify events on guest.
  - Rebased to Slavomir's v7 "Add VM kernel tracing over vsockets and FIFOs" 
    patch series.
  - Decreased the time synch probes from 5000 to 300.
  - Addressed Steven Rostedt comments.
  - Code cleanup. 

 V3 changes:
 - Removed any magic constants, used in the PTP-like algorithm,
   as Slavomir Kaslev suggested.
 - Implemented new algorithm, based on mapping kvm_exit events
   in host context to vsock_send events in guest context,
   suggested by Steven Rostedt.

 V2 changes:
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
 lib/trace-cmd/trace-input.c      | 137 ++++-
 lib/trace-cmd/trace-util.c       |  95 ++--
 tracecmd/Makefile                |   1 +
 tracecmd/include/trace-local.h   |  43 +-
 tracecmd/include/trace-msg.h     |  10 +
 tracecmd/trace-agent.c           |  10 +-
 tracecmd/trace-msg.c             | 209 +++++++-
 tracecmd/trace-output.c          | 117 ++++-
 tracecmd/trace-read.c            |   4 +-
 tracecmd/trace-record.c          | 220 +++++++--
 tracecmd/trace-timesync.c        | 824 +++++++++++++++++++++++++++++++
 13 files changed, 1570 insertions(+), 132 deletions(-)
 create mode 100644 tracecmd/trace-timesync.c

-- 
2.20.1

