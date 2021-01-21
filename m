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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D06C433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 10:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5F5123602
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 10:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbhAUKhg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 05:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729648AbhAUKgv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 05:36:51 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC514C0613ED
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Jan 2021 02:36:10 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id m4so1199378wrx.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Jan 2021 02:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6q1vqmMd2aw0ijuJYtA6/wtk/4CvIcSgnR1uzdgbudg=;
        b=hZW49DkLEx7+qo7T2bHNYZsJM7r0ozoYURFesU7mq6wDaO9LHc+GJJ+0+Pyc8z3ThO
         lI3KgoIP0r/JkZPg1PmccMsA4imXSGaCvJ7IuUJ+bIKdksEoKJNc8d6/o4WwRH6ptMmN
         XkELYgtQLD9vI6rUrNidGwPURK/GMWD3kxdrx2hIbJ79UlxI8eAeBc6s+sSYUW0jD5uz
         Mnjjyqa4k6oELVTUQp0+R6TNkwdvVAP3181I5sJQv7FK6nyv18Gd1jtBLvyaQ80WAngu
         7ZP2oTWI5JR9/kIhTpm6zwZoZ7h1MQ5QfPHfms8V/oAcqScdqEvuNOG0KtrdnpMBI8Qf
         aWYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6q1vqmMd2aw0ijuJYtA6/wtk/4CvIcSgnR1uzdgbudg=;
        b=SsvXCOkXRrs1Xb9J+JytQkbTX/EcAe4/RPIUM9WfI/HPGtnDtGUkP+gkMLlbk/tKbf
         0XL0+WQaIU9+HOIZVRgsTq9B72b/mGo4WrkPZ7Ooz8ROEQr/cup17QhGT870pDfVaFbw
         riIb5+0Yv26VjwupNcHGdEht0rxdTdBlqTA01k9zP4Cy6FEqpexCplCwRanUNMHDB192
         7mvvpPlrHMU/26a9C8FM39c5p64DlRMY3CtWU90IV2//dU2hALXeGoDDzAjoqsj2+b0f
         Omdaju6Sz8misalP48yTqeywYoEY2Etuih/IeeHN47g/bINDjEcUzndEKtRvvNslE3qO
         YMdQ==
X-Gm-Message-State: AOAM5329nP5O5L8qi5hq8D7DnSY4z/fn022ae3sYamOPaWTO6UIZSG+3
        Ons4uNushHF9+nApKZ8Blg0=
X-Google-Smtp-Source: ABdhPJyOMdQPfnHnDmFBhLe0VD9/kLuwJ+MBN468C1jHfkRwNKqaawwuFp2jhwM+xCbtK2v+V5YmHA==
X-Received: by 2002:adf:d206:: with SMTP id j6mr5997636wrh.427.1611225369660;
        Thu, 21 Jan 2021 02:36:09 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l18sm7294123wme.37.2021.01.21.02.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 02:36:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/4] trace-cmd: Remove tracecmd_unpair_peer() from internal header
Date:   Thu, 21 Jan 2021 12:36:03 +0200
Message-Id: <20210121103605.224108-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121103605.224108-1-tz.stoyanov@gmail.com>
References: <20210121103605.224108-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracecmd_unpair_peer() is an official API of trace-cmd library,
declared in trace-cmd.h. The declaration should not be duplicated in
trace-cmd internal header.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 22e20b66..012ddba8 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -143,7 +143,6 @@ typedef void (*tracecmd_handle_init_func)(struct tracecmd_input *handle,
 
 struct tracecmd_input *tracecmd_alloc(const char *file);
 struct tracecmd_input *tracecmd_alloc_fd(int fd);
-void tracecmd_unpair_peer(struct tracecmd_input *handle);
 void tracecmd_ref(struct tracecmd_input *handle);
 int tracecmd_read_headers(struct tracecmd_input *handle);
 int tracecmd_get_parsing_failures(struct tracecmd_input *handle);
-- 
2.29.2

