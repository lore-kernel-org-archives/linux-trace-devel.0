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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B1BC433C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 12:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E91C961582
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 12:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhCYM3e (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 08:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhCYM3V (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 08:29:21 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6E0C06175F
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 05:29:20 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id l4so2566508ejc.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 05:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ueUyM9Dk8CRUH9+ECJQNtCM3EhIQXbKhiTMYpEgrKrM=;
        b=KQlGsmz/SXwYWG11C5dZvV6Du/rjvJXDzTtcHc7IAS9KLyLAr23oJiqGpZKi8Ui/Vg
         dLDuDD/yZ3iOSL/uDQoYBGqB8D3POeTtSSwltoIQTBp7jCE0NkfbQvzr638KfGxQX2Cf
         V5ra4y+b3zcUJEngeEDUdLBFTHkFeS8XB90TlvvcRN7I4zOo4L6EFRk892/JxjNmPCaE
         oX6em6nuljSKPfkIOl97UCzhX5QbBduiqU257aDvIdwq66RwebuBAKP8ZPksGGEYuyKj
         QEGjG63ZkJjTqk/0OhMD/Ua1w7i5mAURA528yVNty3HgNX9UQQbpJwZ7aTuflIp5WJ6M
         bsgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ueUyM9Dk8CRUH9+ECJQNtCM3EhIQXbKhiTMYpEgrKrM=;
        b=RyuAifOUeuShCx6nQ2JTu94HMM9l8IfySJcEIX6S17ryKge5v1LMjVuOEet9QFQGsl
         H6zWlR2PvxZQNbKmN1DMjYRAAz0k+znmlNFI1xfmBXrI6Fdc4jAexhtyZEj+wF+mEXwq
         XZJ215JuoSJ6aySlF7Mc++o9KIpCKc6Hh4dpp8dXNJf9X1JCcRIMo1doyvFt/6tHxp3a
         paAuQiCMZ2tZjrBvm2yDq3bO5GK+d0ztccbkHqau0NqU33P8F2va/PrHuTE1i0b9BzFK
         fXsSXlXV6k7wTM328+XJDnQVaMMgraisQK7geJeFH8/YA/l31HA37FGSN7+P5+oCZR8e
         hS9g==
X-Gm-Message-State: AOAM533m0DrgxyQ1HsYOy9Zxrb1yd/lYe1DKjv+4kS5dLTSO9YX7ZQ68
        /OX4GI5+OX7HJtEcfq98fzk=
X-Google-Smtp-Source: ABdhPJyDm6JL68obiWUhA27z6bZdSSoq1MmK2pIWIj47gGbo8cWUQFxAgj69qCdDdyIYoRGD8JawCQ==
X-Received: by 2002:a17:906:f891:: with SMTP id lg17mr9192629ejb.69.1616675359319;
        Thu, 25 Mar 2021 05:29:19 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id ho11sm2262573ejc.112.2021.03.25.05.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 05:29:18 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2] libtracefs: Prefer using "const char *" arguments
Date:   Thu, 25 Mar 2021 14:29:06 +0200
Message-Id: <20210325122906.28109-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All functions should receive const string arguments, except in the
cases when the argument string itself needs to be modified.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h      | 4 ++--
 src/tracefs-instance.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index f3eec62..05bd0ef 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -42,8 +42,8 @@ int tracefs_instance_file_open(struct tracefs_instance *instance,
 int tracefs_instances_walk(int (*callback)(const char *, void *), void *context);
 
 bool tracefs_instance_exists(const char *name);
-bool tracefs_file_exists(struct tracefs_instance *instance, char *name);
-bool tracefs_dir_exists(struct tracefs_instance *instance, char *name);
+bool tracefs_file_exists(struct tracefs_instance *instance, const char *name);
+bool tracefs_dir_exists(struct tracefs_instance *instance, const char *name);
 
 int tracefs_trace_is_on(struct tracefs_instance *instance);
 int tracefs_trace_on(struct tracefs_instance *instance);
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 0df4e13..0df313c 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -436,7 +436,7 @@ int tracefs_instance_file_open(struct tracefs_instance *instance,
 }
 
 static bool check_file_exists(struct tracefs_instance *instance,
-			     char *name, bool dir)
+			      const char *name, bool dir)
 {
 	char file[PATH_MAX];
 	struct stat st;
@@ -482,7 +482,7 @@ bool tracefs_instance_exists(const char *name)
  *
  * If a directory with the given name exists, false is returned.
  */
-bool tracefs_file_exists(struct tracefs_instance *instance, char *name)
+bool tracefs_file_exists(struct tracefs_instance *instance, const char *name)
 {
 	return check_file_exists(instance, name, false);
 }
@@ -494,7 +494,7 @@ bool tracefs_file_exists(struct tracefs_instance *instance, char *name)
  *
  * Returns true if the directory exists, false otherwise
  */
-bool tracefs_dir_exists(struct tracefs_instance *instance, char *name)
+bool tracefs_dir_exists(struct tracefs_instance *instance, const char *name)
 {
 	return check_file_exists(instance, name, true);
 }
-- 
2.27.0

