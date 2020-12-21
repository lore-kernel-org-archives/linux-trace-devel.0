Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF7F5C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 07:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DB0C22BF5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 07:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgLUHaF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 02:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgLUHaF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 02:30:05 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE61C0613D3
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 23:29:24 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id b2so8661289edm.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 23:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X7rIIeQ9Z0f848iyl/UI8othfNYI3ICLGnze4bFI6y0=;
        b=vbuNSvubr7lMFCqh9kF1C+0tIbqXeQDbKva2YkacbS5xWwfqOiosWP4/Px1EFgcpV7
         knprHPpbLfZRd7bKw8QcpIYvRHwo+TXWWVps304qLDXPkQG20P2s438DUWThOIIlOaI0
         qJ2sTzxns/TrOq71z1s73o6kQvhtj07qgdukerHsy16dbuV10cQShABj4XE1EUdq13df
         TcwrUeIJILFfkIPIhUWo7O4lBAzYSJefQg0rwDGI8gWPCy+QyQ60It3nKUd1cGTeMKmJ
         GKYxsc0MStDrHumRHWS2ndqxniffPUuMXYKdkGkE19wUAly7wVnGn+wTNSwxVf32G+aD
         xPXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X7rIIeQ9Z0f848iyl/UI8othfNYI3ICLGnze4bFI6y0=;
        b=iSU6PkRBnuf7tBz60LSUrWqx5ltT3YY1h3mefnjRhGjQo+pldRxOJFL5OGXPm44x5F
         zsMbZSUeOtCxXUEkme+AQ5VjDUtyh5JUGFN1ACQ1WBfX8LXd8lA9rjNXjgcN05VNlLoP
         Nwmxu1J8kYi616W6VIScINV2Eyp9XyFHgJyBuoTerr7l5QHpBamff7ziiu49329kaSeT
         FyrHh7PSg42HeRexXV9Whwms3/Q2yfiNmQ8jqmVWZNtCoZNVYrSvQEA7q2EwAlc+QIpo
         yY3OWb/AyPLUfVWSzlvO5K/koZvUFI7jBrphWNUYt6R5yvmCqHOY757iJiPk+7eLY2bb
         T+3A==
X-Gm-Message-State: AOAM5316MxZ6L9TkRCtUVZPFW1Tk9kZfrW4BqRMmNEOIqEmMnPGVNcBn
        vJg2VjtC7m/65S/r7HxMWNH+HPsxkh8G64oq
X-Google-Smtp-Source: ABdhPJxszh8Wm/gLHD86blWhkIUtVzS50tlVF4IVw8nq58YQ+dCsSHB6YcJ/kLCuOCr3Nb7DZlZARw==
X-Received: by 2002:aa7:d297:: with SMTP id w23mr14829572edq.374.1608535763452;
        Sun, 20 Dec 2020 23:29:23 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h12sm8557429eja.113.2020.12.20.23.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 23:29:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/2] Consolidate APIs to locate tracefs mount point.
Date:   Mon, 21 Dec 2020 09:29:19 +0200
Message-Id: <20201221072921.210230-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The two APIs to get the tracefs mount point 
tracefs_get_tracing_dir() and tracefs_find_tracing_dir()
are replaced by single one, tracefs_tracing_dir()

v2 changes:
 - Made the new local trace_find_tracing_dir() function hidden.

Tzvetomir Stoyanov (VMware) (2):
  libtracefs: Remove tracefs_find_tracing_dir() API
  libtracefs: Rename tracefs_get_tracing_dir() to tracefs_tracing_dir()

 include/tracefs-local.h |  2 ++
 include/tracefs.h       |  7 ++-----
 src/tracefs-events.c    |  8 ++++----
 src/tracefs-instance.c  |  2 +-
 src/tracefs-utils.c     | 14 +++++++-------
 test.c                  |  2 +-
 utest/tracefs-utest.c   | 23 +++++++----------------
 7 files changed, 24 insertions(+), 34 deletions(-)

-- 
2.28.0

