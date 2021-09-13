Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65491C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AAE36103B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbhIMMuL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235302AbhIMMtN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:49:13 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6497C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:47:57 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id g128so2129545wma.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dO1wy41ALDfjctAASfYVyOXhkrO0dap5MYO7uKXYwpw=;
        b=IslPP8eCDaeSIP9u3ArK3oQqp4kNC0+kc67NRF5gTtUZ3M5RtQrD421ZFK8F+Bc0Te
         K98uWsEbuiXkRR2AQzQc9WbAM4IqE0tXu8auh9/Ojs+iw0HcbZj0Nqh/nmEKUBeBaHTv
         3bCETDCZbinODQWTT4JPILmHJMl0xY8dol1YIYx6wcfaRNgBRCyuQkK5WF/4v6hMX3WT
         SmnxfJjbWVVpvS1goWehgZFiAc7eUB/yXiqfl9osHxDZlCAosAy9QqYmByQw54G2tKAo
         Iw4ZnldJqxlkLTKYzGl+B3hVW181jd6ujcUjrDUTKq+5PFo7VhUcrEu2epagAgqGxMYu
         heNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dO1wy41ALDfjctAASfYVyOXhkrO0dap5MYO7uKXYwpw=;
        b=fQ8g8qA2MRALc+7p+D4mzEtBiymeusVb/OBFYw2zSgPnPeb+KOLOy/b2pJegKskIbw
         zJEwAWjCCa5+nsLbC/iWm50LvmZ2h6RU6s3eSMOJV9wa7Dp/P2U6dy2Iu+b2wJkFPUNK
         k/3Y3HsyzglA3wkSvNQIyb7fdA9bXVFuToCV1cOH3s3kOKjSA0r+1TM9U8tOvETjqFpH
         5ceuOEk/JtKFpLOPcyE7G/sVQiOcRiIri1I5YITChfqa3FC9tg3dJ3FtE8Svv0kC9nae
         aLeyEDxZrtfNTV4cOS7zlGKYGd1N+Ih2qX9x3ohAATXnXdUUO20xyZnuhfhjb5J8p6Ro
         681g==
X-Gm-Message-State: AOAM532/wfjs4Vw+wvfa/D63vd8VDNecGyGDJwlE2c8K53w7Eg0KXjen
        /aqwV4miGEyr5hrccWfSSAIJBvr2q7o=
X-Google-Smtp-Source: ABdhPJzUGMGsQPd8y1jWPyYZ7xFv9Sx1+FXEhuZ6RgogQWtvCLOYmqFA7qzfSAZEwfBMn23fNS927A==
X-Received: by 2002:a05:600c:4f13:: with SMTP id l19mr11006194wmq.39.1631537276298;
        Mon, 13 Sep 2021 05:47:56 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm7718077wmj.0.2021.09.13.05.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:47:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/8] trace-cmd convert
Date:   Mon, 13 Sep 2021 15:47:46 +0300
Message-Id: <20210913124754.3679916-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new trace-cmd subcommand is introduced:
 trace-cmd convert -i <input file> -o <output file>
The command converts trace file between different versions. There are two
parameters for controlling the type of the output file:
 --file-version < 6 / 7>
 --compression < none / any / name of the desired compression algorithm >

This patch-set depends on "[PATCH 00/20] Trace file version 7 - compression",
should be applied on top of it:
 https://lore.kernel.org/linux-trace-devel/20210913124203.3677760-1-tz.stoyanov@gmail.com/

Known issues:
 - conversion of files with empty CPU buffers does not work.

Tzvetomir Stoyanov (VMware) (8):
  trace-cmd library: Use output handler when copying data from input
    file
  trace-cmd library: Handle version 7 files when copying headers between
    files
  trace-cmd library: Copy CPU count between trace files
  trace-cmd library: New API to copy buffer description between trace
    files
  trace-cmd library: New API to copy options between trace files
  trace-cmd library: New API to copy trace data between trace files
  trace-cmd library: Extend tracecmd_copy() API
  trace-cmd: Add new subcommand "convert"

 .../include/private/trace-cmd-private.h       |  15 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  13 +
 lib/trace-cmd/trace-input.c                   | 689 +++++++++++++++---
 lib/trace-cmd/trace-output.c                  | 122 +++-
 lib/trace-cmd/trace-util.c                    |   8 +-
 tracecmd/Makefile                             |   1 +
 tracecmd/include/trace-local.h                |   2 +
 tracecmd/trace-cmd.c                          |   1 +
 tracecmd/trace-convert.c                      | 106 +++
 tracecmd/trace-restore.c                      |   2 +-
 tracecmd/trace-split.c                        |   2 +-
 tracecmd/trace-usage.c                        |  13 +
 12 files changed, 870 insertions(+), 104 deletions(-)
 create mode 100644 tracecmd/trace-convert.c

-- 
2.31.1

