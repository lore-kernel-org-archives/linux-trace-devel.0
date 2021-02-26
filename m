Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED86C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 04:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A81364EE4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 04:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhBZEG5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Feb 2021 23:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhBZEGz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Feb 2021 23:06:55 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5289C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Feb 2021 20:06:14 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id u11so446489wmq.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Feb 2021 20:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Df57X+KVt37q1zgKBJwladZqdut4Qvt/iPbAZh8yNds=;
        b=aKHOXe8fbcb+DjPSAhbTMduLg0HTVIBOa4LspljhJAhVU/W4t3sJMi+B5bzG6LnsYL
         LtuQwqERH9nQGtyJkyj6qwXjpbZcFtDktdN7PsZsDzHsoRZRBAPcbwrEOrJVxwpsLeL/
         w34GQZglLpw4OStPXbfF0Zg1TSA5AopQGeeRvSVl+CVVIpM3mT3XRR8voUstLHHJtZ+l
         g315HDV2v+T+bJ4PebtxHAp93YGMInr8BD6/KuzNPoA6ABF+boCuvqiiHWS7lirl8Yqr
         O+13ZvM15ZU2v7tAbxQbFNw7fnGhaZXjVjPB97hom1MaNUXz9+WQkD9VfB+ruhY4IZVm
         tkwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Df57X+KVt37q1zgKBJwladZqdut4Qvt/iPbAZh8yNds=;
        b=V7D/xpzchycOXOH/xgc3BWjik3a36bxMt4hwEcPrTTcdayH8l5wXLTuapc60kvylW6
         6GafQPYJfiBABsPPhWx3l2fBsClDnghznFp0XTdWFTwP/pjFA1YHVzpKrzMAul3Kk7Ar
         qrfls5gyPVA+GXfjm3k/jQz10vgWTe85YInTlOpH4JHD8wwLaCRGqeg7dlG6I2C8ng8V
         JUBppzOiHgUrtFqiD7ePm0IUIaOqSS6TltXjHt3PS/mEf+7aT5ajXAfE8zknrP+sLlnx
         ddUpq55Gzpgh7y4JktkNBnO15WaGEdkkx6grPUdiyA5QJ4+wlL5RCp6tlHVUlesE54/S
         jQ0w==
X-Gm-Message-State: AOAM532avG0Jczr6BzLmSZrm4mJRMx4Bm29RXL1r/TSn69ac8ARSqUaH
        dofkTfsb96Rs8RyADcle8ew0FiLaUbI27g==
X-Google-Smtp-Source: ABdhPJwclY3ptzlGg7OavqSBrIVvd7gbHuYk9HcYsrirVWAHncAauzr65cWxykGX4Zof400mbM0Dlw==
X-Received: by 2002:a05:600c:26d2:: with SMTP id 18mr718147wmv.41.1614312373577;
        Thu, 25 Feb 2021 20:06:13 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n1sm12357070wrx.45.2021.02.25.20.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 20:06:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/3] Fix listener and add trace file validation
Date:   Fri, 26 Feb 2021 06:06:08 +0200
Message-Id: <20210226040611.186037-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added checks for trace file consistency when reading and writing it.
Fixed broken tarce-cmd listener.

v3 changes:
 - Fixed a comment to be in the Linux style.
 - Moved the optimization for disabling trace plugins in its own patch.
v2 changes:
 - Converted file states from bitmask to enum
 - Added return value of collect_metadata_from_client() to track any errors

Tzvetomir Stoyanov (VMware) (3):
  trace-cmd: Add validation for reading and writing trace.dat files
  trace-cmd: Do not use trace plugins when reading partial trace files
  trace-cmd: Fix broken listener and add error checks

 .../include/private/trace-cmd-private.h       |  23 ++-
 lib/trace-cmd/trace-input.c                   |  27 +++-
 lib/trace-cmd/trace-output.c                  | 139 +++++++++++++++---
 tracecmd/trace-listen.c                       |  30 ++--
 tracecmd/trace-record.c                       |  33 ++++-
 tracecmd/trace-split.c                        |   2 +-
 6 files changed, 202 insertions(+), 52 deletions(-)

-- 
2.29.2

