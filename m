Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D37C49361
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 180AA61370
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhFNHxA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbhFNHxA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:00 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE085C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:42 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id k7so15031934ejv.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k3qTP15/KW1GvymOMvtOciY6oQlool890KwlGyG99eE=;
        b=U7H7LeN/p12pXhVhOKgXIX8erBu6M5o2ezNkPK1VwqNZu0Jf2QqgFJVHh+UEFzgEvD
         w9l+R5l7/7TOo+hRct+nJDDNcBeax8rDqvmo3iEoNArg2uiS+mVQWhgmypFZXssZRF1v
         iqLJCN5NDXQOcoz0Ir1aewy+zLczJxpqLryZXlzuqs0PokegmeyrivuaaWAUyHf3ZMA9
         H5bEqbugfjz7QoPvMJN6/EW9avU0fkmfNRIp685tRHIfF/oZ5d90PiNN+m1OSDRJEVsK
         whVD8LyJ6J9HygsqDWMDJrf7D3uGERgD7V8L1oduwEWBlNyWBYThciUA3WfAEUFylNuv
         wepg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k3qTP15/KW1GvymOMvtOciY6oQlool890KwlGyG99eE=;
        b=iKEnN48rZ++SPndBrg6c7e/LMSUXZ7UX/jhtBtXG6HWu1JQpqTPwGyK8UlAYo8HM5F
         oTCugW2wac56n2m5s8W/mENcTuU114qY0/ahGZ/LAdMNtUyxwrYQ69DZBy4w8ops0PPq
         IBuO12B2Lmi1fDCjo/Qnr5Xv3yVUO7CZboNE5jlKGjBexX0XSncjlpx4vXg4tFZ2zbJ8
         6gcP2RnAcEgBtu9Rcs0oZD1YdaYNfHCUZtXIQWVlAe9KRr4p5SYcSTra6LllGHpqHGbQ
         VZ9/RvX388RhWS2Tsl7Plr40s4e6iGyGJR5+ogkDiJJkJRvvGNTc74VqDVBNjlRoRSop
         5E7w==
X-Gm-Message-State: AOAM533yNJUq15TQH7kVfG+DV/9n4O+rNIxX5Fk4jWZo8xgzfPvZBknN
        bWgXpeiXzzpc15z5z1bynko=
X-Google-Smtp-Source: ABdhPJyxTNoYAXyIlpwV+OGz9gcKhrsuRx41Qsw37QnFq364UUm1JZdvb/GTyh3u7mH5VjpPbUEkgw==
X-Received: by 2002:a17:906:b2d1:: with SMTP id cf17mr14408920ejb.225.1623657040693;
        Mon, 14 Jun 2021 00:50:40 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:40 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 09/45] trace-cmd library: Bump the trace file version to 7
Date:   Mon, 14 Jun 2021 10:49:53 +0300
Message-Id: <20210614075029.598048-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Adding a compression of the trace.dat file will change its structure.
These changes are not backward compatible, the old trace-cmd binaries
will not be able to read compressed trace files. Bumping the version to
7 will prevent old trace-cmd to read such files.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index c6591e56..4d5d1455 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -15,7 +15,7 @@ void tracecmd_critical(const char *fmt, ...);
 void tracecmd_info(const char *fmt, ...);
 
 /* trace.dat file format version */
-#define FILE_VERSION 6
+#define FILE_VERSION 7
 
 #define _STR(x)	#x
 #define STR(x)	_STR(x)
-- 
2.31.1

