Return-Path: <SRS0=aZMu=6W=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD97CC38A2A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 09:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3048208CA
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 09:45:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BzF2BbjK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgEHJpJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 May 2020 05:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgEHJpJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 May 2020 05:45:09 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E4BC05BD43
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 May 2020 02:45:08 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id t11so926804lfe.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 May 2020 02:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SO+E/wgjlJBn7Ow5xBuzGcs/zpVRrG3mz//0Y7CD5mk=;
        b=BzF2BbjKQsVTuXj8PzbzACOOlbQqkZ92hagkLxaJ4nhmQKmkGMGvs2eRYSur6pSdch
         PuKpvwNjIwhBOP7TLd+K1b5ATRCQGemxgYvCvK/FCyIxu6WlTJ9xvXUallplyFl7Wgmq
         xKeYoWeQs2ba2FMjUZ81EG2q3jHZqfbSOOCmRYukM3pc87T6ThRGpGPtQBfkak2ROK5t
         oaXzUzJVE28KSzx0xbAPMYMbP4lLJwqcN1tJJeLKr1zhEykx+ufQz3eGxfRtju8EGyW4
         U/a2q1t3s4vx/tHfQrckd3ZcxQc52hwXPrnUs8B0UILc5sAPpNP/zaBKcOS/GGaHpC6x
         6cFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SO+E/wgjlJBn7Ow5xBuzGcs/zpVRrG3mz//0Y7CD5mk=;
        b=kAvtU618idZ8DWspOJRbAYBu+GIwyH45bXffD9kE9u//a1s+CInmtFlam5wkDhIpjD
         QuAUIgVGI2eEJ2OJvdH6IPd+64uYnOsejGCCRkyic5UwxclAci0IkKa+SVn2UFwYp85p
         fvsV6jBWcmFk9e/zHHAUJ+Ggk1L7ltYFontufVpsiI1vj4YiVNPSXULn8fWhTpnEHsgJ
         QB1z1UWANvexKQYskny3IOHcs9KNxMfa4m5ALH+FSrRDfSNQC9UsD5Fmy3lROGyJ39Je
         2fa+CeCNfMno5VGb5akxE8t/LygNXnn3x3g4vJO9vBiqAcPBHqLJXOffm4RsKu+NpQHs
         euBA==
X-Gm-Message-State: AOAM530MjMI1BGex+55sCo4DLk230SoH9sXvuAdIWyx1X0YyzV92hn7M
        G3PtIlu16/s6RUnNiN9zAfSt8jl0ADQ=
X-Google-Smtp-Source: ABdhPJyyH72YrdSbre7wznXSzSHOe05HKlu8eWsaJ2glnjn6w06znA/dX1S2S+WhCIcRfgBSc+VVyw==
X-Received: by 2002:ac2:4248:: with SMTP id m8mr1325730lfl.211.1588931107373;
        Fri, 08 May 2020 02:45:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z8sm787239lfb.44.2020.05.08.02.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 02:45:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Initial support for containers tracing
Date:   Fri,  8 May 2020 12:45:02 +0300
Message-Id: <20200508094504.2419540-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add support for trace-cmd filtering PIDs per ftrace instance.
Intoduce the "--container" command, which uses ftrace PIDs filtering per
instance.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Handle filtered PIDs per ftarce instance
  trace-cmd: [POC] Add command for container tracing

 include/trace-cmd/trace-cmd.h    |   3 +
 lib/trace-cmd/Makefile           |   1 +
 lib/trace-cmd/trace-containers.c | 141 ++++++++
 tracecmd/include/trace-local.h   |  25 +-
 tracecmd/trace-record.c          | 580 ++++++++++++++++++-------------
 5 files changed, 502 insertions(+), 248 deletions(-)
 create mode 100644 lib/trace-cmd/trace-containers.c

-- 
2.26.2

