Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DA9C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 14:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EB92613FA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 14:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhDUOwd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Apr 2021 10:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243688AbhDUOwb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 10:52:31 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07227C06138B
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Apr 2021 07:51:57 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id u21so63956587ejo.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Apr 2021 07:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yO134/fyrzsf7ZdtA335MY5WxIHpH5Hodqs2eItOlhU=;
        b=cHBphYbUs+BA8ItkNL3nbjdHwMQ8sIGxLNWtdTce3sELT6EStxHzqBQc9a/6hdBsO+
         iAieff6UuDWdZG/By7HW4s2XC/tVZvE9X6NztR4RZnSSzznOs8d6cJY3kYS7spb4sj0H
         o0nSkToER7OR9GdncM1F68ae7TIHJwxjbJfK3wduM+HMv72q2KktKRuqxwXVyrUa3JMU
         s+MQ8gg9UfXcICAMMLI5PMF4beSidur0tmHZxLLPZn4B58rpz5TNrGw2PoDeU4vmfJa/
         Dfkc3vpaehbu5mIzE9Va99QEpkKubChUz4QD9bOOl2xpriM+oW9+yai6h6vTrsRYCIf2
         qVCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yO134/fyrzsf7ZdtA335MY5WxIHpH5Hodqs2eItOlhU=;
        b=mBhMu9mqFhUE6c6uLw4DpT3chaIQbi1BolqR4dWRoreo9Vb5WDD4DHqK2VDRGXsmoR
         WWIJdO/MOcDSnBXIfvoAAqCNOm4EE+SWn9ESFMCfAwKzT/mu3Dau3S8Yp8TfpbaQ2Ga+
         CM1JQqx0ylJWqtGzDKL+ht6B7ohowZu0XcE+WZt+I5viww7ZcTOWvkPoSbMnlBhuMhS9
         +TLdLwyMuZESAo3cFVryK04HrCEBpvjog2VD0tJ5PrVBdMa2RJIZu74wBKbN6wER/xcb
         WONOrmIseLvByMh7d1Z0rtdsvOyw0MVGzIZepreA+gz+kSxZz/+JNwxr3RpF1f1qoput
         TJuQ==
X-Gm-Message-State: AOAM531OQjzBSDu6bk/nSpjbrJr+un+8dqRXI87jni1MEuOj49MVyv91
        X8vfz/uoZwdvRz1CCMMfVBz/WI9Rl4U=
X-Google-Smtp-Source: ABdhPJwQmwCg4FlrxBjZa2QDw0UwPN+Uk/3DQITptsZ76CsOjXp531krk9rbO6M64ovzmk4ZjtKWgw==
X-Received: by 2002:a17:906:6d15:: with SMTP id m21mr15479309ejr.34.1619016715544;
        Wed, 21 Apr 2021 07:51:55 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.28])
        by smtp.gmail.com with ESMTPSA id ke14sm2730325ejc.1.2021.04.21.07.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 07:51:55 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/4] kernel-shark: Integrate install_libkshark-devel.sh
Date:   Wed, 21 Apr 2021 17:51:40 +0300
Message-Id: <20210421145140.95517-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210421145140.95517-1-y.karadz@gmail.com>
References: <20210421145140.95517-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

So far "install_libkshark-devel.sh" was an unofficial script that
was used to help installing the "libkshark-devel" component. It was
introduced, because the CMake syntax for doing this is quite hard to
memorize. Here we make this script an integrated part of the build
system. The message output is made consistent with the messages
printed by "install_gui.sh". The usage of the script is explained
in README.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 README                           | 12 +++++++++++-
 build/install_libkshark-devel.sh |  6 +++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/README b/README
index b1934c3..652891c 100644
--- a/README
+++ b/README
@@ -88,7 +88,17 @@ compiled objects and all files generated by CMake.
 1.6 By default, installation prefix is "/usr/local". It can be changed using
 -D_INSTALL_PREFIX= as a CMake Command-Line option (see the example below).
 
-1.7 In order to uninstall KernelShark do:
+2. To install libkshark-devel do:
+    sudo ./install_libkshark-devel.sh
+
+    This will install all components needed in order to use "libkshark".
+    Note that if you just use:
+
+    sudo make install
+
+    this will install both the GUI and libkshark-devel.
+
+3.  In order to uninstall KernelShark (no matter what has been installed) do:
     cd kernel-shark/build
     ./cmake_uninstall.sh
 
diff --git a/build/install_libkshark-devel.sh b/build/install_libkshark-devel.sh
index a7e420d..b20fca0 100755
--- a/build/install_libkshark-devel.sh
+++ b/build/install_libkshark-devel.sh
@@ -1 +1,5 @@
-sudo cmake -DCOMPONENT=libkshark-devel -P cmake_install.cmake
+if cmake -DCOMPONENT=libkshark-devel -P cmake_install.cmake; then
+    echo "libkshark-devel installed correctly"
+else
+        exit 1
+fi
-- 
2.27.0

