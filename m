Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC7EFC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA77161108
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhKKPLO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbhKKPLN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:11:13 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAA5C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:08:24 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id f8so25603634edy.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XBiRF73IUsvkOtw576gI5xJbi8qjyM/cAJKBDvD1+aY=;
        b=I30mQGxdRqUKGxz+NwA92sSByyI+jbkc3a7rE7bJDMvXvIQOUxad9YKMmUCuxs0cfl
         y4diAv4qvibYC/31sz6K9BLVyYSWTxVsLw376y+Cb1htEAbtvz0R4l3nQpMJn1yhIulO
         0isffaUmS1KF8dD6s3S5iwegL7DiEUMN+P6cfg++4dPFAK7mSzWbFJB6iuNLdeP16EzF
         Wh15wgDbJrl44yrR5jyFPf6+P6WCDsSeglghjSUV5MlnwyINhbhObaLeSKdOPWHCX9vX
         YKbWewrnJN7WOAD97vLQbsuQP1QCsQRk2XMJJX1je870AoL+RIGHBVPBclb8eix5aOWe
         riaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XBiRF73IUsvkOtw576gI5xJbi8qjyM/cAJKBDvD1+aY=;
        b=jX6vLe81tfX8OrEQW9gBs3+DVyMtwOKFCWtUOKD2EnvQ0wQ2L40Pv1Y7wHtw1kt9Xa
         j58fHr2KCg0yVEt6+ezby+ZUqgca0OesuoAFbyY6qELbfUB6aSzHBddczRUPy470s36n
         EYUlRbk0t2E7ZxkuQwnlzxHpslLVRuh7meQF9YpLi6ry3yTIAqRplYFdPFTzvBrFAD4E
         4km9kLTqXYTWMtEUlMJs0WrU87mVrOlyd3VWU/nKl+EkbdV7DMxipaJJSW0IbRoi/rRe
         9qwHYWpxuf90Q722KHZXSgwVBCM7WWZLV+tBkTHj40gO7z56pTlRYtXl2Ec9C4EFjfFA
         oFNQ==
X-Gm-Message-State: AOAM533Eg4hEL5vfbF3hC0y/ZEa+V6zdU1EKffBtdhajQD9NLyPXu4+p
        npd4W/X1mWQyJbfdWBcGswvtDs7wAKmenw==
X-Google-Smtp-Source: ABdhPJxtF8V/G+SiwvTQRVJyuYejbRXrg4PckjXwh73oEi26A50PPOJs+N3LdGiRf8sBY3172uD0KQ==
X-Received: by 2002:a17:907:6e26:: with SMTP id sd38mr10410060ejc.90.1636643302871;
        Thu, 11 Nov 2021 07:08:22 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id he14sm1477686ejc.55.2021.11.11.07.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:08:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 00/25] Trace file version 7 - sections
Date:   Thu, 11 Nov 2021 17:07:56 +0200
Message-Id: <20211111150821.86508-1-tz.stoyanov@gmail.com>
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
 "trace-cmd fixes and clean-ups" patch set.
 "Refactor APIs for creating output handler" patch set.
 "Refactor the logic for writing trace data in the file" patch set.

v5 changes:
 - Rebased on top of the latest master.
v4 changes:
 - Rebased on top of the latest master.
v3 changes:
 - Fixed issues of split and convert commands with some corner cases.
v2 changes:
 - Code cleanups.

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
 lib/trace-cmd/trace-output.c                  | 601 +++++++++++---
 lib/trace-cmd/trace-util.c                    |   2 +-
 tracecmd/trace-listen.c                       |   6 +
 tracecmd/trace-read.c                         |  18 +-
 tracecmd/trace-record.c                       |  36 +-
 tracecmd/trace-restore.c                      |   3 +-
 tracecmd/trace-split.c                        |   3 +
 tracecmd/trace-usage.c                        |   2 +-
 13 files changed, 1302 insertions(+), 310 deletions(-)

-- 
2.33.1

