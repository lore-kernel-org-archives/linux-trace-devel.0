Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DFCFC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAE8A60F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhJHEV4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhJHEV4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:21:56 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985D0C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:01 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id b8so31211428edk.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NA9nfcZLTdgNShBXemBVURIQjjbpTwTghIwgUiLeTpY=;
        b=ATHvrvcB9OloJ34az1y1tEKS4SEgQ2sZFV8JjnpHv9I+g6XmwbHFAP2DXlnLxWzLly
         cOYzWiY5veo0efZEpqBO64vPvfW60CoctEV6lyC9plM1cpN5Wr8mC30nvcK/FQJNw+2l
         zJvCAlgKJ6GbIdu6fvoc+IkgIayTuYOCOnANuRIhNO94hMnUnXLmXppHPAWzQ5W4JRF+
         4hchCQHHcbmWbUV4MEzG1H0B+fdLRacHko2wxRIfxH4JIGu1/KoM5SGgSlDmben//5TN
         7vOhvlAcv4RYhDlw7wUJpZ/waZtmwBwHlleqs/7JNFrGt6MWFrfppGqew9aOmcnslXWA
         0KXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NA9nfcZLTdgNShBXemBVURIQjjbpTwTghIwgUiLeTpY=;
        b=M+fa0lW6OYT3gNqfXEf5z6jxWbdJTykl3PYUD4/HZTG1Hl8Ly6dwkkL44xs19UKOg7
         +j+U9QQoXs6tsSfnn8PvGqtwP7Hadow7qACqabQpovOL7N038L3HySFx8raz4NkpRzO0
         octtwmnz3nHOxyt1TVmnUGpyMQbFFEzGtumsGhiouMZ/QktH4OPOXYDAfvIaBDcxauye
         nacwCQCbj4xMBHRntef9jxFLXizY36+LfYTCK96WyC5oY03H+Pr9IJdNXXuGIFb8YD5Q
         UYtWXdP8hShdDFDLYEWTCCBkhNAKttlP/B36hmgRhmWc0ukMKFDRpjs/Z1GrTirJ5lez
         fYTw==
X-Gm-Message-State: AOAM530PSyNab3nr2Aa2wv+Fj0GNqgrFO1LrQyiqKQkaUzFmhyMW67Zs
        t2oG9c/E1TEtX34ZZW4OJOJGJ0Buf/dRKw==
X-Google-Smtp-Source: ABdhPJzUboeJ4I39eEgrhSK7EQ/luCNF5O9fEIC4PDmRZvkzNbHk2z6XOj/fbNHpRkm+m4rDVNs8mQ==
X-Received: by 2002:a17:906:7b54:: with SMTP id n20mr1225810ejo.525.1633666800248;
        Thu, 07 Oct 2021 21:20:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:19:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 00/25] Trace file version 7 - sections
Date:   Fri,  8 Oct 2021 07:19:33 +0300
Message-Id: <20211008041958.976309-1-tz.stoyanov@gmail.com>
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

This patch-set depends on "[PATCH 0/4] Refactor the logic for writing trace data in the file",
should be applied on top of it:
 https://lore.kernel.org/linux-trace-devel/20211008041514.974537-1-tz.stoyanov@gmail.com/

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
2.31.1

