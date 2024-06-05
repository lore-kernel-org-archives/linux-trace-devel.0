Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0299188CBB
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594991; cv=none; b=iWGsJ+YQl71FlFTShNXJQ1dNGmGxwDouyx+CLlBIUhr7cDkPfANSUbkjM5H9VrfNrArwdabpGU3hGkud8kjXyIX8uYOkfBMX7SGNQknzKFqGyFY+VtkkFqdJ3Y6avRCJU499CF7Lb3aR9HHbSRDzSLqWCth1SAPKogSRQACRx7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594991; c=relaxed/simple;
	bh=6tu4FkQ3DU5OKr7OvHVZobHUi3BHWNIdlU1nx1zfyCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBeQxku3fcCCmBJ0cjHtQJe+YhUg/E0s+tz3yjyvG2PLBnkZJpdFhDh5VMPsUXznxHzF4erehmhxRccs9bumxuSo/Y9vluWl1lyIZO6iXcrnXr+v2hVT+YyydXC7iGDr2X3l3SzUidQtG5huOnng4xQ/T1VeTJm+30czpVtMAxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TIBPDeIr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TIBPDeIr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2e9zTjsfiJG5NUlNHdCZ0vFLzJc61iEI+GPcBf69u9A=;
	b=TIBPDeIrfVqRjnobj/i841Qt7qYn9VKUrFjYEcHSlvEWL1PuR8AxJAFG5XfDz0SfK5fz23
	e+BkU13jueP9Qf/hOlm2v/REVefS+ibTFhmAwlviVzxynDckFpsdmFEh2wWQ55QaksrCUd
	bDRnDeejr4ZpSbmvgmgg1PuyYek1ah0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-ff_ddLcnNy-R7hL-OHckjA-1; Wed, 05 Jun 2024 09:43:04 -0400
X-MC-Unique: ff_ddLcnNy-R7hL-OHckjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2104E185B920;
	Wed,  5 Jun 2024 13:43:04 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id 6246A1C0005E;
	Wed,  5 Jun 2024 13:43:02 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:43:01 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 35/38] trace-cmd: move the initialization of found_pid at the beginning of stop_trace_connect()
Date: Wed,  5 Jun 2024 15:40:50 +0200
Message-ID: <20240605134054.2626953-36-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

In stop_trace_connect(), trace_fields.found_pid is used in the error
path before it has been initialized. Move the initialization at the
beginning of the function.

Fixes a UNINIT error (CWE-457)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-vm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-vm.c b/tracecmd/trace-vm.c
index f78f1d83..960ed5d5 100644
--- a/tracecmd/trace-vm.c
+++ b/tracecmd/trace-vm.c
@@ -280,6 +280,7 @@ static int stop_trace_connect(struct tracefs_instance *open_instance)
 
 	tep = tracefs_local_events_system(NULL, systems);
 
+	trace_fields.found_pid = -1;
 	trace_fields.sched_waking = tep_find_event_by_name(tep, "sched", "sched_waking");
 	if (!trace_fields.sched_waking)
 		goto out;
@@ -295,7 +296,6 @@ static int stop_trace_connect(struct tracefs_instance *open_instance)
 	if (!trace_fields.sched_next)
 		goto out;
 
-	trace_fields.found_pid = -1;
 	trace_fields.pids = NULL;
 	add_pid(&trace_fields.pids, getpid());
 	tracefs_iterate_raw_events(tep, open_instance, NULL, 0, callback, &trace_fields);
-- 
2.44.0

