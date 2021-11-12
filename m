Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C8BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Nov 2021 04:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70E5760F90
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Nov 2021 04:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhKLEQX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 23:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhKLEQW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 23:16:22 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355A3C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 20:13:32 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z10so6039635edc.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 20:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aCbK4AyyXoCz2kJYIVn+kl+vp2uofoX99x4dYRLReSc=;
        b=T91cgNN2kNiy4Edb0bX40XYY2w6nmHiyLU/O3Y1s+E0qJwmwvS288RSP+e9ZNeJ2t/
         /aoOxIyoZJ/JQ6sSEfNLKzer1DjaM0G3ENlUIARYTjJyJvC85sK0ITknPtT34EsUKVIq
         ZjNNBgBT9bLV6KHtZNaXEPLFxx1gC8SzVSZZQqphfv+IYBh+1brgEpw+xd1S2PEaUCDu
         +zVEQQAJ++C3KZxeNNr68d3tRCAXhKLHCqacYdiCZMBplYmYbgWOVNLCEWm9dwgk7t2o
         rr86LcBlnGAeggTeXe2n1nQqLWUy+WvD1X/vDTbX93IkewC35vbdaKCpMwBvySksxnVZ
         qvIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aCbK4AyyXoCz2kJYIVn+kl+vp2uofoX99x4dYRLReSc=;
        b=f+myT1T9uakANoLRwNGn8OJqzZPoPL90u+i+/5QquYmDs30zHY/W3Wh5qKYqzsO9YD
         WQ037alcrcXXyEiHswCK51UW94feBB0Qff228j+plbSKo6Yku17Ta6ooLlrRnAHOkcQk
         QKirzDMiV0DACUjH/RLREpDaaFtVB5VrQ/OZeIdu3hcOxU6RLJNFsgzcX1EF8xg1HypP
         MuGJSIr46xLM3aN9a+F9+R29H0vP/cmWQd2m9piY4MGVwyjOzcodnfnH+sqPPGXLiIYa
         WRm0ZeBAqOd6myewGaGPZxEx4aV1mTq5t/zTNM9nsWTja9qBuaWXTeem3t2C/oZYgxFy
         5yQQ==
X-Gm-Message-State: AOAM5338OpH2uO6LcGUkXaI9DdhEtxtvrpNgPnEHMBM7VV+Bd2quOuah
        uf30aMbVji4xX2vwPTzyFxKYxg4DHAeQQA==
X-Google-Smtp-Source: ABdhPJwe4TM7qFEYVZhImKsTa/0HDHUGMrdNsHYHdU4ZcZRA8m/ksM/9BB1k1vZGskKG2rm3FuWnUA==
X-Received: by 2002:a05:6402:1d9c:: with SMTP id dk28mr6060419edb.357.1636690410877;
        Thu, 11 Nov 2021 20:13:30 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb3sm2212121ejc.81.2021.11.11.20.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 20:13:30 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/2] Get trace buffer page size from kernel
Date:   Fri, 12 Nov 2021 06:13:27 +0200
Message-Id: <20211112041329.23629-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace buffer page size is equal to the system memory page size in
the current ftrace implementation, but this may change in the future.
The newly introduced traceevent library API should be used to get the
real trace buffer page size, bases on the information from the
"events/header_page" ftrace file.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd library: Use the real trace buffer page size
  trace-cmd library: Introduce buffer page size per instance

v2 changes:
 - A libtraceevent is renamed, use the new version.
 - Rewrote get_trace_page_size() to use libtracefs APIs.
 - Cleanups in "trace-cmd dump" output, related to buffer page size print.

This patch set depends on:
 "trace-cmd fixes and clean-ups" patch set.
 "Refactor APIs for creating output handler" patch set.
 "Refactor the logic for writing trace data in the file" patch set.
 "Trace file version 7 - sections" patch set.
 "Trace file version7 - compression" patch set.
 "trace-cmd convert" patch set.
 "trace-cmd dump - v7 update" patch set.
 [PATCH] libtraceevent: A new API for trace page size.

 lib/trace-cmd/include/trace-cmd-local.h |  4 +-
 lib/trace-cmd/trace-input.c             | 11 +++-
 lib/trace-cmd/trace-output.c            | 71 ++++++++++++++++++++-----
 tracecmd/trace-dump.c                   |  9 +++-
 4 files changed, 77 insertions(+), 18 deletions(-)

-- 
2.33.1

