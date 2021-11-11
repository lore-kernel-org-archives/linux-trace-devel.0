Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 726BDC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 14:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45F32610A5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 14:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbhKKOaZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 09:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhKKOaX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 09:30:23 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB20CC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 06:27:33 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id b15so24693611edd.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 06:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7dJob0dX+VuWH0H66PUUYyCXA74hVcR9mshSi29s29g=;
        b=T2mC4SmYXnWMvUBRiOAZZ/fbxyRxjzANKUDuqvdaOWEcQAQOOjP26ieJcXG41v8OoJ
         3wqmcvszB0Aubchj01nvcpXhAKZX5kkj/ghSf8wd/YG/TvE6cFnLvUBTr5Eoycy6Teeg
         nUVP4+MEKiLLverBUn6u0LNdTVDWHtkk7j6VKeSDu2yK1Ps9Do++xAZ+A90t6kndtT/V
         T+cRf6/kK28qh4b0+xEpS/QFyHpPIE/12dP2pLwcQTDi1b36uJVUToyPrTq1/oM7Dy0a
         0MnIQXEvZGikdWwVWdp7DcAyHZKE0sls6cEA8B9+f84eH8jS6SF//FOCI31ToO9XjDAV
         zXsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7dJob0dX+VuWH0H66PUUYyCXA74hVcR9mshSi29s29g=;
        b=aQDjWmo/b1+631DPQPlylF2OFu0jrt5X5Gepoe7Mg0XQHTo8zISGt9kt8LSAEkcj36
         OXlJVNqWjFsSKU20GlFDubcQHzxtMO+CrhEIhGTC5dnPE8WKiqUIk43GKqhBMdWZlDcC
         60B7MkLmHVYSxjBpTlMnT0Yp9HakZ0qB6S7ltPtciw/ncgnFAnpawFSdI0bY796Ishdg
         DLaBeghC5RJO3UANOhYdVV7Gz0EgGpD5LSnHaoOP1COKDozbCnQ1tdHvlRp8Ppj4Bkpd
         s+3VEBZ6I065udsqPoV7NlUfkpdnQJiyYXAucgLfd97HGqYmWpTHM4HEe5V7t72vUprt
         0ozg==
X-Gm-Message-State: AOAM530Ek9slpZ5/5Aump2SnXovRI3sd+CuwoxH0mKVMyaB4tnhpVn0x
        rAteP4N7HqOx0DUza+8s2gNJCjkm62U=
X-Google-Smtp-Source: ABdhPJyFbtwfEWjvxi+PzM965ddhWCVxJQKteZeBCkMQPU3rJ8HEff765HxbZexEpKXl3e54GiraEQ==
X-Received: by 2002:a05:6402:13c9:: with SMTP id a9mr10525227edx.219.1636640852227;
        Thu, 11 Nov 2021 06:27:32 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id l3sm998030edq.19.2021.11.11.06.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 06:27:31 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2] kernel-shark: Add 'Requires' to libkshark.pc
Date:   Thu, 11 Nov 2021 16:27:21 +0200
Message-Id: <20211111142721.93092-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Adding only the requirements for building 'libkshark'. The requirements
for building the GUI are not supposed to be listed here.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt           | 2 ++
 build/libkshark.pc.cmake | 1 +
 2 files changed, 3 insertions(+)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index bb7b2a1..3723654 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -42,6 +42,8 @@ if (NOT _POLKIT_INSTALL_PREFIX)
 
 endif ()
 
+set(LIBTRACECMD_MIN_VERSION 1.0)
+
 set(CMAKE_MODULE_PATH "${KS_DIR}/build")
 find_package(TraceEvent REQUIRED)
 find_package(TraceFS    REQUIRED)
diff --git a/build/libkshark.pc.cmake b/build/libkshark.pc.cmake
index ad4ce34..0764d0d 100644
--- a/build/libkshark.pc.cmake
+++ b/build/libkshark.pc.cmake
@@ -6,5 +6,6 @@ Name: libkshark
 URL: https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/
 Description: Library for accessing ftrace file system
 Version: @KS_VERSION_STRING@
+Requires: json-c, libtracecmd >= @LIBTRACECMD_MIN_VERSION@
 Cflags: -I${includedir}
 Libs: -L${libdir} -lkshark
-- 
2.32.0

