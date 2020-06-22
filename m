Return-Path: <SRS0=YrCp=AD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CDBC433E1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 07:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04B0B2075A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 07:46:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cZxejwnF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731441AbgFVHqA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 03:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731439AbgFVHqA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 03:46:00 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22690C061794
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 00:46:00 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id w6so5669802ejq.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 00:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gaAEJa9PObyNdvPmZn8p8xpie+k4sfXlnpCQwB95P2Y=;
        b=cZxejwnFg19N0xn6zdu9ufXFsZWFqT445wl96aSexyDYGi0p4zcTZxxzmdV9Aly4HE
         eonZyUUGhSa+i/bKAdR9euHbHgzU8spO0aulnBnEZz339rMvknJm26WllQSdU2Huil1Y
         rURJxC1xq9AfgjQktBF9r0BY5bH6Q4wX9/Q2vsewH/WxS4fu1jdXD0CwWejjMIOU4MdZ
         jQ0M/Kh0fzlWTbPy2CEsEL7veGY7EdKa0dYhlnPR6CKWzFtdDua0AX2THfpIwXYOhaBB
         DrrcREZ8/bCk/UCxbmw8lO9U31fybzAJa+tcpBd34Dt1JyFv7sTO0v7J2QwATIyST5F0
         zulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gaAEJa9PObyNdvPmZn8p8xpie+k4sfXlnpCQwB95P2Y=;
        b=CbyAZsBotXNywqbHIC22DgfrC3ZnfOQPWtQz1OoC2nyX8ELkCV/idho8Rhxj1beZB2
         RNA3CEDM82EexKn4PSSsxxXUa205NsQfmU0xpEEYGuTA0V7ToSyHEqeag4rUC+khZWwr
         I8Kp1bVT/vjS1yxlx/moYht/XdEJXlIuyqS77bF+9LX/V6kNHJur66a6Q1OUqter3DmS
         FwGYU3CH8/YRF0HHqn8lXJrjziimSSdysKNRtQtXy4YHOmDGdlP7coAuEhenvVOWHinq
         382nua4FS8FDFJeUk36oxMJu6w7DQMndNUKgXZx9C357+Uy2C8F8+UlFEg39TaoYGUKF
         bqcQ==
X-Gm-Message-State: AOAM533bQJtZ4675R2y5Jadkc/NMbrYKH4JtY1gCD7wzAHBzY9Pg+fBW
        VKznQz8WRBcqeSikUtUNmLc=
X-Google-Smtp-Source: ABdhPJzLTYgsFaUMLh97tbwSn7M9FkX+xItBxKpSNg7Rqpq8bSh7IwstVocrNt12TAslBjrVPw6cmQ==
X-Received: by 2002:a17:906:5e05:: with SMTP id n5mr14413596eju.278.1592811958860;
        Mon, 22 Jun 2020 00:45:58 -0700 (PDT)
Received: from localhost.localdomain ([151.251.241.148])
        by smtp.gmail.com with ESMTPSA id k23sm11094048ejo.120.2020.06.22.00.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 00:45:58 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/4] trace-cmd libtraceevent: Remove unneeded semicolon
Date:   Mon, 22 Jun 2020 10:45:51 +0300
Message-Id: <20200622074554.151747-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622074554.151747-1-tz.stoyanov@gmail.com>
References: <20200622074554.151747-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

Fixes coccicheck warning:

 tools/lib/traceevent/kbuffer-parse.c:441:2-3: Unneeded semicolon

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Link: http://lore.kernel.org/lkml/1588065121-71236-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 lib/traceevent/kbuffer-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/traceevent/kbuffer-parse.c b/lib/traceevent/kbuffer-parse.c
index b18dedc4..2c5f00a9 100644
--- a/lib/traceevent/kbuffer-parse.c
+++ b/lib/traceevent/kbuffer-parse.c
@@ -439,7 +439,7 @@ void *kbuffer_translate_data(int swap, void *data, unsigned int *size)
 	case KBUFFER_TYPE_TIME_EXTEND:
 	case KBUFFER_TYPE_TIME_STAMP:
 		return NULL;
-	};
+	}
 
 	*size = length;
 
-- 
2.26.2

