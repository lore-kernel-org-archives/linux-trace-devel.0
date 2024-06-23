Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C4A183082
	for <linux-trace-devel@vger.kernel.org>; Sun, 23 Jun 2024 17:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719162679; cv=none; b=AUzTCapGt59wHhqHKOXGLu6hHXmaj3U7G3xD8KeBEPcgen8SHDU9z0tyJUyF95vItqRQEZ7IpWUmcWkOOdAN31dRgU01K5sBdOcBjPV0RneHOKU0ZmSlqd9Ra5FSIzKoHWWdrJgh+w6RotijVbu9jta6GIKv1VsaPSAD7GoIN7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719162679; c=relaxed/simple;
	bh=u7b/Upkez/G6Xf7F468GALH+TaC5SW4rzitupYAcbQs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=sEp548kIe7dhGR9IspBTP5GftKXyflZ0xMW6lfJpquhVaRCYVXClDe72uC9q8obScd32Xr0xtkrgdYQ0TglIvkCzTVd3xUZLLl/WL7ZUhN7v7GZJ+JnJP6Ffy08SQX0WQgmNYDASUqN7UHIKb7juNx2KLKxmr/3Kli254VwDk8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IwTzpj8v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IwTzpj8v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719162676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mZJA1g4Rlsb8l71mLMEep7MmBNSypQOXtlpiJgq0+RI=;
	b=IwTzpj8vd6Zhqi2poNYHs0pi7m+F7cLG6rvXim6BNixsA7ikzckAo+Q6A31zVbMv8f1rxm
	wlFBq/UNv+I6NuC5ohTe0j+rn0Ly6IYC1NbOTMaX+gKOzXpemwGMa5it0KGWNz6RbAGiYo
	Xjg9ZNs8Vn6Qop3jRTitYhUGiqaiWOU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-o6CwFXvHMU6sqBoIFGbqVg-1; Sun,
 23 Jun 2024 13:11:14 -0400
X-MC-Unique: o6CwFXvHMU6sqBoIFGbqVg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8FB491956086
	for <linux-trace-devel@vger.kernel.org>; Sun, 23 Jun 2024 17:11:13 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.22.16.63])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 02B6E3000218
	for <linux-trace-devel@vger.kernel.org>; Sun, 23 Jun 2024 17:11:12 +0000 (UTC)
From: Yaakov Selkowitz <yselkowi@redhat.com>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd library: fix compatibility with Python 3.13
Date: Sun, 23 Jun 2024 13:10:57 -0400
Message-ID: <20240623171109.691772-1-yselkowi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

PyEval_CallObject was deprecated in Python 3.9 and removed from 3.13.

Signed-off-by: Yaakov Selkowitz <yselkowi@redhat.com>
---
 python/ctracecmd.i | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index 6d0179e3..8757cbe4 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -214,7 +214,7 @@ static int python_callback(struct trace_seq *s,
 		SWIG_NewPointerObj(SWIG_as_voidptr(event),
 				   SWIGTYPE_p_tep_event, 0));
 
-	result = PyEval_CallObject(context, arglist);
+	result = PyObject_CallObject(context, arglist);
 	Py_XDECREF(arglist);
 	if (result && result != Py_None) {
 		if (!PyInt_Check(result)) {
-- 
2.45.2

