Return-Path: <SRS0=q7JI=ZT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11305C432C3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4B48206F0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:02:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oTQhkRiL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfK0OCw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:02:52 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40519 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfK0OCw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 09:02:52 -0500
Received: by mail-lf1-f66.google.com with SMTP id y5so4550241lfy.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Nov 2019 06:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1ZxxXuB16u225pxnokpLT+sU6rvJUvLJyYojpv60oso=;
        b=oTQhkRiLLFQ4lwvPyoMgUYsPfv+KNI64jDtjb1uvnWIWNNxJ+XJ+NhC3GH9Maf0YCL
         ZXAKHm568BklVk8U93O9pT+r/mIIQ+pPPOtI1YIl6EZUwVfZvrbMFfR8kRgZpGFYRQSr
         p9iOj5UPZmKweiP+ikIdhuVaxefBAGkEFhRTqiSRib6kj5bl75PdWRXZwL0qGcdtb7Wd
         fy/L+8f1gZbuzscqu/IYFCnht6gy7rfM90bAkEFGufBdtv9eZG55235BU0ayEhuG3Ccu
         qfVTo/QNLAta1Yy1/QCulOF4wXdqJ+iY54njXuuL++6dGS4s8A9Bi3xpbvM14ue/I4aS
         fcUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1ZxxXuB16u225pxnokpLT+sU6rvJUvLJyYojpv60oso=;
        b=GFE40LsHN5ALAguoAt+1/L8djXriIkGYUdLZNbNzKGTYbEBvgOWw23jWfEMnkMWVpX
         UH/8jVnfSz6yt5E+002SgZ8IXd6k95Cxnx3GSWrSoL2f+CJMSNA4JVkRLW5tWsBccZak
         Yo9USV24dFn9S/kfgEMF799NzLAoPPJZ3RQvi2fGtl2wKehOgoXy/vmvMxryndmGw0mJ
         KnDoNlroY1Pq4GPjXEoK5nBaQoEkHu9RB2/CxEP5lhRuEqYfkDVZ0Gq7mv2eSfVtb2rD
         BwtQ8DayQQGbDWpO/RLjGwq4WBjmkzL91Y576sMkJSBpVd0ybtQjg9F9acVVFM6+nIC5
         pH2g==
X-Gm-Message-State: APjAAAVa0EkfQMN4LoG9x0Kbp8y6oCx15DfyLanwPEbHRXBq2XTrFLzl
        SHdcZmNpcSydqOH7L+f7myMCEZDvBYk=
X-Google-Smtp-Source: APXvYqy/nSiiJ81MRrI0c3r4B/1KarxghIk+mJQyFvPDfOofdMOGNcIaSNPGNlnTetSLMzsNfO2kRw==
X-Received: by 2002:a05:6512:505:: with SMTP id o5mr4842018lfb.180.1574863369761;
        Wed, 27 Nov 2019 06:02:49 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y18sm7268660lja.12.2019.11.27.06.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 06:02:49 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v14 00/19] Timestamp synchronization of host - guest
Date:   Wed, 27 Nov 2019 16:02:28 +0200
Message-Id: <20191127140247.258766-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Basic infrastructure for host - guest timestamp synchronization and a
POC implementation of PTP-like algorithm. 

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

Tzvetomir Stoyanov (VMware) (12):
  trace-cmd: Add new library API for local CPU count
  trace-cmd: Add new library API for reading ftrace buffers
  trace-cmd:  --del the tracee address map into the guest's trace.dat
    file
  trace-cmd: Add new API to generate a unique ID of the tracing session
  trace-cmd: Store the session tracing ID in the trace.dat file
  trace-cmd: Exchange tracing IDs between host and guest
  trace-cmd: Add guest information in host's trace.dat file
  trace-cmd: Add host trace clock as guest trace argument
  trace-cmd: Refactor few trace-cmd internal functions.
  trace-cmd: Basic infrastructure for host - guest timestamp
    synchronization
  trace-cmd:  [POC] PTP-like algorithm for host - guest timestamp
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
 lib/trace-cmd/trace-msg.c                 | 164 +++++-
 lib/trace-cmd/trace-output.c              | 116 +++-
 lib/trace-cmd/trace-timesync-ptp.c        | 668 ++++++++++++++++++++++
 lib/trace-cmd/trace-timesync.c            | 469 +++++++++++++++
 lib/trace-cmd/trace-util.c                | 358 ++++++++++--
 scripts/debug/tsync_hist.py               |  57 ++
 scripts/debug/tsync_readme                |  13 +
 scripts/debug/tsync_res.py                |  46 ++
 tracecmd/Makefile                         |   3 +-
 tracecmd/include/trace-local.h            |  33 +-
 tracecmd/trace-agent.c                    |  48 +-
 tracecmd/trace-list.c                     |   2 +-
 tracecmd/trace-profile.c                  |   2 +-
 tracecmd/trace-read.c                     |   4 +-
 tracecmd/trace-record.c                   | 603 ++++++++++---------
 tracecmd/trace-show.c                     |   2 +
 tracecmd/trace-stat.c                     |  24 +-
 tracecmd/trace-tsync.c                    | 265 +++++++++
 tracecmd/trace-usage.c                    |   4 +
 27 files changed, 2955 insertions(+), 445 deletions(-)
 create mode 100644 lib/trace-cmd/include/trace-tsync-local.h
 create mode 100644 lib/trace-cmd/trace-timesync-ptp.c
 create mode 100644 lib/trace-cmd/trace-timesync.c
 create mode 100644 scripts/debug/tsync_hist.py
 create mode 100644 scripts/debug/tsync_readme
 create mode 100644 scripts/debug/tsync_res.py
 create mode 100644 tracecmd/trace-tsync.c

-- 
2.23.0

