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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB8DC432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 13:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBA5061153
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 13:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbhHSNJT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 09:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhHSNJT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 09:09:19 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA3BC061575
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Aug 2021 06:08:42 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id r7so9134955wrs.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Aug 2021 06:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fTA18C1juGWZITUqmZQxJSRUfIcz4vFTw5d47852z3k=;
        b=TgIRnYiDJ022o6IIsnJdGiinc0S7cC9bOUwwvr6vWmo3JQXcOsLIIfPwYwz0XRX7nk
         zkSshO+LuoZ/RcJ1ofmUlfyjCVp9uvLJF2BuLs1Bhrhin2c23DAtnv1DPigJqThz/S0v
         vLr6eotkfUIGpO97PGul3Wj+pQRkAO9M/6jCt/7vlTxv9okRlGjQPRj8CfWhUUyGa1r5
         opNENxbqaj9nxqS0RU9QYZzvSAoTzrEjowso2puG2z0XzO9SOBG6r0RDg1twZKllw6Wp
         D18ZINvdKzJQ92dgm4zHns2xpZ6/x4QkRrclW3vDme4j472vG/ALpyPOv+dsOliH5MDL
         FspQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fTA18C1juGWZITUqmZQxJSRUfIcz4vFTw5d47852z3k=;
        b=HFyXYX+3E6a95LCt93ZXUaO2jmY3KJqlwi7GPs1yuRHbG2Hjx2aVbRdsg0nIQhaabP
         xHHPkXS1l5/jBTYYgBOXR0/bi8ho9VrMCpDSkhXjPM+W+59f2BFVg7EwM5kXU7Rozz0v
         EpnXBecYPLuJU1RvNvkn8yOClWtKu0KmsfRdnwF/2PYDHr7Psb6HIaTjdfZ3F7Zs9kVT
         Sgqh+8NFVaePzWLekWgYLrGY4MdU0CBP5hG+MtVeb2P38xqT4CH0P1Y9+ydFGQCyiq8G
         4Vf4CkpbbsgLe3vBUUDXOq0kXcj75nBEHfzBRpLEev7N4B8FbK1kzwIVB4EjfzObzpH3
         yQug==
X-Gm-Message-State: AOAM533EpP3KQa54yZ0YmvyhWAYvOAErjq9SfaQLy7k3GeC8MAT2h6Lu
        rMEvc06CW8F+rH8VKuao0LVu1DuYWj4=
X-Google-Smtp-Source: ABdhPJxsty+mS8e3UVWZOWg9i2i3bDEuotcU1AG9NaD/Ru4KkRwWonZJt5rq7hG50ppnxeJKNyk9dw==
X-Received: by 2002:adf:eacb:: with SMTP id o11mr3804503wrn.418.1629378521388;
        Thu, 19 Aug 2021 06:08:41 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id f17sm2889978wrt.49.2021.08.19.06.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 06:08:41 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 2/7] trace-cruncher: Add type checking for the custom Python types
Date:   Thu, 19 Aug 2021 16:08:22 +0300
Message-Id: <20210819130827.12327-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210819130827.12327-1-y.karadz@gmail.com>
References: <20210819130827.12327-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new method checks if an object has a Python type that matches
the type defined in the C extension module.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/common.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/common.h b/src/common.h
index 6046c0f..fa64696 100644
--- a/src/common.h
+++ b/src/common.h
@@ -65,6 +65,7 @@ static inline void no_free()
 } py_type;									\
 PyObject *py_type##_New(struct c_type *c_ptr);					\
 bool py_type##TypeInit();							\
+bool py_type##_Check(PyObject *obj);						\
 
 #define  C_OBJECT_WRAPPER(c_type, py_type, ptr_free)				\
 static PyTypeObject py_type##Type = {						\
@@ -101,5 +102,9 @@ bool py_type##TypeInit()							\
 	Py_INCREF(&py_type##Type);						\
 	return true;								\
 }										\
+bool py_type##_Check(PyObject *obj)						\
+{										\
+	return (obj->ob_type == &py_type##Type) ? true : false;			\
+}										\
 
 #endif
-- 
2.30.2

