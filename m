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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 030DCC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E032E611CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhIJNtc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbhIJNtb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:31 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6781DC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:20 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id i6so2604778edu.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sbSV29F6hMmCzTMdZJrfrzNUd5KOIS4lhaTklr8yKGw=;
        b=Pe9gqQIRLBp15LdMumN9DCBSWprwFQb0FGdOoKoXTWgmtsv0C8Qev+OhUHW9HY/Q80
         aR+7VKj1LhXprIaP3wOFCd967Nx/VoCMXL0V+JJwzXIhXF1AiVGg/qthTz7g4+GIY1KJ
         i+hSnJk562TIFaX81Dv0iswgcZe2/Qwo+rpsQzc/0msPI2oZBajtfb8B8TYpeQNRn21l
         dbZo1dh1rsnL8sIFK1KiQYVWvIa7tRKn8KoTDwaxblSkCVp/wl4IOw+45PS4tvsWsWLX
         4lBIqboqeG+X9g1pfDfkNLKYY1H0Flu2odqZIOzmybKk2BftbBX8iji3ukZPc4tNua7o
         V/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sbSV29F6hMmCzTMdZJrfrzNUd5KOIS4lhaTklr8yKGw=;
        b=hZmpvE/h8iTWLE57bzBo7eyKhlkhVOSUhn992UiWUGDBo/b4coVjCKGYzXYCcGsDYh
         She5M2N77bC/M7jLjhagU2Vxltt3zUfKXNevLL1V0coB5Rdf6WOTJiVuS7o4BHkV5S3x
         BvjkE+zhblzHhIZpCkJrRgx6XHepEVNfjj7mulv00tjBgX7tMk2jMq8/cqUOjhZtfo4W
         A+RQdEwFb2bwqzTEmfu7mfkChSYLWEvHyQWPmmPtzsuj1LzHg9PpjSCyE2r1Q9zG99i1
         ec3+rEz7odCcVrDAP1UqvnVrRoA1KRkDTyfAnGQIE9VwrMsCksrQvuu6J1wDspm7fu1n
         gnYg==
X-Gm-Message-State: AOAM532zfngvzid/8xIq3rqOTsQflPrpFPNjiWOPLtqohe9LtIQnmIiD
        NdbYIBzVXp+WY3G1OyVEEwEkJhWbuoI=
X-Google-Smtp-Source: ABdhPJzO0COAAzRqV/Ugo20p0oeEo39pNJvJcViL9yAT9dHZKSvpYVMjyHAe4cyuGLindbLL2TkYsQ==
X-Received: by 2002:aa7:d7c8:: with SMTP id e8mr2491751eds.381.1631281699045;
        Fri, 10 Sep 2021 06:48:19 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 18/21] trace-cmd library: Set correct CPU to the record, retrieved with tracecmd_peek_data
Date:   Fri, 10 Sep 2021 16:47:54 +0300
Message-Id: <20210910134757.2863982-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This clean up is needed for the design of the next version of the trace
file, where only CPUs with trace data are stored in the file - empty CPUs
are omitted. Changed tracecmd_peek_data() to use the CPU id, instead of
the CPU index.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 48f6bbd8..48931f2c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2019,7 +2019,7 @@ read_again:
 
 	record->ts = handle->cpu_data[cpu].timestamp;
 	record->size = kbuffer_event_size(kbuf);
-	record->cpu = cpu;
+	record->cpu = handle->cpu_data[cpu].cpu;
 	record->data = data;
 	record->offset = handle->cpu_data[cpu].offset + index;
 	record->missed_events = kbuffer_missed_events(kbuf);
-- 
2.31.1

