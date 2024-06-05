Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9916B19D8A8
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594903; cv=none; b=Yh0xpGHIoOj34U50tr3IOslColT5fAC+m6BxXRPfxv6YGbv99i4Zcfz5svynJVRXkiX7E7qTU/fBWv/SXI+Pw4u8wGZUybNiw0186wiWtKA0UM8PBmMNPHBe7G0zMbIM/gEj4R4COq8wO6hAf+QVLaTTTM+gVgn9vPJ9wLxR724=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594903; c=relaxed/simple;
	bh=jUZTiyebtc0dkMAzws81Zqq/oLOqIzsvf5vXNVHpc2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fk5nHi891IIV4ourvcCxmCkum7/cjHI+nkxEeSQPs2VU/8VY+//K8vqswtanBIgjI9kwFLOB4SLp+InbZH4ClNh45tVonX3nNrNoNtqoXOogo70RQfCIwqNUkmJZLZGgMZOIL9WRFCn8coxl8gsYDPPQU3oeN827uGTikmze3MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hUA49nPj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hUA49nPj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FavApTEUCNvzUVqppKKtckL72ZSPWL/sIQjg9OzoyXA=;
	b=hUA49nPjAWm4cy0W49wXv1RM5ddmQrEFJBE0FvarK+hot/scY51+tRJZ29renCpLdPPX5i
	fC7wzWGLwJjF+5VfeyiQlg4aq5EyyQEOHeHo6kjCN+zLh309/6VJGIZVrdJdZApqrBqFqv
	4ajBB0PqsPjJelF9tr0PxSHDx1oRUgw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-25-uPPo4JtRPB6VdfRdzZojMQ-1; Wed, 05 Jun 2024 09:41:37 -0400
X-MC-Unique: uPPo4JtRPB6VdfRdzZojMQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C40C5811E85;
	Wed,  5 Jun 2024 13:41:36 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id B67FBC15970;
	Wed,  5 Jun 2024 13:41:34 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:41:33 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 10/38] trace-cmd: don't print a NULL string in append_pid_filter()
Date: Wed,  5 Jun 2024 15:40:25 +0200
Message-ID: <20240605134054.2626953-11-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

In append_pid_filter() a NULL pointer is passed as the argument for a
%s format. Change the error message to what is used in trace-record.c
append_pid_filter.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-read.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index beaf97a8..a5a0e10a 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -482,7 +482,7 @@ static char *append_pid_filter(char *curr_filter, char *pid)
 	if (!curr_filter) {
 		filter = malloc(len);
 		if (!filter)
-			die("Failed to allocate for filter %s", curr_filter);
+			die("Failed to allocate pid filter");
 		sprintf(filter, ".*:" FILTER_FMT, pid, pid, pid);
 	} else {
 		curr_len = strlen(curr_filter);
-- 
2.44.0

