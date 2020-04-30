Return-Path: <SRS0=Wcha=6O=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE954C8300B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Apr 2020 12:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEB6A2078D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Apr 2020 12:22:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DQHcR05w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgD3MW3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 08:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726500AbgD3MW3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 08:22:29 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2389C035494
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Apr 2020 05:22:28 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id a21so6231382ljb.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Apr 2020 05:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dMFrehiR+oXsmQhOwuztFId6VaI3Xo62DKdaSY9qRDY=;
        b=DQHcR05wJeKoP284a0LQEvPq3ujfxLYJlmdq7zaMKTMVzTf3JKm4eEEvJkF/vUSZSe
         CgRbp1snUXAUhej0BhSIfhOImMzte3NaPaI49Q2vyLpCm/DMntNw/8rInyT+ayQKRX6I
         PGSZnup9XKcSlp9pOLe6Tc5cunpNQwcfu90nn/waGijq0IHJp4+UgdMV7ZrNE9/QIVNr
         J0YrMJCVKNDKasRXNusQkbJ+6sWuK1CPTB8WWBEqCo1uPWna7Di9zBIf3V0OgU3xiwqb
         DFUHet73bjQcxLKg3CK2N53U87dilDZk7/rGLg1TGKc2WenZwzPiTdC5AzlRd1L8cg+E
         mXYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dMFrehiR+oXsmQhOwuztFId6VaI3Xo62DKdaSY9qRDY=;
        b=HHIXdKwKDT2UWZSn+4VhscW1vwYSAcsn0lqtQ354xtrbuySdhB3M3geIxNFNrwyG7V
         NLi0Kkjm0Nuz3Ivgzlyk9NQ2fxuzPJjAVWU2cKpgGNvTiO6b6fEfumEQUKz+OC1eSXhC
         MKhlRnPJeZ2LxdWOGqRc7IHwlshi9O5n3hEHyiZLQj1Gvfbas0WA6ftimV6v+pEiHljl
         xVi1LsKO4A5m4BHXHhlPGf9vrjH6uNldZJqxpviwDR8nRwPUitmpoNeHOiHThUXT2oJM
         P0HrKzsy1DfIxls4XEtLHXo2sqOvPwGR1dauKYE5EKfnjrk1if9JdTHzFVICGi3TQ+64
         w7VA==
X-Gm-Message-State: AGi0PuaIpyBoVRqCLbRiy+rs/zHx9iPrIAjbsthVobL3Kah2Ay1Aw/f6
        MN2W6dy+3W/+KznZABcH7YEVB8s6x/8=
X-Google-Smtp-Source: APiQypLH+2msD8bKI1cLJvKZxDPG7Pei2+DZwtXxQVtryGr7rDNQNNllXZCjkO10YfRSqqYSPlIFPQ==
X-Received: by 2002:a2e:b162:: with SMTP id a2mr2042015ljm.25.1588249347394;
        Thu, 30 Apr 2020 05:22:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a26sm4793168lfl.66.2020.04.30.05.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 05:22:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/4] trace-cmd: Fix trace-cmd report crash while displaying trace.dat in specific use case
Date:   Thu, 30 Apr 2020 15:22:19 +0300
Message-Id: <20200430122222.101276-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430122222.101276-1-tz.stoyanov@gmail.com>
References: <20200430122222.101276-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace-cmd report command crashes while displaying a file recorded with "--proc-map" and "-B" options:
#trace-cmd record --proc-map  -B test -e sched -F sleep 1
The "--proc-map" options saves the address map of "sleep" into the trace.dat file. This
information is used by KernelShark. The "-B" options traces the specified events into a
ftrace instance "test".
When such file is opened using libtracecmd APIs, the proc-map is parsed and saved into
a tracecmd_input handler, as linked list "pid_maps". Later, when the ftrace instance
"test" is parsed, a copy of this handler is used to fill it with the instance's trace data.
Both tracecmd_input handlers share the same "pid_maps" list, thus leads to a double
free of the list, when  handlers are destroyed.
As this "pid_maps" is not used in ftrace buffers, the "pid_maps" list of the copy can be
initialized to NULL.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 55c3d80a..7583d5cb 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3712,6 +3712,8 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 
 	new_handle->flags |= TRACECMD_FL_BUFFER_INSTANCE;
 
+	new_handle->pid_maps = NULL;
+
 	/* Save where we currently are */
 	offset = lseek64(handle->fd, 0, SEEK_CUR);
 
-- 
2.25.4

