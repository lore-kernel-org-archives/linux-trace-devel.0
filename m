Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68FDC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Nov 2022 22:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbiKQWuH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Nov 2022 17:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240398AbiKQWuG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Nov 2022 17:50:06 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB3465E49
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Nov 2022 14:50:05 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id f71-20020a25384a000000b006dd7876e98eso2861495yba.15
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Nov 2022 14:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mkE/jseB+mAvo5T0KGdJHv7G0FFmlGhJP5kFwdKFknc=;
        b=krp3Im7u4EE7ngh31O+puMO6xpuQb6aLCoGwbJ92YvbTje/EkifY+4TQxfmoaMaWlD
         xB4GmxVxsMYdX7TmLoELM6RpFweoK/aHDX73QOMeCH6FWJRp86y3ESmCTd24lEUefJ1W
         RbCozF+hPP+mKzQg/Qdh1QgjiH3XsXcxoNYGHSgOBpBmSxCxgklhGoahKdGFXBbouky8
         afcvPi1w/ydB6NGfQEzU4/tQRMoHf0pLEVC5BzN+jvIVM6BmFVPDM1Evfn78Z3Ay2wdQ
         6PwlCL/Y6pPS7voC1EbY5ODfg4fByTRSBVVwEM0hdmk/57PrGd/kLjHxJMqeRt+IWEql
         4ROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mkE/jseB+mAvo5T0KGdJHv7G0FFmlGhJP5kFwdKFknc=;
        b=cFIjst2L5Uzp7s0uTrB1tW5o5MMfANRN2VZLRbdtzPZznfQUXhs4DQCMRqTeErr/YR
         lQfNfimrdvvVzL02Nl7zx2/nIQwZVwk6ABU3HDAyfQ27iyqpcRNhBj0b9HhNPSutxAW7
         m/+vp/XL9dRe0UPzzmf2dgu5eXdmtrymj/jMwgByNiof8uGET3LVg3p0NoNG/d/Tl/ar
         H0XgGL8M4oS6wfBXBcdRbIvyehOnG263kRlSDK9bZMQVZsHf6OqPq58hMbKxRfy9EO3k
         mLVyIubZb77p8TGhkx/013nxY7MFVO6c7zynhlDV4GnP5cXVxHXMKsIC7xQCbdPq1Ci0
         3aCA==
X-Gm-Message-State: ANoB5pktKsRceN9V47rxDitVlKJ6s9M47MmQE98VrpqMzigFzQSbb/0A
        h/XiBPX0QytGEPj0lwrQI8HS9qhOZLgL
X-Google-Smtp-Source: AA0mqf7F7zom9i8xWEHIkUNYblobZwQJwp6/9AAJa/Rg8XPgD+B+ulVRzOK1PPLEBUzlvlpnsTtejtxb39SG
X-Received: from irogers.svl.corp.google.com ([2620:15c:2d4:203:3f1e:c462:d6b8:fba8])
 (user=irogers job=sendgmr) by 2002:a25:ca56:0:b0:6c9:9c1a:e8c with SMTP id
 a83-20020a25ca56000000b006c99c1a0e8cmr4059860ybg.620.1668725405037; Thu, 17
 Nov 2022 14:50:05 -0800 (PST)
Date:   Thu, 17 Nov 2022 14:49:50 -0800
Message-Id: <20221117224952.358639-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Subject: [PATCH v1 0/2] perf always use system libtraceevent
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Steven Rostedt <rostedt@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Force the perf build to use the previously optional non-default
LIBTRACEEVENT_DYNAMIC, ie the system libtraceevent. With nothing using
the now out-of-date tools/lib/traceevent remove it.

Discussed on LKML here:
https://lore.kernel.org/lkml/CAP-5=fWxAjEia-Qbm0RVzKOxyiod8rUOBieqaGK=DtQboDe3Qw@mail.gmail.com/

Builds upon:
https://lore.kernel.org/lkml/20221116224631.207631-1-irogers@google.com/

