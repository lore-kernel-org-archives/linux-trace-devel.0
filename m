Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843ACC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4326C60200
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhDVHR5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhDVHR4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 03:17:56 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50863C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:17:22 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id g5so60488796ejx.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wxsHdfSqszneCY213e6A+/YAujf0Ou3Ka8I6EQCYWy8=;
        b=JiXXL/gkpENgczu78EWknV8Iujg029+PupnXPK8wM6QQeuSUtnXOq+I7FAhJam3cir
         yJtR5yuzBSdoJgZBEd66NYK2G/AkTS22tcG5cwp8tBsdek+p1n+r6tfryOky9BgwaKXt
         3qPNADUVId0wKAKhuHdVwR+O2HhTzYKSyzUzS97z9+7xAafu/zbGGrHRrTR+XCfH9/Lc
         U9BWCEmgjfdbEykCL0KnW8HM+SMjfKZfCwPoKOLdYNKX/m4YvF08GKIFDmluBBhvyB5K
         6FxJi61HsXEZt/ydtT0U5nYSocFJRJN8xWSVpBtc5UF48Z8w+bbXLxKCSGv0J2jtNTNj
         2dNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wxsHdfSqszneCY213e6A+/YAujf0Ou3Ka8I6EQCYWy8=;
        b=rzW8q10GVfa+v1y+nWpV3knU8dytKCXLTyWEFLXE6zB3e/e5hEo95ZBOGRJ1HAYU1T
         hw55Xc31trFRnUMNiwj+eBAj+6/JJmbrrQRdi29AosvLhqVPPZw0c4yCLdoBvfVHV17J
         cJe/thwicPCIiaNuhHKYftqwSYpAtL38Ub2P9ODxXCa9jk47hNyLS96rwQwv/Wg0imQm
         1/1uWHQ3LsATwqHtJV2yha+1WbHyUROjtMhgZYeGM4GHRTjb+41dTLsgWM8frrzNYsvT
         8rc0+O2umZ36oCLsnKpU3HepSd81o2B3Y2QrErRjiH36qu3MWJUdpavOgfKNDf6Ev61U
         a4cw==
X-Gm-Message-State: AOAM533TlV08gAQy7+vei+keCoE0LrMuMd1lQGaSAmU3cOg3sutVxEke
        t1cffC3mHQt3GJZqHk12DRA=
X-Google-Smtp-Source: ABdhPJzwpDsZesUm6xDIB14YoM82l9U1k85B5Vbu/BTiTEiwCHMsRxr8SWritfTJ0RutO8Lc8PDdDA==
X-Received: by 2002:a17:906:cc46:: with SMTP id mm6mr1945089ejb.138.1619075841053;
        Thu, 22 Apr 2021 00:17:21 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k19sm1193958ejk.117.2021.04.22.00.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:17:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/6] Bump trace file version
Date:   Thu, 22 Apr 2021 10:17:12 +0300
Message-Id: <20210422071718.483383-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Changed the trace file version to 7 and added support for choosing 
desired the file version.

This patch set depends on "[PATCH v2] trace-cmd: Check if file version is
supported" and should be applied on top of it.
https://lore.kernel.org/linux-trace-devel/20210419093156.200099-1-tz.stoyanov@gmail.com/

Tzvetomir Stoyanov (VMware) (6):
  trace-cmd library: Bump the trace file version to 7
  trace-cmd library: Add new API to get file version of input handler
  trace-cmd library: Select the file version when writing trace file
  trace-cmd library: Remove unused private APIs for creating trace files
  trace-cmd library: Extend the create file APIs to support different
    file version
  trace-cmd record: Add new parameter --file-version

 .../include/private/trace-cmd-private.h       | 27 ++---
 lib/trace-cmd/include/trace-cmd-local.h       |  2 +-
 lib/trace-cmd/trace-input.c                   |  9 ++
 lib/trace-cmd/trace-output.c                  | 98 ++++++++++---------
 tracecmd/trace-record.c                       | 25 +++--
 tracecmd/trace-restore.c                      |  4 +-
 tracecmd/trace-usage.c                        |  1 +
 7 files changed, 95 insertions(+), 71 deletions(-)

-- 
2.30.2

