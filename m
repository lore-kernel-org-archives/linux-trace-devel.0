Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA08CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 13:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA72E619F7
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 13:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhJANfn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 09:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353546AbhJANfm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 09:35:42 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C42C061775
        for <linux-trace-devel@vger.kernel.org>; Fri,  1 Oct 2021 06:33:58 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g7so34118155edv.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Oct 2021 06:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B+AmNzEkMuB/aoxmkAsnfhR/Yi68SmIljR8x7H61Kwc=;
        b=gF9an5DNQB/cO+WnWsHo5XErT1bsf51p7ahf7AXSvGGeEglD9QbmX42BX995UaOqXI
         SEazlQ8aHf/Tzgrfj7OBxmlDe4tIPSEmwQVg6Dj5Wn9ekuTDIO78dZsgkeMXFuhkT4gy
         ViR2HBjMC3iQRm3zoTTa3k3BMuB+8R7qLOXLL994zYeKYuhOrF4xnHFCRjF9euilSm74
         Y5GUzUuPRN1MXcrF/Dqguy8Lv8ObdhnowDQ466aSALy4T9/TEwIYXsTnqg527rMiCMWk
         UWIdsldxDtXgJMsnoaujV84OR7r3dCp9sW5VbsH0Jadh8v/XPN3M3lGd0UPu9rK1uQi0
         vWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B+AmNzEkMuB/aoxmkAsnfhR/Yi68SmIljR8x7H61Kwc=;
        b=3kHgsEo+YPINgyFkQ86XsQRKBPRukB7mPHKaYuCvmF+nFFyOlWku+BPYX81Tk9fv/B
         fp7N1v2V7JDV3Q+Hf0ru55sur4p18PXbPAqMJVX9dhUO75o5ouFK5/xckP3b/iezjIkI
         BsOo/tOTFeI5Gq2OSsw4m8XL18qhgX+d0LF4pJyGnYd05Ep/IxP5E98oWn7CnUf9go3H
         HgGawM0vrbZxPsqqqqBpR4IO3jwnTpOPwsZX+I/abf/hqmFgGdfGJoiZmIo1jjpTflJG
         WZ+aHKVYoz/dH/MvkadUGJcum8OzYu/gOQnraHGo8RQjgjPBHy86+uR+Q1W6FUTikIPR
         CZDA==
X-Gm-Message-State: AOAM530mqAZWDL8La2JQ5xq47fF/BdXUuYc3euqppjIhMLrGF6OzDiFh
        5butzcMwhiiFpMAtg2nVRpUow276BZ8=
X-Google-Smtp-Source: ABdhPJz4u1Nqe/Bymfb4SvbnXrOdCvPeYSNrFmNIXQdyrWrnuN1OP3Ydz3SEOCrF3EXFVtqiLDL5ag==
X-Received: by 2002:a17:906:3542:: with SMTP id s2mr6542898eja.379.1633095236736;
        Fri, 01 Oct 2021 06:33:56 -0700 (PDT)
Received: from crow.. ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id ne24sm2993250ejc.46.2021.10.01.06.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 06:33:56 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/5] trace-cruncher: Proper type name for the python objects
Date:   Fri,  1 Oct 2021 16:33:43 +0300
Message-Id: <20211001133346.8217-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001133346.8217-1-y.karadz@gmail.com>
References: <20211001133346.8217-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This name gets printed as part of the error messages. It makes
no sense to have it include the 'C' type since the developer
that will see the error message will have no idea about the 'C'
internals of the Python module.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/common.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/common.h b/src/common.h
index 697b327..b4c66b7 100644
--- a/src/common.h
+++ b/src/common.h
@@ -63,7 +63,7 @@ static inline int no_destroy(void *ptr)
 
 #define STR(x) #x
 
-#define MAKE_TYPE_STR(x) STR(trace.x)
+#define MAKE_TYPE_STR(x) STR(ftracepy.x)
 
 #define MAKE_DIC_STR(x) STR(libtrace x object)
 
@@ -84,7 +84,7 @@ bool py_type##_Check(PyObject *obj);						\
 
 #define  C_OBJECT_WRAPPER(c_type, py_type, obj_destroy, ptr_free)		\
 static PyTypeObject py_type##Type = {						\
-	PyVarObject_HEAD_INIT(NULL, 0) MAKE_TYPE_STR(c_type)			\
+	PyVarObject_HEAD_INIT(NULL, 0) MAKE_TYPE_STR(py_type)			\
 };										\
 PyObject *py_type##_New(struct c_type *c_ptr)					\
 {										\
-- 
2.30.2

