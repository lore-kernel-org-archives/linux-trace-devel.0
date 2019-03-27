Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419E2C10F00
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 14:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BE8A2082F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 14:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbfC0OTu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 10:19:50 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55235 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbfC0OTu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 10:19:50 -0400
Received: by mail-wm1-f66.google.com with SMTP id f3so211628wmj.4;
        Wed, 27 Mar 2019 07:19:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y7BpUMyKVA0X4XRPvcj0CGLJWTTcTqeuUc+gstR9GZw=;
        b=sxMupXmuzeKte4L2JoHiRi1eL1/gqUPrwXpPh/7VyiTgF4H/pbrJXhKbDcW2XXvrs0
         2iCTVyTdiOtgsHZfQXDozWOOd9uF1XpafUHlpsnp51hKLeLQvbB5GV5N1EY2reRnxAju
         qPcoLYBj/vG5pIN7QNrylmFFT54M4DZdXelUMP3r/rCij1Mn9CQIFwmJoq/3DnjGeXrV
         V/zAhK7dgxDokY4OAn+mrNuEb3ZvD1Aof6Roa1zkpU4dZhtpuaV1ONxngLq9RwJng4Gw
         Moi5sRWj8P7YqtZYuU8YyXpaKOIl61D59svp+4TlxdOvP2m/R6/9KvdLl8BiTRKGkrsg
         5etw==
X-Gm-Message-State: APjAAAUUFT2VLmXrHw5pfj3FL0yI4JDUudows8CRwDgVef2OMj9jybW3
        bGkm67qoegNdcklZHVc7G0yXwqzT
X-Google-Smtp-Source: APXvYqx6I4n3B+7c3TWOW5zdmAg52ZPpdRWCqfADM2+MpBP7gZ1n6cEvZ+ttEqZxlAMda814U3YQiA==
X-Received: by 2002:a1c:f909:: with SMTP id x9mr1240957wmh.18.1553696389038;
        Wed, 27 Mar 2019 07:19:49 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t69sm205022wmt.16.2019.03.27.07.19.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Mar 2019 07:19:47 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] Cleanup traceevent API and make it more consistent
Date:   Wed, 27 Mar 2019 16:19:41 +0200
Message-Id: <20190327141946.4353-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
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
 - Renamed a bunch of tracevent APIs, to make names consistent and descriptive.
 - Unified all tep_is_... APIs to return bool value, instead of int.

Changes depend on "Few patches, related to libtracevent APIs" patchset and 
should be applied on top of it.

Tzvetomir Stoyanov (5):
  tools/perf,tools/lib/traceevent: Make traceevent APIs more consistent
  tools/lib/traceevent: Rename input arguments of libtraceevent APIs
    from pevent to tep
  tools/perf,tools/lib/traceevent: Rename "pevent" member of struct
    tep_event to "tep"
  tools/perf,tools/lib/traceevent: Rename "pevent" member of struct
    tep_event_filter to "tep"
  tools/lib/traceevent: Rename input arguments and local variables of
    libtraceevent from pevent to tep

 tools/lib/traceevent/event-parse-api.c        | 152 ++--
 tools/lib/traceevent/event-parse-local.h      |   6 +-
 tools/lib/traceevent/event-parse.c            | 811 +++++++++---------
 tools/lib/traceevent/event-parse.h            | 130 +--
 tools/lib/traceevent/event-plugin.c           |  32 +-
 tools/lib/traceevent/parse-filter.c           |  46 +-
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
 24 files changed, 682 insertions(+), 683 deletions(-)

-- 
2.20.1

