Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42757C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 10:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BA39610CD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 10:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbhDPKeh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 06:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235193AbhDPKeh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 06:34:37 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98A8C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Apr 2021 03:34:12 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id h4so17151734wrt.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Apr 2021 03:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AXh2+ZSs9EpufwHA9o7kJRh5meN/gGIC7tirB+KnX7g=;
        b=X+DRspKlPfDNUqNVeXYdIZs24GI5buKWPxeMKQ+dJEuy3alXvmOG0LzF8c+bQQ4hQp
         EIj5UmfUgNFOZt1f2CsZ2wa57qI+jyrkbkKjTPgvy0pyjMJwWH1AbaySnBcDZfheTAP3
         KjDt054N5IQCeE/sZCPGZsN6aD7pOFQCEIc0kHKejgeXEvg4ooFLdBES78QMv9u3VKLf
         LRtRHPYqOiyBwNRUox+Z/fT7RlUuhUCiecZ6F5zIyDkXh9FbUw5hv7GScUui1DzIsbi9
         anRFqMYJnawCWwbxjqcvtS+UlPlwhXA8ScGWTeb3X8JyzZhwc+Q0i3wT99L2+kbUmpFc
         ju6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AXh2+ZSs9EpufwHA9o7kJRh5meN/gGIC7tirB+KnX7g=;
        b=XCeIMq/1cxCRqFuLBuhVhA5O4cxIwjpbDmX2bTbQMHZmAUvhrqahd/Yn49L4dzqYfR
         qnJaH0h2qUSCAUHe8/U8UzglMMVdXCUU6hHtH+jYM/hNMeQL6UtyzEYn3CtDfOfg4mY6
         JZe5w4mrXJOo2BFDdfp1Tevsx7oKaG6IDUgoN5Girg/gTDWP8uNRqw9PpHonPIPgpA4X
         aNETTuRva0BOdZfSACEXszH79RsIrYDz/9gZ2NKnXO72WxAi4zL3QuBxelA1eJQkpe/4
         eZHllWQdRNuPQFpZ3xycGMdnNDFOZbyo8dNZNeWCtTgPUWjeNzpwHKYJQYJxa8DeXrG+
         46jg==
X-Gm-Message-State: AOAM533Lb/JEYIIlAKhQ8kboYpMhe3tkPyxZdyOTAgjv8oOlP/upbLJf
        b5cnt5lPEEcUueayhH0kM9gLRAjQu8o0Cw==
X-Google-Smtp-Source: ABdhPJwNmNgf+1Dq9PRYeFqzUAQhIaUwluYqYDlfdME/Xf96dsJ1WvX7WEUGrHz1ibJgSZ/JPXpEDw==
X-Received: by 2002:a5d:6648:: with SMTP id f8mr8380684wrw.76.1618569251653;
        Fri, 16 Apr 2021 03:34:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v8sm9652139wrt.71.2021.04.16.03.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 03:34:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/3] Fix overflow when applying tsc2nsec calculations
Date:   Fri, 16 Apr 2021 13:34:06 +0300
Message-Id: <20210416103409.24597-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Verify that applying tsc2nsec corrections on the recorded timestamps will not
cause an overflow. When recording the trace, in case of tsc2nsec clock, get
the first TSC timestamp as offset to be used in tsc2nsec conversion.

v2 changes:
 - Optimize the logic for getting the timestamp of the first recorded event.

Tzvetomir Stoyanov (VMware) (3):
  trace-cmd library: Add new trace-cmd library APIs for guest ts
    corrections
  trace-cmd library: Add check before applying tsc2nsec offset
  trace-cmd: Get the timestamp of the first recorded event as TSC offset

 .../include/private/trace-cmd-private.h       |  18 ++-
 lib/trace-cmd/trace-input.c                   | 116 ++-----------
 lib/trace-cmd/trace-timesync.c                | 113 ++++++++++---
 tracecmd/include/trace-local.h                |   1 +
 tracecmd/trace-record.c                       | 152 ++++++++++++++----
 5 files changed, 246 insertions(+), 154 deletions(-)

-- 
2.30.2

