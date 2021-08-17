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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C94EC4320A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 16:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2D746102A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 16:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhHQQmV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Aug 2021 12:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhHQQmS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 12:42:18 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45C6C0613C1
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Aug 2021 09:41:44 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id u3so39920279ejz.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Aug 2021 09:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fTA18C1juGWZITUqmZQxJSRUfIcz4vFTw5d47852z3k=;
        b=UjvyVxCOJXL47+osyQGqTC/pXWlph+uNR4kwo0RRtDy1q7ieLazXkseSr4e65TJyq9
         t5T6OsdL1V908tBrh5nHMMg8zToPO3WW/rfCn2WdTD7jXnvX3wxem2+uf9c2p5Kajeua
         modp0DfusfPIbJNNw7DDu/XkvzsnpYo00Ae+9jLwQoAPRpB852ZgiolgX+hK7cZ//Y3I
         zwqAaNyi2TTN7VqtXzh1JJP4Qa6Lt9W4DJ59kMYe61r14HeaktCuQchHRrYe7H1VTzXm
         hN5zejCBmw2EiepYNBetTe7X4j5N1UnkNMzvpZD1gxACfHpEks9g683TC/P5NYtPyivm
         TImg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fTA18C1juGWZITUqmZQxJSRUfIcz4vFTw5d47852z3k=;
        b=fRfooxXknWBfztPPX0YvqJ+PsOsw4G4UFYC6Rxx6+ZnXCBylckdsmIwMxrxt3KElbn
         BWV4hqyGqg+LbQ2SONMQqx6y1iT2jsIJ/GJqDyjTwoWQcNjRFC+XzwRKfmXOPtPcGPv8
         gRlmr/hqehsm5fjttrf8F4O5Nwht30AXH4rHJerZck6iH5JkvwkpW7nuIG3q2/YKLpGU
         OQfiWavcDmT2cnamwE2pTSrOmlMNHZl+PRrm5uDw271X+fYsFptWmga0SLJccPz8JGen
         qDw0DugDH25f6w5GmiRNdmQ5qf4c54/H+tXnaPU05MEmQ3BcKaKwlvlxGjYZfTDudFLv
         ED0g==
X-Gm-Message-State: AOAM5316+R4YxIwgvcalfroQA/xSFq6s1E3S75NubJkQnSpIO3hOO9ep
        4vZUejIYtBPiMHJfR2ki+RYDKQQfIRw=
X-Google-Smtp-Source: ABdhPJxJZZPcYYj78gNLDzLokTcgv0QZAwScuHVuwtRQq/Ko+0+aMYLxtNyK7RGiIIpm3ZO7UaFr1A==
X-Received: by 2002:a17:907:1199:: with SMTP id uz25mr4981442ejb.448.1629218503233;
        Tue, 17 Aug 2021 09:41:43 -0700 (PDT)
Received: from crow.. ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id i16sm968283ejx.78.2021.08.17.09.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 09:41:42 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/4] trace-cruncher: Add type checking for the custom Python types
Date:   Tue, 17 Aug 2021 19:41:08 +0300
Message-Id: <20210817164110.152016-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817164110.152016-1-y.karadz@gmail.com>
References: <20210817164110.152016-1-y.karadz@gmail.com>
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

