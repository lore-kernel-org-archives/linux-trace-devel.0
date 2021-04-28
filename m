Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB7F2C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A9A6613F8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhD1Hav (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhD1Hat (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:30:49 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEFFC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:30:04 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id n21so16919427eji.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+7FlycB1l7p+3+slbzvqct7zh8hMHvc0RfhxXWSNJG8=;
        b=sW5ZXqylnhKSCeNFVE5nsns135KfK6Xc9uZZMVnwchS6SYqZ3bMu9y8Kty9fJwiv/A
         xAZOS8jIAlr+DPCEchCHjSEzuRZ2jSexi8i3JssOeMp26YAyAR+kiSy7fDYI5tPWshvg
         FvUsjjg4w2lSGgoZGYTYColD+CDu9tR7FH56aZGesgFKS8yymBg5j0rhr5vZ55A46Mc3
         zONV7lQD8uRcBOs3jigBN8ANrPeVo2TleU9z7A+EITm4yIgzmxYg3oHt9a3/anY+eBWO
         unJh4AcStQzw01Xgw1jEAwk7728+59rQv7Uh6C9+UXAHLqLr7qEMofhCmlvPVF4AoIu+
         0zxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+7FlycB1l7p+3+slbzvqct7zh8hMHvc0RfhxXWSNJG8=;
        b=nzQNDCuoBzz1QLiiGfwahoH9lWUavcgYv7eFc1KVJEZ2Y2RTsSoDEaAdzfeYK06SQc
         HXbxWcCxleiZnn2WPe0jfnHkZxjZZij2V8YLFkpTIeYZOG4sn7dYn26m5CdfW10dKUAM
         RsnH/brvNS97LB5Xbi6mdxdW7wBuJRMoNDfx9BNDGrOmorXpC+23f4KVrOLEf2e6iL7Z
         8nDphFS50tsO7wC7YoWXAIgvReCWRsXVK31lf2oWnKO23rA0T8pZgq48i6uEa7GxtDKV
         /gWId1TF2skQgLdJBJR/LX5RARgR0KfKArAYU2k50g5q2PWirK4nE5Ee5wB7OsaBNVCo
         Tkng==
X-Gm-Message-State: AOAM531Il54rh0W0sI27N0JwjQ1b5HWWgJMZzDBbdG2HdOcg5xi8vRtA
        vvHGuSuly5YzBXEoyajZ/HGXWb3aWmvKNg==
X-Google-Smtp-Source: ABdhPJwt2+l7M0jXTUqSMcQnPs5Xt+c4R8rWiKmGiSj+/Xv49eEtylms4p+GfKI6uMS68Uvnlh3a6g==
X-Received: by 2002:a17:906:2dc6:: with SMTP id h6mr6176975eji.477.1619595003556;
        Wed, 28 Apr 2021 00:30:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id dh6sm4274292edb.63.2021.04.28.00.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:30:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/4] Add severity to library logs
Date:   Wed, 28 Apr 2021 10:29:57 +0300
Message-Id: <20210428073001.755905-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Defined library log levels and add a new API to set the desired log level.

Tzvetomir Stoyanov (VMware) (4):
  libtraceevent: Add log levels
  libtraceevent: Add logs with severity info
  libtraceevent: Rename tep_vwarning() to tep_vprint()
  libtraceevent: Document new log functionality

 Documentation/libtraceevent-log.txt | 90 +++++++++++++++++++++++++++++
 Documentation/libtraceevent.txt     |  3 +
 src/event-parse.c                   | 14 ++---
 src/event-parse.h                   | 12 ++++
 src/event-plugin.c                  |  2 +-
 src/event-utils.h                   | 11 +---
 src/parse-utils.c                   | 48 +++++++--------
 7 files changed, 140 insertions(+), 40 deletions(-)
 create mode 100644 Documentation/libtraceevent-log.txt

-- 
2.30.2

