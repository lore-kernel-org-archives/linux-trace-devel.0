Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A494C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61F70606A5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbhINNXJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbhINNXJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:23:09 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF4AC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:21:52 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id qq21so22989540ejb.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tVwusibe/B7X9xfQuqVCyHakyuwA7eDZ826QNhOaics=;
        b=dbb+TBgYle7j337v5jbQKcT0XGAv1Z6+ZKe+S3C+znsQYtpezQQp4H4lfy6n9UYZnG
         AT+Qga2d656On9wmHasILqcrsHZRalpInWmhEi2yJWuxgZjt60D/QTd7BhXpjqlhWLvU
         qsS/Gk4R9H0HUMCQYOWVKZA7zFADN5G8DZOfGdSF1bAOZpd+VBHY9ik1cElk21BrguIp
         1M6BpPKSEfYptlnWs2H580Gv6KYasy+GIkVizPqQ70rBMsp+NfbGRnPNKs40YKoh7eB3
         6pN0gSQ/TIwkQoXNj1ghLkqCmP6384/WRcHkG9WHzex0YE94JzQUjWG5HE85H5I7Brfz
         thGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tVwusibe/B7X9xfQuqVCyHakyuwA7eDZ826QNhOaics=;
        b=c6bD5oQzcuqKl/bAahCsdi4XYxIBrUA/T1Pd1Cvvy4C+rhsK7Q88lwzXo5OmAT7PCr
         /meILIRHjW1nqUfWEX/bwTlWgMaQ/UCp+5haVPdnS71/w7CG1V+fC20zAyw11Kx0NFqR
         bGKAM8JfZJIYq4KDA+xXnEZLQ2ueoGP5vXQPF9Trsm4IdGR22GY5L9kH0soa5eXHykG9
         5/+HZ0iEWACUnypN2Iu70kJjOyKmq11RYmG4tlV2GlQeONrZInW7UZxi5zNphUCuMD1v
         qgPPh7qZX0J45ctMbD/pqCRvE0rQ9ZHreeDAL3a9B3LoQjO385NvAZoIs84lqhumWX2u
         W2BA==
X-Gm-Message-State: AOAM530CsubQMa/FxNr7bZRle+X5k0VN1xMCCxdzTjFIxZd6QTQtNhij
        tj85NWd6fqk83wRndZSRae/bDWrnX+Q=
X-Google-Smtp-Source: ABdhPJws7OiFJhgbzjlZdQyic2JrpGwQp4xjtRHDww7wAmf3GxsZepwWZrAZ9K1/KgqKXp0bREogcg==
X-Received: by 2002:a17:906:f24d:: with SMTP id gy13mr18522825ejb.395.1631625710522;
        Tue, 14 Sep 2021 06:21:50 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l7sm5708431edb.26.2021.09.14.06.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:21:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 00/10] trace-cmd dump - v7 update
Date:   Tue, 14 Sep 2021 16:21:38 +0300
Message-Id: <20210914132148.3968401-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Updated the "trace-cmd dump" subcommand to work with trace files version 7.

This patch-set depends on "[PATCH v2 0/8] trace-cmd convert",
should be applied on top of it:
 https://lore.kernel.org/linux-trace-devel/20210914131921.3967421-1-tz.stoyanov@gmail.com/

v2 changes:
 - fixed issues of split and convert commands with some corner cases

Tzvetomir Stoyanov (VMware) (10):
  trace-cmd dump: Add helpers for processing trace file version 7
  trace-cmd dump: Print compression header
  trace-cmd dump: Add helpers for processing trace file sections
  trace-cmd dump: Read recursively all options sections
  trace-cmd dump: Read extended BUFFER option
  trace-cmd dump: Dump sections
  trace-cmd dump: Dump trace file version 7
  trace-cmd dump: Dump sections content
  trace-cmd dump: Add new argument --sections
  trace-cmd dump: Align better the output of flyrecord dump

 tracecmd/trace-dump.c | 458 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 413 insertions(+), 45 deletions(-)

-- 
2.31.1

