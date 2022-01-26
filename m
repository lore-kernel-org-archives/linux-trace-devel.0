Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E732BC28CF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbiAZJtM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbiAZJtL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:11 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279F7C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:11 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id j2so37375834ejk.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=URhxN0qAlAJsN9hErbcmgw3e0IQxzahzo9Kw0Wqna+c=;
        b=JLuEh7rnI74AtC0GGrqg6q8NS1gtlCHvK+4YAh9b+h2ys1+te0o9FOZLmE+gHUV+Il
         GCZNbtGzxchJEDnbba96KGXNzD0caggtsHSKJ4jmhcsivvjyUd8h0xiS/ERM3h6IMNm8
         EDrgCziSYjWmTA20VXl57nOf71zGHQ0f9JTu4u8dgff+RY9Z9XAyoYL3k9oAukq4VsSJ
         HmIlCO2mrWPMnP6a8SCVg78IxaIsDFg0CUnL6Apx8Emhq128M46Q46rWe8aRhiFq9pp/
         1iq4gInTi92LL2QyRKL4h1KzoXH5cfz3/EbOPoOpecn/2jtwgI/r0SIn+l88TM4KTF/j
         fisg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=URhxN0qAlAJsN9hErbcmgw3e0IQxzahzo9Kw0Wqna+c=;
        b=DLfOTXkeVjBwgD5/zbxzCOP5ZkFY7cZTfFjeNdGqBviYoXVgk3O6+o9TJbVZxHa0sS
         qdhJXp/jumSiYkprmSaEDp4+W1V/6CvrTPiMikVFUS79ymdTJva5IcCU1cDPLLoJZ65/
         8lAo+bsoGZ24TO7A9oFBw4VmcR6agmHXkwcOsRweMKJ0fXG6rWAowqYlI8bmNn5STqym
         VygHFfAikA1wpnVtZmt8muBWZ6CEzj1DqVUeM1fefoX6XkxysAPFh+5+hqa+r9Vu4+Wv
         M15KZEqXIVxLoUY7W+upRBXF20Z7TGo8JdlmP8saFA36eEqwTSAPm8Q0Yhg2G8kemt4/
         MVLA==
X-Gm-Message-State: AOAM532sIMaXcAtmLMeANW2py0ny6j0mMG52XKLUjJXIOngauZWdxV9n
        Oc/Z+n+XF/pBN2e0iy5OTu/rgIYKwOE=
X-Google-Smtp-Source: ABdhPJy79Xnv7UvyC6QtvzBIA04E0H1gngE6R/0M+Mw7YmxTo0LqfXPkCrGvY0+ccVwQj4PgrokjAw==
X-Received: by 2002:a17:907:a42b:: with SMTP id sg43mr8549419ejc.310.1643190549636;
        Wed, 26 Jan 2022 01:49:09 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 00/20] Trace file version 7 - compression
Date:   Wed, 26 Jan 2022 11:48:46 +0200
Message-Id: <20220126094906.570451-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
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

v8 changes:
 - Bug fixes.
 - Code cleanups.
 - Rebase.
v7 changes:
 - Bug fixes.
 - Code cleanups.
 - Rebase.
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
  trace-cmd library: Extend the input handle with trace data
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
 lib/trace-cmd/trace-compress-zlib.c           | 109 ++
 lib/trace-cmd/trace-compress.c                | 981 ++++++++++++++++++
 lib/trace-cmd/trace-input.c                   | 513 ++++++++-
 lib/trace-cmd/trace-output.c                  | 352 ++++++-
 lib/trace-cmd/trace-util.c                    |  10 +
 tracecmd/Makefile                             |   4 +
 tracecmd/trace-list.c                         |  26 +
 tracecmd/trace-record.c                       |  40 +-
 tracecmd/trace-usage.c                        |   6 +
 14 files changed, 2048 insertions(+), 74 deletions(-)
 create mode 100644 lib/trace-cmd/trace-compress-zlib.c
 create mode 100644 lib/trace-cmd/trace-compress.c

-- 
2.34.1

