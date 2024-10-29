Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185DE20370B
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 08:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730188896; cv=none; b=Ag1yjo+gEzl+QXUyt/o+Fhx2fuMDfWAgYHhSZMbSoitV7De6i7rTmxe2lUgfgDQR3RHgw1Tg3rmY57gQ2tQ1WgKiqotHUbZs3eGixvrR4j/LlRkfwc5CDouMB7jS4HthzHBhvSsGc34ctr5hzd1JU3pJaT/svbbHfH3rIbouLNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730188896; c=relaxed/simple;
	bh=6Z7rOhZJRWa5BkDMs9A6UPerFDTmUoJeFZvlbBoHrFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMLCMYHx3gQ4ksVxdicBKWnyb7N4esI1Hh4xWCf/sL5W7LB8qe4EJFafR+DTZTWsG2ZscMKRQFF5Yur/POGKh0CtfG5LvAuLb+Swoi3J6bGefDbbFkqJSAGA9lIihG3tJnqgBNJti2OGV2Y/wqwugtHKe/rzodsvYbcvrvLQnBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MuKRGwHW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MuKRGwHW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730188892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Opl3HJFj4EUUlrwA3RES9A46e65pslUfIiInT5P0DE=;
	b=MuKRGwHWZ1fzvXB+ZmTu7gOL8MlAUAQuMXdUTXK6b9fzmra8RZomKlO2y/hFOwhAWMKKfp
	bmm084W4uoeLMoLl4661fS7a7riF3U4i9/r+2kOIUTJomO7gBBprNlv+o6TJuFQTbkyBtv
	pGPcEYwlgpnceMaKcUTzR14tRpwC6Ps=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-536-TMqIKZSDMkumOO5LK39eXQ-1; Tue,
 29 Oct 2024 04:01:29 -0400
X-MC-Unique: TMqIKZSDMkumOO5LK39eXQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 274FB19560BE;
	Tue, 29 Oct 2024 08:01:28 +0000 (UTC)
Received: from fedora (unknown [10.45.224.46])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 3535A1956086;
	Tue, 29 Oct 2024 08:01:25 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Tue, 29 Oct 2024 09:01:24 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 2/8] trace-cmd record: Prevent a memory leak in show_error()
Date: Tue, 29 Oct 2024 09:01:11 +0100
Message-ID: <20241029080117.625177-3-jmarchan@redhat.com>
In-Reply-To: <20241029080117.625177-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
 <20241029080117.625177-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

In show_error() the pointer p is used for several functions. At first,
it contain a substring of path.

Then it is replaced by either an allocated string containing the path
to the error log file or the result of read_path(), neither of which
are freed when exiting.

Free p in both case in the exit path.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-record.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a008cdfd..3c42cdf0 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2374,6 +2374,7 @@ static void show_error(const char *file, const char *type)
 
  out:
 	printf("Failed %s of %s\n", type, file);
+	free(p);
 	free(path);
 	return;
 }
-- 
2.47.0

