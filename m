Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2559CC433C1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D048661969
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhCVJ7y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 05:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhCVJ7t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 05:59:49 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67DEC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:48 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id bx7so18499176edb.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I+9Yc4CHGGuZTd85gR1y4noFfb1SfPK8z47ZN/RI9kQ=;
        b=uxQzyZiovVwEYMc3sf52TIL7s524af26iEm91Z9nc7Ce8gY8/FASyqfIUFpmeKoHI5
         4ufZP6wN4QDIZkO2ZcXzKGKoUjxcIqXqRfJ5/2h4/lNa380hx4siQXalykqJjZGDMXd+
         Umwgg1vfHTyL/O0PXG9AAdtsK6/gFesjq2ETTl/T9RSf0d7jEPgMnx+9YMdH3NRocWRn
         1Jk9b9IBJ1d44FapuLhXyF2I+0YMatywM4NjAbvGjtQW3uyzg/RFIObcMNS4XsCu6MuT
         yfeVWtvEYWG1dBc8C4LxRo7JQGDiB17Ho72xXXT9u495Cn6vVcC18YboP58uSD4CQTY4
         J3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I+9Yc4CHGGuZTd85gR1y4noFfb1SfPK8z47ZN/RI9kQ=;
        b=W6zMUiNCl88Xo1rc0IHg4JKgswW3LspXMKJQ5eO5nzr6JTTjMgv/vczMUQyrY2Bc+3
         +HKt/6mqaXrbmEI36jWkzCrP7s92FpacoAhSEp5vlLLwrAs8nwKXShw5/XYU804QaFOA
         sd/AR8WARQW4KJOH/Mt3W01xM1gezv59AD7syH3mXq2yOz0nacW55sDlFEkfsdiQxtRI
         R5TGcYucCdMDn/+c24Iubdpx22FIdkegCV3Xib2x9hvhHYHecAesfik4OQ/XD7imDcWb
         rkYWfofeb3K5y4+gmOoNDPHm0wrnVokZPCT5LgSElyHgwhRrPU+7FgN43t5OfVj3AaF7
         Mcmg==
X-Gm-Message-State: AOAM5306mG4m6/DjZjkP+KhIX9tlC7T2OIT/qiea5XWSqv3vheYVUW+b
        oy1ScCePLZUz1962WSrJT/EfNuTJcOWQrQ==
X-Google-Smtp-Source: ABdhPJwqkzwVkC0DFBaRlix6zE6QxsgkQ5xObfD3iBlCfmpm4HNlQuaXfrwN71d7+CdV9iL1SbDeVA==
X-Received: by 2002:a05:6402:1d39:: with SMTP id dh25mr25173268edb.282.1616407187554;
        Mon, 22 Mar 2021 02:59:47 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g26sm9288424ejz.70.2021.03.22.02.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:59:46 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 00/18]  TSC trace clock to nanosecond conversion
Date:   Mon, 22 Mar 2021 11:59:27 +0200
Message-Id: <20210322095945.259300-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added new logic for converting TSC event's timestamps to nanoseconds. This
trace clock is used by default in host-guest tracing session in combination
with KVM time sync plugin. The parameters for conversion are retrieved by
the perf kernel interface.
New option is added to "trace-cmd report" command to force displaying raw
time stamps from the trace file, without any corrections to the time stamps.

These changes depend on "Refactoring and improvements of time sync logic"
patch set.

v2 changes:
 - Added new trace clock "-C tsc2nsec", which does not depend on host-guest
   tracing use case.
 - A few minor improvements and fixes. 

Tzvetomir Stoyanov (VMware) (18):
  trace-cmd: Add initial perf interface in trace-cmd library
  trace-cmd: Extend trace-cmd dump subcommand to display the clock
  trace-cmd: Save only the selected clock in the trace.dat file
  trace-cmd: Add new trace-cmd clock tsc2nsec
  trace-cmd: Add a new option in trace file metadata for tsc2nsec
    conversion
  trace-cmd: Save information for tsc to nanoseconds conversion in trace
    file
  trace-cmd: Read information for tsc to nanoseconds conversion from
    trace file
  trace-cmd: Save tsc2nsec clock in trace.dat file
  trace-cmd: Append new options into guest trace file at the end of the
    tracing session
  trace-cmd: Remove unneeded multiply in events timestamp reading
  trace-cmd: Perform all timestamp corrections in a single function
  trace-cmd: Convert tsc timestamps to nanosecods when reading trace
    data from a file
  trace-cmd: Set order and priorities when applying timestamp
    corrections
  trace-cmd: Add a new flag to disable any timestamp corrections
  trace-cmd: Add new parameter "--raw-ts" to "trace-cmd report" command
  trace-cmd: Print times in TimeShift options as unsigned in trace-cmd
    dump
  trace-cmd: Use tsc clock for host-guest tracing, if available
  trace-cmd: Get current clock for host-guest tracing session

 Documentation/trace-cmd/trace-cmd-dump.1.txt  |   2 +
 Makefile                                      |   6 +
 lib/trace-cmd/Makefile                        |   3 +
 .../include/private/trace-cmd-private.h       |  22 ++
 lib/trace-cmd/trace-input.c                   | 103 +++--
 lib/trace-cmd/trace-output.c                  |  65 ++-
 lib/trace-cmd/trace-perf.c                    | 105 +++++
 lib/trace-cmd/trace-timesync.c                |   1 -
 tracecmd/include/trace-local.h                |   7 +
 tracecmd/trace-dump.c                         |  55 ++-
 tracecmd/trace-read.c                         |   9 +-
 tracecmd/trace-record.c                       | 372 +++++++++++++++---
 tracecmd/trace-usage.c                        |   1 +
 13 files changed, 649 insertions(+), 102 deletions(-)
 create mode 100644 lib/trace-cmd/trace-perf.c

-- 
2.30.2

