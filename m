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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF39C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 13:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1C9D61105
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 13:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbhDBNUG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 09:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhDBNUF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 09:20:05 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC07C0613E6
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Apr 2021 06:20:04 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a7so7425499ejs.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Apr 2021 06:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i2bpfUmF+YwnlreGA7yi828PWj2M/BNGHaLXVcBvWW4=;
        b=REF/nlwNwfIZXeL6rbJwNkdlxtJ8LQYFZ7N3ii6BjQiDnnDL4Zyu84DEUJB7+NwOdv
         EgNtzS9pYF5F6Z5zSf0L+NDGrMUJtHdRa5QkdJrEf6SuBXdTgK1qw7MpNpYTvEeVKgxj
         cx3p4yd4uaM3O9UiHoyBFo/WSDhzRZ3Mf6N1+ML0zv/JBVHGxrdcmvqmcg9KS0cI5QX+
         jQIzUA67rc1ukDU0kpOBh0BCJrL3wwxgp+dZ4w9dtlFa3SLLKtLW6fuEX3LpugwwTuY5
         Zr2MoX4zQmN0/xSOgJE9YSHoLT6RFdLGaNjjD9ila2YcKNOBUftr7Y5jE4MEf0oTnj3P
         rcYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i2bpfUmF+YwnlreGA7yi828PWj2M/BNGHaLXVcBvWW4=;
        b=PPrdc+AXDX4lsGr1yMxXQ1CAEsrXv2jfi4+gB2hqvuHXQ0WmH/11gNruOxb+ncAOLQ
         3sfMiMd0++D7QEk2I5Mnz/WQlgopx8xwcAPZP/2t9VSA0+LusxeSwcx9QSKw23q35gqt
         bTZiqxnmxbdkZve95cH3KTnhkomCPRfJL3QC2Hi5T0y9+63f66Tl0U7l9lS5MhN52m2P
         WBC+a20xyIv1tcQmVb0bT37veBgZn5SNtn/j2fWn0QffhoD6vNPBx6ZTpJtOC+QnjzS7
         bb5X7M2Lbl0RxcuzeK68j0zMRScr59mRBUR7Jum00rglsiTCNefbwiEL1phWYaNH+xmn
         yU4w==
X-Gm-Message-State: AOAM531ZHVFS+MfxT7kheVT7bgqGxc6FatnmrPdXALC3HvWt+gSvinYH
        a9DztLQpwKRSEmQOxD6xM9Y=
X-Google-Smtp-Source: ABdhPJysBYzjTyUyim8oNEEtWwol3hgkzi9aZtrWnCeltrVbIND3ldRkmmE5Qj/92r0Ek0SLvr7nVg==
X-Received: by 2002:a17:906:94d6:: with SMTP id d22mr912713ejy.424.1617369603290;
        Fri, 02 Apr 2021 06:20:03 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id n3sm4120476ejj.113.2021.04.02.06.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 06:20:02 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/6] libtracefs: Modify the arguments of tracefs_option_is_set()
Date:   Fri,  2 Apr 2021 16:19:43 +0300
Message-Id: <20210402131947.346235-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210402131947.346235-1-y.karadz@gmail.com>
References: <20210402131947.346235-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This function is supposed to take as argument a mask returned by
"tracefs_options_get_supported()" or "tracefs_options_get_enabled()",
hence this argument must be a pointer.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h   | 4 ++--
 src/tracefs-tools.c | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index fbd7db5..5c4e50d 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -136,8 +136,8 @@ struct tracefs_options_mask {
 };
 void tracefs_option_set(struct tracefs_options_mask *options, enum tracefs_option_id id);
 void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_option_id id);
-bool tracefs_option_is_set(struct tracefs_options_mask options, enum tracefs_option_id id);
-
+bool tracefs_option_is_set(struct tracefs_options_mask *options,
+			   enum tracefs_option_id id);
 struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
 bool tracefs_option_is_supported(struct tracefs_instance *instance, enum tracefs_option_id id);
 struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance);
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 51a7971..3b5f773 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -359,10 +359,11 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
  * Returns true if an option with given id is set in the bitmask,
  * false if it is not set.
  */
-bool tracefs_option_is_set(struct tracefs_options_mask options, enum tracefs_option_id id)
+bool tracefs_option_is_set(struct tracefs_options_mask *options,
+			   enum tracefs_option_id id)
 {
 	if (id > TRACEFS_OPTION_INVALID)
-		return options.mask & (1ULL << (id - 1));
+		return options->mask & (1ULL << (id - 1));
 	return false;
 }
 
-- 
2.27.0

