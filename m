Return-Path: <SRS0=pFV5=55=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DFF8C352B6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Apr 2020 08:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A2FD20732
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Apr 2020 08:37:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ht2oUx8a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgDMIh1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Apr 2020 04:37:27 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35474 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727856AbgDMI2w (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Apr 2020 04:28:52 -0400
Received: by mail-ed1-f68.google.com with SMTP id c7so11076957edl.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Apr 2020 01:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IEYZpRAvAz1P0pPwkhPRTdNDKuiJ8k+E9V0tkgHERuc=;
        b=ht2oUx8alLZgBRnxdi7pfCs5XtT5AIWQ/2Ay9wxX8I5AYaaTkPKgPM2SIOF0Y95cJI
         mDh5PrhcC9rKjSEfrrgPPsBCojOr5oHIMa5UKw4VFaYtnitQci/3RC7Rwdsq4oEtWzMd
         IxHGOonV+n+oHIFtpIZOc1AGdgl0UPIJQ9xvTJ8VD40mTSDzfkvKzALX+k49lKwp+5Jt
         T3akmgssRw2Jy6OPEuYT6gIyIIcaHI/NDemkgHWKv1bCNKtvWPipzRS9hbpO12mDHsw7
         tnkaQxOc7AI1xLNo+3P31Taf8VeMSnkDj6C8kbCWVatNn0JMAqIuKKZTutDkIku3Lzzn
         bBvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IEYZpRAvAz1P0pPwkhPRTdNDKuiJ8k+E9V0tkgHERuc=;
        b=TsDP/dLxZCq3iIzSybvy58J3fCLNskOt475+q1PNsxwdTivxdcCSzYV/V8tpjOlZSS
         PZEmKlUW4LqPmddpSjM6FXwYnn/jQRPud+Zk15PU5uaXBJ61tJH2vqU1NVBPJBnWPUmj
         s+8fRGoZXiHfqhaMmdbHAECJlRRaqv7Fw+/BtJ9ZrOV1nP8aEb8tctUWL3EXIyAnRudX
         ByZh0+PkYdTkvjzloLyccdftrbL5SFibyR6AZyrGFSx2N+Xs7Zujmrq50tBrJZzPFZjj
         uqHSQqbuzlrvFbC5pgvtprCMtEJEj+yuQi/AUVZbB2XNa5oaqHFEK17wOnvqFPlAcWft
         lrZw==
X-Gm-Message-State: AGi0PuYPixaq4s4n1ivYQzDLXSu4OMMBlybl8oIiR7Zk4ijfIPfGllbt
        nNzc3rv6SMROFlSzJbk2xLniLfuDd1M=
X-Google-Smtp-Source: APiQypKgFpegEBHRHQ5YqJtBcWw64iTIMBbRlgh343q3wDNqWFbccRzCzdK53oy4MNI4lrVozA4PsA==
X-Received: by 2002:a2e:88d4:: with SMTP id a20mr5711410ljk.175.1586766219754;
        Mon, 13 Apr 2020 01:23:39 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b9sm9463605lfp.27.2020.04.13.01.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 01:23:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/2] trace-cmd: Validate input parameters of tracecmd_get_guest_cpumap() API
Date:   Mon, 13 Apr 2020 11:23:34 +0300
Message-Id: <20200413082334.164158-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200413082334.164158-1-tz.stoyanov@gmail.com>
References: <20200413082334.164158-1-tz.stoyanov@gmail.com>
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
index cd909613..bbf5367d 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3856,9 +3856,12 @@ int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
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

