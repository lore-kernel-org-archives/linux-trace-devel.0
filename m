Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50418199235
	for <linux-trace-devel@vger.kernel.org>; Fri,  7 Jun 2024 16:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717776363; cv=none; b=HWuoiSrfIMXH7NB6W54NB2IVZAVqlxxQcQh0f+LioF5/9GsGH//F6pBYSIQvLDvwbJnUbzwvBawq3ip+7oFRw4L0KQakNYt8bCu0UBbVO/bMz4EJMCQcnm7PbkyfUCFxjsgRRsAW226bkwgr2WVFv0eliP+U9JXCkiR0fs2Xo90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717776363; c=relaxed/simple;
	bh=6I45+YL8eVDYaYvFI2kccLgNe4ODj4nmUeQHpqS0Etw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oP2tDOt/szJbnRtIb6mm3YdcM94Eve9j6gkXqyaXgKGkkje6xMJX/SDPsOGzjI/bZp2uw9Cii4EQOLt86ffKCWc961nZveeKyoOFJ80V1auHb8pjofWYJiIqq64Y3Fo6KFYylUzFeY5QVUV4MKUan5RQbgIiHcdW1krKtC926Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b4qtLjWx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b4qtLjWx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717776361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JcP3fYm9J0YCatO/9/xelOXZJLvTk/wX8Mun1PO35hw=;
	b=b4qtLjWxWPSNrXqyjkSNLcEJQiTcHgMe6H0O2tCRWc4gggfVMSpLF4TeTDt+mmiQbOFK05
	hb/aGZQXFqxmu8IJ3HPC29kmKM/+/kxI7cj4N/aZ9ZYtd71qe6g+MpasQ6uPMSaued3R6R
	REPvznMQKnnfNfSc7Zs75x3nUqIm288=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-Ak-8C7lEMteYoFjVJicknw-1; Fri,
 07 Jun 2024 12:05:59 -0400
X-MC-Unique: Ak-8C7lEMteYoFjVJicknw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BFDD219560AD;
	Fri,  7 Jun 2024 16:05:58 +0000 (UTC)
Received: from fedora (unknown [10.43.17.163])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 84AFE19560AA;
	Fri,  7 Jun 2024 16:05:56 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Fri, 07 Jun 2024 18:05:55 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 4/4] libtraceevent: don't return a pointer to a local variable get_field_str()
Date: Fri,  7 Jun 2024 18:05:42 +0200
Message-ID: <20240607160542.46152-5-jmarchan@redhat.com>
In-Reply-To: <20240607160542.46152-1-jmarchan@redhat.com>
References: <20240607160542.46152-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

The function get_field_str() can return a pointer to string on the
stack. Replace it by a global variable.

Fixes a RETURN_LOCAL error (CWE-562)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/parse-filter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/parse-filter.c b/src/parse-filter.c
index e448ee2..f0c0ae1 100644
--- a/src/parse-filter.c
+++ b/src/parse-filter.c
@@ -1698,6 +1698,8 @@ static int test_num(struct tep_event *event, struct tep_filter_arg *arg,
 	}
 }
 
+char hex[64];
+
 static const char *get_field_str(struct tep_filter_arg *arg, struct tep_record *record)
 {
 	struct tep_event *event;
@@ -1705,7 +1707,6 @@ static const char *get_field_str(struct tep_filter_arg *arg, struct tep_record *
 	unsigned long long addr;
 	const char *val = NULL;
 	unsigned int size;
-	char hex[64];
 
 	/* If the field is not a string convert it */
 	if (arg->str.field->flags & TEP_FIELD_IS_STRING) {
-- 
2.45.1

