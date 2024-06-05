Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962A2195FE9
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594884; cv=none; b=R7rXdh2MAcibnzUgJLH10hXEOlAcjaja+nBKFnD36W11Qcl3GrNBDfNPFR55Cwl6VkKVZb4QGzuAkK0VVgjdo2G3QTVec0Aw+Ep2KERESUsoscQNiXGO+EzfpnkXPMYxjBx+J0FOe4/h7ptUuXj6ipVJXy9L4bWx5Zpr18MPotI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594884; c=relaxed/simple;
	bh=dNZL2O9Un2dQ/KKsO2HTYL+AyQxOHA8cuQZetnPTCBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RybehkORS4PhPrIEhlDDTe5TJsYnmuyHQbINyN9kP2FAjY5qDeQ7gnPrVramp/vn3FsEk0aSJaXNKqDYSc5/Cq04nh/8ZADY8BKj1FhUZhqo1IuyHFPIaOs6ShX7E51VevH0z3qEMDo4pmjXLVSwJyskAQD6D4X5psl3zQJuLn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FC3KYuTW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FC3KYuTW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S5tTpftksqgDfMzfbzE87T+ijuUaWf9OyJHE3Htr24k=;
	b=FC3KYuTWUynl1I3euuOF+8M4uOKdCPJkBLguGs/D2nQClzIG937zodYgP6cmgEsgLeBOI5
	PSwu1Rg8rCzNtMhOHRaz75wsHyCGJ68BKeCn8cuN7Od4Ke2eNPvctEvPLQPzjmE+vINd4p
	jjJizvzuplbRDptFrOCZz0n5rC0opbc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-qztPHwyzOue_2br5NEm2Yw-1; Wed,
 05 Jun 2024 09:41:20 -0400
X-MC-Unique: qztPHwyzOue_2br5NEm2Yw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D3CB195DE46;
	Wed,  5 Jun 2024 13:41:19 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id F0EA51955DC0;
	Wed,  5 Jun 2024 13:41:16 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:41:15 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 05/38] trace-cmd lib: prevent possible memory coruption in add_plugin_file()
Date: Wed,  5 Jun 2024 15:40:20 +0200
Message-ID: <20240605134054.2626953-6-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

If strdup() fails the error path access original address of
pdata->files after it has been dereferenced. Make sure that
pdata->files contains the up-to-date pointer before calling calling a
function that could fail.

This was flagged as ressource leak (CWE-772) because ptr isn't freed
in that scenario, but there is something worse going on that the
static analysis missed.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index b5002f1d..47ca3db1 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -279,11 +279,11 @@ static void add_plugin_file(struct tep_handle *pevent, const char *path,
 	if (!ptr)
 		goto out_free;
 
+	pdata->files = ptr;
 	ptr[pdata->index] = strdup(name);
 	if (!ptr[pdata->index])
 		goto out_free;
 
-	pdata->files = ptr;
 	pdata->index++;
 	pdata->files[pdata->index] = NULL;
 	return;
-- 
2.44.0

