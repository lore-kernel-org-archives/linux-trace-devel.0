Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27246C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Mar 2022 20:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350907AbiC3UUF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Mar 2022 16:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350901AbiC3UUE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Mar 2022 16:20:04 -0400
Received: from mail.efficios.com (mail.efficios.com [167.114.26.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283EC27FEB;
        Wed, 30 Mar 2022 13:18:19 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 8343D2851B0;
        Wed, 30 Mar 2022 16:18:18 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id liiiRE86cOBp; Wed, 30 Mar 2022 16:18:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 39C42285337;
        Wed, 30 Mar 2022 16:18:18 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 39C42285337
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1648671498;
        bh=8ediofSqJKX2Zks+4QSp0wj5eoOOq1PxGvE7lIh1nRE=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=dplyxnZ6o/oz354M5U+6xg7KRCp8NTy/ii11u1Lb5dIYCon1NJRbtLZKD5PmO52pT
         ijJa8MzgzLnnlr30hZwiEP/mTyEcjmSLK/oD5yUPvxrl6UD/lfKFUg3JRypw5KKWBi
         CXv1CMGXSNHD7HXDtMnItENro/Nt7yCmy/89DHEkxVBzbvoTs2a/kXPz0c1etNFnYu
         y6bBvO1X8Aqj+gmg8diBqXNIZamMJB9fFtZCAeau8RX+GgwQ6DNtX9B8qQwJDGXdMw
         CXEe57VSAg9RvgHSv99G3IC+3XjHtqCVprnWrZEM9oLQL4saE+DxbQF9OyGrudrt0Y
         NooNnapmrbGrA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id p67GgNSbFrfO; Wed, 30 Mar 2022 16:18:18 -0400 (EDT)
Received: from thinkos.internal.efficios.com (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by mail.efficios.com (Postfix) with ESMTPSA id 0204C284BF9;
        Wed, 30 Mar 2022 16:18:17 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH] tracing: do not export user_events uapi
Date:   Wed, 30 Mar 2022 16:17:55 -0400
Message-Id: <20220330201755.29319-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In addition to mark the USER_EVENTS feature BROKEN until all interested
parties figure out the user-space API, do not install the uapi header.

This prevents situations where a non-final uapi header would end up
being installed into a distribution image and used to build user-space
programs that would then run against newer kernels that will implement
user events with a different ABI.

Link: https://lore.kernel.org/all/20220330155835.5e1f6669@gandalf.local.h=
ome

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/uapi/Kbuild | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/Kbuild b/include/uapi/Kbuild
index 61ee6e59c930..425ea8769ddc 100644
--- a/include/uapi/Kbuild
+++ b/include/uapi/Kbuild
@@ -12,3 +12,6 @@ ifeq ($(wildcard $(objtree)/arch/$(SRCARCH)/include/gen=
erated/uapi/asm/kvm_para.
 no-export-headers +=3D linux/kvm_para.h
 endif
 endif
+
+# API is not finalized
+no-export-headers +=3D linux/user_events.h
--=20
2.20.1

