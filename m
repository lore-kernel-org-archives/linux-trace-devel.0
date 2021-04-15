Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C729EC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 12:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B65B613B6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 12:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhDOMNs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 08:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbhDOMNs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 08:13:48 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1444C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 05:13:23 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id g5so29814692ejx.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 05:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TZ1GyzeGmmgtMFQVJ90CpgBIgCC7iOlumpQCDzRj1ag=;
        b=Kli1GKOq9XOAJXAipcgHVTtRRt+XNvt57TpB6BUlrasarWnFpnSsS6LG/fpKWN8kLB
         Q3S2CDxDrbfPAYBWnWZ7phKtt+OwAZszrSoLPV7AXhCjhwPjr7rtOnoG4jvgXKO+ICHk
         9lzry+gGkKwQapL3WdwlNZR6U3IYWRLOUOoW7Ouftjwd0L1aRKlXXE6h+zWgmJOVqCK+
         zYW9/bV++RAT0utud6nlFTXH6KcbRI0A7vFgq8XAWmpMecCG2RDPVKltCjg8IqDaUrnY
         3881OzTLlZ0dl0m9qJCWAH4V8Ei+DCx9Jb/nOjLKp99z0UDUnbnhV4c0oBlZTMvtUBNy
         Zj8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TZ1GyzeGmmgtMFQVJ90CpgBIgCC7iOlumpQCDzRj1ag=;
        b=BhnaCAkvVdYkHWGUC6O8kDrmTssQshsSlOm2klsa9O8b+EG1lEjCC5qx8AmoZWz/gj
         Xtsy5sIeutOdx+SWi4A/+XNS4r6aYd2VrpgOzuSNsKI69DGJoSBhqqGBwViW/YTwuY22
         soQALTkskds5unnaMl3gHM2lPD5YK1euh1ARf8bcNmuZFz2Lk+vLq1JNd5WSQQOenFu7
         e6RtscVpEj1wH0HUFZTNsORxx4B+f24lvbFy59tU8KNn7Cex0c43Y+HSKjDQSDSLFzDe
         peOUH9Q6PC2GbF4Y7fDjPmwRUcDyiBML5fWj8JouF45dpmJqov+hZNRlOLPlNxeCj2Iy
         JS5w==
X-Gm-Message-State: AOAM5337QZqM716S9uxpEBG/my3GWxYymu5UhO5M/icHZ4AwnkUrUnwY
        fv8MKwtr4hQQ1aJwnl2MqOM=
X-Google-Smtp-Source: ABdhPJyZfceB1K/VvBkK3VuK4+bROG7uU6dHgkoQzT5wAKI7Brg6vMvpM+s8csqtdF+W0o6y5hAnuw==
X-Received: by 2002:a17:907:9607:: with SMTP id gb7mr3027561ejc.380.1618488802707;
        Thu, 15 Apr 2021 05:13:22 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.55])
        by smtp.gmail.com with ESMTPSA id o20sm2364863eds.65.2021.04.15.05.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 05:13:22 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     tz.stoyanov@gmail.com, linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/3] New methods for writing to file
Date:   Thu, 15 Apr 2021 15:13:08 +0300
Message-Id: <20210415121311.59787-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Yordan Karadzhov (VMware) (3):
  libtracefs: Add more methods for writing to files
  libtracefs: Add tests for the new methods for writing
  libtracefs: Document the new methods for writing to file.

 .../libtracefs-instances-file-manip.txt       | 199 ++++++++++++++++++
 Documentation/libtracefs-instances-files.txt  |  35 +--
 include/tracefs.h                             |   4 +
 src/tracefs-instance.c                        |  74 +++++--
 utest/tracefs-utest.c                         |  32 +++
 5 files changed, 296 insertions(+), 48 deletions(-)
 create mode 100644 Documentation/libtracefs-instances-file-manip.txt

-- 
2.25.1

