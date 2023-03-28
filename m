Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBBFC761AF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Mar 2023 15:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbjC1PEg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Mar 2023 11:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbjC1PEg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Mar 2023 11:04:36 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717B6DBF2
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 08:03:19 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id ek18so50999846edb.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 08:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680015792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wzYybfXXAZ5J1gON+2zGMGIU9NemBBzTFdv7qTXZpWw=;
        b=bCVAQvTITB5j0L93C2r04bW2tAxX952+NVaaf4YignisyiS7tJ7XCvZPbXoCOSs5la
         CSzbBLdOEvZkzh03FeEi+thpYwbLw0EPkslma2jpyMhFYnmcrnjEUAX34cPDJTodjvnX
         cJeYc7piMNqOkPZ0imYXC46S965/n6YiSzINGD+CfUZXH9px7LGMLkUuEqIo/VBPE0cW
         cyuphDKzHvsWvJup/8SUs93Z6PAzu4qZOA3ONQZS/XX7s10FjtZPvEZ/IW2WBcIKkd8o
         /AzK6s6BcYtgyoEp36r5O6CXMyS6wUQcGjsgkh1pubD9WpDU91DqTkkj+ZvqhOr00t5a
         nsjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680015792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wzYybfXXAZ5J1gON+2zGMGIU9NemBBzTFdv7qTXZpWw=;
        b=uoMfNgxcl5ZxuJEbbMktX8NLlNxLjTsT+rM/di1dNJ885dZJRfuFS+P2ImG2KdkqHs
         dJBrch3M40Tu23tTZyxCTd8btFUh4tFc992f6qdIiaRpehkjZxSUx1XBinKNcOi3m6yE
         oPyGhKyH4M+pYNdeosiqCAyLU9k5v4DWzJl5sAeyq39IVm3VGzhyafP9waTUCPIhGb7T
         c9sew7GnaPQHyWYdLAkhPw0PWhffQG6sryX1rHfiBSjiuLeqpkNtqOJGzG/TH7Gk5AcL
         9G4XFlI/CjR4u4DhuTfoika6udcwhuLRw/uVi0DeOY4IQr6knyWGy8csyOuBb68G5vJn
         Figw==
X-Gm-Message-State: AAQBX9frVpKix0S3NJCAvdR4z+0SHrExWviOumrf0Qex8XhX8C4Mp/PA
        hzkoI5u04kAMGQvjvcfA/sHbO6d2DqA=
X-Google-Smtp-Source: AKy350bk59kvRgMmzwS/o7kgvl6P+fJZEOobALPcRmKiIR5u7VS7rohuJ2MKaXDaUCROri/L0MDUMQ==
X-Received: by 2002:a17:906:3607:b0:92d:44ca:1137 with SMTP id q7-20020a170906360700b0092d44ca1137mr16760447ejb.43.1680015792457;
        Tue, 28 Mar 2023 08:03:12 -0700 (PDT)
Received: from oberon.zico.biz (77-85-190-39.ip.btc-net.bg. [77.85.190.39])
        by smtp.gmail.com with ESMTPSA id c16-20020a170906925000b009327f9a397csm14799009ejx.145.2023.03.28.08.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 08:03:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] libtracefs: Documentation for tracefs_instance_reset()
Date:   Tue, 28 Mar 2023 18:03:07 +0300
Message-Id: <20230328150308.34783-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230328150308.34783-1-tz.stoyanov@gmail.com>
References: <20230328150308.34783-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The newly introduced API tracefs_instance_reset() should be described in
the tracefs man pages.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-instances-manage.txt | 7 +++++--
 Documentation/libtracefs.txt                  | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-instances-manage.txt b/Documentation/libtracefs-instances-manage.txt
index c03a272..1e0735e 100644
--- a/Documentation/libtracefs-instances-manage.txt
+++ b/Documentation/libtracefs-instances-manage.txt
@@ -4,7 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_instance_create, tracefs_instance_destroy, tracefs_instance_alloc, tracefs_instance_free,
-tracefs_instance_is_new, tracefs_instances - Manage trace instances.
+tracefs_instance_is_new, tracefs_instances, tracefs_instance_reset - Manage trace instances.
 
 SYNOPSIS
 --------
@@ -18,6 +18,7 @@ struct tracefs_instance pass:[*]*tracefs_instance_alloc*(const char pass:[*]_tra
 void *tracefs_instance_free*(struct tracefs_instance pass:[*]_instance_);
 bool *tracefs_instance_is_new*(struct tracefs_instance pass:[*]_instance_);
 char pass:[**]*tracefs_instances*(const char pass:[*]_regex_);
+void *tracefs_instance_reset*(struct tracefs_instance pass:[*]_instance_);
 
 --
 
@@ -60,6 +61,8 @@ it will match all instances that exist. The returned list must be freed with
 *tracefs_list_free*(3). Note, if no instances are found an empty list is returned
 and that too needs to be free with *tracefs_list_free*(3).
 
+The *tracefs_instance_reset*() function resets the given _instance_ to its default state.
+
 RETURN VALUE
 ------------
 The *tracefs_instance_create()* and *tracefs_instance_alloc()* functions return a pointer to
@@ -106,7 +109,7 @@ struct tracefs_instance *inst = tracefs_instance_alloc(NULL, "bar");
 	}
 
 	...
-
+	tracefs_instance_reset(inst);
 	tracefs_instance_free(inst);
 --
 FILES
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index c3f448d..052e1c9 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -25,6 +25,7 @@ Trace instances:
 	struct tracefs_instance pass:[*]*tracefs_instance_alloc*(const char pass:[*]_tracing_dir_, const char pass:[*]_name_);
 	void *tracefs_instance_free*(struct tracefs_instance pass:[*]_instance_);
 	char pass:[**]*tracefs_instances*(const char pass:[*]_regex_);
+	void *tracefs_instance_reset*(struct tracefs_instance pass:[*]_instance_);
 	bool *tracefs_instance_is_new*(struct tracefs_instance pass:[*]_instance_);
 	bool *tracefs_file_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
 	bool *tracefs_dir_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
-- 
2.39.2

