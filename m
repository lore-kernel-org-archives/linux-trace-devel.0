Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24EBCC433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 04:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E83EC6023B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 04:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhDLEYk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Apr 2021 00:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhDLEYk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 00:24:40 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AC8C061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Apr 2021 21:24:23 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id s15so13364919edd.4
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Apr 2021 21:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wIWCl8E+FUVAMfKnF5/zD4jBXy64+WvGnJCL3vUOmEY=;
        b=qmOYh0JOkPlOkw1nmeqrGufhCu3nJ2WDjjRTfu9kPPuHWoAsM3j5WitwBSRdeOD3yA
         rmhiHMJn5WltV8mffUmYGl/svNGIYPo7sXfjAPPuZoORO1Mnv998AOSJe0s6j6+hBaV3
         XsjWLfWP+ODCMcrE/frJq2QwJJYpAdzo/fUEptDkDphdWsfBEybI9oDJZbowzfsYdHlv
         e5gbUwsKQmjnnN6YwU1nwKdG81kB3Ocu3HvhneqRsvPxvfKHRc6UnguEW/2sHPeExg6W
         o6W0TNOFsg8MkxlSwYEql/auge3Efjq8lXGpGzD/VMA3F053bdYQTLzb7Aq0FwnRViAD
         s3tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wIWCl8E+FUVAMfKnF5/zD4jBXy64+WvGnJCL3vUOmEY=;
        b=ZD0hmNeGZWXjGBkOzIvHKNEFYja3G+5Hsl0VECb+dHOttACfyimkTrS3Gsmj5sniI1
         itdNUZEDtN1g3NW/cNa7FVbBbJpWtqvIziUGu+1aMTj8q0Cq3L42jay4EfrrqUrvagyB
         lhFc3hk+NiojRaD/5aHANZzURaoOo34Fp12kzIQT0I9uFdj0unCO38TpVIuEnDeQVfrQ
         xywPypS1jIDmF90C6UdaSu86SnQqsW5hoVvFMQDVIEQi6YIpGUoWs5ekyB8vJy8UwZKd
         VQQk/k2qpoqdBHPfNG5uJnHXFOSNrcozKPypVGSUhcJRPuko0rc2SffmBcuGw34yFwuO
         pdUA==
X-Gm-Message-State: AOAM533m1RICExLaJ3kqD4UpXMupHYN8PAfRZVo4YGA80jZKbrm3G9Ka
        t+7b7ZA/+SnjSNiM7na3jNz44ekVxfLOvQ==
X-Google-Smtp-Source: ABdhPJxtETnymQVCGFBRh0s+cM7gYUNv3wxmfKtJildF1aTP2Xqjd+3rY7FidHU+ooUx/H22/xcVlA==
X-Received: by 2002:aa7:d917:: with SMTP id a23mr18482770edr.80.1618201461851;
        Sun, 11 Apr 2021 21:24:21 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id bh14sm4926786ejb.104.2021.04.11.21.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 21:24:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] Fix unit tests and APIs for loading saved mappings
Date:   Mon, 12 Apr 2021 07:24:16 +0300
Message-Id: <20210412042419.3295237-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some last minute changes broke the unit tests of the library. While running
the tests, noticed also the problem in the logic that loads saved command
lines, kallsyms and printk formats.

Tzvetomir Stoyanov (VMware) (3):
  libtracefs: Fix trace options unit test
  libtracefs: Fix loading of saved maps
  libtracefs: Fixed trace marker unit test

 src/tracefs-events.c  |  6 +++---
 utest/tracefs-utest.c | 25 +++++--------------------
 2 files changed, 8 insertions(+), 23 deletions(-)

-- 
2.30.2

