Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F2E195FE4
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594871; cv=none; b=PCwZT0EDuHaDOwYWQrJniRc/vHBLo8s3QNPR2tEJRqIXtfBIsZ0CzgpRO6sUahbtzOGQouyvyjsGL9EPI2YREC2g20rI9trxgtiiBI9cx9Tf7D3HDNTkFL/Ulr5rdWHxKlRGJu9M4Rm8S8aOU+9PHb6sA9DAvT58rbVwj6bYwWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594871; c=relaxed/simple;
	bh=kSdj8X2YTt1jV/AVgWCwFTejqymYC5/BXMN6lNpM2Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwNwrsSZ5tuMyAHsltfVSinnegnI9g966VwvmJLLmJ3OVItBWPNYikF2gpbw52K5YJ2Ck7f433K0+fVRYElDtUXx3PbtmE4QAk1x/B9L0IJfg+qPb93glXkngUHEJrfzEfy9f/v5C9gl13oExRzqzqruNg8GTFWPJpOPnHbTwCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hnn1lsHp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hnn1lsHp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yv4Jsp6nEsOsNYMxuQDgQPrhjnu8PW9f0Zwj6uqDtbk=;
	b=Hnn1lsHpYBiUWy/mUrDk7pO3yHhwVzXtsx646a3Hjhygqde18kzvWj2eAHN/wqTF5VPZGe
	mC9e5Lc1EKdYeVQ1bnGvDBVYYOh5jN4LLrxUzIxvkGKLBdZUyIrei/nXnfyg28jEt9RRo/
	F1Rhc42y7UHMX7RhrP3fcz6Onz4txiQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-124-zk7VbjiHO_KExTmdLy2kGA-1; Wed,
 05 Jun 2024 09:41:06 -0400
X-MC-Unique: zk7VbjiHO_KExTmdLy2kGA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 72E171955D78;
	Wed,  5 Jun 2024 13:41:05 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 15A8F1956055;
	Wed,  5 Jun 2024 13:41:02 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:41:01 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 02/38] trace-cmd msg: prevent a memory leak in get_trace_req_args()
Date: Wed,  5 Jun 2024 15:40:17 +0200
Message-ID: <20240605134054.2626953-3-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

In get_trace_req_args() vagrs is not freed when the function exits
without an error. This could be of course be fixed by freeing vagrs
before exit, but actually I don't see the point of the buffer at all
since it just use to copy the content of buf and then read to fill
args. Why not just read from buf to begin with?

Remove vagrs and use buf directly.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-msg.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 3a555c36..f5c604f1 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -1247,7 +1247,6 @@ static int get_trace_req_args(char *buf, int length, int *argc, char ***argv)
 	unsigned int nr_args;
 	char *p, *buf_end;
 	char **args = NULL;
-	char *vagrs = NULL;
 	int ret;
 	int i;
 
@@ -1266,15 +1265,8 @@ static int get_trace_req_args(char *buf, int length, int *argc, char ***argv)
 		goto out;
 	}
 
-	vagrs = calloc(length, sizeof(char));
-	if (!vagrs) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	memcpy(vagrs, buf, length);
-	buf_end = vagrs + length;
-	for (i = 0, p = vagrs; i < nr_args; i++, p++) {
+	buf_end = buf + length;
+	for (i = 0, p = buf; i < nr_args; i++, p++) {
 		if (p >= buf_end) {
 			ret = -EINVAL;
 			goto out;
@@ -1289,7 +1281,6 @@ static int get_trace_req_args(char *buf, int length, int *argc, char ***argv)
 
 out:
 	free(args);
-	free(vagrs);
 	return ret;
 
 }
-- 
2.44.0

