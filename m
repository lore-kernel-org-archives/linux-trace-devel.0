Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E25119D8A8
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594918; cv=none; b=DraXlFxXZLUCvRDCuwXgh10lWGUw2MK+IdKrKjJMQOlnbDA3MJqNXhubN+kUURE7ngHWSp+kvbItvvNoJ6PkKLZ8yi2mc0nQ4Bt2A+z4OI2nwVd//5LaRXXGIS7VJGMqIYGq/yxB1XxJ+CU7KV7JPsk0dZteEOfNEIp3Ds2JZrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594918; c=relaxed/simple;
	bh=U6dsy/JyA+kvQ+BYMQmNIaVA0+9fJNM+Paws/j0bD3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUJQpqUgckp09LY20Dhcv4J1Rpu4XPrTzNSf/fIH3oz/xCcE3tQUPXDDsYzL2xgAkusum6s7Yd8+FmxsZ+jgPBztdkovUFauu93cgEgrr7OD9xou3p/Qp8JdwxUCZU4GWoonjwBihVpSnLfN0ChvSYARxKvgNK4ef85RecXlr8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f1TXoQ84; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f1TXoQ84"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nNsK2TXhWen7RqUaDDLK3h9BZOGMdQnuwnmcUCsLZ50=;
	b=f1TXoQ84NH01Te9wpMFNa+MBjwomXFAFAaBsf0Xro6mHpaGN0MDMHzRQSD55WeBEGf+aJ3
	k8E90qnncjbei7UAq//w34Sn6Ya5pZXooUWWX5efpLu0UIDD+maKQ3t0wynqDh5tJq0fGm
	l9nHMhMshvhG0P+ifARJU2kYXR5jGNc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-WTvJcsCPOW6s-HOH_9NZXg-1; Wed,
 05 Jun 2024 09:41:54 -0400
X-MC-Unique: WTvJcsCPOW6s-HOH_9NZXg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90BA519560B1;
	Wed,  5 Jun 2024 13:41:53 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 2FA9A19560A2;
	Wed,  5 Jun 2024 13:41:50 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:41:49 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 15/38] trace-cmd lib: check the return value of do_lssek() in trace_get_options()
Date: Wed,  5 Jun 2024 15:40:30 +0200
Message-ID: <20240605134054.2626953-16-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Check that do_lseek doesn't fail before calling malloc() with a -1
argument.

This is flagged as an overrun error (CWE-119) by static anaysis
because of the call to read() later, but I don't imagine that malloc
would succeed.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-output.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 5ba0a145..35904620 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2069,6 +2069,8 @@ __hidden void *trace_get_options(struct tracecmd_output *handle, size_t *len)
 	}
 
 	offset = do_lseek(&out_handle, 0, SEEK_CUR);
+	if(offset == (off_t)-1)
+		goto out;
 	buf = malloc(offset);
 	if (!buf)
 		goto out;
-- 
2.44.0

