Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6521C00140
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Aug 2022 03:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239757AbiHODOF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 14 Aug 2022 23:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbiHODOF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 14 Aug 2022 23:14:05 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369B013E9F
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Aug 2022 20:14:03 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id j11so4622446qvt.10
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Aug 2022 20:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Tv8BDoTZt/uMAIY6+kagGIdLuGbxEvjkQ/gFv0ZutkA=;
        b=eWhPds/2X1sHiQmmLB2C9i1aIR0r9tIlhmM17GsINaMY3W719Grlw95RBt6W647kdM
         vrmv0YGzrNC335KPOuddj1eWEZ0k9HQlMKMDthT6As89ysfBSgR3GXzv1a2caLHmHj/B
         DLeNiLf/CODG34dPzSYLFZSJMPRyH1i9AaRIM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Tv8BDoTZt/uMAIY6+kagGIdLuGbxEvjkQ/gFv0ZutkA=;
        b=cPUfWhDsWzkL2qRxxE+FBa4UaDtb3wIXiU/LsOO/4JIcCkKNflbuWxxhkIA3kRJMgv
         Bmbaqv6S/zYJGiCRQlQkRtpaN9nTBYAC2L7ezEEyqfvDD/QNoWXJ119br53IZoY3RY/D
         A3DuBsW88e7VcFCYK6nkRUwXqhc3YNQr0y174md0Notbj+fbHTigUZmRD3Jh2dM7vQhq
         Z+avUtXsmNu/lVfeQbGqJ5Ker3pZtxbkTG8DrMXZUGO4UsA7Vhi+i5CZRo1CfQ37GNmO
         HJtpZPR20zF6WQThgOCfsnev9H+SfUaSA1r1L12SiSroL+JBGSYSAVdlaN926iZVpJ9f
         0TXw==
X-Gm-Message-State: ACgBeo2eAqdJ65QTcB5darPkDN5KNYZ83QNKFSyBrp5tfyptklF9JYjl
        b0dDNGv0zNj3DX0Nh26ZPehmy8pTjQAweg==
X-Google-Smtp-Source: AA6agR4pmn51O4vBQ/Y6mdwfsdjPIloj42HaevZzArWKjdBoQj0aUy1QeZa0WjhhAdKVIhik7riG8w==
X-Received: by 2002:a0c:c68a:0:b0:491:76f9:b314 with SMTP id d10-20020a0cc68a000000b0049176f9b314mr3493300qvj.86.1660533242043;
        Sun, 14 Aug 2022 20:14:02 -0700 (PDT)
Received: from localhost.localdomain (c-73-148-104-166.hsd1.va.comcast.net. [73.148.104.166])
        by smtp.gmail.com with ESMTPSA id d135-20020ae9ef8d000000b006bb0f9b89cfsm3560743qkg.87.2022.08.14.20.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 20:14:01 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH 1/2] trace-cmd: libtracecmd: Fixing linking to C++ code
Date:   Sun, 14 Aug 2022 23:13:41 -0400
Message-Id: <20220815031342.775201-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Linking in C++ compilers (including g++) causes references to be created
with their arguments. Due to this, trace library headers included into
C++ code base will cause their objects to built with symbols with
arguments. Apparently this is to support operator overloading in C++.

This causes linker errors. For example, here's what I get when I try to
link libtracecmd with a main.o built from a C++ main.cc source file.

 main.cc:(.text+0x90):
	undefined reference to `tracecmd_get_tep(tracecmd_input*)'
	undefined reference to `tracecmd_free_record(tep_record*)'
	undefined reference to `tracecmd_read_data(tracecmd_input*, int)'

The standard fix for this is to wrap the C project's header in
extern "C".

With this patch, I am able to link libtracecmd into a C++
code base.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/trace-cmd/trace-cmd.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 4963f45..b050233 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -9,6 +9,10 @@
 #include "event-parse.h"
 #include "tracefs.h"
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 struct tracecmd_input;
 
 enum tracecmd_open_flags {
@@ -78,5 +82,8 @@ struct tracecmd_filter *tracecmd_filter_add(struct tracecmd_input *handle,
 					    const char *filter_str, bool neg);
 enum tracecmd_filters tracecmd_filter_match(struct tracecmd_filter *filter,
 					    struct tep_record *record);
+#ifdef __cplusplus
+}
+#endif
 
 #endif /* _TRACE_CMD_H */
-- 
2.25.1

