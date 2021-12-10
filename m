Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE52C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbhLJLDQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbhLJLDP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:15 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06704C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:41 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id x15so29282046edv.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KmLrgtl/JZN9vijVHcqqzM2eA5vzrk8cgp+KMqDo2EE=;
        b=jz+cVw4u6kY4eRu+kz2pNHba3IK8I4BDqqR9mwLvB4zGZhjlqCIWe6SVh9e0WOdmGT
         FjlsicGcEMGD20FGM8wvD76tuSnkq++k+00QSkbS7fZVlwn9oimXeSuR8lgK59NMZz3z
         TzK6bct5MzZYYWkxO62eJAkwK2Pm3+uvTBBNHpFQXAeOCKdu6WwEenntSb5b6lka8d72
         XZLCTx+i85SfbbJVfzpyp4KA4qR5Hs1IjVt1h+E1kiSCZF4fP0G5YPVLLDhJ8dHgjhFm
         5SVtAbQ0nkvmRq21IWI4EcsflE5jWyF4Gq67oFaSMsBR9oWccpnpBkqPKeByasBiTY5/
         sTdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KmLrgtl/JZN9vijVHcqqzM2eA5vzrk8cgp+KMqDo2EE=;
        b=5PKIGkRnX31mbhlk5Xc55i1no6aDvuHfmy7BMuzObsWgUvo8zgyH9uA8XO1Zb5K/w/
         7y5OCoWNWecQfZEGXj5YMW5h4ncVTdTLmbKp0gf/k5/1TyO+Bm5v/89d1VAbRCAXlzt2
         ncR/Z4EP+nM8xg0SuPPjpWOW0roZ7pSuz2Kb5Sqavt6VKAucIY1R/lET7pNLrbVvQky/
         8P0uMeL5HDCA5OS4jV4sLGuG0NfDwVlODZ45Xy10oOnwhN3L8mgnTJUq+I2bcJmHIjr/
         Alkf4shzBwa266EX4Z7JteYps+Lhr6XDUoHVqZhK83o9hbW6ZzAeLaf2z3V1WA4UtnDY
         pYCg==
X-Gm-Message-State: AOAM531SDCChlzI1if3NEQTwljMxRMJtdO6o4YUNxex7nDbSI2jStHt5
        Rf17tgBro65Q7ggc93tAChIpqbZtxJ4=
X-Google-Smtp-Source: ABdhPJwMeXyNjsHCCTYJOhYPiympjQyy9lPsOdOZd2/WfJDOReatjA4o6+URI01AGrugSNwbZnZ1+A==
X-Received: by 2002:a17:907:629b:: with SMTP id nd27mr22940731ejc.24.1639133979643;
        Fri, 10 Dec 2021 02:59:39 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j17sm1320379edj.0.2021.12.10.02.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:59:39 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 00/20] Trace file version 7 - compression
Date:   Fri, 10 Dec 2021 12:59:18 +0200
Message-Id: <20211210105938.98250-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Introduced compression of the metadata and trace data in trace files version
7. The compression is optional and disabled by default. A new parameter of
"trace-cmd record" is introduced, which can be used to configure the trace
file compression:
 --compression < none / any / name of the desired algorithm >

This patch-set depends on:
 "[PATCH v7 00/25] Trace file version 7 - sections"
 https://lore.kernel.org/linux-trace-devel/20211210105448.97850-1-tz.stoyanov@gmail.com/

v6 changes:
 - Rebased on top of the latest master.
 - Introduced new metadata strings section.
 - Use 8 bytes for section size.
v5 changes:
 - Rebased on top of the latest master.
v4 changes:
 - Rebased on top of the latest master.
v3 changes:
 - Rebased on top of the latest master.
v2 changes:
 - fixed issues of split and convert commands with some corner cases

Tzvetomir Stoyanov (VMware) (20):
  trace-cmd library: Add support for compression algorithms
  trace-cmd library: Internal helpers for compressing data
  trace-cmd library: Internal helpers for uncompressing data
  trace-cmd library: Inherit compression algorithm from input file
  trace-cmd library: New API to configure compression on an output
    handler
  trace-cmd library: Write compression header in the trace file
  trace-cmd library: Compress part of the trace file
  trace-cmd library: Add local helper function for data compression
  trace-cmd library: Compress the trace data
  trace-cmd library: Decompress the options section, if it is compressed
  trace-cmd library: Read compression header
  trace-cmd library: Extend the input handler with trace data
    decompression context
  trace-cmd library: Initialize CPU data decompression logic
  trace-cmd library: Add logic for in-memory decompression
  trace-cmd library: Read compressed latency data
  trace-cmd library: Decompress file sections on reading
  trace-cmd library: Add zlib compression algorithm
  trace-cmd list: Show supported compression algorithms
  trace-cmd record: Add compression to the trace context
  trace-cmd report: Add new parameter for trace file compression

 Documentation/trace-cmd/trace-cmd-list.1.txt  |   3 +
 Makefile                                      |   7 +
 lib/trace-cmd/Makefile                        |   8 +
 .../include/private/trace-cmd-private.h       |  46 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  17 +
 lib/trace-cmd/trace-compress-zlib.c           | 109 +++
 lib/trace-cmd/trace-compress.c                | 913 ++++++++++++++++++
 lib/trace-cmd/trace-input.c                   | 483 ++++++++-
 lib/trace-cmd/trace-output.c                  | 333 ++++++-
 lib/trace-cmd/trace-util.c                    |  10 +
 tracecmd/Makefile                             |   4 +
 tracecmd/trace-list.c                         |  26 +
 tracecmd/trace-record.c                       |  34 +-
 tracecmd/trace-usage.c                        |   6 +
 14 files changed, 1921 insertions(+), 78 deletions(-)
 create mode 100644 lib/trace-cmd/trace-compress-zlib.c
 create mode 100644 lib/trace-cmd/trace-compress.c

-- 
2.33.1

