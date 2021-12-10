Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839EBC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240166AbhLJLIv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237368AbhLJLIv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:08:51 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E09C0617A2
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:15 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id r11so28271637edd.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VDXdWdnKZX9LnIkpC8f1aH5jEyZfuFRrR691bXeyCy8=;
        b=g1FEr9O3OzzAKDCIg8rgT65DH50kCRxEaGzvp0npcysUyg4Fty59w5d97WHy75wsfG
         81thO0oodq8YuzPK5kYT2mojragHtRsai+CSk/ZeOY9RYOcPxyrQ8Rs7rN7gKGgUtUoD
         qxOuvcWdQ3VmJM3bUr/ggzNu1QP6xGvcXt3qO1xjmuBNOMPbbtGYUrWhW29mOkf9m6RV
         K/DiexDKgzVkN9y7cv7Inv9+GvHkwlpleADiTly22W8NG0JejYBxSusp4ix3tPh3I5lA
         bxvFNivJkaf6NC7m6Wi5/uZnu327GWPFwS0vWOT8p23Hyse/iju4bLYpjIKouk0Al2rv
         JLvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VDXdWdnKZX9LnIkpC8f1aH5jEyZfuFRrR691bXeyCy8=;
        b=bnpy1AsBaeU6ln75RA8yi/Rs78slMdrtguy7UxveAu8RL+YlsugiUdx/dxu2EqR/JD
         k7sApVBKl7c6AqV8fJKq0MUSn8qCdKmqAF7IjpyAYfvzhEkVYWthnUKXDFLB1X4DRShj
         IPYankP1b7Hpq1JjWvZyKDaSxvAJ84uT7lH1hWNiVK+8dnoGZyWYswXRngHE3RKbqtXe
         dFfcdd4keWSdLBAP2DsanK3W6ey2G77Or1B4seqcNh3QCWOUKYOkT2/h2EveyqjoHnHd
         bgT7cfRsB3GuPgZc9NVICM95eAYXXelOEGHHIW4llAhbp0CpFAM9hIidBa91TZGwBrei
         dKYg==
X-Gm-Message-State: AOAM531bGN5XKaMbPljKBjUfRIfpU5CrxyCeYtsU5S4OlM41PFFMEaeL
        olvu1sz9CE2Siz8saofYF+qoxmxrhJ0=
X-Google-Smtp-Source: ABdhPJzIH6HIIHE/4umIvkYkGcckYbAm1K8vl8wwaNj5JsEHSKAoasCRLO69qOVD3H8ozPYAz+V3wg==
X-Received: by 2002:a05:6402:2809:: with SMTP id h9mr38005668ede.351.1639134314396;
        Fri, 10 Dec 2021 03:05:14 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gs17sm1278887ejc.28.2021.12.10.03.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:05:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 00/11] trace-cmd dump - v7 update
Date:   Fri, 10 Dec 2021 13:05:00 +0200
Message-Id: <20211210110511.98856-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Updated the "trace-cmd dump" subcommand to work with trace files version 7.

This patch-set depends on:
 "[PATCH v6 0/9] trace-cmd convert"
 https://lore.kernel.org/linux-trace-devel/20211210110249.98583-1-tz.stoyanov@gmail.com/

v6 changes:
 - Rebased on top of the latest master.
 - Introduced new metadata strings section.
 - Use 8 bytes for section size.
v5 changes:
 - Rebased on top of the latest master.
v4 changes:
 - Rebased on top of the latest master.
v3 changes:
 - Rebased on top of the latest master.
v2 changes:
 - fixed issues of split and convert commands with some corner cases

Tzvetomir Stoyanov (VMware) (11):
  trace-cmd dump: Add helpers for processing trace file version 7
  trace-cmd dump: Print compression header
  trace-cmd dump: Add helpers for processing trace file sections
  trace-cmd dump: Read recursively all options sections
  trace-cmd dump: Read extended BUFFER option
  trace-cmd dump: Dump sections
  trace-cmd dump: Dump trace file version 7
  trace-cmd dump: Read strings sections from v7 trace files
  trace-cmd dump: Dump sections content
  trace-cmd dump: Add new argument --sections
  trace-cmd dump: Align better the output of flyrecord dump

 tracecmd/trace-dump.c | 549 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 504 insertions(+), 45 deletions(-)

-- 
2.33.1

