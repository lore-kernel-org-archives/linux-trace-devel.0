Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE5FAC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358064AbhLBMZa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358220AbhLBMZV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:21 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33142C061759
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:21:58 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id r25so49127611edq.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1KHJZnnOhOcGS6pSumd33M6bZDywyCutGPtAaqo4W9I=;
        b=MD4LG/uveBFJ3PWCEiYZTf1r1wFd6vGkxwKoB8omU5foPodnzjt833gGvuylaQql0E
         TVXvL/j3S+OncKA8t/pucLuO8QlZGhxr04QlBW2nKLRZlFNqEcyBVD9bWOZqevR3W553
         o7jQ8fOuDb6eVFAO2RBIk2aOIdQ3wbyoi8rlKeKL0EkdP6FcczBrURzCOTgDJzaeup4P
         dzqrFcqyRZnZN3GwObi8aVwbRTKfBJOp5zMFKEaP0WsHvpUuD4UeKAE/SxXMKc8xWhje
         UmJSTso3Pzm+m+OKW9OnGN6UbOjcCmVFUk7A324i0+FKTNm6p2RLmXF3V5N6IgHbp61q
         CQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1KHJZnnOhOcGS6pSumd33M6bZDywyCutGPtAaqo4W9I=;
        b=w2iMWH91sTPVYqZcKwbtO6SpX7JWTW71UmPrq54m1GXaBf1tYCGPVrOnMYURgqM8m4
         fSg+w+LK4/vPytWUj8ws9hNV6i4pDrHBNzkRO3HDRaGbcjguXLcZz/bx1oPgP62ROGI/
         SeNcSP0SZWABthHGACYk/kKv8q4YlROmfgr6X8vDnig7OA/RnBfVo5ApZwC4o692iTsq
         BiJZEwaj6kOY8tK5QhqUFMdKyDbk/wynf589CpH4sF1vN4oS9DEQUutBw5NGMrC9a4pk
         MtwVPhdJq1n/sG2IeV1/vOo928rqKVDqSeMTt4vB5g1YbW4NlZK3GTzew0smKAWIhrtK
         KLtw==
X-Gm-Message-State: AOAM53232Sq/C2nDW7eOQxTgLf2gq08KF7ZD7Jleve3nULSHTHixGVv+
        HwaQO2/nwOO58u+WTFfwHBKJY8jBha39lw==
X-Google-Smtp-Source: ABdhPJwE6tUcClxJpS0sUCVFPKI5zjUKIPx8gCof+bW1QQKnIDL3Qb+6mr8v25tKwMe4PvUKxaaWCw==
X-Received: by 2002:a17:906:3745:: with SMTP id e5mr14832327ejc.400.1638447713833;
        Thu, 02 Dec 2021 04:21:53 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:21:53 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 00/23] Trace file version 7 - sections
Date:   Thu,  2 Dec 2021 14:21:29 +0200
Message-Id: <20211202122152.43275-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
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

This patch-set depends on:
 "[PATCH 0/5] Cleanups of tracecmd_output_ APIs"
  https://lore.kernel.org/linux-trace-devel/20211202121949.43084-1-tz.stoyanov@gmail.com/

v6 changes:
 - Rebased on top of the latest master.
 - On trace file v7 close, write any unsaved options in the file - as
   a last section.
 - Removed the patch "Do not write CPUs with empty trace data" from the
   patch set. Empty CPUs are written in v7 trace files, the same way as in
   v6.
v5 changes:
 - Rebased on top of the latest master.
v4 changes:
 - Rebased on top of the latest master.
v3 changes:
 - Fixed issues of split and convert commands with some corner cases.
v2 changes:
 - Code cleanups.

Tzvetomir Stoyanov (VMware) (23):
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
  trace-cmd library: Add section header before flyrecord trace data
  trace-cmd library: Fit CPU latency trace data in the new trace file
    version 7 format
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
  trace-cmd: Write buffers metadata in  trace files version 6
  trace-cmd report: Add new parameter for trace file version

 include/trace-cmd/trace-cmd.h                 |   5 +
 .../include/private/trace-cmd-private.h       |  27 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  16 +-
 lib/trace-cmd/trace-input.c                   | 768 ++++++++++++++----
 lib/trace-cmd/trace-msg.c                     | 127 ++-
 lib/trace-cmd/trace-output.c                  | 600 +++++++++++---
 lib/trace-cmd/trace-util.c                    |  12 +-
 tracecmd/trace-listen.c                       |   3 +
 tracecmd/trace-read.c                         |  18 +-
 tracecmd/trace-record.c                       |  31 +-
 tracecmd/trace-usage.c                        |   2 +-
 11 files changed, 1301 insertions(+), 308 deletions(-)

-- 
2.33.1

