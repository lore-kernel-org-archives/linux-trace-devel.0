Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A05C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Feb 2021 07:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31EFD64F97
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Feb 2021 07:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhBEH6i (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Feb 2021 02:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbhBEH6g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Feb 2021 02:58:36 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA005C06178A
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Feb 2021 23:57:55 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id w1so10313724ejf.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Feb 2021 23:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dZwHjTOkyis6npMucGzFo9vy9CdVJRMV2PHz0w3wMhc=;
        b=JfbSkB0Q47x8ZsPt4CjLAjydDCRjDroXrpxAtksS23bxv3QJhV/n5oGwoPcDQI1YbX
         SW/yABjXq0ziFE0eVqm+dQi0dOnpAOWDl+IoV3fQu7nQBXfIkrW5L3UJv7nx6g36C4vH
         SUFbIpg8ZJIRkFQPCEHDTVOxT6jxFGTAYWT2rLebpvHkIDdL7TmEYznk4NWTvnhtlIm2
         xW9I5PDD01CLe/gszd1AlcQ9WqNzNSZ9e1hfwFc8F4oXSJOFyoL4O1srohvghNOE6fca
         +iAoWvIXuC7icnYD7TriznCh2TNnPGWFUjcgvfOX0q2EAXcjbYj9pDeTjqExKupzZdml
         ycRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dZwHjTOkyis6npMucGzFo9vy9CdVJRMV2PHz0w3wMhc=;
        b=l8zivqWCTd8raLX29zgmBJ+rokc4IiPEfQpTDraWQlFOtCMavOBT+QJzhJVInUGEec
         be7pz0l/D2kuihx6RuzlRFO9IAXAqMHXHq4Vc0igqRvL99D0j6rHFipPNv+ipsBhC5rx
         WulPmX58sYJdO+MMqWjLBlRu14T3NEYYzrfVtc9v3T39OFOjJqWSt831ljaR4Zzqg0HH
         RBygQgNJKi2uhL9g4s/6i6aEZhnzGjLRLhU1XtYNHX4+4y/Y85CRoxQgT5v0hVRj3hys
         /FG148nOl6HgZ5qsoQlbdeh6DfawG+2+u/525ZV/08pQH5h67+6mdT1Z0mpoRcLMQCxU
         d1jg==
X-Gm-Message-State: AOAM533glLlNI25p2MnE0JYl7BidTC3iQGC4lxBNf+klMkVS5/QXOuIk
        1jOJZgdAzJ9XLYm95/vbNJ4=
X-Google-Smtp-Source: ABdhPJxH3ewTjqZophl4JHz5wXNOs/hyaswtFq2p4PZKamAB4liGUhGEMQQExoM13HmGFNRMjYMX/w==
X-Received: by 2002:a17:906:b284:: with SMTP id q4mr2491699ejz.507.1612511874724;
        Thu, 04 Feb 2021 23:57:54 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q16sm3571134ejd.39.2021.02.04.23.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 23:57:54 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Add missing APIs to libtracecmd main man page
Date:   Fri,  5 Feb 2021 09:57:52 +0200
Message-Id: <20210205075752.1283926-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

These APIs were not listed in the main man page of tracecmd library:
  tracecmd_open()
  tracecmd_open_fd()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracecmd/libtracecmd.3.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/libtracecmd/libtracecmd.3.txt b/Documentation/libtracecmd/libtracecmd.3.txt
index 14dfeb8d..7431c2ce 100644
--- a/Documentation/libtracecmd/libtracecmd.3.txt
+++ b/Documentation/libtracecmd/libtracecmd.3.txt
@@ -12,6 +12,8 @@ SYNOPSIS
 *#include <trace-cmd.h>*
 
 Open and close trace file:
+	struct tracecmd_input pass:[*]*tracecmd_open*(const char pass:[*]_file_, int _flags_);
+	struct tracecmd_input pass:[*]*tracecmd_open_fd*(int _fd_, int _flags_);
 	struct tracecmd_input pass:[*]*tracecmd_open_head*(const char pass:[*]_file_, int _flags_);
 	void *tracecmd_close*(struct tracecmd_input pass:[*]_handle_);
 
-- 
2.29.2

