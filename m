Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF3FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 14:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C8B660E90
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 14:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346920AbhIXO7I (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 10:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346908AbhIXO7I (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 10:59:08 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220A4C061571
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 07:57:35 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id x7so22455948edd.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 07:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GZ5F6axA23WOnePgOGfVtshpIF5Yiz/VNcPvfZH95Jk=;
        b=M4IIykX4LJS+3bffDUiLxz2CgRFwUVDNva0hl2cjcML9iiaqnMZl8T/AS/A6YpjH3p
         sHY6uZQgjNGASLXGwFtC6TBgHE/iaiLN7oP8IJ8aIMOFk7xp5eTi1A43iv0ONqQgzPhk
         Io8W1Kul9KJs5G7LRCUw8EH5S9wWebUyprCFukEvhOTCVu7RTR9bOcFWtwfKVwSJOu+f
         U6Qqji0xLQipDc/68aR75SfHa5dofAoj7K4PTU+8EJiy2rj+CjjGHr6fxwKTDV7zkF/d
         5tcRS+mlk90bTj4zXacOfvv3g3r4WX1APLZjGig7ICj6ZtNfgp6LGWPHt69NumPBYM3t
         srTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GZ5F6axA23WOnePgOGfVtshpIF5Yiz/VNcPvfZH95Jk=;
        b=Uf7LSAWjNiAcWfNHAo/L6mhi+I0Hu4FExU4asGWPApd6eXUOzeQkissLLxv3vYzBkz
         zy0rV5dsexsXl1AXS2+6twvnzpN7jnzsLo3xnHl3ks99mn0O6LMwdxj3pwj9p25ND2Dt
         MJDYBIzvw+Z5yqmwYX8/JDVjJKMYRxbjrXkSyfR9cNbqzDyAqK/nTr/XpVLpGenb0FOU
         SkzZE3oPHFxuVtl8ssykcJ7yXdoZ29SJ+AsxhKnSOjq2evcel/jXzz1NaRRkmRZGRrC7
         mnJEVdPKQFdaeAuJbUbWJ18KlO49PE8fVo2+H364+Pdkvq4dYHlp3/cmPD4VehDc0tv4
         snbg==
X-Gm-Message-State: AOAM530NxmSUV+fZqVBcWwwjq8cP9PljYcDwYVkfIsL3bowLZUuoT+Hx
        GOceLE/rUzrLlo4wUjIHQDM=
X-Google-Smtp-Source: ABdhPJyImXmCLAvcoQeTU/H/lxhq7FzcWhKILj26U/bmNmkPbRGRRT82Yx16kutzuvnwCpW/tUbnkA==
X-Received: by 2002:aa7:c952:: with SMTP id h18mr5531179edt.18.1632495451927;
        Fri, 24 Sep 2021 07:57:31 -0700 (PDT)
Received: from crow.. ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id r26sm5219602ejd.85.2021.09.24.07.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 07:57:31 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2] libtracefs: Fix code indentation
Date:   Fri, 24 Sep 2021 17:57:20 +0300
Message-Id: <20210924145720.164830-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a code style fix. No functional changes are introduced.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---

I am re-sending this patch because the Tzvetomir reported problems
applying the previous version.

 include/tracefs.h  |  3 +--
 src/tracefs-hist.c | 12 ++++++------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 25abbdc..9d84777 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -309,8 +309,7 @@ enum tracefs_compare {
 	TRACEFS_COMPARE_AND,
 };
 
-void tracefs_hist_free
-(struct tracefs_hist *hist);
+void tracefs_hist_free(struct tracefs_hist *hist);
 struct tracefs_hist *
 tracefs_hist_alloc(struct tep_handle *tep,
 		   const char *system, const char *event,
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 003715f..eeb8374 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -206,8 +206,8 @@ void tracefs_hist_free(struct tracefs_hist *hist)
  */
 struct tracefs_hist *
 tracefs_hist_alloc(struct tep_handle *tep,
-			const char *system, const char *event_name,
-			const char *key, enum tracefs_hist_key_type type)
+		   const char *system, const char *event_name,
+		   const char *key, enum tracefs_hist_key_type type)
 {
 	struct tep_event *event;
 	struct tracefs_hist *hist;
@@ -366,10 +366,10 @@ add_sort_key(struct tracefs_hist *hist, const char *sort_key, char **list)
 
 	if (!key_list[i]) {
 		for (i = 0; val_list[i]; i++) {
-		if (strcmp(val_list[i], sort_key) == 0)
-			break;
-		if (!val_list[i])
-			return NULL;
+			if (strcmp(val_list[i], sort_key) == 0)
+				break;
+			if (!val_list[i])
+				return NULL;
 		}
 	}
 
-- 
2.30.2

