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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B885C433C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DED961A13
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhCYGlk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhCYGlU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:20 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B69C06175F
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:20 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id c8so1078669wrq.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A4LvwnxyzRE/EtAFtpTGnD7SDW9+pNTORWFgylvctSQ=;
        b=GlDFFaFSRQ1NgoA2pG4JU38rhkFB8rILYihmfE4JIF93r75iLbQfGSG6bTsBa8d8zP
         jBonS2ptUyfKefpKokVAw9nkocBLAatRL7FpYaIcYMj4WHHMZLL73dK+pDQq7o2XBCXv
         tWpYGO2hdEcoC9jGxiOQ4xznmMVif0oKUdZvYEH3lyZvpKqLRakfbQXbiCtnRpK+zkJZ
         kJtWSp1KFJWzlUjyDojIiDIQJ2axBLvBlTEKla1F87B4aWB0lrUH3ToHiOn69qT8N5mn
         0+DEoJ6S1H0LsgA8GBtclYkOZOV1jbd9xWz+V52HW2IEZ+QccvOJXJxUz0bp98kvyZb2
         7YRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A4LvwnxyzRE/EtAFtpTGnD7SDW9+pNTORWFgylvctSQ=;
        b=SSyym+QxLEqHS/akXEm1FXTr7SKPu5enu2+M3FanQSuRiUVfjOIGotadR8bnktahqx
         Lzv+PM4DfL5T/W4lJUvT5ipX/ba+jYtg85PRNxII6lJGbc2u6mQ5F9gUfSU3frzCrWP4
         gEsoDaBkNSDM+cwEJviLt/7nBGyLF8WfjHryTxdMLF3Kwz1qb/NWDZi/nC3XqNX2vBMl
         PNi+I13YI8JH2JgBYxMNLBeeui1+Br4qTrrXXR7iTN6oiOMTwHbiOuZ8RrF7orLiWyUK
         syCS4LyrH2VG4YGFYHek5gF5HrRmfoDGIJSrQmPErmG5GqVGCobkuwcSeGr0G15FCdZk
         KRkA==
X-Gm-Message-State: AOAM532/3vaKnJ/LdMMpX0on98y8R+IA6OP9SmW9ORUIh/8ZYwndoM+9
        NPhZF4+3aTSWLnMUN9kDd/JGvRaq4bxuxQ==
X-Google-Smtp-Source: ABdhPJxdmanJyUKyPGqtFNQvUhMXgmj9bDZZ6svavawghkZPzRqskEYBL6PO1gjMloGOaXxKqAHuPA==
X-Received: by 2002:adf:dc4e:: with SMTP id m14mr7353862wrj.248.1616654479172;
        Wed, 24 Mar 2021 23:41:19 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 23/23] trace-cmd: Read at least 8 bytes trace-id option
Date:   Thu, 25 Mar 2021 08:40:55 +0200
Message-Id: <20210325064055.539554-24-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading the trace-id option from trace.dat file, check if the size
is at least 8 bytes. If the size is greater, use the first 8 bytes only
and ignore the rest. That way we can safely extend this option in the
future, without breaking the legacy logic.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 513f6cc3..c0b47345 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2703,7 +2703,7 @@ static int handle_options(struct tracecmd_input *handle)
 				trace_pid_map_load(handle, buf);
 			break;
 		case TRACECMD_OPTION_TRACEID:
-			if (size != 8)
+			if (size < 8)
 				break;
 			handle->trace_id = tep_read_number(handle->pevent,
 							   buf, 8);
-- 
2.30.2

