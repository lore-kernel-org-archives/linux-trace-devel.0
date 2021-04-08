Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3B2C43460
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 14:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C68C26102A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 14:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhDHOAt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 10:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbhDHOAt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 10:00:49 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9AFC061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 07:00:36 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a7so3262755eju.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 07:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V2q+mngI8o65igWRMdQUWGiqpOULnIZpGWSosWw5jnY=;
        b=M355Jb/ColuABbqm/p/oJwBjjAfKwDtd/MFGNQFfSkfEm6EDdB2LYaW4EGT+Cjan30
         UcChweiFXjnj/WrZ6wulUcY2byA7D/wiuwRDo1XCfSLZT+akNRJcecy4YwKLXum1H+JE
         VEYt4ToychJjrBxme0lHhFYXaC3TRgHBDaDrqzP/5geqzg9xgLCSLm04FAQ7d6SyUxlQ
         o1+hIAsgC8YryXakkzRLQa24aklTfg1C5HlTTCSzk/kS7MXqMsRhyKx4ldpnVDlMNmTA
         /zFRhi3XXOWlwydk0vGDd8BiE0gpVh3LzccPqcDQIGApyf2WPQoiJBdrOfJ8XcUjTIGU
         HEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V2q+mngI8o65igWRMdQUWGiqpOULnIZpGWSosWw5jnY=;
        b=SIrUU34/L4iWAi0DLAcLYf4/OJ6N2fZj4EWAHV4+O8XuUzQozgtxPL1jmBlZQSFVUL
         p+8rMuRB7+MGizPXIfX0Dx8O6q6tJjoNeI+FjBKpyzJsyc/XMw4gNV6sHPCISyCqaARy
         rCWy6hXloDNhwzqaEl2c82eLflIvLmjrWcSof9y39a/1uOVHicpHwI8AzH1iFbGmhKTr
         RlQIggZ4D+8VT7kWIjoKPOUM9zeyvjUnSGt2e/tAXcRAVWBxyqi9Ty+I/pt+odRgE9j0
         s0pr2+0jqpUi0oIJbONoTm5sDK2B+wWQWc0Uyvx6bNPDJ50CA8bWbJ3XYeU0j63mtLe/
         VDUw==
X-Gm-Message-State: AOAM533A30Privxb8QWLr2PUdkkK7eX45m08NLBQWQRyQ3FJ5n0kXARl
        nAmdimcsp7a1QV1sQ+0xqNo=
X-Google-Smtp-Source: ABdhPJzoJtY9/XPCoV99bHSymKrciL0h4V40toA0DaT4tQ2h+rLVdIM2x/KhDOQBFYky04UGCHS44g==
X-Received: by 2002:a17:906:cc96:: with SMTP id oq22mr10192051ejb.311.1617890435205;
        Thu, 08 Apr 2021 07:00:35 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id jt18sm8212150ejc.96.2021.04.08.07.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 07:00:34 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 0/5]  Refactor the APIs for tracing options
Date:   Thu,  8 Apr 2021 17:00:19 +0300
Message-Id: <20210408140024.13093-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Yordan Karadzhov (VMware) (5):
  libtracefs: Fix issues with tracefs_option_id()
  libtracefs: Modify the arguments of tracefs_option_is_set()
  libtracefs: Encapsulate "struct tracefs_options_mask"
  libtracefs: Option's bit masks to be owned by the instance
  libtracefs: Rename tracefs_option_is_set()

 Documentation/libtracefs-option-get.txt |  4 +-
 include/tracefs-local.h                 | 12 ++++++
 include/tracefs.h                       | 11 ++---
 src/tracefs-instance.c                  | 15 +++++++
 src/tracefs-tools.c                     | 57 +++++++++----------------
 utest/tracefs-utest.c                   | 12 ++----
 6 files changed, 56 insertions(+), 55 deletions(-)

-- 
2.27.0

