Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8994C433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Feb 2021 04:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A040564DA8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Feb 2021 04:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhBQE0g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Feb 2021 23:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhBQEYZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Feb 2021 23:24:25 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B382FC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Feb 2021 20:23:44 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id hs11so20087765ejc.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Feb 2021 20:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AwgmpS6YkEhi+7wYqlDJYlSaN10jqzbRdSNK+gtCfZA=;
        b=I9vRWrA8048AIo75N+083aMHXE5RV9ns82U9/5/kVRhMotIqzdKeZBRDkLkc7mUe+h
         iPb1ZDB6FD7OlcEJcrGWbqxK7QPlbL3Cp/fc0X+5oZa4aR1sgUIntKiC9Eo+P4Tt6Znk
         GkydWR77QIn07X17d2t/S+UO3ROP+n+g+27J7abX1K80jC0Ihj7DNVl0ZmlDbFLqKEsr
         Wcao+zXCU6g2b7lYm6XBvvY/d/f541JSluUjPv4FHkye3ED2DwVkzKWRdwwcSEqpgYD5
         or1DbS7/6B/FHPeCRgt1iKMgF2b6rqtK4ubEGgVb1p+9ycj8tc9PZvM/fpKcoPOSeTDO
         FkUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AwgmpS6YkEhi+7wYqlDJYlSaN10jqzbRdSNK+gtCfZA=;
        b=X6Ry+1fYBd3en/A9c9CQsQbnzCIknqGWfoG+RkIcWfOyRLkMpwADNuBHQ/T/OKG2E7
         njjTqwKNA59jpcui+MjePXN1leSs5bfJvzsW8Q6bXOEUD5Lkr+AqwkvFe1hWmp39k8Cu
         eGem2QeYRdI9KLOpZ0G6Zyu1TgkS45JDpW3n4gqMJy3r+YJ6t3k/RD/jlF4lPGqM6XQg
         0Pl++eKzKTdX3QE+JKZw6k46gfnkT/p4DDKfZOUrlz0F6w9GULcMZATYTVsq0SAS963s
         Hw6mUZWEPSt9gmFfxTTXdkN0i61YYhIF5QksAqHvllmEWVaRBzmbg9toQj9nCvW751wk
         FaqA==
X-Gm-Message-State: AOAM5301GLjNSA1lyX8+ek/CTUnxdlokc/ou8PPrKFKMMaRvahwxFQjE
        9InGbbBtADru3dCRb7W2bw2BGbOgtUj2dQ==
X-Google-Smtp-Source: ABdhPJyOlW39E3msstNbNbu6ds2apjoR5N/BSck6ngDwLnNeYf+/gHGwZwirxiKNMpqPUNhPwFDuHw==
X-Received: by 2002:a17:906:e4f:: with SMTP id q15mr23587431eji.216.1613535823443;
        Tue, 16 Feb 2021 20:23:43 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id cb21sm389698edb.57.2021.02.16.20.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 20:23:42 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Fix listener and add trace file validation
Date:   Wed, 17 Feb 2021 06:23:39 +0200
Message-Id: <20210217042341.1675546-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added checks for trace file consistency when reading and writing it.
Fixed broken tarce-cmd listener.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Add validation for reading and writing trace.dat files
  trace-cmd: Fix broken listener and add error checks

 .../include/private/trace-cmd-private.h       |  24 ++-
 lib/trace-cmd/trace-input.c                   |  27 ++-
 lib/trace-cmd/trace-output.c                  | 161 +++++++++++++++---
 tracecmd/trace-listen.c                       |  22 ++-
 tracecmd/trace-record.c                       |  33 +++-
 tracecmd/trace-split.c                        |   2 +-
 6 files changed, 219 insertions(+), 50 deletions(-)

-- 
2.29.2

