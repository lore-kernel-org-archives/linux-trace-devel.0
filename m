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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 190B2C4338F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 16:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5A7960FE6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 16:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhHQQmU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Aug 2021 12:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhHQQmS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 12:42:18 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD01C061764
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Aug 2021 09:41:43 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r19so29079838eds.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Aug 2021 09:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dvQOYcdkaA9RAlrwEppLpq09VEggm5oXxIPlxlY+fqE=;
        b=kOOPzfL6a8NkkmAcyjSBT75BggTu9qVl3MPqhtH1BxVyp3+u/Hyx11jhW4pRWh3SwF
         HRfF71E9JQhTyE6lfvn4WCiPutWGYD1MMWULAGd55sRVJZOWbYrQ45OrmvOTo5/su9JW
         HSp4DHEgesaAxKpRgipf86iwMF31/wLPRG5wzyFBPflE3RL4Bromm6ShoNlycYZkDupq
         VaCrtkMHYCZyBkhoQUOhUEAlhwXJ0f27DrgqNUEP4d4hvcfhmdEovagNqjnn1SdpDm0+
         f7Y7vPGJD2GdCCHWYA81xGBuVmBs1kZYTBroIEHMs5CXveLyvIt0rPN+l+1CVCXKkkD9
         xYvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dvQOYcdkaA9RAlrwEppLpq09VEggm5oXxIPlxlY+fqE=;
        b=VSmOMxI4g4C4Q2DrTd7FbiyQEf9u0E9eO193gRuzR3rxzL4I87dTkeWRNzb1vY7x6C
         lM7nzDTENBdlz2IWV37nvl24P7pk9MgACBfCiRayZ1VAn0KHH4qgt+7ET27VV2XM3WO2
         AHgiYDAPiB9Tvkkr97TVoXTfljEUJVk14Cc/EwxIJwHjUXV9eMu6v0i2A2xdzjfmi5re
         CctM8btNPBOSbStpDrg1mp3O/zbAiyYBAmY98Qp/scExVWe6QLRg0ifCLrX6dNC3HUDv
         v3vH0vbuwPGIA2M3JsCsyyuz1dLTyYdsC3KIhe94y5LzZ8LwH5ZatBFyt2uM2U4n21Zv
         uHZw==
X-Gm-Message-State: AOAM530kAPg9gjg6nxEAZG1RtLkvy7/LGZpR4L2FUaD0X+ac968q4nnC
        lJp++9ZMisTCXP88/G+pAwUvRR4JqkE=
X-Google-Smtp-Source: ABdhPJy/5fhUx74q4fkqh6S/8Acwhjx2dD+OI8+WzB1wYuA0TYRxY5zZfvdVQug1cKmiwuMB+bSfBA==
X-Received: by 2002:a50:998f:: with SMTP id m15mr4983190edb.193.1629218502371;
        Tue, 17 Aug 2021 09:41:42 -0700 (PDT)
Received: from crow.. ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id i16sm968283ejx.78.2021.08.17.09.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 09:41:41 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/4] trace-cruncher: Use proper naming in common.h
Date:   Tue, 17 Aug 2021 19:41:07 +0300
Message-Id: <20210817164110.152016-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

PyTepEvent was the first Python type defined in the C extension module.
A legacy from this first implementation can be found in the naming of
some variables used by the type definition macros.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/common.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/common.h b/src/common.h
index 9985328..6046c0f 100644
--- a/src/common.h
+++ b/src/common.h
@@ -54,27 +54,27 @@ static inline void no_free()
 
 #define STR(x) #x
 
-#define MAKE_TYPE_STR(x) STR(traceevent.x)
+#define MAKE_TYPE_STR(x) STR(trace.x)
 
-#define MAKE_DIC_STR(x) STR(libtraceevent x object)
+#define MAKE_DIC_STR(x) STR(libtrace x object)
 
 #define C_OBJECT_WRAPPER_DECLARE(c_type, py_type)				\
 	typedef struct {							\
 	PyObject_HEAD								\
 	struct c_type *ptrObj;							\
 } py_type;									\
-PyObject *py_type##_New(struct c_type *evt_ptr);				\
+PyObject *py_type##_New(struct c_type *c_ptr);					\
 bool py_type##TypeInit();							\
 
 #define  C_OBJECT_WRAPPER(c_type, py_type, ptr_free)				\
 static PyTypeObject py_type##Type = {						\
 	PyVarObject_HEAD_INIT(NULL, 0) MAKE_TYPE_STR(c_type)			\
 };										\
-PyObject *py_type##_New(struct c_type *evt_ptr)					\
+PyObject *py_type##_New(struct c_type *c_ptr)					\
 {										\
 	py_type *newObject;							\
 	newObject = PyObject_New(py_type, &py_type##Type);			\
-	newObject->ptrObj = evt_ptr;						\
+	newObject->ptrObj = c_ptr;						\
 	return (PyObject *) newObject;						\
 }										\
 static int py_type##_init(py_type *self, PyObject *args, PyObject *kwargs)	\
-- 
2.30.2

