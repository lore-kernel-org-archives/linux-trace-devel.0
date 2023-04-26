Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88424C77B78
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Apr 2023 04:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239034AbjDZELd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Apr 2023 00:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjDZELc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Apr 2023 00:11:32 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8209910E6
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Apr 2023 21:11:30 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f1950f5628so52966515e9.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Apr 2023 21:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682482289; x=1685074289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wzYybfXXAZ5J1gON+2zGMGIU9NemBBzTFdv7qTXZpWw=;
        b=Tsc/GRPlgC6RlywaJNCX5ilYmGUFuRVWphr6VyR4hiEmxOzOMHDm8NRpYTNGnkBrFa
         qhGO2+D4t9Sfjwsm1j8fJTpRLJELfW7NNtDfXznbmDrzk/WLEY6NHikzY19q1jsjYj4I
         VSsJAHaH+APrbkgi1FcfLeJCxYLReYCsl8ZZES1TBkHflj70VQm5DR6Gn9egeXD4ElBx
         WMiMCSNOARrn2s+pKHEFOExuk9wpVxaRarJmSnk3XTw93DpMJrVgVVQtB4Uv+yAtuvOm
         HsT/MTyVAcUc5utT1gX13xMTaww7P1iT/hiHAHUW0uLu68biaRk9TizwmzvRpK5Zyp2i
         +RVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682482289; x=1685074289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wzYybfXXAZ5J1gON+2zGMGIU9NemBBzTFdv7qTXZpWw=;
        b=jFWAHvNXjlwwog4EJ1WMCRjRyPe8qk1ko9AWGbSFf46lPNpYM9zPyOi664h65nWMKA
         jBdlJKHK5jnpRiRRdvAAtAE72I771svMfjDXBQRvurzoKjJ4tTmhPBv3gM8D1T+fCXAe
         2d9jTYshQF4ebVC+W5M35lexKCjdheKcDR5W5oZ9OCXy22aNasZ3zuwoRIKduEgimlJ+
         hXRino76zkJBU2lKnqu+FVRO/9uy64iV+qpi59vzqVQhGUPSlhoX0nszEuufWPEWoL7V
         zA3wzfvr9Wiim+vWlzyMK1fMM10FDL5+H8Il33DbtUxzGfUssMBc2oxlnaUsv+dD3ILw
         1Nwg==
X-Gm-Message-State: AAQBX9dG+3I/4tWt/Sfh2KFQd1ZhVZTNi+ojQFdaCOieHEOzn+LN59Jt
        GQUd99ovB/hiD+6OgFEO9Lo=
X-Google-Smtp-Source: AKy350YgFxmVNDQ7MikeS6snchCN5PxGrcQVp5tPLEjpKS1EwZ+o/4TIyhVj1H8aZ8xZeeDAdjylyA==
X-Received: by 2002:adf:f845:0:b0:303:3880:9273 with SMTP id d5-20020adff845000000b0030338809273mr11260093wrq.17.1682482289057;
        Tue, 25 Apr 2023 21:11:29 -0700 (PDT)
Received: from oberon.zico.biz (77-85-190-39.ip.btc-net.bg. [77.85.190.39])
        by smtp.gmail.com with ESMTPSA id m5-20020a5d6a05000000b002f01e181c4asm14648107wru.5.2023.04.25.21.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 21:11:28 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/3] libtracefs: Documentation for tracefs_instance_reset()
Date:   Wed, 26 Apr 2023 07:11:23 +0300
Message-Id: <20230426041124.69544-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230426041124.69544-1-tz.stoyanov@gmail.com>
References: <20230426041124.69544-1-tz.stoyanov@gmail.com>
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

