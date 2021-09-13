Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EBBCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09A1060F0F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbhIMMbH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239946AbhIMMbG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:06 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94A2C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:29:50 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 196-20020a1c04cd000000b002fa489ffe1fso6820369wme.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gdFyVlYNoTqcaOWrDp/d17dftYmxdnI4H9BPUkOVYVs=;
        b=qPYszzR5elL14jA72fMJyOgAzvLySoJSuuPegKW5mmVpOfsjntZGg1P285+SgWo9mx
         RicG3JTwQUSrxvOKuC8D+f5CS+mV7p1gj6nFMUrm+csm9mvehYyhl95gGE5IIKg0TNKr
         Gqn6ySvJr7dPZyAyFkk2ZiAnYtYqxd1uCjqjf+j68CCcgWzWY7sOnTE2+kUs3Pmn/1uw
         VaCRrPFbLNf7AnwWXB28pddvmmxcsrNthc94EjkJz6VcsVQzQuggTh7eaF9QgOzn/JN8
         H7KWFdFAWSxsBwBqstVAb0MXtFOhbBvogsApIpr5cZykeRdPh+ZyWHA2XRg6Uf2eOTbx
         s59g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gdFyVlYNoTqcaOWrDp/d17dftYmxdnI4H9BPUkOVYVs=;
        b=TaJB15fXG74sP0jbI+ka8DKhH3572A9cdBaVGoM+N8aBGfpxGX5QFH3K1/VqCjBLx3
         Eb2N1Oyd77Ggponv4f4tOVi410qKvJ4E+N+gj4B5+rnqNdiv8d5TZ6UZpG/cri2FRyYX
         5GROtgC8uO3u0xO5C+tmLrrtlbBsC/uAUox3Y3lHtByVMUQFLXq6rL14ZPk6rWoekgJb
         jaWQo2zyeZASb0o838dJ0m/CwhAEfcp2tyeDGSAT+L8lFhFpNws/hByyZrI3YCJUUMD+
         5SN1oRdnTqI1W5wG63R7gXOryDzLXKG6SDj7lhkBE0HEGNfjkKJBe/BC1G1kEgVHf+gk
         TRzA==
X-Gm-Message-State: AOAM533ZDmWsyL8zIK8uatD71z0zyAd9VMeFgIoTuC57sb0DirJ3Pkzp
        Nk+BDWdJ5oHNB5SZHbRBUDCxHiH5zg4=
X-Google-Smtp-Source: ABdhPJxxm7QgIV/dIJzroWAWsKtDCWuop8ZOsb98XOQucPWGM28h3YbX3tTn5R5u1INygAqd8fjjKA==
X-Received: by 2002:a1c:9888:: with SMTP id a130mr11030196wme.102.1631536189381;
        Mon, 13 Sep 2021 05:29:49 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:29:48 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 00/25] Trace file version 7 - sections 
Date:   Mon, 13 Sep 2021 15:29:22 +0300
Message-Id: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Introduce the next version of the trace-cmd trace file - 7. Major changes
since version 6 is more flexible extendable structure of the file, based on
independent sections.
Known issues:
 - Only trace-cmd record and report subcommands work with trace file v7.

This patch-set depends on "[PATCH v2 00/21] trace-cmd fixes and clean-ups",
should be applied on top of it:
  https://lore.kernel.org/linux-trace-devel/20210913122759.3672494-1-tz.stoyanov@gmail.com/

v2 changes:
 - code cleanups

Tzvetomir Stoyanov (VMware) (25):
  trace-cmd library: Define trace file version 7
  trace-cmd library: Add cache functionality to network message handler
  trace-cmd library: New APIs to get and set version of output handler
  trace-cmd library: Add internal helper function for writing headers
    before file sections
  trace-cmd library: Write header before file sections
  trace-cmd library: Add multiple options sections in trace file version
    7
  trace-cmd library: Do not write CPU count section in trace files
    version 7
  trace-cmd library: Move CPU flyrecord trace metadata into the buffer
    option, for trace file version 7
  trace-cmd record: Append trace options after the trace data are
    written
  trace-cmd library: Add section header before flyrecord trace data
  trace-cmd library: Fit CPU latency trace data in the new trace file
    version 7 format
  trace-cmd library: Do not write CPUs with empty trace data
  trace-cmd library: Add macro to check file state on reading
  trace-cmd library: Introduce sections in trace file reading logic
  trace-cmd library: Initialize internal sections database on file read
  trace-cmd library: Use sections database when reading parts of the
    trace file
  trace-cmd library: Read headers from trace file version 7
  trace-cmd library: Read extended BUFFER option
  trace-cmd library: Handle the extended DONE option
  trace-cmd library: Initialize CPU data for reading from version 7
    trace files
  trace-cmd library: Handle latency trace in version 7 files
  trace-cmd library: Handle buffer trace data init for version 7 files
  trace-cmd report: Use the new latency API to read data
  trace-cmd: Call additional APIs when creating trace file
  trace-cmd report: Add new parameter for trace file version

 include/trace-cmd/trace-cmd.h                 |   5 +
 .../include/private/trace-cmd-private.h       |  27 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  14 +-
 lib/trace-cmd/trace-input.c                   | 766 ++++++++++++++----
 lib/trace-cmd/trace-msg.c                     | 127 ++-
 lib/trace-cmd/trace-output.c                  | 597 +++++++++++---
 lib/trace-cmd/trace-util.c                    |   2 +-
 tracecmd/trace-listen.c                       |   6 +
 tracecmd/trace-read.c                         |  18 +-
 tracecmd/trace-record.c                       |  36 +-
 tracecmd/trace-restore.c                      |   3 +-
 tracecmd/trace-split.c                        |   3 +
 tracecmd/trace-usage.c                        |   2 +-
 13 files changed, 1300 insertions(+), 306 deletions(-)

-- 
2.31.1

