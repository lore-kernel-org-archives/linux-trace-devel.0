Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B517C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34E85610CE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbhINNP7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbhINNP7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:15:59 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15E0C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:41 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id t18so20199175wrb.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yf4SE3nliZy7Dp2fffJ+iBhrw6Il0i5GIgpLnqZ/a1A=;
        b=GeXUGzVf6nL4mZPoiYrsw90HzjmfFM7nqsHGHqYbD/hOJkbLSBryXuNn9DBXGwUrWl
         6fI71eBTwIb+zi3T2EodYyZ/ndroJ1+3RBbFWD15mx2nUKoJGmdZ5HxS/VWzpisMfKCO
         htO5Ey2+3jccIsTVQOjrIttj7YjwlapGMH/zDP0nW297KW+cuYeTBXOwjd1IDvltMYMD
         s7zals/g58lv7m5yU309OoT/V19X5BAKcgLNzRJgKPI2Q4zRHiIVE19oe3xI7a7OA4Bq
         5EOb9lXDp+XfwGVAKLxB3ghABBrmMbTqDBz0TbAoEQzLaIqYwF0r6R0HD6yva/OiQ1yc
         +Juw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yf4SE3nliZy7Dp2fffJ+iBhrw6Il0i5GIgpLnqZ/a1A=;
        b=gFkUmr7N7ALhkAluBbr4BDtKwfZjERSP677V1wJ2QcGOP3kG9www6CXDpa5xYrbouB
         2TPpGwQSiMuPNTbqTL5arSlwipK6xa4myVvCrZipT2qwnNFoc/0qkk4iuwt/JYTKMWtj
         JlovVjMtxHCilc3G9zgy5PJjYq1lBLJNGRbpbrreDIWqvx9BHLMZymFYnC+6WNu70Ibt
         pSR6ddQJ8qmkZ93jliYlXgMuCJK6cLjiu0bJAdcX1JfDkPw1ybjyGkDb7dkcG1SlPjXH
         ImrmNO/7zAkAjmCCsaQP7G37F+LmvVkbdXlKMaowGi7yUedGW17mEl+k22yfoRAgN7yY
         0vhw==
X-Gm-Message-State: AOAM531hdgXOPJYa5USkgvsKbC7m76+ogzFBqsE8OCXKlqCbnaZkiF1S
        lFp4FZGa6hJzSYf05b9FsicxX/YTHk4=
X-Google-Smtp-Source: ABdhPJxCNVUhefNW54yWQB6p3kqYoGcb5y5//DL2Cbh8PzhNeCloAeiHhUf9XZnPvTe4VVTcSfzGiA==
X-Received: by 2002:adf:d1b2:: with SMTP id w18mr19403416wrc.6.1631625280367;
        Tue, 14 Sep 2021 06:14:40 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y9sm1274760wmj.36.2021.09.14.06.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:14:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 00/25] Trace file version 7 - sections
Date:   Tue, 14 Sep 2021 16:14:13 +0300
Message-Id: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
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

This patch-set depends on "[PATCH v3 00/21] trace-cmd fixes and clean-ups",
should be applied on top of it:
  https://lore.kernel.org/linux-trace-devel/20210914131232.3964615-1-tz.stoyanov@gmail.com/

v3 changes:
 - fixed issues of split and convert commands with some corner cases
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
 lib/trace-cmd/trace-input.c                   | 768 ++++++++++++++----
 lib/trace-cmd/trace-msg.c                     | 127 ++-
 lib/trace-cmd/trace-output.c                  | 597 +++++++++++---
 lib/trace-cmd/trace-util.c                    |   2 +-
 tracecmd/trace-listen.c                       |   6 +
 tracecmd/trace-read.c                         |  18 +-
 tracecmd/trace-record.c                       |  36 +-
 tracecmd/trace-restore.c                      |   3 +-
 tracecmd/trace-split.c                        |   3 +
 tracecmd/trace-usage.c                        |   2 +-
 13 files changed, 1302 insertions(+), 306 deletions(-)

-- 
2.31.1

