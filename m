Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D03AAC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2A27611EE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbhIJNtU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbhIJNtM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:12 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4754EC061757
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:01 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id q3so2590516edt.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y9LU7vDB4oJrDhpYL9P863AWx7n6muP+f+JlGe+Snjo=;
        b=EgvT6VppRcW9FfR6ocw3WNqEOWgRJrmWbInOTN0UssfMYkknbMtKakBekAJFsS2A0r
         L4yejtKo+9YfmwKi4l6dKwAimRUaMpcevlBtaT9V8Y6mFLm0zauAQOIHihtn+grC9xo9
         1P1J6Q4XA6wRmI0PW3aPNJNw7jG3syCJ1gAdDmgz4aC9ygzqEw8/eYNLGhU3CAYYN39F
         h7DWE6Bz36P1+Dl4TW2LqmaP+T37V78rBWVvix/6PVwVGimhKT7dnoclIbPrqU9hjRlK
         R+MJcl233ZysNAAK3gTH5D2gIQAsRgthEUB76rUEwdz1jFNCd8Y1SWw465Ieu6s9KIBU
         Za7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y9LU7vDB4oJrDhpYL9P863AWx7n6muP+f+JlGe+Snjo=;
        b=1t+CGYPWaDXANEXTTgx0oBHXn+CzMrLDuqrZx7PhWc4UjK88mNF91C5mERmUBA9XlB
         TNXQyhEOAyZvPMu2mFg7v0af737fyGuQUl/8htT4VvsL2ApO0tya44Koqjv/lq6c3nqm
         gkBDldzpU8fPEDYasGDtlHUpFmp3bYFa5SqXMDTbgU5DgRcCDGKT7rmc5r5Del9un7Z7
         dxnIplgsdDsPrJasxn8RHbJZ3kLHthwuirUTPc4etwNob/Q9J4FNGRlxIMfZ0RLkJvzU
         pFmrt2VUWne39HF65kBmWLsm/ZO5r/lCVkKvMzlyNZJF/OoJBwU86SAk0ZOaHtSndhJC
         b+EA==
X-Gm-Message-State: AOAM5300GuAJdjrS/xBI8p9s7w9AABLCe+t5r5BPHNk0svhK2UOR7gUl
        qPLG3um0xQ25DW7rL82sVYHWjX24BhM=
X-Google-Smtp-Source: ABdhPJy5fblbN2KbAai2H3WYvxilpb149ZFFNO4UmaPt1Lorvh6Q72EdqK54uQqXWZUVvZ8LVNxFKw==
X-Received: by 2002:a05:6402:1508:: with SMTP id f8mr6483735edw.255.1631281679828;
        Fri, 10 Sep 2021 06:47:59 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:47:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 00/21] trace-cmd fixes and clean-ups
Date:   Fri, 10 Sep 2021 16:47:36 +0300
Message-Id: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Various trace-cmd application and library fixes, clean-ups and internal
refactoring, needed for trace file version 7 and compression changes.

This patch-set supersedes "[v2,00/87] Trace file version 7":
   https://lore.kernel.org/linux-trace-devel/20210729050959.12263-1-tz.stoyanov@gmail.com/

Tzvetomir Stoyanov (VMware) (21):
  trace-cmd library: Read option id with correct endian
  trace-cmd report: Fix typos in error messages
  trace-cmd library: Fix version string memory leak
  trace-cmd library: Fixed a memory leak on input handler close
  trace-cmd library: Do not pass guests list to a buffer instance
  trace-cmd library: Set long size to the input tep handler when it is
    read from the file
  trace-cmd library: Do not use local variables when reading CPU stat
    option
  trace-cmd library: Reuse within the library the function that checks
    file state.
  trace-cmd library: Fix possible memory leak in read_ftrace_files()
  trace-cmd library: Fix possible memory leak in read_event_files()
  trace-cmd library: Fix possible memory leak in read_proc_kallsyms()
  trace-cmd library: Fix possible memory leak in read_ftrace_printk()
  trace-cmd library: Fix possible memory leak in
    read_and_parse_cmdlines()
  trace-cmd library: Set input handler default values in allocation
    function
  trace-cmd library: Track maximum CPUs count in input handler
  trace-cmd report: Close input file handlers on exit
  trace-cmd report: Do not print empty buffer name
  trace-cmd library: Set correct CPU to the record, retrieved with
    tracecmd_peek_data
  trace-cmd library: Refactor APIs for creating output handler
  trace-cmd library: Refactor the logic for writing trace data in the
    file
  trace-cmd report: Init the top trace instance earlier

 .../include/private/trace-cmd-private.h       |  35 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  19 +
 lib/trace-cmd/trace-input.c                   | 209 +++--
 lib/trace-cmd/trace-output.c                  | 780 +++++++++++-------
 lib/trace-cmd/trace-util.c                    |  28 +
 tracecmd/trace-listen.c                       |   2 +-
 tracecmd/trace-read.c                         |  21 +-
 tracecmd/trace-record.c                       |  73 +-
 tracecmd/trace-restore.c                      |  32 +-
 9 files changed, 785 insertions(+), 414 deletions(-)

-- 
2.31.1

