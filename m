Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA330C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C203120661
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfCHNo1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:44:27 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52126 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfCHNo1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:44:27 -0500
Received: by mail-wm1-f66.google.com with SMTP id n19so12577732wmi.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:44:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yUpNdRbq33uIpZSw+ryStVWRppLGcU9yATLiH1OjFLo=;
        b=bcHFpmL82wpqvaLydu71QPHndL1xCW7WSmwqvN2/iM1AW5Fv6xwR2BRp5+z0OytvdJ
         CQO83A/oaTyNnxP3sUU7Y5Vv/HhUYCZn/q8C6UwrU3OBqzZsmsmHM+BUgvgLWSdEJE9v
         NBsL9SFWDJdOVGnJglWp7VjU9mThwVnA9pDCmhEAiZJbAPU516t1IB4c50SBIjrKpeTh
         CY3c1MBSggb66MLthvCfI9n/s4XJ8mbMDf2zrhy9v9oTRlbUtjl0/5YDQmjwE7ewfP9O
         cWm8ZrWkdX7R3aBGtLxJSZX7uZehx6H9sMDeY4PpBu9pBYjKox7cSAe0rcoqnMoXxqg2
         nU4Q==
X-Gm-Message-State: APjAAAWxxfWaC52bS4N1aJsz1cNGmA7VoorEnJfAx29ABoOOh12DqDZr
        UNn/3jN/QdMYofXVLnyQhKk=
X-Google-Smtp-Source: APXvYqzT8kNJBmmAPlbTGQzuhPWmrP+stwpP5OWjg0geZQgNLitmGLp6sd4CD0aqkTWtivHQiaBE2A==
X-Received: by 2002:a1c:9e97:: with SMTP id h145mr9000606wme.147.1552052665285;
        Fri, 08 Mar 2019 05:44:25 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w4sm11631872wmg.8.2019.03.08.05.44.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:44:24 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 0/9] [POC] trace-cmd: Timetamps sync between host and guest machines, relying on vsock events.
Date:   Fri,  8 Mar 2019 15:44:14 +0200
Message-Id: <20190308134423.22008-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
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
  trace-cmd [POC]: Implemented timestamps synch PTP-like algorithm,
    using vsock events.

 include/trace-cmd/trace-cmd.h    |  19 +-
 include/traceevent/event-parse.h |   1 +
 lib/trace-cmd/trace-input.c      | 137 ++++++-
 lib/trace-cmd/trace-util.c       |  99 +++--
 tracecmd/Makefile                |   1 +
 tracecmd/include/trace-local.h   |  60 +++
 tracecmd/include/trace-msg.h     |  10 +
 tracecmd/trace-msg.c             | 284 +++++++++++++-
 tracecmd/trace-output.c          | 117 +++++-
 tracecmd/trace-read.c            |   4 +-
 tracecmd/trace-record.c          | 227 +++++++++--
 tracecmd/trace-timesync.c        | 622 +++++++++++++++++++++++++++++++
 12 files changed, 1467 insertions(+), 114 deletions(-)
 create mode 100644 tracecmd/trace-timesync.c

-- 
2.20.1

