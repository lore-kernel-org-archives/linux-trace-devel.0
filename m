Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD1AC433C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0BA461992
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbhCXNE3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbhCXNEW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:22 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86196C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:21 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id 14so1142379wrz.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HtxPQ25PE5//Awn5wGqP8YGAlQctVvzxbZe8RL8oxU8=;
        b=Y1fNMSOpJlCSRMwjCfPrwEMbNC+saTaXeQ37+N5oVL9lQp3MCA6Rhriq/Hz4oENHva
         RTzt94UFiMtHdrO++FoE1wvJGKRieRaWwbmEH5xieCtsv+tKYatJ0zITIs5J2ySr0Hsv
         N0oEsOicEv6Z+HaatJikBK8RGDBmN4tcpE6tL+396UIe/1wpo1tnvi4HoGq2GmAsj0wd
         0ijYF84RZbkTNywWR3Idt1WbQUhc4P2M1p1uwlnq0czFXBc9qeZkbGppaq50TfI9YImm
         lybRGdgLi4QqT+6Q7xR17V1s6SFVGOO97qQq5znHzgTBUJG9k1Ih4sLpux6GpH9+WnBi
         P+Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HtxPQ25PE5//Awn5wGqP8YGAlQctVvzxbZe8RL8oxU8=;
        b=ExbH7S8YkP+st7AfmTFDmzz5tVLyL4CEYPSh+BKJQaVSI4u84V1XBeRllDK7SIAWC6
         mwxBm2zagnblabEzJuGCypYL+zFS3A6zjVkkTQOtwpQkKHkNmshMhkfJnfs6DEyVUBYT
         VXsFJwX6NxhVT/Uykzx1catf1B1iwzZZNC5w+VDBrZvx4jYD+vZL8Jn82nlejtV6OQsg
         kUo85FbyNzk528uwnYcdxnCcEzVhbruWKxE3OXuvVmlkhHOSKiJUmKajCKSxvGOulZhF
         RGVdy2IYNa4LM9vgusdiI69NopTuQIRpjVVTe8M5OCCKjApPTdT/v0yqyFqU5JF6xd/q
         f/xA==
X-Gm-Message-State: AOAM53031Lv8m6U7rvmuFV8ISgvcw+pNVKL+0xKVRvGl5JJIX69hTrjF
        8q864t751HNtIxq8KJqjnZngO0s3AcUMNQ==
X-Google-Smtp-Source: ABdhPJw24OHywjGXTiWDjLkiEY2k2lU1ihHAVmIOnPLGFyTHY+u+zAw4t5l3k0/Wso1DlQU1rZmwLA==
X-Received: by 2002:adf:f186:: with SMTP id h6mr3449078wro.290.1616591060331;
        Wed, 24 Mar 2021 06:04:20 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:19 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 00/23] TSC trace clock to nanosecond conversion
Date:   Wed, 24 Mar 2021 15:03:55 +0200
Message-Id: <20210324130418.436206-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c                  |  65 ++-
 lib/trace-cmd/trace-perf.c                    | 105 +++++
 lib/trace-cmd/trace-timesync.c                |   1 -
 tracecmd/include/trace-local.h                |   7 +
 tracecmd/trace-dump.c                         |  55 ++-
 tracecmd/trace-read.c                         |   9 +-
 tracecmd/trace-record.c                       | 387 +++++++++++++++---
 tracecmd/trace-usage.c                        |   1 +
 13 files changed, 662 insertions(+), 104 deletions(-)
 create mode 100644 lib/trace-cmd/trace-perf.c

-- 
2.30.2

