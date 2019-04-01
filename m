Return-Path: <SRS0=/ZZC=SD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E46FCC43381
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Apr 2019 13:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B98012086C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Apr 2019 13:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfDANVP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Apr 2019 09:21:15 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40706 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfDANVP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Apr 2019 09:21:15 -0400
Received: by mail-ed1-f66.google.com with SMTP id h22so8189263edw.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Apr 2019 06:21:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0aYd86pBDCtFof2fnbuPWK4tOty5UKV1nw7O3CJOqbo=;
        b=I01+WMjrJf5VOv21brAZf3YioaO6uXD0QZitirx5BbqPkvGVZ/n9IjaU7j8I9QOR/N
         2YAx0Zpf6/qwe3wov9mcyiXi6yKTRHLb40Lx0QLo/1wCHj0X1ubV6shrlydM2ax/kIt2
         BcjmgTdrdOIRAmGOQmx+YfNdh51zqTikUrMI4V+PWH0iFJZ0r38kCD0M3Vnns3CkVNjJ
         OwPN3TW6CANlRu4DR+FjiVhkj7dOGL8v4Bb1zGuOIkYk9KOAvBC4cg6rZ8flycztArnb
         lO89WbeqYx6T0DLGEDNKl+BuJ9gLAhWTwEwRZvy/MTU2Hc/R36Fi/cVyv49p+dHwAd6q
         DaSQ==
X-Gm-Message-State: APjAAAVe+URIpMXylCOrMPQnvWdZgoZ8mVqlrKkBssSOqh/e/1PuVYow
        uAQNfXNXXd/Hd1RakBIaEjAJM9YN
X-Google-Smtp-Source: APXvYqxpoCgvarHC4VMpzGiJti3zDjnmp5Wr997gKzTD3m/nNrv9ylnmAFq2KhVYv+vPQgOgiyK1tQ==
X-Received: by 2002:a50:95f2:: with SMTP id x47mr41053356eda.178.1554124873428;
        Mon, 01 Apr 2019 06:21:13 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y27sm1488112edb.67.2019.04.01.06.21.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Apr 2019 06:21:12 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/4] Cleanup traceevent API and make it more consistent
Date:   Mon,  1 Apr 2019 16:21:07 +0300
Message-Id: <20190401132111.13727-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
 v3 changes:
  - Excluded patch
    "tools/perf,tools/lib/traceevent: Make traceevent APIs more consistent"
   from the series, as is is already merged.
  - Rebased on top of Steven's branch tip/perf/core

 v2 changes:
  - Excluded patches:
     "tools/lib/traceevent: Remove tep filter trivial APIs"
     "tools/lib/traceevent: remove call to exit() from tep_filter_add_filter_str()"
    from the series, as they are already merged.
  - Dropped patch "tools/lib/traceevent: Add counter to track parsing failures",
    this functionality will not be part of the traceevent library. Applications
    should track parsing failures themselves.
  - Few minor changes, to address Steven Rostedt comments 
]

This patch series does a cleanup of traceevent implementation and APIs:
 - All "pevent" function parameters and local variables are renamed to "tep". 
   This makes the implementation consistent with the chosen naming convention, 
   tep (trace event parser), and avoids any confusion with the old "pevent" name. 

Changes depend on "Few patches, related to libtracevent APIs" patchset and 
should be applied on top of it.

Tzvetomir Stoyanov (4):
  tools/lib/traceevent: Rename input arguments of libtraceevent APIs
    from pevent to tep
  tools/perf,tools/lib/traceevent: Rename "pevent" member of struct
    tep_event to "tep"
  tools/perf,tools/lib/traceevent: Rename "pevent" member of struct
    tep_event_filter to "tep"
  tools/lib/traceevent: Rename input arguments and local variables of
    libtraceevent from pevent to tep

 tools/lib/traceevent/event-parse-api.c        | 132 +--
 tools/lib/traceevent/event-parse-local.h      |   6 +-
 tools/lib/traceevent/event-parse.c            | 772 +++++++++---------
 tools/lib/traceevent/event-parse.h            | 127 ++-
 tools/lib/traceevent/event-plugin.c           |  32 +-
 tools/lib/traceevent/parse-filter.c           |  44 +-
 tools/lib/traceevent/plugin_cfg80211.c        |   8 +-
 tools/lib/traceevent/plugin_function.c        |  14 +-
 tools/lib/traceevent/plugin_hrtimer.c         |  12 +-
 tools/lib/traceevent/plugin_jbd2.c            |  12 +-
 tools/lib/traceevent/plugin_kmem.c            |  32 +-
 tools/lib/traceevent/plugin_kvm.c             |  48 +-
 tools/lib/traceevent/plugin_mac80211.c        |   8 +-
 tools/lib/traceevent/plugin_sched_switch.c    |  18 +-
 tools/lib/traceevent/plugin_scsi.c            |   8 +-
 tools/lib/traceevent/plugin_xen.c             |   8 +-
 tools/perf/builtin-kmem.c                     |   2 +-
 tools/perf/util/data-convert-bt.c             |   4 +-
 tools/perf/util/python.c                      |   2 +-
 .../util/scripting-engines/trace-event-perl.c |   2 +-
 .../scripting-engines/trace-event-python.c    |   2 +-
 tools/perf/util/trace-event-parse.c           |   2 +-
 22 files changed, 646 insertions(+), 649 deletions(-)

-- 
2.20.1

