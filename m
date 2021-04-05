Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6066C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 14:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70AB2613B2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 14:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241300AbhDEOV3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 10:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241285AbhDEOV3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 10:21:29 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1576C061756
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 07:21:22 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x21so12745520eds.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 07:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t5VDmGckW9M/z9VMKy3Ept5MTZOei/JLdYyO+IiW5V0=;
        b=ZcZqn4tdxXltyE6tYZiSwTv6Cama77S7nfbn7VVpg6AYW3r+5WcCrUGI2ePinmbAHG
         Glcdb2KZbEi/AIS9C0Pw5fxdwKHaTfWJ0C8S2JzaeOvunTPm8UzEyMSZ3d38XGs6V3TV
         TtO6QD01tSpXyh4jLZZwiWRbIWKH+SFDHqjFMzX5O7RJ7jnGY1w7mLQmRTxid9eMB2jy
         GUv0epkC/CT+HuNX+uMuV5zZPQ1/pQ5FJ8eyBA3/eOIF+ZyqirH1yW5YznkNJJyp7Z7u
         t8Ktq8KTM0zoK4Kij6+ODIwYWbhuNHRU/H5SbMVfY45SNrgz8nki+zVssADMMWXaBpVn
         K2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t5VDmGckW9M/z9VMKy3Ept5MTZOei/JLdYyO+IiW5V0=;
        b=kdsx5dMIUqZc0+6qYEMpEFXu2L9K3z2xIEsKR0umXerkYa7nOf31VGchxEuvGBz0XA
         Fo9B1oGHnukFdLSebBGmQEfixH59UI5XbuhyocCEqxfhZvAK7tZsY0Y0ZwpUB5IAhoF6
         vrOZ4FfTe2HtUhou54I0ahOo99CYqteDKSneop6DiirJ7GDL+Su+6jYYuZHCimVB+lX1
         vugu0HcfHcFLfsvH5bBjXovLu18Z5DwDJcb6ctyPqPw8HBQSksVjoHleL4v/sMuMyu/f
         djKsfbLZi4Tom8dgoJ6lDAMHHWkYILLwxvFY/3xiIEFSFlUdsvXYt82CTcqKv0Dfldac
         e7rQ==
X-Gm-Message-State: AOAM531LY1OFeWfP5EHCtmEilc4Y29D+K+V/5YHm6b01ten++5DvTPv9
        smQKH2N6tMep4OscvYfOfkw=
X-Google-Smtp-Source: ABdhPJwU2ReQdV2/ObEN/OBdYcJ9x217pFwqE+duDxKZNex0QpsMDtg0OB5GbvB1/ELIFgKvXMVJ1g==
X-Received: by 2002:a05:6402:17c6:: with SMTP id s6mr17367678edy.319.1617632481737;
        Mon, 05 Apr 2021 07:21:21 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id e5sm3156972edr.64.2021.04.05.07.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 07:21:21 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 0/5] Refactor the APIs for tracing options
Date:   Mon,  5 Apr 2021 17:21:02 +0300
Message-Id: <20210405142107.507711-1-y.karadz@gmail.com>
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
 include/tracefs-local.h                 | 10 +++++
 include/tracefs.h                       | 11 ++---
 src/tracefs-instance.c                  | 14 +++++++
 src/tracefs-tools.c                     | 56 +++++++++----------------
 5 files changed, 49 insertions(+), 46 deletions(-)

-- 
2.27.0

