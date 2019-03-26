Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A37C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED28920823
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:43:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731979AbfCZPnc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:43:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53093 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfCZPnc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 11:43:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id a184so13154019wma.2;
        Tue, 26 Mar 2019 08:43:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NxoHuRCKKv0LkL0w4skRon9PU1PTcT75V45Vm3BVSq8=;
        b=uO+zY5Lb8mO4KLJ41TMgbsaVreEyA4P22TjP8tJXOOLY/2ma/9ugELkNpcu3KX4TaE
         wE0iZ2x/dYdzVteds1MT67wbRPjsXvvF89KFIbSA43LDLOweHwDmBaaK5vLfSanOEbvY
         dpA6CnwITVH4Lp5TMRn3ZUajZnd+2xuceCUO9RPSvl+YM3uasex3H+Dk4bdiL3gDEDUz
         SSAv+tqWJOitIyOE4iFvNOEpry4gpBzIQaVP/7oNoRGZEG6b9dASUoNzPndD48oLt9uo
         YPczJ88bU1hyz2LSvY5GgKZyAmNVUa0kYG8bQAchyscHvTIGNfZCHg9bE1d9hSl9xKUy
         px0Q==
X-Gm-Message-State: APjAAAXPTmajfaKMyM9vIyUi6WpSKqFa8quDLcZWCVwGmoZOd1W1HgAJ
        57H1FP73ZlEBzyq8vLMttLvCXNvx
X-Google-Smtp-Source: APXvYqzErFvbZBA7VzTsqpMFFrPMSiXkn5+m8pVUL1nloBpslsanw4U+qvtVvfkYyd3gcTgArj9Uig==
X-Received: by 2002:a1c:7a03:: with SMTP id v3mr6716358wmc.58.1553615010490;
        Tue, 26 Mar 2019 08:43:30 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id n11sm31927685wrt.63.2019.03.26.08.43.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Mar 2019 08:43:29 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] Cleanup traceevent API and make it more consistent
Date:   Tue, 26 Mar 2019 17:43:20 +0200
Message-Id: <20190326154328.28718-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch series does a cleanup of traceevent implementation and APIs:
 - All "pevent" function parameters and local variables are renamed to "tep". 
   This makes the implementation consistent with the chosen naming convention, 
   tep (trace event parser), and avoids any confusion with the old "pevent" name 
 - Removed deprecated tep filter trivial APIs.
 - Removed call to exit() from one of traceevent APIs, a library function should 
   not force the application to exit.
 - Added counter to track parsing failures.

Changes depend on "Few patches, related to libtracevent APIs" patchset and 
should be applied on top of it.

Tzvetomir Stoyanov (8):
  tools/perf,tools/lib/traceevent: Make traceevent APIs more consistent
  tools/lib/traceevent: Add counter to track parsing failures
  tools/lib/traceevent: Remove tep filter trivial APIs
  tools/lib/traceevent: rename input arguments of libtraceevent APIs
    from pevent to tep
  tools/perf,tools/lib/traceevent: rename "pevent" member of struct
    tep_event to "tep"
  tools/perf,tools/lib/traceevent: rename "pevent" member of struct
    tep_event_filter to "tep"
  tools/lib/traceevent: rename input arguments and local variables of
    libtraceevent from pevent to tep
  tools/lib/traceevent: remove call to exit() from
    tep_filter_add_filter_str()

 tools/lib/traceevent/event-parse-api.c        | 181 ++--
 tools/lib/traceevent/event-parse-local.h      |   8 +-
 tools/lib/traceevent/event-parse.c            | 817 +++++++++---------
 tools/lib/traceevent/event-parse.h            | 148 ++--
 tools/lib/traceevent/event-plugin.c           |  32 +-
 tools/lib/traceevent/parse-filter.c           | 216 +----
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
 tools/perf/util/trace-event-read.c            |   2 +-
 tools/perf/util/trace-event.c                 |   4 +-
 24 files changed, 719 insertions(+), 871 deletions(-)

-- 
2.20.1

