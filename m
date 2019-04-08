Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C9FC10F13
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CEBC20883
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbfDHPXo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 11:23:44 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37335 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728838AbfDHPXn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 11:23:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id v14so15177104wmf.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Apr 2019 08:23:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4UJXab+RTfeS9J0fhSGUebyqdb6wh5oYM52e+NiMvyA=;
        b=a5DvHaQfo1UZdMXtfa6vjxORe4RV3FPQTrSQODhhl7hh4qm5jYXy+3e+hrMZf1ClIl
         gbsGe+gi4adMw9JG0dCVAN2UHDFVctYa5LoCdF6UeHdhz4chiiVzUT6/WF8/nGogtIyD
         InHTvu51fA3nsGTySn0dR5UZJWFcFFQ0b4nIJIENM8Yd8SQELqcsVVKfyRaK+dHLTdQK
         5yuZZ8pcfOHsQbQEDlmTevkbaK48LO2u/qw+3YQojiivS6Bbzc9b+74hW8e7HJsKutWj
         807QrVjMYpxQ0x4cIO+tnWfZRkYimmU+ZOVQaqvi2/hoCVwNgmibRHbWF+cBicDmnYny
         KFYQ==
X-Gm-Message-State: APjAAAUFchGW97vOL92qRyp6BFH/gnihEnAsdKV4WBzehKaEFYDuxl8J
        nxaw7WftAOR/OEgCZofA8gmzHdRp
X-Google-Smtp-Source: APXvYqy/079XFvUOWCcJjzTrvMthlIlsYhscN9WZln9RfDV2dKutVqf/nj8E7n4zFTkGr4uM3Nfqpg==
X-Received: by 2002:a7b:c155:: with SMTP id z21mr18225615wmi.1.1554737022008;
        Mon, 08 Apr 2019 08:23:42 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c6sm11142498wmb.21.2019.04.08.08.23.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Apr 2019 08:23:41 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 00/10] Backport of traceevent APIs cleanup changes from kernel tree to trace-cmd
Date:   Mon,  8 Apr 2019 18:23:30 +0300
Message-Id: <20190408152340.12450-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
 v2 changes:
  Fixed broken links in the patches descriptions.
]

A set of patches which aligns kernel libtraceevent implementation to trace-cmd 
one:
 - Got rid of "pevent" in library APIs and internal code, replaced it with "tep"
 - Removed deprecated filter trivial API
 - Made the API more consistent: aligned all "tep_is ... " APIs to return bool
 - Changed descriptions of some APIs, in order to be more informative

Steven Rostedt (VMware) (1):
  tools lib traceevent: Removed unneeded !! and return parenthesis

Tzvetomir Stoyanov (9):
  tools lib traceevent: Change description of few APIs
  tools lib traceevent: Implement new traceevent APIs for accessing
    struct tep_handler fields
  tools lib traceevent: Remove tep filter trivial APIs
  tools lib traceevent: Remove call to exit() from
    tep_filter_add_filter_str()
  tools tools, tools lib traceevent: Make traceevent APIs more
    consistent
  tools lib traceevent: Rename input arguments of libtraceevent APIs
    from pevent to tep
  perf tools, tools lib traceevent: Rename "pevent" member of struct
    tep_event to "tep"
  perf tools, tools lib traceevent: Rename "pevent" member of struct
    tep_event_filter to "tep"
  tools lib traceevent: Rename input arguments and local variables of
    libtraceevent from pevent to tep

 include/traceevent/event-parse.h   | 158 +++---
 lib/trace-cmd/trace-ftrace.c       |  16 +-
 lib/trace-cmd/trace-input.c        |  12 +-
 lib/traceevent/event-parse-api.c   | 213 ++++----
 lib/traceevent/event-parse-local.h |   6 +-
 lib/traceevent/event-parse.c       | 796 ++++++++++++++---------------
 lib/traceevent/event-plugin.c      |  32 +-
 lib/traceevent/parse-filter.c      | 216 +-------
 plugins/plugin_blk.c               |   8 +-
 plugins/plugin_cfg80211.c          |   8 +-
 plugins/plugin_function.c          |  22 +-
 plugins/plugin_hrtimer.c           |  13 +-
 plugins/plugin_jbd2.c              |  12 +-
 plugins/plugin_kmem.c              |  34 +-
 plugins/plugin_kvm.c               |  49 +-
 plugins/plugin_mac80211.c          |   6 +-
 plugins/plugin_sched_switch.c      |  18 +-
 plugins/plugin_scsi.c              |   8 +-
 plugins/plugin_xen.c               |   8 +-
 python/ctracecmd.i                 |   4 +-
 python/tracecmd.py                 |   2 +-
 tracecmd/trace-output.c            |   2 +-
 tracecmd/trace-profile.c           |   4 +-
 tracecmd/trace-read.c              |   6 +-
 tracecmd/trace-split.c             |   2 +-
 25 files changed, 735 insertions(+), 920 deletions(-)

-- 
2.20.1

