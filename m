Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E05C43219
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 14:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BFDF611AD
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 14:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhKJOlB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Nov 2021 09:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbhKJOlB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Nov 2021 09:41:01 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B39C061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Nov 2021 06:38:13 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id c8so11193590ede.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Nov 2021 06:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gVl2lGOEbrYtvOxvPaqXjrFeVlmvMF0E1XHgYel1EJM=;
        b=StckmEvNhPwmp5pClBkzzVVxcK1biazyCtZALvJFe28xVW4TTQ9ZWuQFCW7fkcMLJ8
         pgFVMsqYLM6rWd8Fm6DEH5QSEXoV8g04HKszc1mMmNu7i4GgMMD9dLtQJox3rBeqq9z0
         2dbiLUcW/dBmf+mvFetdHrNt5MSWrj8a5Y+Dm24eraMSCy6G5lLUhgFZwO22evL1H09j
         VYUXajK8C0tdktEoRs3QHYwXDP2jrThM/4PGkx+4t8FXya81qdwN7DUyZw+yA/Lt2uxz
         Vjp1NQ1PRlK73w2xWobKdNRa2ttt+zourF2UudbjRnMRqBUzBX5R44sgWwtuSCPBCAWV
         bO2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gVl2lGOEbrYtvOxvPaqXjrFeVlmvMF0E1XHgYel1EJM=;
        b=mICI4ZIf7gEB4UOJlNjoHW6HKL75WjcXukeaYi+YJWjZPYFp3AECqCL/4pP0ryt+Fi
         kzdQU0emH1Dqpq+EjZuTQX09r+t6CHtG3w9Dc4o3Xg2zW03HkRZfopW43RCOGbm/AeV+
         rYYcsErPSgT3msCxT8Tsh0bAfUcQVsiCx6g7RF+ZT9PLIRUgAPxXS9YtKeVAmWESSKrr
         aVjkECFIf7N8y7r39WI+r2HLnTM+0d4CELH05p1zVSFVMs3R2upl3i1LDzdwNgN9DDHL
         gk6DttHOugI8sVvr2KpH9JVHseMyerqbDBPXUBs1/dmWcN4EUGblQy/wK/oXmwdh4Qkm
         8/+g==
X-Gm-Message-State: AOAM531aASHHua0vvkk9SWRiQxWXr7JmG1FPd934a0t2obu7ce4/IUmF
        9poaQxMs9WgIJi7Aa33wRL2g7dHnPMY=
X-Google-Smtp-Source: ABdhPJwB/eufP/ynEEl9Mpgh6yEixjNoCdN5EPaAx05A6wYC4WpMoq1JL8JCZByd1PXzvk8sNZz+iw==
X-Received: by 2002:aa7:c4d3:: with SMTP id p19mr11586edr.333.1636555091659;
        Wed, 10 Nov 2021 06:38:11 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id hc10sm11477039ejc.99.2021.11.10.06.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 06:38:11 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/5] kernel-shark: Add 'Requires' to libkshark.pc
Date:   Wed, 10 Nov 2021 16:37:46 +0200
Message-Id: <20211110143747.32833-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211110143747.32833-1-y.karadz@gmail.com>
References: <20211110143747.32833-1-y.karadz@gmail.com>
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
 build/libkshark.pc.cmake | 2 ++
 2 files changed, 4 insertions(+)

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
index ad4ce34..0591cf9 100644
--- a/build/libkshark.pc.cmake
+++ b/build/libkshark.pc.cmake
@@ -6,5 +6,7 @@ Name: libkshark
 URL: https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/
 Description: Library for accessing ftrace file system
 Version: @KS_VERSION_STRING@
+Requires: tracecmd >= @LIBTRACECMD_MIN_VERSION@
+Requires: json-c
 Cflags: -I${includedir}
 Libs: -L${libdir} -lkshark
-- 
2.33.1

