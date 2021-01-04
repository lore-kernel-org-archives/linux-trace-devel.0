Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B04C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1A03206E4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbhADRsW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbhADRsW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:48:22 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09717C061795
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:47:42 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id dk8so28284564edb.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xrqfjcx8+apSca3gz79+n8M1aFpRLw6AXfLNdpf8fU0=;
        b=BxUDvE5zLFIIZXViJaDnYTgO0dn52D6I+9vdcqUvjpLVRkQan0Aho+zYFEiI9raVil
         0Mu0rulzJBDTYyNqIpGAgLI5le3JtvuiI44Md2nkcFQQEMpcR+OrdfEwA9jy5eKcOLeX
         HodtX4dP6XlrUc0sB2bgkx1eie9ZpmXvqnDRExioPqQjUY5wmTF1GMCqCBUyhf/A0xeF
         n4UIj5UBgZ7hlFyiyvXeD8cL94TXTd96txZz27M/p7vXjwm4NxeDzvjHT3fPMC0hLyax
         gJqPe9PMKaWZZ21axfElzxkZVGthZ3ta5d58tewOGDEpfjDG8YYbSojXHalrtm+RWABh
         zdhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xrqfjcx8+apSca3gz79+n8M1aFpRLw6AXfLNdpf8fU0=;
        b=TIdy3fmfGUsaCoJ3Bs1zpM/qWPql/mV3los71z6Yg0WqPsgKHR+J6cex4QGb7DkDNp
         urkCynpxzJl1LfnMrsbXR7wB+fVDEZdnZHvOa0VuSKTXdrvBAd49ZkrtB4dO0NC6btFf
         tV1VOOQX8jvMUhRn1YCnUYzzEcOw6D3B7g0r9MhdBvG2UCiMvu59EV0BQVpesLUaqa6z
         9HvoHpMx5yfqZ2UuH0CzXf0peXW40vENvSHQdGGbvYdTTzQ0+soZGPg58eFVLJl0pt4p
         vyFWql4R0ZAABErVgGriYO/AN2C3sYdTqMRGQ48cslkcstCfCUG4hJJpihUFVi2lxaC2
         wZbQ==
X-Gm-Message-State: AOAM532IkKvZ42k7u5uWXQxmQ21+juC3UvdrfYTJryfjQX2Q3CT1jwYH
        QE0YgKjgBnZRwhIJxTxesYTyNsFkLF/pag==
X-Google-Smtp-Source: ABdhPJzkwzKosHp6T06RuAzN6ZBAgUEffxm5CXnwLCqrKbS1uQYf0Hw39eyXb9yk8k5rdZBtK2RbTQ==
X-Received: by 2002:a50:fd18:: with SMTP id i24mr73048643eds.146.1609782460876;
        Mon, 04 Jan 2021 09:47:40 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:47:40 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        David Runge <dave@sleepmap.de>
Subject: [PATCH v8 04/44] kernel-shark: Change the CMake minimum version required
Date:   Mon,  4 Jan 2021 19:46:44 +0200
Message-Id: <20210104174724.70404-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
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
index 3ea40f0..d75f179 100644
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

