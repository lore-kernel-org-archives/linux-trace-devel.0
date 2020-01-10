Return-Path: <SRS0=6mRI=27=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 432B6C282DD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Jan 2020 14:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05C612077C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Jan 2020 14:26:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nFxUOCPI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgAJO0K (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 09:26:10 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45368 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbgAJO0K (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 09:26:10 -0500
Received: by mail-lj1-f193.google.com with SMTP id j26so2300296ljc.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Jan 2020 06:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9fZQguXMCxmbQlI3DmBb1GPG0r68/54q9gWH/D8Fw/M=;
        b=nFxUOCPI4NlmE6CgWFsqf3D5xi8gV2V/i2GQn3p+r9Z8fN9UpIFgLSCrrF35iV/fNj
         j0HfV6A7+01ogU28SA/Q8PNf8ZlR4/m00zIqpbBp2BEtt8/GpmJ+tgAtdIaDltiGiNDy
         evhbcHmLfRxBskKFS7Oj8tlg5n8GqbNGkdWq8PWL7hJBK0lNloV/mecYaahndENsMJja
         O6H+RUQrIvwmxVGGcKs4rQDdhz1x4z7bUGG1E9gyoqapWODj6KiBWPI3PUuaTF6AgjVO
         NfuhtK527X1waSAyBdgeFtXnhZXnGHTf85Zm9EzjKzT7U0CZ/qLDUnUyVct9NcXsaMB/
         nPcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9fZQguXMCxmbQlI3DmBb1GPG0r68/54q9gWH/D8Fw/M=;
        b=oUrdImbYod0pag/7yJHikftWX2x+JTLkafDPBrlNH86oPklTKStTvYe1YMGrMG0/XA
         oJxcNKCHucCSSph8vNGvluY4KwOyKaYuy4qPY0TnXPP4YnWNu5wX+sogbi9iiXmBi0MD
         T6HacYfde6PyQwgvBzPO0t3tbr5Xf/6vjj4IxI4Fs3mCc3banRbdYb51miuK2W83VMNb
         AXjTF+GwPG5BgMkp2FADF1IfYQG9lGdkdjSj8oaTis7yQ1Iwr5fIIhrxENoTcMQbJ0Ic
         SfvnLPPL6/JndDd5t3rV+cJEwZslOxhG8BVWowThrV02FumIM9bc2BO59dnpwmvNB5HS
         z6Pg==
X-Gm-Message-State: APjAAAUl6sDhBBrUUoVKDhzkItHEgqfZQzlub923kqBcMeC88GW61fPx
        wPiT9WByPEtf0VF0Zh5/ET1mvFqXLyE=
X-Google-Smtp-Source: APXvYqxGqkucKC+oQm/LKYvrUNzK5/VrfaO8fnbP4Awvs7oQHBJ3bi7IOp8hATf/1gUFO9tKYQQiLA==
X-Received: by 2002:a2e:b0c9:: with SMTP id g9mr2848037ljl.134.1578666368481;
        Fri, 10 Jan 2020 06:26:08 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id z11sm1078991ljc.97.2020.01.10.06.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 06:26:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Remove duplicated "list" command entry
Date:   Fri, 10 Jan 2020 16:26:05 +0200
Message-Id: <20200110142605.322787-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Remove a leftover in trace-cmd command array, the
"list" entry was duplicated by mistake.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-cmd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 4e670f1..dbfcc97 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -101,7 +101,6 @@ struct command commands[] = {
 	{"options", trace_option},
 	{"show", trace_show},
 	{"list", trace_list},
-	{"list", trace_list},
 	{"help", trace_usage},
 	{"dump", trace_dump},
 	{"-h", trace_usage},
-- 
2.24.1

