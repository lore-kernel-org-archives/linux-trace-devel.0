Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531D218FDDA
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594979; cv=none; b=RnIoCcx27vvkAX3XiXxXDpyOx8KQDqXF3c5eKoG8RRJB2MMp6IxThzgF4Azo2VZteft0hyjtAUTCHGMJrJhQJOhv0JfgTLUyNJ6JrwWq6S80fT/ApIUZtvMsOvZg+ot6InYAKPpZ45mEPwVRNue+KntbBwwZu/doKDtefdcOOQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594979; c=relaxed/simple;
	bh=F4TqmHUHiE6IxgZNl2NtmOZPGaBDqUjJvOq555Fk4D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lS8KEFzEwu/oKXAQ7aOfL7/8HOKXDeLm71wJw5rPe0fIeGlApP/hMW+BSqIl+ajMvz2DmJehEcrDhlLehT9W8BsP3GJ/6OZnL5AjVOokaeo5a978EV7zpu+wMbQGtVa0tIg2yRgsAauX2sul6DZ7apeZRw4bWNkd/UtaFAc22T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fVTdv0lO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fVTdv0lO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d2VaQrQ2Zri57wNIs1QKqhla95JBoCevABvvUKYcrAM=;
	b=fVTdv0lOpn5EsaNfG8sfvvMsW2Wm2R0pBmwe3dLivrwhWF98IDR24Eh1w+gb3YJTOJN6Ma
	hpBgKKn+rKUqIaxj+CR6DSuRznti6Yfdg2fJIsZmr/l0HadBQs4DDsme6GUvBMFyZA7utv
	Ysbz01Nd3QLfuf839+fkZmiO+xktHEY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-310-DFz83D4cPzigpWKqmAaqdw-1; Wed,
 05 Jun 2024 09:42:54 -0400
X-MC-Unique: DFz83D4cPzigpWKqmAaqdw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C21083806700;
	Wed,  5 Jun 2024 13:42:53 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id E9513492BE8;
	Wed,  5 Jun 2024 13:42:51 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:42:50 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 32/38] trace-cmd lib: prevent memory leak in tracecmd_create_event_hook()
Date: Wed,  5 Jun 2024 15:40:47 +0200
Message-ID: <20240605134054.2626953-33-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Free hook in the error path.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-hooks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/trace-cmd/trace-hooks.c b/lib/trace-cmd/trace-hooks.c
index a58b5356..47f25fb3 100644
--- a/lib/trace-cmd/trace-hooks.c
+++ b/lib/trace-cmd/trace-hooks.c
@@ -151,6 +151,7 @@ struct hook_list *tracecmd_create_event_hook(const char *arg)
 
 invalid_tok:
 	tracecmd_warning("Invalid hook format '%s'", arg);
+	free(hook);
 	return NULL;
 }
 
-- 
2.44.0

