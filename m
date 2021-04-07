Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B538C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 03:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4272360C3D
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 03:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348436AbhDGDsi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 23:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344405AbhDGDsg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 23:48:36 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09C0C06174A
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Apr 2021 20:48:25 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id a6so10316313wrw.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Apr 2021 20:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w+5pGQYb8dUco1zzxlNa8KEOKzpznge8An/shu36+J0=;
        b=hznGCS2C3PRWw5qPIeqq9SwzMp9A3TobZfdHLwaiClAQbwdNIpEs8Hoqok0m9K5bTk
         e8yGrgR2rM/wR1tlpd9CW+HTknesg6WIt8cGRjVtCJijVnxqqtSVNFWJjc7NIVLW1BG1
         UPau3rQxIpO6PSvRb4Nz9M5TvBcPB/PToiCeSKcKhz1Os49hlJ+LTVch0QUt9Twf2reF
         8gjV7lxrhc6btXP8AvykKppRQV6GelOXs5gjLjFq1cjNneZBAaHIgW87n8kebnNX0ugW
         IYq4JfGn1WJCwNtGngA55PZxVTIIrg7dC1QTg5LSRRA7QVo5zdJftpcO1ImiULpDsR4W
         Re+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w+5pGQYb8dUco1zzxlNa8KEOKzpznge8An/shu36+J0=;
        b=YfTQv3fI3cSl3DlvOQjwHjsiiEbRT80RvK3G4aDoqOfNTEDOmhk4KLZCD0DXHOfElW
         PNRrMwoAcBBmt1OaFkHxilvxdM5AQ8ieujQfYBK6L55b3DmT4bSBm79VwoLBdc5arAsn
         sWEh+Rlu3pCWZcYSBDNlpbFevmJQ6PMzXZDdOfL/h0kCSwL/ySNudSGNzsXucVO5djZb
         LJz/gEXjo6JReeDOgZovs22xJfra7NgvaOn2jc0hpQVsUdWeBiz3SIb8VwWqXi5Trl7T
         4sh2KI2svbseiLU4Xrj6BepbpOfE9Ca22dCqYIoTDDZJXKMZZio5qPBb3sDAHik6svPO
         dcyg==
X-Gm-Message-State: AOAM531+ZdzdmTdz2a23GfdyCGEHanlPuAMPAA5v5AjtrHJPdA7zUqIb
        ZKbDxB/xU+FQBcGBzQjycheBJLYvbe3fkw==
X-Google-Smtp-Source: ABdhPJze/MXckSrmPN9CmFpM1mJ4e+B1935wOi0jC8WX3pkEK5JXnkU/Ta9FG6E5LN4XOM9fXPQcSg==
X-Received: by 2002:adf:db42:: with SMTP id f2mr1618138wrj.359.1617767304550;
        Tue, 06 Apr 2021 20:48:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l21sm5684973wmg.41.2021.04.06.20.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 20:48:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/4] Iterate over raw events in sorted order
Date:   Wed,  7 Apr 2021 06:48:18 +0300
Message-Id: <20210407034822.2373958-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

tracefs_iterate_raw_events(): read oldest events first.
Updated the unit tests and documentation according to the new logic of
the function.

v2 changes:
 - Conding style fixes.
 - Fixed typo in function name.

Tzvetomir Stoyanov (VMware) (4):
  libtracefs: Iterate over raw events in sorted order
  libtracefs: Unit test for iterate over raw events in sorted order
  libtracefs: Unit test for iterate over raw events in selected CPUs
  libtracefs: tracefs_iterate_raw_events() documentation update

 Documentation/libtracefs-events.txt |  14 +-
 src/tracefs-events.c                | 247 ++++++++++++++++++----------
 utest/tracefs-utest.c               |  31 +++-
 3 files changed, 190 insertions(+), 102 deletions(-)

-- 
2.30.2

