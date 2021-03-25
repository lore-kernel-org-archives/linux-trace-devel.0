Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 267D8C433C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0B3E61A12
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCYGlb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbhCYGk7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:40:59 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B279AC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:40:58 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id p19so528124wmq.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TEeW1Y1a36U1aYfQWHGblqkgTof04EBUafqwFp4l8lU=;
        b=OIG924BfdryLgkDzgwzlQXQJdUxjS1a8y/fxEkDD5BeKPCHmxdV49xqZpdtFVrYWxc
         oztwjzWSnG+aNUx3us1GyPLXjJ8SaRH4vr4wgwGihgq+3c1zCQM7tfOUTkmeeJV45mwN
         QNopntt4CAQTa4OAYU2fep9SGZuQ1woxDJTO48bwqMrY3wVXh1C9c9DOgV6kQbYj2K9c
         if2toXHUHnSXkCGMufcLAjXVWIwbdFSA8BpIuX7Avlhp6OsmD67ZGDMfoeenF7BrMybf
         SUpC4udgh1rg1oMmwE6eTFc4gwJHynp4gf9ag2Obk6GxI8iRYjADaM4tPczKr2BaWcNB
         HafQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TEeW1Y1a36U1aYfQWHGblqkgTof04EBUafqwFp4l8lU=;
        b=XK3kxOErVo72NnjuErFg9yDq+BCBZVFv3ZiCMqm7hk0ZkO2wy2UzDEhqzk2vWq1Bp6
         kmup2AmqSxrqSjdbkY4KyGnt9E/gzUNqgVeauYx6tAOie4u75JDNCCnwXLntoh3hyaJy
         ShhdvQ5LHAoIfsOMvag8AxJ5vKGrd62t4+ovITzelRZvOYkKrOH2zl0jXsab/vD2qZRE
         BRe30TXTew9OlW0rRb3hJHFxfGgeeaK62SqOUuTYOb0ivyX206FkyBtOxpkb25R/eqK9
         xLRNR1okut+JH3HseQPy2R7e+BQ7nDF1i1CzxdbNEUmd2rvdrdVW4+PScOYoka3tG8qm
         2oBA==
X-Gm-Message-State: AOAM531Fj9DlTn9vDRWMZxEPeuHltBUWQ5rytiAA8PqG6ZytjJem0TBQ
        sDzuI9UW/yQOSoVDFEqKHmWrH9OpUT71pg==
X-Google-Smtp-Source: ABdhPJypNrtdp7Hh3ZNtpCLWzpmu6l8LJ1IaQeSX/Dou1WVkaVPnyBCc5ERUuO7Wq7EZNGOlirzN4g==
X-Received: by 2002:a05:600c:203:: with SMTP id 3mr6179668wmi.88.1616654457425;
        Wed, 24 Mar 2021 23:40:57 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:40:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 00/23] TSC trace clock to nanosecond conversion
Date:   Thu, 25 Mar 2021 08:40:32 +0200
Message-Id: <20210325064055.539554-1-tz.stoyanov@gmail.com>
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

v4 changes:
 - Improved getting the clock for the trace session, if there is no user
   specified one. The clock of the first host instance is used, instead of
   the top intstane.
 - Improved printing the clocks from the trace file with trace-cmd dump
   command
 - Fixed bugs, addressed Steven's comments.

v3 changes:
 - Split logically the changes in more patches.
 - Extended the TRACECLOCK option with trace clocks.
 - Fixed the TRACEID option to expect at least 8 bytes, so it can be
   extended in the future without breaking the old logic.
 - Code cleanup and coding style fixes.
v2 changes:
 - Added new trace clock "-C tsc2nsec", which does not depend on host-guest
   tracing use case.
 - A few minor improvements and fixes. 

Tzvetomir Stoyanov (VMware) (23):
  trace-cmd: Add initial perf interface in trace-cmd library
  trace-cmd: Extend trace-cmd dump subcommand to display the clock
  trace-cmd: Save only the selected clock in the trace.dat file
  trace-cmd: Internal refactoring, move logic for local tep handler in
    its own function
  trace-cmd: Add new local function to check if a trace clock is
    supported
  trace-cmd: Add new trace-cmd clock tsc2nsec
  trace-cmd: Define a new option for tsc2nsec conversion
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
  trace-cmd: Change "--nodate" option to affect "--date" option only
  trace-cmd: Add new parameter "--raw-ts" to "trace-cmd report" command
  trace-cmd: Print times in TimeShift options as unsigned in trace-cmd
    dump
  trace-cmd: Use tsc clock for host-guest tracing, if available
  trace-cmd: Get current clock for host-guest tracing session
  trace-cmd: Save the trace clocks in TRACECLOCK option
  trace-cmd: Read at least 8 bytes trace-id option

 Documentation/trace-cmd/trace-cmd-dump.1.txt  |   2 +
 Makefile                                      |   6 +
 lib/trace-cmd/Makefile                        |   3 +
 .../include/private/trace-cmd-private.h       |  22 +
 lib/trace-cmd/trace-input.c                   | 103 +++--
 lib/trace-cmd/trace-output.c                  |  66 ++-
 lib/trace-cmd/trace-perf.c                    | 105 +++++
 lib/trace-cmd/trace-timesync.c                |   1 -
 tracecmd/include/trace-local.h                |   7 +
 tracecmd/trace-dump.c                         |  57 ++-
 tracecmd/trace-read.c                         |   9 +-
 tracecmd/trace-record.c                       | 401 +++++++++++++++---
 tracecmd/trace-usage.c                        |   1 +
 13 files changed, 678 insertions(+), 105 deletions(-)
 create mode 100644 lib/trace-cmd/trace-perf.c

-- 
2.30.2

