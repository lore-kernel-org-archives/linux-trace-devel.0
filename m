Return-Path: <SRS0=ZUfG=6F=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD229C54FC9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Apr 2020 10:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F4982068F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Apr 2020 10:47:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JpyIVJ2p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgDUKrS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 21 Apr 2020 06:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgDUKrR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 06:47:17 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42942C061A0F
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Apr 2020 03:47:17 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id a21so153068ljb.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Apr 2020 03:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7CV8kwNj0v63uaTVO1MdqjXwobG5XCgAym5zqGF/BAo=;
        b=JpyIVJ2plSxcACzn2ZNzFKhZTxbYIH/+8Dwvq/GEl94gv5Maesfe+FmNkMtcLovn4N
         IGW62JbcLVgFG497qHk09xaAn5x62lyO+qMOsi1oeDcG9CVwVvEM97E9wOSVnrTPkxzd
         BCdtWIDjZe0gSN+tbLhul/uFhBJA4ZgKFcl89LRLNgffhGPUa+gvG+8KMMKVCOJUaVPA
         +O801AuBZxm4sTV6gqD76+8+H931rmVzfMzzNcx22bHZg/XsOZewZg2Yq+z7uO/DZGsA
         ZmNAsfyOEk4Jca+RGnoBoL2s+PdE/l8ct/pRN28oXz4ayXa2n0kT5tlKa1FggMeHclDY
         yOQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7CV8kwNj0v63uaTVO1MdqjXwobG5XCgAym5zqGF/BAo=;
        b=iDaWHF7xH1kIq301ijzOh/HoiU2WUDHblT1az4DYl9km4Dai3RFPo7QoZSNvqouGb+
         o8n2iAXTyoN4jfW4rdPs+JRczRY2R0Xk35zAVWfsc4cJ3Lpwwe534nZFWjJd83aAopr2
         JtlMh+y9yJksvSYYvTO39yZvi/CMxHyk2lahdf7oZ9TCRowRd/vFCQf5eCQJgd4H2qPb
         MOQoIPG1MZQzyM3LsHzRaX2MPd/c2hWo2gg4Wz9Vrg01qG2Nb4ajZavmEN66Sp4kndsf
         paFM4nI74OYyl8kjKrwoP67FRNsLN+wjPYNXoSi40hwk+NY9KrfW/UmWi2Q/JEDvih+f
         Hhug==
X-Gm-Message-State: AGi0PuYn6xA49N45GJ5FqWghU0nIe+qSHGgPA/guFx76kW5dKv/xp0nZ
        5uGKmvO6lBI+djVdgf+Lsci1/uJWNuQ=
X-Google-Smtp-Source: APiQypIBhChirb3b2Z9JAGGt2RtsyK/vDmViZRQlGplfFJMiSvzLp6NtWSIV2yJ1UvIefOv7s/dz8w==
X-Received: by 2002:a2e:80cc:: with SMTP id r12mr4346257ljg.269.1587466035807;
        Tue, 21 Apr 2020 03:47:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id m23sm1680202ljb.87.2020.04.21.03.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 03:47:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Display more ftrace configuration by trace-cmd stat
Date:   Tue, 21 Apr 2020 13:47:11 +0300
Message-Id: <20200421104713.31762-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Display configured filtered PIDs in trace-cmd stat command.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Add helper function to print content of a trace file
  trace-cmd: Print configured filtered PIDs in trace-cmd stat command

 tracecmd/trace-stat.c | 80 +++++++++++++------------------------------
 1 file changed, 24 insertions(+), 56 deletions(-)

-- 
2.25.3

