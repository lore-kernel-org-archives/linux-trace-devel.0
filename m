Return-Path: <SRS0=47nt=6S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 126D9C4724C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 06:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5764206EB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 06:27:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bCj6JxcI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgEDG1R (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 02:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgEDG1R (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 02:27:17 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB95C061A0E
        for <linux-trace-devel@vger.kernel.org>; Sun,  3 May 2020 23:27:17 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id l11so8706004lfc.5
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 May 2020 23:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=57pf2vmbn/ZPqxx/s/C2s7WKP1jPtYMnO7l6ZFUDIes=;
        b=bCj6JxcIZ/9k/FnGrmDarSdrwR2WFntuAXp5pKMBcbp47tTcR83bN8yVHPnbD53HPd
         7KFfQEgQuDngHiq7noDsiZhSgThFQ6qUPvoslEz+dlikgRyM0a836ul+R4es8tYGCo6s
         vJ+s5q0XSPGBytJNVH+ZxvQTrJvDsIFfOSXV+AYLskF3NqjU1HXKdHwswHz/sc0sBR4I
         l7D0CFc0Or8J1WPLY+mlFNyLwkBwtcardksjmo221YnoFI81IwZ+Onbe8mIeORabPDZa
         F6H47k0CushrDlO6IGRZ1B9FHQ3MYzqynuFXkafGBgQKg6q+dTDwE0+jlT+OfBN4GhL0
         qRdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=57pf2vmbn/ZPqxx/s/C2s7WKP1jPtYMnO7l6ZFUDIes=;
        b=R5/5bpQkmHk8B53iCmpXDcPHJb9lERG+DfK+FDn9UgRxoct1EMBgEM7w58B2GJTDBG
         qGhiZet4mNx5rV4TId/ncGzsshr+9zly7ljCxCKonkdp81wS4FTkVE9zshbERTILRavr
         bINiMziT1KUy3UjrdQmOJ3tv+k/r3FbdBxHul6GLHzEHVxdGIu+9iiLJO2AJF9GwQD+R
         uvNXuIlAG4ZIM3hpRJJ1W08hN02me1ruFPu0FiMNxqhu1lyQ5Vk9QWzlp74XPXNGVUjo
         HmgxT8cO2kAQHyrnlVGrN/+lXDJqeeLOe9dTGrXLZOa9wY0Oapp5/wxqx5e8oPoXP2L1
         yRQA==
X-Gm-Message-State: AGi0PuYmeJR0mrp62yFd+/+CNc0x7ExlgG/2wZPz0FTvJQD2ViVzhfHd
        xJwsZJEbFgzdj2ASPQCECCI=
X-Google-Smtp-Source: APiQypIm+OoqpEx+gaOAeGpw1+kXYqpb0tUypWL/oE5EQNbngNwdgeGFR2Gh755caMEAcyL/obkhHQ==
X-Received: by 2002:ac2:4c3b:: with SMTP id u27mr923122lfq.212.1588573635596;
        Sun, 03 May 2020 23:27:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u6sm7397150ljd.68.2020.05.03.23.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 23:27:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/4] trace-cmd: Fix trace-cmd report crash while displaying trace.dat in specific use case
Date:   Mon,  4 May 2020 09:27:08 +0300
Message-Id: <20200504062711.107867-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504062711.107867-1-tz.stoyanov@gmail.com>
References: <20200504062711.107867-1-tz.stoyanov@gmail.com>
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
2.26.2

