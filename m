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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C1EC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 512432333C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392576AbgLKPI5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391084AbgLKPIx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:08:53 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1B7C0613D6
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:13 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id a3so8888054wmb.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ia0GlPxxrStrpPcBJScq8HAGyJAYHxheHA2Cbt8KU3M=;
        b=L2ek6KRvCLKbY7uCer76RIrFFC4HGRciGWa8aBQrk2rUyOO+43BfrbjqCqRjkuU68b
         06xF4mTC1E/HzMCW9U252guVhgJJ7JrlMQPbaH9G3YM/6fpOs8mRDXBI7tY5us3VpSCf
         kNCJ4iu5AFls71MKsrNXvDWYrQPW4ZdkVma7rDCBlk6eR5w6ONwUVk3VJSc1tp+twwXl
         W4rr/tMNR6ZCN0xMsUrrv7TRe5lEA+vFCMxkaYtbhQraZk8nOJSTyA8DY7ErX+WcshiA
         RAaPPicl4DOZ3ABa7lHOvYmdw7X25Hkd9dgma5tAVHGWoouhEvrz8c6a63zb/WTdhr2R
         uFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ia0GlPxxrStrpPcBJScq8HAGyJAYHxheHA2Cbt8KU3M=;
        b=HIbH7XQAkzaeZpltf7/2X5qQ3mj0ewXHpEzOsQYlC+druiTHYGZjbRD0snglKWCsuA
         uqSQ+qH7gwrclSwoze1fP6VTbyjLeUKvWTGHE2K0nWTduzgabAF7ukueCGs2/MBk3CSO
         VuiqQiTXNR3wLXgtAOANcKiZCMezZISYhaTBWIIkRObWDDuzKNaBBCLKo16ap+g/Sz6Y
         1TIyrO0YfDU34IaV6Fqtla/HMiRThg5iDD+3qtrKQCtZDif9KsQgygU9DV5MJNZ0scVC
         Z0URaTroWo3BQnVMH9BbVuBDHzyiKzlLRytGG8J9o0OjTjQFCdJWfCibCraEU7D7G3N/
         0NVg==
X-Gm-Message-State: AOAM531NnoeWTIDMXIMFtbrGgApUQHv1Xa2VFCM8eDcwa2JFUy12p3Pc
        0yUrSzkCRqUnZjjysLxLIr/7MF3z+00=
X-Google-Smtp-Source: ABdhPJxdh/EKlA5b9gTpR/hfAqWsZYn0yx4UDUBrcunt7OFBi0fYexqs5hMp4dUpnMANR+q56niz+w==
X-Received: by 2002:a1c:41c5:: with SMTP id o188mr13958586wma.18.1607699292237;
        Fri, 11 Dec 2020 07:08:12 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id w17sm15620948wru.82.2020.12.11.07.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:08:11 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        David Runge <dave@sleepmap.de>
Subject: [PATCH v7 02/32] kernel-shark: Change the CMake minimum version required
Date:   Fri, 11 Dec 2020 17:07:26 +0200
Message-Id: <20201211150756.577366-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211150756.577366-1-y.karadz@gmail.com>
References: <20201211150756.577366-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We use some CMake features that are available since version 3.1.2

Suggested-by: David Runge <dave@sleepmap.de>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index c95249e..e730398 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -1,5 +1,5 @@
 # Check if cmake has the required version
-cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)
+cmake_minimum_required(VERSION 3.1.2 FATAL_ERROR)
 
 # Set the name and version of the project
 project(kernel-shark)
-- 
2.25.1

