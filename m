Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D6E9C4332E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF74722513
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgLUGD7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 01:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727449AbgLUGD5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 01:03:57 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C504C061257
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:02:55 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id b2so8504319edm.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t7fom9nv1VAKckVHUanRTrgaFGadYrevGLTBJ36l/H0=;
        b=f1qT3TEzkSlROMEyyhmdSlORv/LDg2V+1L+5Cyr5Dui4prNqD7x8QiuB2yhEzspP+K
         c4otyaEntV3Z7zZMFJ0+UVzFGQcTQekc1G2jHx3O1alNQxWEB3/ZwVK+DR2a3aO5kri0
         aCYa65cERkw/BTAWB+klW/Hvnnjj11QmqvZFPaKEera7H2bMfOvjUjVfX65Fg60PfFEK
         GTO9sXCi6KmVLZTNEtYZTjDZEwOMM1hEwqpoR7BuwYAgDUxm3tHJEGpyzahO1xgS4KO8
         +L22pjZDZcJxZhHoPb07XN/69ZXlgxC30gfHkSSqGzRz8HMF68WGMSCnzqd5p9IKWWYQ
         68rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t7fom9nv1VAKckVHUanRTrgaFGadYrevGLTBJ36l/H0=;
        b=KB4dUTZoJp/tt/s7Gg4md4z5eI1yCgZSphlUcIvg90dsNGRWHOZJiTg6T0wP4i66JF
         qBFttdxnyf3xdPHNBrYRObKHU6or8mYTT9FpuH+wlL/bvU8LMz7lH2v2xnk/juxkZ9lQ
         BbHLodJ4KygCAkJqz+LbVJWzXzENKOYc9tFPIsNheByUWnUY2xFc2mH22la5+O5veTzm
         xPttStIl03V9weL8F4HqZlbg5t2UULV3Fj8D8Ir+TwQVasHJC9HAdG2jRFh7crn1T/B0
         7yjksDoV80XweGR4DONsZ/lK6Y8SgjgiLCWzIv8dOkjcUMgaNJrzE2mxwRc8KSioJ17x
         vYzA==
X-Gm-Message-State: AOAM532ueSxD+7qkJxevi9zs8LnrLUBNvGHDBtvWLzgF9wP+9o4qh/Pc
        kizIp0s5Ga3tjKq5RQvldEw=
X-Google-Smtp-Source: ABdhPJzxmTT++7p0JNzWM/2KvIq0aDRgWIfkrTM5qYuWd/OVd/8gSRzY7BqNN4YENveQLSWMUtAT9w==
X-Received: by 2002:a05:6402:1696:: with SMTP id a22mr14641487edv.385.1608530574332;
        Sun, 20 Dec 2020 22:02:54 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z10sm8560885ejl.30.2020.12.20.22.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 22:02:53 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/8] libtracefs man pages
Date:   Mon, 21 Dec 2020 08:02:44 +0200
Message-Id: <20201221060252.177890-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Initial implementation of libtracefs man pages.

v2 changes:
 - Removed tracefs_find_tracing_dir() API
 - Renamed tracefs_get_tracing_dir() to tracefs_tracing_dir()
 - Removed any references to "#include <event-parse.h>"
 - Rewrote some descriptions, as suggested by Steven.

Tzvetomir Stoyanov (VMware) (8):
  libtracefs: Initial support for man pages
  libtracefs man pages: APIs for locating trace directory and files.
  libtracefs man pages: APIs for working with trace systems and events.
  libtracefs man pages: APIs for managing trace instances.
  libtracefs man pages: APIs for working with files in trace instances.
  libtracefs man pages: helper APIs for working with trace instances.
  libtracefs man pages: APIs for initializing a tep handler with trace
    events from the local system.
  libtracefs man pages: helper APIs for working with trace file system.

 Documentation/Makefile                        | 211 ++++++++++++++++++
 Documentation/asciidoc.conf                   | 120 ++++++++++
 Documentation/libtracefs-events-tep.txt       | 131 +++++++++++
 Documentation/libtracefs-events.txt           | 143 ++++++++++++
 Documentation/libtracefs-files.txt            |  97 ++++++++
 Documentation/libtracefs-instances-files.txt  | 160 +++++++++++++
 Documentation/libtracefs-instances-manage.txt | 111 +++++++++
 Documentation/libtracefs-instances-utils.txt  | 112 ++++++++++
 Documentation/libtracefs-utils.txt            | 103 +++++++++
 Documentation/libtracefs.txt                  |  84 +++++++
 Documentation/manpage-1.72.xsl                |  14 ++
 Documentation/manpage-base.xsl                |  35 +++
 Documentation/manpage-bold-literal.xsl        |  17 ++
 Documentation/manpage-normal.xsl              |  13 ++
 Documentation/manpage-suppress-sp.xsl         |  21 ++
 15 files changed, 1372 insertions(+)
 create mode 100644 Documentation/Makefile
 create mode 100644 Documentation/asciidoc.conf
 create mode 100644 Documentation/libtracefs-events-tep.txt
 create mode 100644 Documentation/libtracefs-events.txt
 create mode 100644 Documentation/libtracefs-files.txt
 create mode 100644 Documentation/libtracefs-instances-files.txt
 create mode 100644 Documentation/libtracefs-instances-manage.txt
 create mode 100644 Documentation/libtracefs-instances-utils.txt
 create mode 100644 Documentation/libtracefs-utils.txt
 create mode 100644 Documentation/libtracefs.txt
 create mode 100644 Documentation/manpage-1.72.xsl
 create mode 100644 Documentation/manpage-base.xsl
 create mode 100644 Documentation/manpage-bold-literal.xsl
 create mode 100644 Documentation/manpage-normal.xsl
 create mode 100644 Documentation/manpage-suppress-sp.xsl

-- 
2.28.0

