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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06039C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 13:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBD7461103
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 13:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbhDBNUJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 09:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbhDBNUJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 09:20:09 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E630FC0613E6
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Apr 2021 06:20:07 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id kt15so7389857ejb.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Apr 2021 06:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x8tIxns34gnz4fZ4JdmkZkTAeAO8lKWHxthoAShmqBw=;
        b=sdT6vodvyH1fx4lZbLZppr9nPuh5hTTBR2oCQDAUtMPZvXgENYfc2r1w4P9siKmovi
         4E/jVY8C8ezw+8W31siGhyGDPGSjmW0BC1okeQ6d1uthgqFW+w5guPTxRkbTD0ZkGtip
         dn+a1HXHuzEJAgwbT8jrz394jLl26/9W2uTlpEkS8WKu4mWfmXjgY+nXNmotNE9Ub57h
         BAEk0Ihyv+gowIehoY7u8hmqyfdCv44EqkKgkM7Pm6HJqz/7ZuK2QIG8r0mYDTdmj/lp
         u/9vn5Wd6c8JdG5fSf9jKFN5gsYg9QDkuZfWpLggZbQ3r2vOrCBp01qK/UoRwG3h6qhZ
         t0og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x8tIxns34gnz4fZ4JdmkZkTAeAO8lKWHxthoAShmqBw=;
        b=Xm5ewGX9MugPb5VMTtKHddg9rNXI6eN1mnlQxQEo7chSgcj6rpJYrYMNKRKnVUEm5b
         8TJxWtDeyce/3QRuPmgKd4YAM0mfdrIOD8WRKP/2INCwNUYZaUr/hQYIiUNeCvqeTJwL
         nuZXuFtLc7PG/VhQSbk7v2D6pk4ncV8x4P4qjAsyFrtpTDzk6Pkkv9TnMKs3axPjEGEI
         yzz2LxjC6cKqVUIG6+vn1vSHjKsDay2eUpNGtORQR2jbg+jqUM08FRArUa4Q4GUIHI5C
         saI6DCkqpmyMKMjotkCyFTDebzj9KzvC7O5wNTEzVxMjxdZHlNl/dElQdew9vNP6XcAj
         V+YA==
X-Gm-Message-State: AOAM530AkykvhC85UewfxtdksSGQmcLLwtJfk/ScSyefbs25U/HC4GPn
        FyZ+drRiIu0usY/gjbbHV3M=
X-Google-Smtp-Source: ABdhPJwKyStFQWTmpeQb5lFN0A00Xv5ggMFs4bS1TX7fm2Vd6DqiToHGS86Ibvvw5QSm6xPR9azrpw==
X-Received: by 2002:a17:906:4ada:: with SMTP id u26mr14038772ejt.129.1617369606702;
        Fri, 02 Apr 2021 06:20:06 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id n3sm4120476ejj.113.2021.04.02.06.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 06:20:06 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 6/6] libtracefs: Rename tracefs_option_is_set()
Date:   Fri,  2 Apr 2021 16:19:47 +0300
Message-Id: <20210402131947.346235-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210402131947.346235-1-y.karadz@gmail.com>
References: <20210402131947.346235-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The old name of the function is potentially confusing. Indeed
the function do not check anything about the option itself (is it
supported or is it enabled). The function only check if inside
the mask the bit that correspond to a given option is set.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h      | 4 ++--
 src/tracefs-instance.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 9efa91a..05d2edb 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -132,8 +132,8 @@ enum tracefs_option_id {
 #define TRACEFS_OPTION_MAX (TRACEFS_OPTION_VERBOSE + 1)
 
 struct tracefs_options_mask;
-bool tracefs_option_is_set(const struct tracefs_options_mask *options,
-			   enum tracefs_option_id id);
+bool tracefs_option_mask_is_set(const struct tracefs_options_mask *options,
+				enum tracefs_option_id id);
 const struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
 bool tracefs_option_is_supported(struct tracefs_instance *instance, enum tracefs_option_id id);
 const struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance);
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 9cb4b6d..f37b024 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -839,15 +839,15 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
 }
 
 /**
- * tracefs_option_is_set - Check if given option is set in the bitmask
+ * tracefs_option_mask_is_set - Check if given option is set in the bitmask
  * @options: Options bitmask
  * @id: trace option id
  *
  * Returns true if an option with given id is set in the bitmask,
  * false if it is not set.
  */
-bool tracefs_option_is_set(const struct tracefs_options_mask *options,
-			   enum tracefs_option_id id)
+bool tracefs_option_mask_is_set(const struct tracefs_options_mask *options,
+				enum tracefs_option_id id)
 {
 	if (id > TRACEFS_OPTION_INVALID)
 		return options->mask & (1ULL << (id - 1));
-- 
2.27.0

