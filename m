Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3C4C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 05:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB57C64EB8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 05:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhBSFcm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Feb 2021 00:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhBSFcl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Feb 2021 00:32:41 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB80CC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Feb 2021 21:32:00 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id bl23so10127505ejb.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Feb 2021 21:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KNJKyHZsz0glLv9IaZkUFV6PtngS2VtPFCYHort/lhw=;
        b=t7whxy/gWgnDM23ibdJBxLY0OWyCh2ZMFQoB+l+ESZoRZtCZoVS9OXEuQniWZgqJS8
         BSLw7eOCPkPMAxHaTOQDcsiiD2TYNBTVM43u8Itri5mrIse6BTQyYfRCMpDWQK3GgYMS
         A4GgtBgjxSQ+K+3JnZG7xlJEYLSPnKf+iHubNQdoqO9ul8VziCvXy/qhPuQClZmEDfmn
         e5Sbg9N8GjBzq3YjXuH+QXuka6B08wOc1IR2XD6z3nwCmbyYUy5ownehUuhVFdHpFY7P
         tVjTIjDwpiof4phanzYxDNGzIEqGmG1tLTBoIUVTlFHETgX6kvNdWVh5ZF7ffzjaJXir
         v2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KNJKyHZsz0glLv9IaZkUFV6PtngS2VtPFCYHort/lhw=;
        b=m+5jKHcrJWlif3WQoBZCXfc9M6yfQVnGbzw7ayffek6mYlnXywdZmtfjkpyegLB8uV
         9J40KJMMTTiANvcjpAFCvM8J6irEZ6nUEHm/I47zFFYUV9cvsrIA2PlOB7zf9WBArOEA
         t34xuxXXu5OdPn1POoBCNAyXN5hVHqV5+sDI9G9i5IFBXYsQ3Ic5Tq1My78jRCWzEZCd
         RU9HQZtW6KaBOJ9jxZgQSIU3lGZ7s9XPjj1Z9f/t+yuIU3+M5dwxD8U02TlUvXvsM2v/
         Jj4ybGKAOU9QeEc40/wkRO+tMGEorjhrFtq8C/dSyaE0P2HjZNHmWZarnkckW/uMk/vM
         I9yw==
X-Gm-Message-State: AOAM5316IhTw3ctY+N6b5Q6xnt1Ajb5hftfEYswDwf7uwz9Aft7BKj7Y
        mpuqEqNXZU/yULG6GsYoSvKHo91rrSknlw==
X-Google-Smtp-Source: ABdhPJxBVTNICHJwJLodeoNWhia+Ul09767I1By151N700uPzLTKCPVlxuMPTI3+uorCbBVnq+wVDw==
X-Received: by 2002:a17:907:12d0:: with SMTP id vp16mr1231758ejb.232.1613712719633;
        Thu, 18 Feb 2021 21:31:59 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id bm2sm3752883ejb.87.2021.02.18.21.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 21:31:58 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/2] Fix listener and add trace file validation
Date:   Fri, 19 Feb 2021 07:31:54 +0200
Message-Id: <20210219053156.2235035-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added checks for trace file consistency when reading and writing it.
Fixed broken tarce-cmd listener.

v2 changes:
 - Converted file states from bitmask to enum
 - Added return value of collect_metadata_from_client() to track any errors

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Add validation for reading and writing trace.dat files
  trace-cmd: Fix broken listener and add error checks

 .../include/private/trace-cmd-private.h       |  23 ++-
 lib/trace-cmd/trace-input.c                   |  27 +++-
 lib/trace-cmd/trace-output.c                  | 138 +++++++++++++++---
 tracecmd/trace-listen.c                       |  30 ++--
 tracecmd/trace-record.c                       |  33 ++++-
 tracecmd/trace-split.c                        |   2 +-
 6 files changed, 201 insertions(+), 52 deletions(-)

-- 
2.29.2

