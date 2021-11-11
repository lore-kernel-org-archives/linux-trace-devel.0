Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF34C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8418C61252
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhKKPQU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbhKKPQT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:16:19 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E53C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:30 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id x15so25531207edv.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BI222C2gzQ083UU0Vs+l+pEVn+cOc7viEECX3vXtOt8=;
        b=SOTYJv7r1bybdgWayGd1gc+hmFCkYUgj0BbnJ/qP1jBSq5C7VJfyqJNQ7gpCjsugb9
         cHW1SXGlCM+tpJlfyp6eneDjCV4wLV+03z8y5jSk2Xic2qY9jT5VitGmoCmEeo6sZEmT
         2HwI+hGBFEZNtBVgOpE7vn1xTm7pZG2HFnU4OEAMnwkm6Z3HwtQurFUE1470zhc32XuG
         iJl8JcnnTYpowPI59DO3f7fmNZILX45qKSs7NapuWvocZFXemU4Fif1I3tgZWRQYCvfe
         0m/BLi6Rh/ptCeaN266ES49oq4xiaIksb5KK3sPw3bVIqe1yr5I+Y6R8KrFFU1ncDyy6
         cyXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BI222C2gzQ083UU0Vs+l+pEVn+cOc7viEECX3vXtOt8=;
        b=LyxdX8o4PRDXOyEA6xjYepDJgj0g8DOAglid9KQsvOqq5ZcpLxHWJS0BQNJwSLwONQ
         ytyh5pc33iGLS5Ay5KMhJ+/YnOaen0vfUEQLaR1oDG29C+umqFPYQ9OZJcDuq4ol14vJ
         EFT6T/Dm3nWfxqgO6ZcyUwq16SAWLBT804+MCFfVzY0KGC82LNvV1AXNu+VQDu8ONtV1
         9rxgK4zu+Eg9fccwix8Is67TOlHVcne4vWtHacLV5FZuutOuZpj50JgXrKCKAR4x1t5s
         ET6qHWIi6M4E6IeSy6wOAKHa5X0dOyE42WOBzeYuJgWP/rsapqMtu5F18yU2z5xY/9EA
         pHkg==
X-Gm-Message-State: AOAM530C16ihlCE8QWKr49xQ8UqYmLgORUxkth/c8ulThgrowDukQGmI
        UUK0df7fcDd9SefqymoJyQzhKPPQjn4oEg==
X-Google-Smtp-Source: ABdhPJz9ZJ5/mm3N9w+TqMgCL1HBvHLw4aS0VqAOuQu+ZcyZT//dUWPNQbqDx6aldQQS+4UvHTtgfg==
X-Received: by 2002:a17:907:3da6:: with SMTP id he38mr9700797ejc.151.1636643608246;
        Thu, 11 Nov 2021 07:13:28 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id sg17sm1429686ejc.72.2021.11.11.07.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:13:27 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Get trace buffer page size from kernel
Date:   Thu, 11 Nov 2021 17:13:24 +0200
Message-Id: <20211111151326.87227-1-tz.stoyanov@gmail.com>
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

This patch set depends on:
 "trace-cmd fixes and clean-ups" patch set.
 "Refactor APIs for creating output handler" patch set.
 "Refactor the logic for writing trace data in the file" patch set.
 "Trace file version 7 - sections" patch set.
 "Trace file version7 - compression" patch set.
 "trace-cmd convert" patch set.
 "trace-cmd dump - v7 update" patch set.
 "trace-cmd documentation update for v7 files" patch set.
 [PATCH] libtraceevent: A new API for trace page size.


 lib/trace-cmd/include/trace-cmd-local.h |   4 +-
 lib/trace-cmd/trace-input.c             |  11 ++-
 lib/trace-cmd/trace-output.c            | 106 +++++++++++++++++++++---
 tracecmd/trace-dump.c                   |   9 +-
 4 files changed, 112 insertions(+), 18 deletions(-)

-- 
2.33.1

