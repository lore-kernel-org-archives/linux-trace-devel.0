Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6825C2BB55
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D0342072F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hIBj+Gnj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgDIN2m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:28:42 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42411 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgDIN2m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 09:28:42 -0400
Received: by mail-lf1-f68.google.com with SMTP id s13so7886513lfb.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Apr 2020 06:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pUW1anL2wk235Ln4epnDwvtptT/jzD31dJ1Oan9gm4I=;
        b=hIBj+Gnj94Be4L0K2z/EZmHbCfl24a2bCXrP8KlDiv+FsG1BwGo3SS+IXrKuJeGB15
         jB5OksOr96gIrIk3cT+VFXoADVlSZRjJG1S07VZ8IFtGEmr+AVw08XqX2TaXI3UxXLeC
         ZCoyNbeoY2gZav+4iZYqfSRuviCQKwIMjNtk71+0us/enJXRr9AO5hqHnLT7c2BoVWWz
         8WL/RnhyRhfJrxMUnpmVtTiJOevthLNPMFxKaVZ+ILTOmtzXID9mA26cnRkg/LUBDbcV
         A9FIWjdZejD7B28sm9omTcQ4mbqld1t9cYLgLPk/rcYsKYbzsPZPthZCiIvMHBwV9As0
         208w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pUW1anL2wk235Ln4epnDwvtptT/jzD31dJ1Oan9gm4I=;
        b=CfcDkD2IQY7EhVW/WfZ+/zR8OJud07vcOHfBV86WjrM0LI6Or4gskhmyAYJKVq2HUG
         z3yCDGvNZMzkrS87L1TATiLPCzFEjRxdip6Ddy/g9Wgk7EsbY2h4IkX/W9GdTZEQtpai
         RrSDPlUIfPmnus05xcbTcaLHw1tPzLA6V2QeI1o6IK5UEhhRyBHMz0DpGBGc33hErSgs
         i+WyQgixbene8zcHoK4IeJmUs1plUMeuFH2lOOTP5fh7Rn3zAFZR1aoltgukGxtBF4Br
         NZk6JmzfnlAJfBVA7zV/0zI6yg77kVZV3dCvgtNzAkF19+X5upxmcHqtdiGNQ39Vacp7
         SE1w==
X-Gm-Message-State: AGi0PuaUOgzvG85EXGd5WRlLxcyfCy5afUJvzn0zEu2nCHE7TS2dngv4
        IagXUtFxAsnw6oldlXKtPBA=
X-Google-Smtp-Source: APiQypI+3mSSZ3YdwRTy5zXulwzBdBuZhp/QegW6E7+62AAotwv+lzrf4kCFpAhO6T0kMbV41alKwQ==
X-Received: by 2002:ac2:57cb:: with SMTP id k11mr7792089lfo.19.1586438921338;
        Thu, 09 Apr 2020 06:28:41 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 13sm15210345ljq.68.2020.04.09.06.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 06:28:40 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Validate input parameters of tracecmd_get_guest_cpumap() API
Date:   Thu,  9 Apr 2020 16:28:35 +0300
Message-Id: <20200409132835.79530-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200409132835.79530-1-tz.stoyanov@gmail.com>
References: <20200409132835.79530-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The API:
int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
			      unsigned long long trace_id,
			      const char **name,
			      int *vcpu_count, const int **cpu_pid)
is used to retrieve the host PID to guest VCPU mapping from a tracecmd input
handle, if such information is available in the trace.dat file for
the peer with the given trace_id. The input parameters name, vcpu_count and
cpu_pid are mandatory, they are used to return then requested mapping.
The API could be used also to check if such information is available, without
requesting it. Made those input parameters optional, so the API can be used
in this use case.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 6c358131..8651dac1 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3823,9 +3823,12 @@ int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
 	if (!guest)
 		return -1;
 
-	*name = guest->name;
-	*vcpu_count = guest->vcpu_count;
-	*cpu_pid = guest->cpu_pid;
+	if (name)
+		*name = guest->name;
+	if (vcpu_count)
+		*vcpu_count = guest->vcpu_count;
+	if (cpu_pid)
+		*cpu_pid = guest->cpu_pid;
 	return 0;
 }
 
-- 
2.25.1