Ian Rogers (2):
  perf build: Require libtraceevent from the system
  tools lib traceevent: Remove libtraceevent

 tools/lib/traceevent/.gitignore               |    4 -
 tools/lib/traceevent/Build                    |    8 -
 tools/lib/traceevent/Documentation/Makefile   |  207 -
 .../traceevent/Documentation/asciidoc.conf    |  120 -
 .../Documentation/libtraceevent-commands.txt  |  153 -
 .../Documentation/libtraceevent-cpus.txt      |   77 -
 .../libtraceevent-endian_read.txt             |   78 -
 .../libtraceevent-event_find.txt              |  103 -
 .../Documentation/libtraceevent-event_get.txt |   99 -
 .../libtraceevent-event_list.txt              |  122 -
 .../libtraceevent-event_print.txt             |  130 -
 .../libtraceevent-field_find.txt              |  118 -
 .../libtraceevent-field_get_val.txt           |  122 -
 .../libtraceevent-field_print.txt             |  126 -
 .../libtraceevent-field_read.txt              |   81 -
 .../Documentation/libtraceevent-fields.txt    |  105 -
 .../libtraceevent-file_endian.txt             |   91 -
 .../Documentation/libtraceevent-filter.txt    |  209 -
 .../Documentation/libtraceevent-func_apis.txt |  183 -
 .../Documentation/libtraceevent-func_find.txt |   88 -
 .../Documentation/libtraceevent-handle.txt    |  101 -
 .../libtraceevent-header_page.txt             |  102 -
 .../libtraceevent-host_endian.txt             |  104 -
 .../Documentation/libtraceevent-long_size.txt |   78 -
 .../Documentation/libtraceevent-page_size.txt |   82 -
 .../libtraceevent-parse_event.txt             |   90 -
 .../libtraceevent-parse_head.txt              |   82 -
 .../Documentation/libtraceevent-plugins.txt   |  122 -
 .../libtraceevent-record_parse.txt            |  137 -
 .../libtraceevent-reg_event_handler.txt       |  156 -
 .../libtraceevent-reg_print_func.txt          |  155 -
 .../Documentation/libtraceevent-set_flag.txt  |  104 -
 .../Documentation/libtraceevent-strerror.txt  |   85 -
 .../Documentation/libtraceevent-tseq.txt      |  158 -
 .../Documentation/libtraceevent.txt           |  192 -
 .../traceevent/Documentation/manpage-1.72.xsl |   14 -
 .../traceevent/Documentation/manpage-base.xsl |   35 -
 .../Documentation/manpage-bold-literal.xsl    |   17 -
 .../Documentation/manpage-normal.xsl          |   13 -
 .../Documentation/manpage-suppress-sp.xsl     |   21 -
 tools/lib/traceevent/Makefile                 |  300 -
 tools/lib/traceevent/event-parse-api.c        |  333 -
 tools/lib/traceevent/event-parse-local.h      |  123 -
 tools/lib/traceevent/event-parse.c            | 7624 -----------------
 tools/lib/traceevent/event-parse.h            |  750 --
 tools/lib/traceevent/event-plugin.c           |  711 --
 tools/lib/traceevent/event-utils.h            |   67 -
 tools/lib/traceevent/kbuffer-parse.c          |  809 --
 tools/lib/traceevent/kbuffer.h                |   68 -
 .../lib/traceevent/libtraceevent.pc.template  |   10 -
 tools/lib/traceevent/parse-filter.c           | 2281 -----
 tools/lib/traceevent/parse-utils.c            |   71 -
 tools/lib/traceevent/plugins/Build            |   12 -
 tools/lib/traceevent/plugins/Makefile         |  225 -
 .../lib/traceevent/plugins/plugin_cfg80211.c  |   43 -
 .../lib/traceevent/plugins/plugin_function.c  |  282 -
 tools/lib/traceevent/plugins/plugin_futex.c   |  123 -
 tools/lib/traceevent/plugins/plugin_hrtimer.c |   74 -
 tools/lib/traceevent/plugins/plugin_jbd2.c    |   61 -
 tools/lib/traceevent/plugins/plugin_kmem.c    |   80 -
 tools/lib/traceevent/plugins/plugin_kvm.c     |  527 --
 .../lib/traceevent/plugins/plugin_mac80211.c  |   88 -
 .../traceevent/plugins/plugin_sched_switch.c  |  146 -
 tools/lib/traceevent/plugins/plugin_scsi.c    |  434 -
 tools/lib/traceevent/plugins/plugin_tlb.c     |   66 -
 tools/lib/traceevent/plugins/plugin_xen.c     |  138 -
 tools/lib/traceevent/tep_strerror.c           |   53 -
 tools/lib/traceevent/trace-seq.c              |  249 -
 tools/lib/traceevent/trace-seq.h              |   55 -
 tools/perf/Makefile.config                    |   51 +-
 tools/perf/Makefile.perf                      |   95 +-
 71 files changed, 28 insertions(+), 19993 deletions(-)
 delete mode 100644 tools/lib/traceevent/.gitignore
 delete mode 100644 tools/lib/traceevent/Build
 delete mode 100644 tools/lib/traceevent/Documentation/Makefile
 delete mode 100644 tools/lib/traceevent/Documentation/asciidoc.conf
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-commands.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-cpus.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_find.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_get.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_list.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_find.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_get_val.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_print.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_read.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-fields.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-func_apis.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-func_find.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-handle.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-header_page.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-long_size.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-parse_event.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-parse_head.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-record_parse.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-set_flag.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-strerror.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq.txt
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent.txt
 delete mode 100644 tools/lib/traceevent/Documentation/manpage-1.72.xsl
 delete mode 100644 tools/lib/traceevent/Documentation/manpage-base.xsl
 delete mode 100644 tools/lib/traceevent/Documentation/manpage-bold-literal.xsl
 delete mode 100644 tools/lib/traceevent/Documentation/manpage-normal.xsl
 delete mode 100644 tools/lib/traceevent/Documentation/manpage-suppress-sp.xsl
 delete mode 100644 tools/lib/traceevent/Makefile
 delete mode 100644 tools/lib/traceevent/event-parse-api.c
 delete mode 100644 tools/lib/traceevent/event-parse-local.h
 delete mode 100644 tools/lib/traceevent/event-parse.c
 delete mode 100644 tools/lib/traceevent/event-parse.h
 delete mode 100644 tools/lib/traceevent/event-plugin.c
 delete mode 100644 tools/lib/traceevent/event-utils.h
 delete mode 100644 tools/lib/traceevent/kbuffer-parse.c
 delete mode 100644 tools/lib/traceevent/kbuffer.h
 delete mode 100644 tools/lib/traceevent/libtraceevent.pc.template
 delete mode 100644 tools/lib/traceevent/parse-filter.c
 delete mode 100644 tools/lib/traceevent/parse-utils.c
 delete mode 100644 tools/lib/traceevent/plugins/Build
 delete mode 100644 tools/lib/traceevent/plugins/Makefile
 delete mode 100644 tools/lib/traceevent/plugins/plugin_cfg80211.c
 delete mode 100644 tools/lib/traceevent/plugins/plugin_function.c
 delete mode 100644 tools/lib/traceevent/plugins/plugin_futex.c
 delete mode 100644 tools/lib/traceevent/plugins/plugin_hrtimer.c
 delete mode 100644 tools/lib/traceevent/plugins/plugin_jbd2.c
 delete mode 100644 tools/lib/traceevent/plugins/plugin_kmem.c
 delete mode 100644 tools/lib/traceevent/plugins/plugin_kvm.c
 delete mode 100644 tools/lib/traceevent/plugins/plugin_mac80211.c
 delete mode 100644 tools/lib/traceevent/plugins/plugin_sched_switch.c
 delete mode 100644 tools/lib/traceevent/plugins/plugin_scsi.c
 delete mode 100644 tools/lib/traceevent/plugins/plugin_tlb.c
 delete mode 100644 tools/lib/traceevent/plugins/plugin_xen.c
 delete mode 100644 tools/lib/traceevent/tep_strerror.c
 delete mode 100644 tools/lib/traceevent/trace-seq.c
 delete mode 100644 tools/lib/traceevent/trace-seq.h

-- 
2.38.1.584.g0f3c55d4c2-goog

