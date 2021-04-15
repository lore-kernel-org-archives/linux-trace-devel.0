Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C58C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 08:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C0906113D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 08:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhDOIP4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 04:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbhDOIPz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 04:15:55 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB927C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 01:15:31 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id s15so26955677edd.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 01:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SuZReQyGiIsEAduYbv5ctkjEQv24VvL2wmGNY/8i/m4=;
        b=L6ELMM/o22wEyt8fgJR0McOkJFudKjGSn1ft704quA8rMWgoaitka76gREptqgKWE3
         N0jqaOdkZo/ci1DOK3rZsdGSPA1i/tDNH8qjdnLMhKqlr5eKdd0SwEy3QwEfMD21HJVU
         WqN/6/S7ZDzIuPYCcZ31MBBnOIgLFF2AIVGhAWa/RJNLQwUi6wtyt1tGTyg4xu5WANA5
         gJk5WHCy7KdI0pJxvrsYuYhVW0HlSdDxGt7QOYVlKHPzJzeznBkY86vcjBxcaRwhzR1V
         oQOm43akpcsLXA8g0JD88SMuE528HTmYkwM8cNLkbQWgQb4ukqLxqaBLMwzt3B6Csy4W
         a5Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SuZReQyGiIsEAduYbv5ctkjEQv24VvL2wmGNY/8i/m4=;
        b=S7thV2pK2T/ksFXgzb01dZLx0dN6RKOSB42eVVPyHwA/WjwUSCHDCCM31AP9WVVAnA
         esmBM6BvzcWWHcGBYUrCphGUDZltNQGfKDnmYz5kcdA/EzC9OZc2EZiN+FgZCqcakefs
         5kOmUFU9K4wBc0QdkjTrMpMTV6cvbW+xEKFQNigHpfqnfQFycLpjff1oq1Wy4xpid9q8
         HPtAFqBqpy3Mv51QQkNxhdoPCloH4NBA1hR0Nxah/HT466AqkRs/6G9GIXhdZErWJg+Q
         obIc4XqurLJhZrN8+i0poZNY8fEOncpFSz576zy0SbmOGln8I5YJtYwtjYvqhWWd9fAT
         TbeQ==
X-Gm-Message-State: AOAM530pUn2fNnj5P8vBBW9Lk7ywJHI0+nlAXuMAluA6ZHrg4aRNPBzZ
        Oe4hWuY1Lw52keBSWwJauNyA9IhywtI=
X-Google-Smtp-Source: ABdhPJy4ZNOIOCxyqj5N1ApiYDleNpTvgutMXZ0cI/4eW6eJ8VjGaUBtgHOpeAP3FSBVssSdfeUiEQ==
X-Received: by 2002:a05:6402:51d4:: with SMTP id r20mr2683318edd.112.1618474530485;
        Thu, 15 Apr 2021 01:15:30 -0700 (PDT)
Received: from oberon.zico.biz ([151.251.243.123])
        by smtp.gmail.com with ESMTPSA id r19sm1312840ejr.55.2021.04.15.01.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 01:15:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] Fix overflow when applying tsc2nsec calculations
Date:   Thu, 15 Apr 2021 11:15:23 +0300
Message-Id: <20210415081527.3483835-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Verify that applying tsc2nsec corrections on the recorded timestamps will not
cause an overflow. When recording the trace, in case of tsc2nsec clock, get
the first TSC timestamp as offset to be used in tsc2nsec conversion.


Tzvetomir Stoyanov (VMware) (3):
  trace-cmd library: Add new trace-cmd library APIs for guest ts
    corrections
  trace-cmd library: Add check before applying tsc2nsec offset
  trace-cmd: Get the timestamp of the first recorded event as TSC offset

 .../include/private/trace-cmd-private.h       |  18 ++-
 lib/trace-cmd/trace-input.c                   | 116 ++------------
 lib/trace-cmd/trace-timesync.c                | 113 +++++++++++---
 tracecmd/include/trace-local.h                |   1 +
 tracecmd/trace-record.c                       | 146 ++++++++++++++----
 5 files changed, 240 insertions(+), 154 deletions(-)

-- 
2.30.2

