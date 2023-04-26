Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA1EC7618E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Apr 2023 04:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238586AbjDZELb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Apr 2023 00:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjDZELa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Apr 2023 00:11:30 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B3683
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Apr 2023 21:11:28 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-2f58125b957so5944102f8f.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Apr 2023 21:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682482287; x=1685074287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kEEzUcirjDGdbinjJe4Zo6ovjeOPJHM7bMANkz70Z6s=;
        b=P5PUli7A3ZwKgM2ZaUj45Yeo4uIuq6CXrbAyUsoSAN5rFBxCzjPKB5wMtw+zZG8cxg
         LxojLq012XdiGxeWX0s1oamSHZw3YHUHsK6ZdLnSHKTVaeD3WrmSkpK7ej0BCr/0bjKm
         053Kbgo1MwAZiWTh5W9P1zY6we3e1wg9P3W+XRQw7kBkK3vAESPFX04UxfVucmHwDuBB
         Yg1LerTC9VuehgIp4/FjPE+pDzE1JYKXFVFjQLN4VlnQ63yVrnSwMbGKcJdqYQM2SueM
         GJGQGorwWEfMN7AyL+wjnoXSDNfUvgqmiZTOsGn3YniVwoF5oXMC0yBWkRqqEkzjbnJw
         0F5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682482287; x=1685074287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kEEzUcirjDGdbinjJe4Zo6ovjeOPJHM7bMANkz70Z6s=;
        b=JP33ubFcP6XQHP2IasbaTpLPOTvs70ctrNV2bbrVQW07gH8Je53ylcl2grHSICaBp5
         n5iJJHA+lt5+lrrPdP7abjtAqw0oc9iH8K+BULtFw2Cnu7r/7uOcwoDt+7Xr9d7s+M7/
         nhZIFbKtMq8zm+LO8iCSzTBep9cM+enDQnqgQ22Lf+7i370sy3orP4s6o0qFkvmQhUdj
         dcf4Jzag+Q1/jwGnrzHkeXXRsgVjYnFBvjrNYBgZsjaxCOn1un4IzdDZuOBWNg7mCEMK
         jZ2NLZgyghF8FOC2HHpWeRcRiDhww5py5g5v32V+/++OW8mlwENNhx8YOAjwLB+av9sW
         drdw==
X-Gm-Message-State: AAQBX9ehSjAdNtyHe9UIr8JNGHM/w51WnmVpqPNqGy5QJtYQC97WAXEi
        N4uaEME3RGxgHqmrJkl4YlnrGbKylgpnGg==
X-Google-Smtp-Source: AKy350Y1XEYSCGWCeoVsW0cHTg3+3eQJGDlJIJ+zRdLE02Mf1qGPPieKsxuMxX3sjUobf4+Sha4/2w==
X-Received: by 2002:a05:6000:a:b0:2f8:1ab3:6e18 with SMTP id h10-20020a056000000a00b002f81ab36e18mr13975183wrx.51.1682482287021;
        Tue, 25 Apr 2023 21:11:27 -0700 (PDT)
Received: from oberon.zico.biz (77-85-190-39.ip.btc-net.bg. [77.85.190.39])
        by smtp.gmail.com with ESMTPSA id m5-20020a5d6a05000000b002f01e181c4asm14648107wru.5.2023.04.25.21.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 21:11:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/3] libtracefs: Introduce new API to reset ftrace instance
Date:   Wed, 26 Apr 2023 07:11:21 +0300
Message-Id: <20230426041124.69544-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new API tracefs_instance_reset() for resetting instance to its default
state, based on the logic from "trace-cmd reset" command.

v2 changes:
 - Check if the kernel is configured with triggers enabled, before calling
   clear_trigger().
 - Clear "stack_trace_filter" file.
 - Fixed spelling and coding style errors.

Tzvetomir Stoyanov (VMware) (3):
  libtracefs: New API to reset ftrace instance
  libtracefs: Documentation for tracefs_instance_reset()
  libtracefs: Unit test for tracefs_instance_reset()

 Documentation/libtracefs-instances-manage.txt |   7 +-
 Documentation/libtracefs.txt                  |   1 +
 include/tracefs-local.h                       |   1 +
 include/tracefs.h                             |   1 +
 src/tracefs-instance.c                        | 207 ++++++++++++++++++
 src/tracefs-utils.c                           |  20 ++
 utest/tracefs-utest.c                         | 183 ++++++++++++++++
 7 files changed, 418 insertions(+), 2 deletions(-)

-- 
2.39.2

