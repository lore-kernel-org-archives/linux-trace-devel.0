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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F31C43460
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 14:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64B74613B5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 14:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241301AbhDEOVc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 10:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241296AbhDEOVb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 10:21:31 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C6CC061756
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 07:21:25 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id k8so5316345edn.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 07:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uSnuq4D62Yc0ec11b4yKBS0jyRnEZHthUr23YIc0H1c=;
        b=ZmWIijB22JoGEcg/Jz2hKxDZw5FZro1coWSxdoysuBRT8xTmeOMekgkZFuqeUgki3Q
         9eUMjN4a0RP81wuPax9F2ReKL9dWyyRCKlf+P4Rk2yUlvunSDYmYC1jorcBhpz3WgRuR
         8alGC4nLH1Z2CfMHfvs9i4QPjz7vnphhFlPt64V2vwIAbR7M1Yoe2qtP4DaCc1qfZcT5
         a9uwQOsJyTLjfmLH+g/U2RPm4x6tldRC/BFCksVKLsW/fkF3GG6g44YLoa9yvoECIB0B
         FE1NPE4PM6Fwl153/69Vlj0kmJQpOjfWH/o7roG50o5KSDYJeJwsEQh2lpr79i9O4DGe
         4UTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uSnuq4D62Yc0ec11b4yKBS0jyRnEZHthUr23YIc0H1c=;
        b=AG2utnJcP/N4AvkZKO2lLX1XxmJGb/nGK8E3JQMO8HIJFgwG/v7plBlVPuwCrSSYbf
         5oyOzk32YL0PClEWXeiTIMycpSiGbLqWdYtDTJnyQBBX0y7LOn0S3lAl60ZZF8e5gT/6
         w41K9HxCMDeEtvcIsv2rVuRIBqURZCkF3aSQstcDHvXcP/CK8zHy7rKvN4TJlxfyK1C2
         BWX6HsFT5lF2SaihdrgfVcfM/GXsFIuelSaJQDkrJ8CisDqG5VQyNoz8oy5vnkCmcAB5
         +6PqrE/hKM+7CaKjwweu4Nkm7PwugTuYM1pb3uXEyQLqYX5ZxqDizWit3dp0kSaLsYJn
         kvFw==
X-Gm-Message-State: AOAM532myKGaI+okoafUlg8qAt1ppbx3tyE6LcFjtZpW3Mppk0Vut0nk
        TuWH1nlYLJpDCKWavhBNgLs=
X-Google-Smtp-Source: ABdhPJzJddzVuxUmtsoI1Fy3pWJ8Qyhm3mbrg+Swj0dTGjPPi0d2h0GglGLOXPjKJMz8OZgH6+h3vw==
X-Received: by 2002:aa7:da97:: with SMTP id q23mr31068855eds.180.1617632484381;
        Mon, 05 Apr 2021 07:21:24 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id e5sm3156972edr.64.2021.04.05.07.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 07:21:24 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/5] libtracefs: Encapsulate "struct tracefs_options_mask"
Date:   Mon,  5 Apr 2021 17:21:05 +0300
Message-Id: <20210405142107.507711-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210405142107.507711-1-y.karadz@gmail.com>
References: <20210405142107.507711-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The definition of the mask gets hidden from the user. This way we will
be able to modify this definition in the future, without breaking the
API. Such a modification will be compulsory, if too many new tracing
options are added in the future. Note that encapsulating the mask
definition, requires two API methods to be eliminated, however those
methods have no particular use-cases for the moment.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs-local.h |  4 ++++
 include/tracefs.h       |  6 +-----
 src/tracefs-tools.c     | 31 ++++++++-----------------------
 3 files changed, 13 insertions(+), 28 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 187870e..0a746f2 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -33,4 +33,8 @@ char *trace_find_tracing_dir(void);
 #define DEFFILEMODE (S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH) /* 0666*/
 #endif
 
+struct tracefs_options_mask {
+	unsigned long long	mask;
+};
+
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/include/tracefs.h b/include/tracefs.h
index 5c4e50d..0665e8d 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -131,11 +131,7 @@ enum tracefs_option_id {
 };
 #define TRACEFS_OPTION_MAX (TRACEFS_OPTION_VERBOSE + 1)
 
-struct tracefs_options_mask {
-	unsigned long long	mask;
-};
-void tracefs_option_set(struct tracefs_options_mask *options, enum tracefs_option_id id);
-void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_option_id id);
+struct tracefs_options_mask;
 bool tracefs_option_is_set(struct tracefs_options_mask *options,
 			   enum tracefs_option_id id);
 struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 3b5f773..a932216 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -197,6 +197,13 @@ enum tracefs_option_id tracefs_option_id(const char *name)
 	return TRACEFS_OPTION_INVALID;
 }
 
+static void trace_option_set(struct tracefs_options_mask *options,
+			     enum tracefs_option_id id)
+{
+	if (options && id > TRACEFS_OPTION_INVALID)
+		options->mask |= (1ULL << (id - 1));
+}
+
 static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *instance,
 						      bool enabled)
 {
@@ -229,7 +236,7 @@ static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *i
 		}
 		id = tracefs_option_id(dent->d_name);
 		if (id != TRACEFS_OPTION_INVALID)
-			tracefs_option_set(bitmask, id);
+			trace_option_set(bitmask, id);
 	}
 	closedir(dir);
 	tracefs_put_tracing_file(dname);
@@ -366,25 +373,3 @@ bool tracefs_option_is_set(struct tracefs_options_mask *options,
 		return options->mask & (1ULL << (id - 1));
 	return false;
 }
-
-/**
- * tracefs_option_set - Set option in options bitmask
- * @options: Pointer to a bitmask with options
- * @id: trace option id
- */
-void tracefs_option_set(struct tracefs_options_mask *options, enum tracefs_option_id id)
-{
-	if (options && id > TRACEFS_OPTION_INVALID)
-		options->mask |= (1ULL << (id - 1));
-}
-
-/**
- * tracefs_option_clear - Clear option from options bitmask
- * @options: Pointer to a bitmask with options
- * @id: trace option id
- */
-void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_option_id id)
-{
-	if (options && id > TRACEFS_OPTION_INVALID)
-		options->mask &= ~(1ULL << (id - 1));
-}
-- 
2.27.0

